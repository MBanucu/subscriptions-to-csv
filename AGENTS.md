# AGENTS.md

This file provides guidelines and commands for agentic coding agents working on this Nix flake project that converts subscription lists to CSV with EUR conversion and totals.

## Overview

This project is a Nix flake containing:
- A Python script (`main.py`) for processing subscription data with command-line argument parsing
- Exchange rate fetching from API
- CSV generation with EUR conversions
- Total sum calculation
- Comprehensive unit test suite (`tests/test_main.py`)
- Wrapper package for improved GitHub flake argument handling
- Multi-architecture support (Linux x86_64/aarch64, macOS x86_64/aarch64)

## Project Structure

```
.
├── flake.nix          # Nix flake configuration (multi-arch support)
├── flake.lock         # Nix flake lock file
├── main.py            # Main Python application
├── tests/             # Test directory
│   ├── test_main.py   # Unit tests
│   └── README.md      # Test documentation
├── subscriptions.txt  # Default input file (example)
├── subscriptions.csv  # Default output file (generated)
├── README.md          # Project README
├── AGENTS.md          # This file - agent guidelines
└── .gitignore         # Git ignore patterns
```

## CLI Usage

The application supports command-line arguments for input and output files, with both positional and optional syntax. Multiple package variants are available for different use cases.

### Basic Usage

- **Default**: `nix run .#subscriptions-to-csv` (uses `subscriptions.txt` and `subscriptions.csv`)
- **Positional**: `nix run .#subscriptions-to-csv input.txt output.csv`
- **Wrapper**: `nix run .#wrapper --input input.txt --output output.csv`
- **Help**: `nix run .#subscriptions-to-csv -- --help`

### Examples

```bash
# Use default files
nix run .#subscriptions-to-csv

# Specify input file only
nix run .#subscriptions-to-csv custom-subscriptions.txt

# Specify both input and output (positional)
nix run .#subscriptions-to-csv subscriptions.txt results.csv

# Using wrapper with options
nix run .#wrapper --input ~/data/subscriptions.txt --output ~/exports/subs.csv

# Show help
nix run .#subscriptions-to-csv -- --help
```

### GitHub Flake Usage

For running directly from GitHub without cloning:

```bash
# Basic usage (positional args only)
nix run github:MBanucu/subscriptions-to-csv#subscriptions-to-csv subscriptions.txt output.csv

# Both packages support the same argument patterns
nix run github:MBanucu/subscriptions-to-csv#wrapper -- --input subscriptions.txt --output output.csv

# Alternative that bypasses GitHub caching (works with both packages)
nix run git+https://github.com/MBanucu/subscriptions-to-csv.git#wrapper -- --input subscriptions.txt --output output.csv
```

**Note**: When using `nix run` with remote flakes, use the `--` separator before long-form options (`--input`, `--output`) to ensure proper argument parsing. Both `subscriptions-to-csv` and `wrapper` packages support identical argument patterns. If packages aren't found, refresh the cache with: `nix flake metadata --refresh github:MBanucu/subscriptions-to-csv`

## Build/Lint/Test Commands

### Building and Running

- **Build the flake**: `nix build`
- **Run the application**: `nix run .#subscriptions-to-csv`
- **Run wrapper**: `nix run .#wrapper --input file.txt --output out.csv`
- **Enter development shell**: `nix develop`
- **Check flake validity**: `nix flake check`
- **Update flake inputs**: `nix flake update`
- **Show flake outputs**: `nix flake show`

### Testing

The project includes a comprehensive unit test suite using pytest. Tests cover argument parsing, exchange rate fetching, data processing, and CSV generation.

#### Running Tests

- **Run all tests**: `nix develop` then `pytest`
- **Run specific test file**: `pytest tests/test_main.py`
- **Run specific test**: `pytest tests/test_main.py::TestParseArguments::test_default_arguments`
- **Run with verbose output**: `pytest -v`
- **Run tests matching pattern**: `pytest -k "parse"`

#### Test Coverage

The test suite includes:
- **Argument parsing**: Default, positional, and optional arguments
- **Exchange rate API**: Successful fetching and fallback behavior
- **Data parsing**: EUR/USD currency conversion, multiple subscriptions, error handling
- **CSV generation**: File output, headers, and total calculations
- **Integration tests**: Full workflow from input to output

#### Manual Testing

For additional manual verification:

- Run the command: `nix run .#subscriptions-to-csv`
- Verify output CSV is created correctly
- Check that EUR conversions use current exchange rates
- Confirm total sum is calculated accurately
- Test CLI options: `nix run .#subscriptions-to-csv --help` should display usage information

For manual testing of specific scenarios:
- Test with different input files: `nix run .#subscriptions-to-csv ./custom-subscriptions.txt`
- Test output to different file: `nix run .#subscriptions-to-csv subscriptions.txt output.csv`
- Test options: `nix run .#subscriptions-to-csv --input input.txt --output output.csv`
- Test remote execution: `nix run github:MBanucu/subscriptions-to-csv#subscriptions-to-csv --input ~/path/to/file.txt`

### Linting

No formal linting is configured. For Python code within the flake:

- Use `python3 -m py_compile` to check syntax
- Manually review for PEP 8 compliance
- Run tests with `pytest` to ensure functionality

For Nix code:
- `nix flake check` will catch basic errors
- Use `nixpkgs-fmt` if available for formatting

## Code Style Guidelines

### General Principles

- Keep code simple and readable
- Use descriptive variable names
- Handle errors gracefully with fallbacks
- Prefer standard library over external dependencies
- Document complex logic with comments

### Nix (flake.nix)

#### File Structure
- Support multiple architectures using `forAllSystems`
- Group related outputs together (packages, apps, devShells)
- Use descriptive let bindings for complex expressions

#### Naming Conventions
- Use `systems` list for supported architectures
- Use `forAllSystems` helper for multi-arch support
- Use `pkgs` for nixpkgs package set
- Package names: lowercase-with-dashes
- Attribute names: camelCase for outputs

#### Multi-Architecture Support
The flake supports multiple systems:
- `x86_64-linux` (Linux x86_64)
- `aarch64-linux` (Linux ARM64)
- `x86_64-darwin` (macOS x86_64)
- `aarch64-darwin` (macOS ARM64)

#### Formatting
- 2-space indentation
- Align attribute names in sets
- Use consistent quoting (double quotes for strings)
- Break long lines appropriately

Example:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          my-package = pkgs.writeShellApplication {
            name = "my-package";
            runtimeInputs = with pkgs; [ python3 ];
            text = ''
              # script here
            '';
          };
        }
      );
    };
}
```

#### Error Handling
- Use `tryEval` for optional operations
- Provide meaningful error messages
- Use `abort` for unrecoverable errors

#### Imports and Dependencies
- Minimize runtime dependencies
- Use `with pkgs;` sparingly, prefer explicit imports
- Pin versions through flake inputs

### Python (main.py)

#### Imports
- Import standard library modules first
- Group imports by type (stdlib, third-party)
- Use absolute imports
- Avoid wildcard imports (`from module import *`)

Example:
```python
import sys
import json
import csv
import urllib.request
```

#### Formatting
- Follow PEP 8 style guide
- 4-space indentation
- Line length: 88 characters (Black default)
- Use double quotes for strings unless single quotes are needed
- Add trailing commas in multi-line structures

#### Naming Conventions
- Functions: snake_case (e.g., `fetch_exchange_rate`)
- Variables: snake_case (e.g., `total_eur`)
- Constants: UPPER_SNAKE_CASE
- Classes: PascalCase (if any)

#### Types
- Use type hints for function parameters and return values
- Import from `typing` module when needed

Example:
```python
from typing import List, Dict

def process_data(data: List[str]) -> Dict[str, float]:
    # implementation
```

#### Error Handling
- Use try-except blocks for network operations
- Provide fallback values for API failures
- Log errors to stderr
- Don't crash on malformed input, skip gracefully

Example:
```python
try:
    with urllib.request.urlopen(url) as f:
        data = json.load(f)
except Exception as e:
    print(f"Failed to fetch data: {e}", file=sys.stderr)
    data = {"rates": {"EUR": 1.0}}  # fallback
```

#### Data Processing
- Validate input data before processing
- Store parsed data in Python data structures (lists, dictionaries) before generating output
- Use list comprehensions for simple transformations
- Handle edge cases (empty files, malformed lines)
- Convert strings to appropriate types early

Example:
```python
# Parse data into list of dictionaries first
subscriptions = []
for item in data:
    subscriptions.append({
        'field1': value1,
        'field2': value2
    })

# Then generate output using the data structure
```

#### Performance
- Minimize API calls (cache rates if possible)
- Process files line-by-line for large inputs
- Use efficient data structures

#### CLI Argument Parsing
- Use `argparse` from the standard library for command-line interfaces
- Define both positional and optional arguments with clear descriptions
- Handle argument precedence (optional overrides positional, defaults as fallback)
- Support `--help` for usage information

Example:
```python
import argparse

def parse_arguments():
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
```

#### CSV Generation
- Use the `csv` module from the standard library for proper CSV formatting
- Prefer `csv.DictWriter` for structured data with headers
- It handles quoting, escaping, and formatting automatically

Example:
```python
import csv

with open(args.output, 'w', newline='') as csvfile:
    fieldnames = ['Service', 'Price', 'Currency', 'PriceEUR']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(subscriptions)
```

### Bash/Shell Scripting

#### Best Practices
- Use `set -euo pipefail` for error handling
- Quote variables to prevent word splitting
- Use descriptive variable names
- Keep scripts simple, delegate complex logic to Python

#### Nix String Interpolation
- Use `''${variable}` for interpolation in multi-line strings
- Escape special characters appropriately
- Test interpolation thoroughly

### Documentation

#### Comments
- Use `#` for single-line comments
- Explain why, not just what
- Keep comments up-to-date with code changes

#### README
- Include setup instructions
- Document usage examples
- Explain configuration options

### Security

- Validate URLs before fetching
- Don't store sensitive data in code
- Use HTTPS for API calls
- Sanitize user inputs

### Git Workflow

- **Always use conventional commit format**: All commits must follow the Conventional Commits specification v1.0.0
- **Internalize the specification**: Read and understand https://www.conventionalcommits.org/en/v1.0.0/#specification before crafting any commit message
- Use conventional commit messages
- Keep commits focused and atomic
- Test before committing
- Use meaningful branch names

### Dependencies

- Keep runtime dependencies minimal
- Use stable versions from nixpkgs
- Test with different Nix versions
- Update flake.lock regularly

### Future Improvements

- Implement caching for exchange rates
- Add configuration file support
- Improve error messages and user feedback
- Add support for more currencies
- Enhance CLI with additional options (e.g., currency selection, verbose output)

## Cursor Rules

No Cursor rules (.cursor/rules/ or .cursorrules) found in this repository.

## Copilot Rules

No Copilot rules (.github/copilot-instructions.md) found in this repository.

## Agent Guidelines

When making changes:

1. Always test with `nix run .#subscriptions-to-csv` after modifications, including testing CLI options like `--help`, `--input`, and `--output`
2. Test the wrapper package: `nix run .#wrapper --input subscriptions.txt --output test.csv`
3. Run the test suite with `pytest` to ensure no regressions
4. Verify CSV output format remains consistent
5. Check that exchange rate fetching works
6. Ensure total calculation is accurate
7. Update this file if adding new patterns or tools

Recent refactoring examples:
- **Multi-architecture support**: Updated flake.nix to support x86_64/aarch64 Linux and macOS using `forAllSystems`
- **Wrapper package**: Added wrapper package as an alternative interface with identical functionality
- **Code organization**: Extracted Python code from inline flake.nix string to separate `main.py` file with proper function structure for better maintainability and testability
- **Test suite**: Added comprehensive pytest test suite covering all major functionality
- **Data processing**: Separated data parsing from CSV output generation by storing subscription data in Python data structures first, then using `csv.DictWriter` for proper formatting

For new features:
- Consider backward compatibility
- Add appropriate error handling
- Update documentation
- Test edge cases

Remember: This is a simple utility. Keep changes focused and maintainable.