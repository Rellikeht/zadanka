{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
          python313Full
          uv
          zookeeper
          libnotify
        ];

        libs = with pkgs; [
          #  {{{
          zlib
          stdenv.cc.cc.lib
          glib
        ]; #  }}}
        ld_path = "${pkgs.lib.makeLibraryPath libs}";
      in {
        devShells = {
          default = pkgs.mkShell {
            inherit buildInputs;
            phases = [];
            shellHook = ''
              export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${ld_path}"
            '';
          };
        };
      }
    );
}
