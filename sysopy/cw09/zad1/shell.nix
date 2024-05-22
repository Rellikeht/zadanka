{pkgs ? (import <nixpkgs> {}), ...}: let
  packages = with pkgs; [
    ncurses
  ];
in
  pkgs.mkShell {
    inherit packages;
    phases = [];
    shellHook = ''
    '';
  }
