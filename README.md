# Subscriptions to CSV

A simple Nix flake utility to convert a subscription list into a CSV file with EUR conversions and totals. Includes a comprehensive test suite for reliable development.

## Description

This tool processes a text file containing subscription services and their prices, generates a CSV with columns for Service, Price, Currency, and Price in EUR (with automatic USD to EUR conversion), and calculates the total sum in EUR. The project includes comprehensive unit tests covering all major functionality.

## Installation

Ensure you have Nix installed with flakes enabled.

### Option 1: Clone the Repository

Clone or download this repository to use locally.

### Option 2: Direct from GitHub

You can also use this flake directly from GitHub without cloning:

```bash
# Run with default files
nix run github:MBanucu/subscriptions-to-csv#subscriptions-to-csv

# Specify input and output files
nix run github:MBanucu/subscriptions-to-csv#subscriptions-to-csv path/to/input.txt path/to/output.csv

# Show help
nix run github:MBanucu/subscriptions-to-csv#subscriptions-to-csv -- --help
```

This approach allows you to use the tool immediately without downloading the source code.

**Note**: When using `nix run` directly from GitHub, use positional arguments for input/output files or the `--` separator before option flags. Both approaches work the same way. Options work normally when running locally after cloning.

### Alternative: Using the Wrapper Package

You can also use the wrapper package, which provides identical functionality to the main package:

```bash
# Using wrapper with long-form options
nix run github:MBanucu/subscriptions-to-csv#wrapper -- --input subscriptions.txt --output output.csv

# Alternative: Always works (bypasses GitHub caching)
nix run git+https://github.com/MBanucu/subscriptions-to-csv.git#wrapper -- --input subscriptions.txt --output output.csv

# Clone locally and use options normally
git clone https://github.com/MBanucu/subscriptions-to-csv
cd subscriptions-to-csv
nix run .#wrapper -- --input subscriptions.txt --output output.csv
```

**Note:** If you get "attribute 'wrapper' not found", refresh the nix cache with:
```bash
nix flake metadata --refresh github:MBanucu/subscriptions-to-csv
```

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
nix run .#subscriptions-to-csv -- --help
```

Note: The `--` separates nix arguments from application arguments.

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
Spotify,12.99,€,12.99
Netflix,19.99,€,19.99
GutHub Copilot Pro,10.00,USD,8.62
Total in EUR: 41.60
```

## Configuration

- **Input file**: Default `subscriptions.txt`, can be overridden with `--input` or positional argument
- **Output file**: Default `subscriptions.csv`, can be overridden with `--output` or positional argument
- **Exchange rate**: Automatically fetched from exchangerate-api.com
- **Fallback**: If API fails, uses rate 1.0

## Test Coverage

The project includes comprehensive unit tests covering:
- Command-line argument parsing (default, positional, optional)
- Exchange rate API fetching with fallback behavior
- Subscription data parsing and currency conversion
- CSV file generation and total calculations
- Integration testing of the full workflow

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
# Run the test suite
nix develop
pytest

# Run specific tests
pytest tests/test_main.py
pytest -k "parse"  # Run tests matching pattern

# Manual testing - Run with defaults
nix run .#subscriptions-to-csv

# Test CLI options
nix run .#subscriptions-to-csv -- --help

# Check the output CSV and total
```

### Code Style

See AGENTS.md for detailed coding guidelines.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Run tests: `nix develop && pytest`
5. Test manually: `nix run .#subscriptions-to-csv`
6. Submit a pull request

## License

This project is open source. Please check the license file if present.