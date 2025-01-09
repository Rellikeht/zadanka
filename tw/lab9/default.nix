{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    gradle
    kotlin
    kotlin-language-server
  ];
}
