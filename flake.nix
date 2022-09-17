{
  description = "reproducible, declarative environment with nodejs toolings/pkgs";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      scripts = {
        # add node pkgs to $PATH so we can
        # pin global npm pkgs with package-lock.json.
        pathAddNodePkgs = "export PATH=./node_modules/.bin:$PATH";
        # use yarn or npm or pnpm.
        depsInstall = "yarn";
      };
    in
    # support all the platforms dynamically.
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; with pkgs.nodePackages; [
            nodejs-14_x
            yarn
          ];

          shellHook = ''
            ${scripts.pathAddNodePkgs} &&
            ${scripts.depsInstall} &&
            echo "Nodejs Version: $(node --version)"
          '';
        };
      }
    );
}
