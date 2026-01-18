# Subscriptions to CSV

A simple Nix flake utility to convert a subscription list into a CSV file with EUR conversions and totals.

## Description

This tool processes a text file containing subscription services and their prices, generates a CSV with columns for Service, Price, Currency, and Price in EUR (with automatic USD to EUR conversion), and calculates the total sum in EUR.

## Installation

Ensure you have Nix installed with flakes enabled.

Clone or download this repository.

## Usage

### Basic Usage

```bash
# Enter the development shell
nix develop

# Run the converter
subscriptions-to-csv
```

This will read `subscriptions.txt` and output `subscriptions.csv`.

### Custom Files

```bash
# Specify input and output files (positional)
nix run .#subscriptions-to-csv path/to/input.txt path/to/output.csv

# Or using options
nix run .#subscriptions-to-csv --input path/to/input.txt --output path/to/output.csv
```

### Direct Run

```bash
nix run .#subscriptions-to-csv
```

### Help

```bash
# Show usage information
nix run .#subscriptions-to-csv --help
```

## Input Format

The input file should contain subscription data in the following format:

```
Service Name
	Price Currency
Service Name
	Price Currency
```

Example:

```
Spotify
	12.99 €
Netflix
	19.99 €
GutHub Copilot Pro
	$10.00 USD
```

Supported currencies: € (Euro), USD (automatically converted to EUR).

## Output

The output CSV contains:

- **Service**: The subscription name
- **Price**: The original price
- **Currency**: The original currency
- **PriceEUR**: The price in EUR (converted if necessary)

Plus a total sum in EUR printed to the console.

Example output:

```
Service,Price,Currency,PriceEUR
"Spotify","12.99","€","12.99"
"Netflix","19.99","€","19.99"
"GutHub Copilot Pro","10.00","USD","8.62"
Total in EUR: 41.60
```

## Configuration

- **Input file**: Default `subscriptions.txt`, can be overridden with `--input` or positional argument
- **Output file**: Default `subscriptions.csv`, can be overridden with `--output` or positional argument
- **Exchange rate**: Automatically fetched from exchangerate-api.com
- **Fallback**: If API fails, uses rate 1.0

## Requirements

- Nix with flakes support
- Internet connection for exchange rate fetching

## Development

### Building

```bash
nix build
```

### Testing

```bash
# Run with defaults
nix run .#subscriptions-to-csv

# Test CLI options
nix run .#subscriptions-to-csv --help

# Check the output CSV and total
```

### Code Style

See AGENTS.md for detailed coding guidelines.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Test with `nix run .#subscriptions-to-csv`
5. Submit a pull request

## License

This project is open source. Please check the license file if present.