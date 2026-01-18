# AGENTS.md

This file provides guidelines and commands for agentic coding agents working on this Nix flake project that converts subscription lists to CSV with EUR conversion and totals.

## Overview

This project is a Nix flake containing:
- A Python script for processing subscription data with command-line argument parsing
- Exchange rate fetching from API
- CSV generation with EUR conversions
- Total sum calculation

## CLI Usage

The application supports command-line arguments for input and output files, with both positional and optional syntax.

### Basic Usage

- **Default**: `nix run .#subscriptions-to-csv` (uses `subscriptions.txt` and `subscriptions.csv`)
- **Positional**: `nix run .#subscriptions-to-csv input.txt output.csv`
- **Options**: `nix run .#subscriptions-to-csv --input input.txt --output output.csv`
- **Help**: `nix run .#subscriptions-to-csv --help`

### Examples

```bash
# Use default files
nix run .#subscriptions-to-csv

# Specify input file only
nix run .#subscriptions-to-csv custom-subscriptions.txt

# Specify both input and output
nix run .#subscriptions-to-csv subscriptions.txt results.csv

# Using options
nix run .#subscriptions-to-csv --input ~/data/subscriptions.txt --output ~/exports/subs.csv

# Show help
nix run .#subscriptions-to-csv -- --help
```

Note: When running from GitHub (e.g., `nix run github:MBanucu/subscriptions-to-csv#subscriptions-to-csv`), use `--` to separate nix args from app args for help or options.

## Build/Lint/Test Commands

### Building and Running

- **Build the flake**: `nix build`
- **Run the application**: `nix run .#subscriptions-to-csv`
- **Enter development shell**: `nix develop`
- **Check flake validity**: `nix flake check`
- **Update flake inputs**: `nix flake update`

### Testing

There are currently no automated tests in this project. To manually test:

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
- Follow nixpkgs flake template structure
- Group related outputs together
- Use descriptive let bindings for complex expressions

#### Naming Conventions
- Use `system` for the target system string
- Use `pkgs` for nixpkgs package set
- Package names: lowercase-with-dashes
- Attribute names: camelCase for outputs

#### Formatting
- 2-space indentation
- Align attribute names in sets
- Use consistent quoting (double quotes for strings)
- Break long lines appropriately

Example:
```nix
{
  packages.${system}.my-package = pkgs.writeShellApplication {
    name = "my-package";
    runtimeInputs = with pkgs; [ python3 ];
    text = ''
      # script here
    '';
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

### Python (Embedded Script)

#### Imports
- Import standard library modules first
- Group imports by type (stdlib, third-party)
- Use absolute imports
- Avoid wildcard imports (`from module import *`)

Example:
```python
import sys
import json
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
- Use list comprehensions for simple transformations
- Handle edge cases (empty files, malformed lines)
- Convert strings to appropriate types early

#### Performance
- Minimize API calls (cache rates if possible)
- Process files line-by-line for large inputs
- Use efficient data structures

#### CLI Argument Parsing
- Use `argparse` from the standard library for command-line interfaces
- Define positional and optional arguments with clear descriptions
- Provide sensible defaults for input/output files
- Support `--help` for usage information

Example:
```python
import argparse

parser = argparse.ArgumentParser(description='Process subscription data')
parser.add_argument('--input', '-i', default='subscriptions.txt', help='Input file')
parser.add_argument('--output', '-o', default='subscriptions.csv', help='Output file')
args = parser.parse_args()
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

- Add proper test suite with pytest
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
2. Verify CSV output format remains consistent
3. Check that exchange rate fetching works
4. Ensure total calculation is accurate
5. Update this file if adding new patterns or tools

For new features:
- Consider backward compatibility
- Add appropriate error handling
- Update documentation
- Test edge cases

Remember: This is a simple utility. Keep changes focused and maintainable.