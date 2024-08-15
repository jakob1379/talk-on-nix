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
      ];

    in {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = (generalPackages pkgs); # ++ (pythonBasePackages pkgs);

          shellHook = ''
          echo "Welcome to the ❄️nix❄️ shell!"
          '';
        };
      });
    };
}
