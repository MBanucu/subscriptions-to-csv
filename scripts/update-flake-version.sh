#!/bin/bash
# Post-release hook to update flake.nix version
# This runs after semantic-release updates other files

set -e

# Get the version from __init__.py (should be updated by semantic-release)
VERSION=$(python -c "import subscriptions_to_csv; print(subscriptions_to_csv.__version__)")

echo "Updating flake.nix version to $VERSION"

# Update the version line in flake.nix
sed -i "s/version = \".*\";/version = \"$VERSION\";/" flake.nix

echo "flake.nix updated successfully"
