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
          subscriptions-to-csv = pkgs.python3Packages.buildPythonPackage {
            pname = "subscriptions-to-csv";
            version = "1.0.0";
            format = "pyproject";

            src = ./.;

            nativeBuildInputs = with pkgs.python3Packages; [
              setuptools
            ];

            propagatedBuildInputs = with pkgs.python3Packages; [ ];

            meta = with pkgs.lib; {
              description = "Convert subscription list to CSV with EUR conversion";
              license = licenses.mit;
              maintainers = [ ];
            };
          };
          default = self.packages.${system}.subscriptions-to-csv;
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
