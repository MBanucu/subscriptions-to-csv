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
        ];

        shellHook = ''
          echo "You can now run:  subscriptions-to-csv"
        '';
      };

      packages.${system}.subscriptions-to-csv = pkgs.writeShellApplication {
        name = "subscriptions-to-csv";

        runtimeInputs = with pkgs; [
          python3
          coreutils
        ];

        text = ''
          python3 -c "
          import sys, json, urllib.request, argparse

          # Parse arguments
          parser = argparse.ArgumentParser(description='Convert subscription list to CSV with EUR conversion')
          parser.add_argument('input', nargs='?', default='subscriptions.txt', help='Input file containing subscriptions')
          parser.add_argument('output', nargs='?', default='subscriptions.csv', help='Output CSV file')
          parser.add_argument('--input', '-i', dest='input', help='Input file containing subscriptions')
          parser.add_argument('--output', '-o', dest='output', help='Output CSV file')
          args = parser.parse_args()

          # Fetch USD to EUR exchange rate
          try:
              with urllib.request.urlopen('https://api.exchangerate-api.com/v4/latest/USD') as f:
                  data = json.load(f)
              rate = data['rates']['EUR']
          except:
              print('Failed to fetch exchange rate', file=sys.stderr)
              rate = 1.0  # fallback

          # Read input file
          with open(args.input, 'r') as f:
              lines = f.readlines()

          # Output CSV
          total_eur = 0.0
          with open(args.output, 'w') as out:
              print('Service,Price,Currency,PriceEUR', file=out)
              for i in range(0, len(lines), 2):
                  if i + 1 >= len(lines):
                      break
                  service = lines[i].strip()
                  price_line = lines[i+1].strip().lstrip('\t')
                  parts = price_line.split()
                  if not parts:
                      continue
                  price_str = parts[0].lstrip('$')
                  try:
                      price = float(price_str)
                  except ValueError:
                      continue
                  currency = parts[1] if len(parts) > 1 else '€'
                  if currency == 'USD':
                      eur_price = price * rate
                  else:
                      eur_price = price
                  total_eur += eur_price
                  print(f'\"{service}\",\"{price:.2f}\",\"{currency}\",\"{eur_price:.2f}\"', file=out)

          print(f'Created {args.output}')
          print('First few lines:')
          with open(args.output, 'r') as f:
              for i, line in enumerate(f):
                  if i >= 5:
                      break
                  print(line.rstrip())
          print(f'Total in EUR: {total_eur:.2f}')
          " "$@"
        '';
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.subscriptions-to-csv}/bin/subscriptions-to-csv";
      };
    };
}
