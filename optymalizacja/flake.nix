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

        buildInputs = with pkgs; [
          ninja
          meson
          hyperfine

          # should all be on the host
          # binutils # for gprof
          # gcc
          # clang-tools
        ];
        # ++ (with self.packages.${system}; [run]);
      in {
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
