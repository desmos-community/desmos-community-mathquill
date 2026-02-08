{
  description = "Build script for Desmos Community Mathquill";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    desmos-mathquill = {
      url = "github:desmosinc/mathquill";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      desmos-mathquill,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        src = desmos-mathquill;
        override = ./override;

        pname = "desmos-community-mathquill";
        # calver, unusual for npm but this is a nightly ci build
        version =
          let
            inherit (builtins) substring;
            normalise = pkgs.lib.strings.removePrefix "0";
            dateStr = self.lastModifiedDate;
            year = normalise (substring 0 4 dateStr);
            month = normalise (substring 4 2 dateStr);
            day = normalise (substring 6 2 dateStr);
          in
          "${year}.${month}.${day}";

        nodejs = pkgs.nodejs_25;

        # we're overriding everything from buildNpmPackage anyway
        desmosMathquill = pkgs.stdenvNoCC.mkDerivation {
          inherit src pname version;

          # handle dependencies with importNpmLock
          npmDeps = pkgs.importNpmLock { npmRoot = src; };

          nativeBuildInputs =
            with pkgs;
            [
              perl
              jq
              sd
              openssl
              importNpmLock.npmConfigHook
            ]
            ++ [ nodejs ];

          buildPhase = ''
            runHook preBuild

            # install dependencies and prevent reinstall
            npm install
            touch node_modules/.installed--used_by_Makefile

            # fix build scripts
            patchShebangs --build .

            make basic font

            # move to clean package directory
            mkdir -p out/dist
            cp build/mathquill-basic.css out/dist/style.css
            cp build/mathquill-basic.min.js out/dist/index.global.js
            cp src/mathquill.d.ts out/dist/lib.d.ts

            # copy overrides
            cp -r ${override}/. out/

            # patch files
            sd -F 'declare namespace' 'export namespace' out/dist/lib.d.ts
            sd -f s '@font-face\s*\{.*?\}' \
              "@font-face {
                font-family: 'Symbola';
                src: url(data:font/woff2;charset=utf-8;base64,$(base64 -w 0 build/fonts/Symbola-basic.woff2)) format('woff2');
              }" out/dist/style.css
            sd -F '{VERSION}' '${version}' out/README.md
            sri() {
              echo "sha384-$(openssl dgst -sha384 -binary "$1" | openssl base64 -A)"
            }
            sd -F '{CSS-SRI}' $(sri out/dist/style.css) out/README.md
            sd -F '{JS-SRI}' $(sri build/mathquill-basic.min.js) out/README.md
            jq '.version = "${version}"' out/package.json > out/package.json.tmp
            mv out/package.json.tmp out/package.json

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p $out

            # build outputs
            cp -r out/. $out/

            runHook postInstall
          '';
        };

        updateScript = pkgs.writeShellScriptBin "update-and-publish" ''
          set -eu

          echo "Checking for updates" >&2
          nix flake update desmos-mathquill

          # check if flake.lock was updated or the action was manually triggered
          if [ -n "$(git status --porcelain)" ]; then
            echo "Desmos Mathquill was updated" >&2
          elif [ "$EVENT_NAME" = "workflow_dispatch" ]; then
            echo "Running anyway (manual invocation)" >&2
          else
            echo "No updates for now" >&2
            exit 0
          fi

          # update our readme
          cp ${desmosMathquill}/README.md .

          # push changes to repository
          git commit -a -m "Nightly update"
          git push

          echo "Publishing version ${version}" >&2
          ${nodejs}/bin/npm publish --access public ${desmosMathquill}
        '';
      in
      {
        packages.default = desmosMathquill;

        # make it easier to nix run
        apps = {
          update-and-publish = {
            type = "app";
            program = "${updateScript}/bin/update-and-publish";
          };
        };
      }
    );
}
