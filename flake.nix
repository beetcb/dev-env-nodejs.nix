{
  description = "reproducible, declarative environment with nodejs toolings/pkgs";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    # support all the platforms dynamically.
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        scripts = {
          # add node pkgs to $PATH so we can
          # pin global npm pkgs with package-lock.json.
          pathAddNodePkgs = "export PATH=./node_modules/.bin:$PATH";
          # use yarn or npm of your own choice.
          npmInstall = "npm install";
        };
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs-14_x
          ];

          shellHook = ''
            ${scripts.pathAddNodePkgs} &&
            ${scripts.npmInstall} &&
            echo "Nodejs Version: $(node --version)"
          '';
        };
      }
    );
}
