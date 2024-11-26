{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs;
    [
      gradle
      nodejs_20
    ]
    ++ (with nodePackages; [
      typescript-language-server
    ]);

  shellHook = ''
  '';
}
