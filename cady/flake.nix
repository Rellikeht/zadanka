{
  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    self,
  }:
    flake-utils.lib.eachSystem flake-utils.lib.allSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            octaveFull

            # libglvnd
            # qt6.qtdeclarative
            # qt6.qtbase
            # qt6.qttools
          ];
          phases = [];
          shellHook = '''';
        };
      }
    );
}
