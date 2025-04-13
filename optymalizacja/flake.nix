{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flakeUtils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flakeUtils,
  }:
    flakeUtils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        buildInputs = with pkgs;
          [
            ninja
            meson
            # hyperfine

            # should all be on the host
            # binutils # for gprof
            # gcc
            # clang-tools
          ]
          ++ (with self.packages.${system}; [
            find_root
            build
          ]);
      in rec {
        devShells = {
          default = pkgs.mkShell {
            inherit buildInputs;
            phases = [];
            # https://github.com/NixOS/nixpkgs/issues/18995
            hardeningDisable = ["fortify"];
            shellHook = '''';
          };
        };

        packages = rec {
          find_root = pkgs.writeScriptBin "find_root" ''
            MESON_FILE="meson.build"
            BUILD_DIR="build"
            if [ -n "$1" ]; then
                BUILD_DIR="$1"
            fi
            while ! [ -e "$MESON_FILE" ]; do
                cd .. || exit 1
                if [ "$PWD" = "/" ]; then
                    echo "Reached /" > /dev/stderr
                    exit 1
                fi
            done
            echo "$PWD"
            exit 0
          '';

          build = pkgs.writeScriptBin "build" ''
            BUILD_DIR="build"
            if [ -n "$1" ]; then
                BUILD_DIR="$1"
            fi
            ROOT="$(${find_root}/bin/find_root)"
            if [ "$?" -gt 0 ]; then
              exit 1
            fi
            cd "$ROOT"
            exec meson compile -C "$BUILD_DIR"
          '';

          # default = find_root;
        };
      }
    );
}
