{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
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
      in {
        devShells = {
          default =
            import ./default.nix {inherit pkgs;};
        };
      }
    );
}
