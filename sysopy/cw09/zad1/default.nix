{pkgs ? (import <nixpkgs> {}), ...}:
pkgs.stdenv.mkDerivation {
  name = "life";
  src = ./.;

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
}
