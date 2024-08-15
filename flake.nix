{
  description = "Simple tex-env with pre-commit";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = function:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ]
          (system: function nixpkgs.legacyPackages.${system});

      generalPackages = pkgs: with pkgs; [
        reveal-md
        marksman
        nodejs
      ];

    in {
      # make sure that 
      
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {

          
          packages = (generalPackages pkgs); # ++ (pythonBasePackages pkgs);

          shellHook = ''
            echo "Welcome to the ❄️nix❄️ shell!"
            if [ ! -d reveal.js ]; then
              echo "Cloning reveal.js repository..."
              git clone https://github.com/hakimel/reveal.js.git
            fi

            cd reveal.js
            if [ ! -d node_modules ]; then
              echo "Installing reveal.js dependencies..."
              npm install
            fi
          '';          
        };

      });
    };
}
