{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    gradle
    scala
    scalafmt
    metals
  ];
}
