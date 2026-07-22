#!/usr/bin/env bash
# Build the site locally and publish it to the server webroot
# (Caddy serves /var/www/home). The old flow rebuilt on the server,
# but the new server has no hugo and never touched the webroot —
# so: commit+push the sources, build here, rsync the result
# (same pattern as card.beimgraben.net/deploy.sh).
set -euo pipefail
cd "$(dirname "$0")"

git add .
git commit -m "${1:-Publishing}"
git push

nix develop --command hugo --gc
cp google*.html public/

rsync -rlc --delete public/ frederik@beimgraben.net:/var/www/home/
