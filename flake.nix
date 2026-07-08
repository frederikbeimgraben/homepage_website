{
  description = "frederikbeimgraben.de — personal homepage (Hugo)";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Hugo Modules pulled in via go.mod (congo theme, plausible-hugo). Fetched
      # once as a fixed-output derivation so the site build itself is offline.
      hugoModules = pkgs.stdenv.mkDerivation {
        pname = "homepage-website-hugo-modules";
        version = "0-unstable";
        src = ./.;
        nativeBuildInputs = [ pkgs.hugo pkgs.go pkgs.git pkgs.cacert ];
        buildPhase = ''
          export HOME=$TMPDIR
          hugo mod vendor
        '';
        installPhase = ''
          mkdir -p $out
          cp -r _vendor/. $out/
        '';
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-J2iaMtfrVgvKoWzajb11j/tVpu4IbeoW9zUPOEZgJmI=";
      };

      homepage-website = pkgs.stdenv.mkDerivation {
        pname = "homepage-website";
        version = "0-unstable";
        src = ./.;
        nativeBuildInputs = [ pkgs.hugo pkgs.go ];
        configurePhase = ''
          export HOME=$TMPDIR
          mkdir -p _vendor
          cp -r ${hugoModules}/. _vendor/
        '';
        buildPhase = ''
          hugo --minify --gc
        '';
        installPhase = ''
          mkdir -p $out
          cp -r public/. $out/
        '';
        meta = {
          description = "Personal homepage built with Hugo";
          homepage = "https://github.com/frederikbeimgraben/homepage_website";
        };
      };
    in
    {
      packages.${system} = {
        default = homepage-website;
        homepage-website = homepage-website;
        hugoModules = hugoModules;
      };

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [ hugo go ];
        shellHook = ''
          echo "homepage_website dev shell — hugo $(hugo version | cut -d' ' -f2), go"
          echo "Serve locally with: hugo server -D"
          # Drop into the user's interactive zsh (loads ~/.zshrc); guarded so
          # `nix develop -c <cmd>` and non-interactive uses still run in bash.
          [[ $- == *i* ]] && exec ${pkgs.zsh}/bin/zsh
        '';
      };
    };
}
