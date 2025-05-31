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
          # erlang
          # erlang-ls
          # erlfmt

          rabbitmq-server
          elixir-ls
          elixir
          # (not given directly) deps
          inotify-tools
        ];
      in {
        devShells = {
          default = pkgs.mkShell {
            inherit buildInputs;
            phases = [];
            shellHook = '''';
          };
        };
      }
    );
}
