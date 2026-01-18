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
              self.packages.${system}.subscriptions-to-csv
            ];

            shellHook = ''
              export PATH="$PATH:${self.packages.${system}.subscriptions-to-csv}/bin"
              echo "You can now run: subscriptions-to-csv"
              echo "Run tests with:  pytest"
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

            # Remove cached bytecode to avoid issues
            postInstall = ''
              find $out -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
            '';

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

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          # Test that the help command works
          help-test =
            pkgs.runCommand "subscriptions-to-csv-help-test"
              {
                nativeBuildInputs = [ self.packages.${system}.subscriptions-to-csv ];
              }
              ''
                subscriptions-to-csv --help | grep -q "Convert subscription list to CSV"
                touch $out
              '';

          # Test basic functionality with sample data
          basic-test =
            pkgs.runCommand "subscriptions-to-csv-basic-test"
              {
                nativeBuildInputs = [ self.packages.${system}.subscriptions-to-csv ];
                # Create a test input file
                inputData = ''
                  Test Service
                  	25.00 €
                  Another Service
                  	15.50 USD
                '';
              }
              ''
                echo "$inputData" > test_input.txt
                subscriptions-to-csv test_input.txt test_output.csv
                # Check that output file was created
                test -f test_output.csv
                # Check that it contains expected content
                grep -q "Test Service" test_output.csv
                grep -q "Another Service" test_output.csv
                grep -q "25.00" test_output.csv
                grep -q "15.50" test_output.csv
                touch $out
              '';

          # Test named arguments
          named-args-test =
            pkgs.runCommand "subscriptions-to-csv-named-args-test"
              {
                nativeBuildInputs = [ self.packages.${system}.subscriptions-to-csv ];
                inputData = ''
                  Named Test
                  	10.00 €
                '';
              }
              ''
                echo "$inputData" > named_input.txt
                subscriptions-to-csv --input named_input.txt --output named_output.csv
                test -f named_output.csv
                grep -q "Named Test" named_output.csv
                touch $out
              '';
        }
      );
    };
}
