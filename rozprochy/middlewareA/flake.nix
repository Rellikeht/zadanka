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
                protoc-gen-go-grpc
                protoc-gen-go
                protobuf

                uv
                python313
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
