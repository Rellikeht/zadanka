{
  description = "";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    name = "life";
    src = self;
  in {
    packages.x86_64-linux.default = with import nixpkgs {system = system;};
      stdenv.mkDerivation {
        inherit name src;

        nativeBuildInputs = with pkgs; [
          gcc
        ];

        buildInputs = with pkgs; [
          ncurses
        ];

        buildPhase = ''
          make
        '';

        installPhase = ''
          mkdir -p $out
          cp life $out/
        '';
      };
  };
}
