{
  description = "reproducible, declarative environment with nodejs toolings/pkgs";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    # support all the platforms that are supported by nix.
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        envRaw = ''
          # add node npm pkgs to $PATH.
          layout node
          # load reproducible dev environment declaration.
          use flake . --impure
        '';
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs-14_x
            nix-direnv
          ];

          shellHook = ''
            node --version
            echo "${envRaw}" >> .env &&
            direnv allow . &&
            npm i
          '';
        };
      }
    );
}
