# AGENTS.md

This file provides guidelines and commands for agentic coding agents working on this Nix flake project that converts subscription lists to CSV with EUR conversion and totals.

## Overview

This project is a Nix flake containing:
- A Python package (`subscriptions_to_csv/`) with proper packaging using `pyproject.toml`
- Dual CLI and library support for PyPI publishing
- Exchange rate fetching from API with fallback handling
- CSV generation with EUR conversions and totals
- Comprehensive unit test suite (`tests/test_main.py`)
- Full type hints and proper error handling
- Python package built with `buildPythonPackage` for distribution
- Multi-architecture support (Linux x86_64/aarch64, macOS x86_64/aarch64)

## Project Structure

```
.
├── flake.nix          # Nix flake configuration (multi-arch support)
├── flake.lock         # Nix flake lock file
├── .envrc             # Direnv configuration for automatic devShell loading
├── pyproject.toml     # Python package configuration
├── subscriptions_to_csv/  # Python package directory
│   ├── __init__.py    # Package initialization and exports
│   ├── converter.py   # Core conversion functions and classes
│   └── cli.py         # Command-line interface
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
- **Named options**: `nix run .#subscriptions-to-csv -- --input input.txt --output output.csv`
- **Help**: `nix run .#subscriptions-to-csv -- --help`

### Examples

```bash
# Use default files
nix run .#subscriptions-to-csv

# Specify input file only
nix run .#subscriptions-to-csv custom-subscriptions.txt

# Specify both input and output (positional)
nix run .#subscriptions-to-csv subscriptions.txt results.csv

# Using named options
nix run .#subscriptions-to-csv -- --input ~/data/subscriptions.txt --output ~/exports/subs.csv

# Show help
nix run .#subscriptions-to-csv -- --help
```

### GitHub Flake Usage

For running directly from GitHub without cloning:

```bash
# Basic usage (positional args only)
nix run github:MBanucu/subscriptions-to-csv#subscriptions-to-csv subscriptions.txt output.csv

# Using named options (requires -- separator)
nix run github:MBanucu/subscriptions-to-csv#subscriptions-to-csv -- --input subscriptions.txt --output output.csv

# Alternative that bypasses GitHub caching
nix run git+https://github.com/MBanucu/subscriptions-to-csv.git#subscriptions-to-csv -- --input subscriptions.txt --output output.csv
```

**Note**: When using `nix run` with remote flakes, use the `--` separator before long-form options (`--input`, `--output`) to ensure proper argument parsing. If the package isn't found, refresh the cache with: `nix flake metadata --refresh github:MBanucu/subscriptions-to-csv`

## Library Usage

The package can be used as a Python library for programmatic access to subscription conversion functionality.

### Installation

```bash
pip install subscriptions-to-csv
```

### Basic Usage

```python
from subscriptions_to_csv import convert_subscriptions

# Convert from string data
data = """Netflix
$15.99 USD
Spotify
€9.99"""

subscriptions, total = convert_subscriptions(data)
print(f"Total: €{total:.2f}")
for sub in subscriptions:
    print(f"{sub['Service']}: {sub['Price']} {sub['Currency']} = €{sub['PriceEUR']}")
```

### Advanced Usage

```python
from subscriptions_to_csv import SubscriptionConverter, fetch_exchange_rate

# Manual control over exchange rates
converter = SubscriptionConverter()
converter.set_exchange_rate(0.85)  # Set custom rate

subscriptions = converter.convert("Netflix\n$15.99 USD")
total, count = converter.convert_with_total("Netflix\n$15.99 USD")

# Write to CSV file
converter.convert_to_csv("Netflix\n$15.99 USD", "output.csv")

# Individual functions
rate = fetch_exchange_rate()
parsed = parse_subscription_data("Netflix\n$15.99 USD", rate)
write_csv_file(parsed, "output.csv")
```

### API Reference

- `convert_subscriptions(content, output_file=None, exchange_rate=None)` - Main conversion function
- `fetch_exchange_rate()` - Fetch current USD to EUR exchange rate
- `parse_subscription_data(content, rate)` - Parse subscription data into dictionaries
- `write_csv_file(subscriptions, output_file)` - Write subscriptions to CSV file
- `SubscriptionConverter` - Class for advanced usage with state management

## Build/Lint/Test Commands

### Building and Running

- **Build the flake**: `nix build`
- **Run the application**: `nix run .#subscriptions-to-csv`
- **Enter development shell**: `nix develop` (or use direnv for automatic loading)
- **Run type checking**: `mypy subscriptions_to_csv/` (in devShell)
- **Check flake validity**: `nix flake check`
- **Update flake inputs**: `nix flake update`
- **Show flake outputs**: `nix flake show`

### Testing

The project includes a comprehensive unit test suite using pytest. Tests cover argument parsing, exchange rate fetching, data processing, and CSV generation.

#### Running Tests

- **Run all tests**: `pytest` (in devShell, activated automatically with direnv)
- **Run specific test file**: `pytest tests/test_main.py`
- **Run specific test**: `pytest tests/test_main.py::TestParseArguments::test_default_arguments`
- **Run with verbose output**: `pytest -v`
- **Run tests matching pattern**: `pytest -k "parse"`

#### Flake Checks

The flake includes automated CLI integration tests that verify the `nix run` commands work correctly:

- **Run flake checks**: `nix flake check` (includes CLI tests)
- **Run specific checks**:
  - `nix build .#checks.x86_64-linux.help-test` - Tests `--help` command
  - `nix build .#checks.x86_64-linux.basic-test` - Tests basic functionality with sample data
  - `nix build .#checks.x86_64-linux.named-args-test` - Tests named arguments (`--input`/`--output`)

Flake checks ensure CLI functionality documented in README.md actually works and prevent regressions.

### Code Quality

The project uses mypy for static type checking to ensure type safety and catch potential runtime errors.

#### Type Checking

- **Run mypy**: `mypy subscriptions_to_csv/` (in devShell)
- **Configuration**: `mypy.ini` with strict type checking settings
- **CI Integration**: Runs automatically on all pull requests and main branch pushes
- **Python Version**: Checks against Python 3.8+ type annotations

Mypy configuration enforces:
- All functions must have type annotations
- No implicit Optional types
- Strict equality checks
- Comprehensive error reporting

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

### Python (subscriptions_to_csv/)

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

#### Commit History Cleanup

For complex changes that result in multiple incremental commits (fixes, documentation updates, etc.), consider creating a clean commit history:

1. **Create a clean branch from a stable commit**:
   ```bash
   git checkout -b feature-clean <stable-commit-hash>
   ```

2. **Make all changes at once** on the clean branch:
   - Implement the complete feature
   - Add all necessary documentation updates
   - Fix any issues that arise
   - Test thoroughly

3. **Create a single comprehensive commit**:
   ```bash
   git add <all-changed-files>
   git commit -m "feat: comprehensive description of all changes

   - Detail all major changes made
   - List files modified
   - Explain the complete transformation"
   ```

4. **Replace the main branch** with the clean history:
   ```bash
   git checkout main
   git reset --hard <clean-branch-commit-hash>
   git branch -D feature-clean
   git push  # May need --force if history was rewritten
   ```

**Benefits**:
- Cleaner, more understandable git history
- Easier to review complete changes
- Better for releases and changelogs
- Reduces noise from incremental fixes

**When to use**: For complex refactors, major feature additions, or when incremental commits become messy.

#### Automated Release Management

The project uses **python-semantic-release** for automated versioning and publishing based on conventional commit messages.

**Workflow**:
1. **Commit with conventional format**: Use `feat:`, `fix:`, `docs:`, etc.
2. **Push to main branch**: Triggers automated release workflow
3. **Automatic actions**:
   - Version bump determination (major/minor/patch)
   - Changelog generation
   - Git tag creation
   - GitHub release creation
   - Version file updates (pyproject.toml, __init__.py)
   - PyPI package publishing

**Commit Types & Version Bumps**:

| Commit Type | Version Change | Example |
|-------------|----------------|---------|
| `fix:` | Patch (0.0.x) | `fix: correct EUR conversion bug` |
| `feat:` | Minor (0.x.0) | `feat: add new CLI option` |
| `feat!:` or `BREAKING CHANGE:` | Major (x.0.0) | `feat!: change API completely` |
| `docs:`, `refactor:`, `test:`, `chore:` | No release | `docs: update README` |

**Performance**: Releases complete in 13-16 seconds with full automation.

**Manual Releases**:
For special cases, you can still create releases manually:
```bash
gh release create v1.2.3 --generate-notes
```

**Configuration**:
- `.github/workflows/release.yml`: GitHub Actions workflow
- `pyproject.toml`: python-semantic-release configuration
- Uses python-semantic-release (latest stable)
- Follows conventional commits specification v1.0.0

**Monitoring CI/CD Pipeline**:
To watch the complete automated CI/CD pipeline (tests + releases):

```bash
# 1. List recent workflow runs (shows both CI and Release)
gh run list --limit 5

# 2. Watch CI workflow completion (runs first)
gh run watch $(gh run list --workflow=ci.yml --limit 1 --json databaseId -q '.[0].databaseId')

# 3. Watch Release workflow (triggers after CI success)
gh run watch $(gh run list --workflow=release.yml --limit 1 --json databaseId -q '.[0].databaseId')

# 4. Monitor both workflows in sequence (recommended)
CI_RUN=$(gh run list --workflow=ci.yml --limit 1 --json databaseId -q '.[0].databaseId')
echo "Watching CI workflow..."
gh run watch $CI_RUN
echo "CI completed! Watching Release workflow..."
RELEASE_RUN=$(gh run list --workflow=release.yml --limit 1 --json databaseId -q '.[0].databaseId')
gh run watch $RELEASE_RUN

# 5. Check final status
gh release list --limit 1
python3 -c "import urllib.request, json; print('PyPI:', json.load(urllib.request.urlopen('https://pypi.org/pypi/subscriptions-to-csv/json'))['info']['version'])"

# 6. Debug failed workflows
gh run view <failed-run-id> --log | grep -A 5 -B 5 "error\|Error\|ERROR"
```

**Workflow Execution Flow:**
1. **Push to main** → CI workflow starts automatically
2. **CI runs tests** (pytest) → 12-15 seconds
3. **CI success** → Release workflow triggers automatically
4. **Release analyzes commits** → Creates version bump + changelog
5. **Release builds & publishes** → PyPI + GitHub release

**Expected Timeline:**
- CI: ~12-15 seconds (if tests pass)
- Release: ~13-16 seconds (if triggered)
- Total: ~25-30 seconds for full pipeline

**Common Monitoring Scenarios:**
- ✅ **Normal flow**: CI passes → Release triggers → Success
- ⚠️ **Tests fail**: CI fails → No release → Fix and retry
- ❌ **Release fails**: CI passes → Release fails → Check PyPI auth/logs

The release workflow typically completes in 13-16 seconds and includes:
- Semantic release analysis
- Version file updates
- Package building
- PyPI publishing
- GitHub release creation

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

1. The project uses direnv for automatic devShell loading - when entering the directory, the Nix devShell environment is automatically activated if direnv is installed
2. Always test with `nix run .#subscriptions-to-csv` after modifications, including testing CLI options like `--help`, `--input`, and `--output`
3. Test with named options: `nix run .#subscriptions-to-csv -- --input subscriptions.txt --output test.csv`
4. Run the test suite with `pytest` to ensure no regressions (available automatically in devShell)
5. Verify CSV output format remains consistent
6. Check that exchange rate fetching works
7. Ensure total calculation is accurate
8. Update this file if adding new patterns or tools

Recent refactoring examples:
- **Environment management**: Added `.envrc` file with direnv support for automatic devShell loading when entering the directory
- **Python packaging**: Converted from single-file script to proper Python package using `pyproject.toml` and `buildPythonPackage` for better distribution and packaging practices
- **Multi-architecture support**: Updated flake.nix to support x86_64/aarch64 Linux and macOS using `forAllSystems`
- **Code organization**: Refactored `main.py` into `subscriptions_to_csv/` package with separate `converter.py`, `cli.py`, and `__init__.py` modules for better maintainability and testability
- **Library support**: Added dual CLI and library API with type hints and proper error handling for PyPI publishing
- **Test suite**: Updated comprehensive pytest test suite to work with new package structure while maintaining all functionality
- **Data processing**: Separated data parsing from CSV output generation by storing subscription data in Python data structures first, then using `csv.DictWriter` for proper formatting

For new features:
- Consider backward compatibility
- Add appropriate error handling
- Update documentation
- Test edge cases

Remember: This is a simple utility. Keep changes focused and maintainable.