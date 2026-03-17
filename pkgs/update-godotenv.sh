#!/usr/bin/env bash
# Updater script for godotenv
# Usage: ./update-godotenv.sh [--dry-run] [--no-deps]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GODOTENV_NIX="$SCRIPT_DIR/godotenv.nix"
DEPS_JSON="$SCRIPT_DIR/deps.json"
DRY_RUN=""
REGEN_DEPS=true
FORCE_UPDATE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN="--dry-run"
            shift
            ;;
        --no-deps)
            REGEN_DEPS=false
            shift
            ;;
        --force-deps)
            FORCE_UPDATE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--dry-run] [--no-deps] [--force-deps]"
            exit 1
            ;;
    esac
done

# GitHub repository details
OWNER="chickensoft-games"
REPO="GodotEnv"

echo "=== GodotEnv Updater ==="

# Get current version from godotenv.nix
CURRENT_VERSION=$(grep -oP 'version = "\K[^"]+' "$GODOTENV_NIX")
echo "Current version: $CURRENT_VERSION"

# Get latest release tag from GitHub
LATEST_TAG=$(curl -sS "https://api.github.com/repos/$OWNER/$REPO/releases/latest" | grep -oP '"tag_name":\s*"\K[^"]+')
echo "Latest release: $LATEST_TAG"

# Extract version number (remove 'v' prefix)
LATEST_VERSION="${LATEST_TAG#v}"

if [[ "$CURRENT_VERSION" == "$LATEST_VERSION" ]] && ! $FORCE_UPDATE; then
    echo "Already up to date! (use --force-deps to regenerate deps.json anyway)"
    exit 0
fi

echo "Updating from $CURRENT_VERSION to $LATEST_VERSION..."

# Fetch the new hash by downloading the archive and computing SHA256
echo "Fetching new hash..."
TEMP_DIR=$(mktemp -d)
ARCHIVE_URL="https://github.com/$OWNER/$REPO/archive/$LATEST_TAG.tar.gz"
ARCHIVE_PATH="$TEMP_DIR/archive.tar.gz"

curl -sSL "$ARCHIVE_URL" -o "$ARCHIVE_PATH"

# Compute SHA256 in nix format (sha256-...)
# sha256sum outputs hex, but Nix needs base64 - convert hex to base64
HEX_HASH=$(sha256sum "$ARCHIVE_PATH" | cut -d' ' -f1)
# Convert hex to base64 using perl
NEW_HASH="sha256-$(perl -MMIME::Base64 -e 'print encode_base64(pack("H*", $ARGV[0]))' "$HEX_HASH" | tr -d '\n')"

rm -rf "$TEMP_DIR"

echo "New hash: $NEW_HASH"

if [[ "$DRY_RUN" == "--dry-run" ]]; then
    echo ""
    echo "=== Dry Run - No changes made ==="
    echo "Would update version from $CURRENT_VERSION to $LATEST_VERSION"
    echo "Would update hash to: $NEW_HASH"
    if $REGEN_DEPS; then
        echo "Would regenerate deps.json"
    else
        echo "Would skip deps.json regeneration (--no-deps)"
    fi
    exit 0
fi

# Update godotenv.nix
echo "Updating $GODOTENV_NIX..."

# Update version
sed -i "s/version = \"$CURRENT_VERSION\"/version = \"$LATEST_VERSION\"/" "$GODOTENV_NIX"

# Update hash - use different delimiter to handle + and = in base64
sed -i "s|hash = \".*\"|hash = \"$NEW_HASH\"|" "$GODOTENV_NIX"

echo "Done! Updated godotenv.nix:"
echo "  Version: $CURRENT_VERSION -> $LATEST_VERSION"
echo "  Hash: $NEW_HASH"

# Regenerate deps.json if requested
if $REGEN_DEPS; then
    echo ""
    echo "Regenerating deps.json..."

    # Create a temporary directory for the source
    TEMP_DIR=$(mktemp -d)
    EXTRACT_DIR="$TEMP_DIR/GodotEnv-$LATEST_VERSION"

    # Download and extract
    ARCHIVE_URL="https://github.com/$OWNER/$REPO/archive/$LATEST_TAG.tar.gz"
    curl -sSL "$ARCHIVE_URL" | tar -xzf - -C "$TEMP_DIR"

    # Find the .csproj file
    CSPROJ_FILE=$(find "$EXTRACT_DIR" -name "*.csproj" -path "*/GodotEnv/*" | head -n 1)

    if [[ -z "$CSPROJ_FILE" ]]; then
        echo "Error: Could not find .csproj file in $EXTRACT_DIR"
        rm -rf "$TEMP_DIR"
        exit 1
    fi

    echo "Found project file: $CSPROJ_FILE"

    # Generate deps.json using nuget-to-json
    # First, restore packages to get them in a local directory
    cd "$EXTRACT_DIR"

    # Create packages directory
    PACKAGES_DIR="$TEMP_DIR/packages"
    mkdir -p "$PACKAGES_DIR"

    # Run dotnet restore to download packages
    echo "Running dotnet restore..."
    nix-shell -p dotnetCorePackages.sdk_8_0 --run "dotnet restore '$CSPROJ_FILE' --packages '$PACKAGES_DIR'" || {
        echo "Warning: dotnet restore failed, trying alternative method..."
    }

    # Check if packages were downloaded
    if [[ -d "$PACKAGES_DIR" ]] && [[ -n "$(ls -A "$PACKAGES_DIR" 2>/dev/null)" ]]; then
        echo "Using nuget-to-json to generate deps.json..."
        # nuget-to-json takes a packages directory and outputs JSON
        nix-shell -p nuget-to-json dotnetCorePackages.sdk_8_0 --run "nuget-to-json '$PACKAGES_DIR'" > "$DEPS_JSON"
        echo "Generated deps.json"
    else
        echo "Warning: No packages found, deps.json may be incomplete"
        echo "[]" > "$DEPS_JSON"
    fi

    cd "$SCRIPT_DIR"
    rm -rf "$TEMP_DIR"

    echo "Done! Updated deps.json"
else
    echo ""
    echo "Skipping deps.json regeneration (--no-deps)"
fi

echo ""
echo "=== Update Complete ==="
echo "Run 'direnv reload' or 'nix-shell --run \"godotenv --version\"' to verify"