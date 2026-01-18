{
  description = "Convert subscription list to CSV";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      # Support multiple systems
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              gawk
              coreutils
              python3Packages.pytest
            ];

            shellHook = ''
              echo "You can now run:  subscriptions-to-csv"
              echo "Run tests with: pytest"
            '';
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          subscriptions-to-csv = pkgs.writeShellApplication {
            name = "subscriptions-to-csv";

            runtimeInputs = with pkgs; [
              python3
              coreutils
            ];

            text = ''
              python3 main.py "$@"
            '';
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.subscriptions-to-csv}/bin/subscriptions-to-csv";
        };
      });
    };
}
