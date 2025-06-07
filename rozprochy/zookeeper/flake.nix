{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-24.05";
    flakeUtils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    # nixpkgs-old,
    flakeUtils,
  }:
    flakeUtils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        # pkgs-old = nixpkgs-old.legacyPackages.${system};

        buildInputs = with pkgs; [
          gradle
          jdk17

          zookeeper
        ];
        # ++ (with pkgs-old; [
        #   zookeeper
        # ]);
        # ++ (with self.packages.${system}; [default]);
      in {
        devShells = {
          default = pkgs.mkShell {
            inherit buildInputs;
            phases = [];
            shellHook = '''';
          };
        };

        # packages = rec {
        #   default = pkgs.writeScriptBin "run" ''
        #     echo "Do the thing"
        #   '';
        # };
      }
    );
}
