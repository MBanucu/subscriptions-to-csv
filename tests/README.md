# Tests

This directory contains unit tests for the subscriptions-to-csv application.

## Running Tests

To run the tests, enter the development shell and run pytest:

```bash
nix develop
pytest
```

## Test Coverage

The tests cover:

- **Argument parsing**: Default arguments, positional arguments, and optional arguments
- **Exchange rate fetching**: Successful API calls and fallback behavior
- **Subscription data parsing**: EUR/USD currencies, multiple subscriptions, error handling
- **CSV file writing**: File creation, header formatting, total calculation
- **Integration test**: Full workflow from argument parsing to CSV output

## Test Structure

- `test_main.py`: Unit tests for the main application functions
  - `TestParseArguments`: Tests command-line argument parsing
  - `TestFetchExchangeRate`: Tests exchange rate API functionality
  - `TestParseSubscriptionData`: Tests subscription data parsing logic
  - `TestWriteCsvFile`: Tests CSV file writing and total calculation