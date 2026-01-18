import sys, json, urllib.request, argparse, csv


def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description='Convert subscription list to CSV with EUR conversion')
    parser.add_argument('input_pos', nargs='?', help='Input file containing subscriptions')
    parser.add_argument('output_pos', nargs='?', help='Output CSV file')
    parser.add_argument('--input', '-i', help='Input file containing subscriptions')
    parser.add_argument('--output', '-o', help='Output CSV file')
    args = parser.parse_args()

    # Use optional args if provided, otherwise positional, otherwise defaults
    args.input = args.input or args.input_pos or 'subscriptions.txt'
    args.output = args.output or args.output_pos or 'subscriptions.csv'

    return args


def fetch_exchange_rate():
    """Fetch USD to EUR exchange rate from API."""
    try:
        with urllib.request.urlopen('https://api.exchangerate-api.com/v4/latest/USD') as f:
            data = json.load(f)
        return data['rates']['EUR']
    except Exception:
        print('Failed to fetch exchange rate', file=sys.stderr)
        return 1.0  # fallback


def parse_subscription_data(lines, rate):
    """Parse subscription data from lines into list of dictionaries."""
    subscriptions = []
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
        subscriptions.append({
            'Service': service,
            'Price': f'{price:.2f}',
            'Currency': currency,
            'PriceEUR': f'{eur_price:.2f}'
        })
    return subscriptions


def write_csv_file(subscriptions, output_file):
    """Write subscriptions to CSV file and return total EUR."""
    total_eur = sum(float(sub['PriceEUR']) for sub in subscriptions)
    with open(output_file, 'w', newline='') as csvfile:
        fieldnames = ['Service', 'Price', 'Currency', 'PriceEUR']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(subscriptions)
    return total_eur


def print_summary(output_file, total_eur):
    """Print summary of the conversion."""
    print(f'Created {output_file}')
    print('First few lines:')
    with open(output_file, 'r') as f:
        for i, line in enumerate(f):
            if i >= 5:
                break
            print(line.rstrip())
    print(f'Total in EUR: {total_eur:.2f}')


def main():
    """Main function to run the subscription converter."""
    args = parse_arguments()
    rate = fetch_exchange_rate()

    # Read input file
    with open(args.input, 'r') as f:
        lines = f.readlines()

    subscriptions = parse_subscription_data(lines, rate)
    total_eur = write_csv_file(subscriptions, args.output)
    print_summary(args.output, total_eur)


if __name__ == '__main__':
    main()