{
  inputs = {
    #  {{{
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flakeUtils.url = "github:numtide/flake-utils";
  }; #  }}}

  outputs = {
    #  {{{
    self,
    nixpkgs,
    flakeUtils,
  }:
  #  }}}
    flakeUtils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        stdenv = pkgs.stdenv;
        lib = pkgs.lib;

        libs = with pkgs; [
          #  {{{
          zlib
          stdenv.cc.cc.lib
          glib
          openssl
        ]; #  }}}

        ld_path = "${pkgs.lib.makeLibraryPath libs}";
      in rec {
        packages = rec {
        };

        devShells = {
          default = pkgs.mkShell {
            #  {{{
            buildInputs =
              #  {{{
              [
              ]
              ++ (with pkgs; [
                zeroc-ice
                gradle

                uv
                python312

                # for zeroc to compile
                openssl
                bzip2

                # gradle
              ]); #  }}}

            phases = [];
            shellHook = ''
              export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${ld_path}"
            '';
          }; #  }}}
        };
      }
    );
}
