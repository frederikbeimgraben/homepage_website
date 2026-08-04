#!/usr/bin/env bash
# Build the site locally and publish it to the server webroot
# (Caddy serves /var/www/home). The old flow rebuilt on the server,
# but the new server has no hugo and never touched the webroot —
# so: commit+push the sources, build here, rsync the result
# (same pattern as card.beimgraben.net/deploy.sh).
#
# Usage:
#   ./publish.sh                # commit any changes, build, deploy
#   ./publish.sh "message"      # the same, with a commit message
#   ./publish.sh --dry-run      # build and list what would change, deploy nothing
set -euo pipefail
cd "$(dirname "$0")"

readonly TARGET="frederik@beimgraben.net:/var/www/home/"

dry_run=false
message="Publishing"
for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=true ;;
    *) message="$arg" ;;
  esac
done

# Commit only when something changed. `git commit` fails on an empty tree, and
# `set -e` then stops the script before it deploys. Publishing again with no
# source change is a normal thing to want, so it must not be an error.
git add .
if git diff --cached --quiet; then
  echo "publish: no source change to commit"
else
  git commit -m "$message"
fi

# `git push` with nothing to push exits 0, so it needs no guard.
git push

# Clean build: hugo does not remove outputs for deleted statics, and a
# stale public/ would resurrect them on the server via rsync.
chmod -R u+w public 2>/dev/null || true
rm -rf public
# --minify to match the Nix package build. Without it the deployed site was
# the unminified one, about 5 KB more HTML per page.
nix develop --command hugo --gc --minify
cp google*.html public/

# rsync runs with --delete against the live webroot. If the build gave no
# output, that command would empty the site, so stop instead.
if [[ ! -s public/index.html ]]; then
  echo "publish: the build made no public/index.html, no deploy" >&2
  exit 1
fi

if [[ "$dry_run" == true ]]; then
  echo "publish: dry run against $TARGET, nothing is written"
  rsync -rlc --delete --dry-run --itemize-changes public/ "$TARGET"
  exit 0
fi

rsync -rlc --delete public/ "$TARGET"
echo "publish: deployed to $TARGET"
