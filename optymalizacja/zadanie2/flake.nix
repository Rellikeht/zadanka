{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

        nativeBuildInputs = with pkgs; [
          ninja
          meson

          # should all be on the host
          # binutils # for gprof
          # gcc
          # clang-tools
        ];

        buildInputs = with pkgs; [
          # hyperfine
          papi
        ];
        # ++ (with self.packages.${system}; [run]);
      in {
        devShells = {
          default = pkgs.mkShell {
            inherit nativeBuildInputs buildInputs;
            phases = [];
            # https://github.com/NixOS/nixpkgs/issues/18995
            hardeningDisable = ["fortify"];
            shellHook = '''';
          };
        };

        packages = rec {
          run = pkgs.writeScriptBin "run" ''
            echo "Do the thing"
          '';
          default = run;
        };

        apps = rec {
          run = {
            type = "app";
            program = "${self.packages.${system}.run}/bin/run";
          };
          default = run;
        };
      }
    );
}
