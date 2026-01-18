{
  description = "Convert subscription list to CSV";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      # Change this to your system if needed
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

    in
    {
      devShells.${system}.default = pkgs.mkShell {
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

      packages.${system}.subscriptions-to-csv = pkgs.writeShellApplication {
        name = "subscriptions-to-csv";

        runtimeInputs = with pkgs; [
          python3
          coreutils
        ];

        text = ''
          python3 main.py "$@"
        '';
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.subscriptions-to-csv}/bin/subscriptions-to-csv";
      };
    };
}
