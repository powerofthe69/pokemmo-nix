#!/usr/bin/env bash
set -e

# Dependencies: curl, jq, nix-prefetch-url
# nix shell nixpkgs#curl nixpkgs#jq nixpkgs#nix

SOURCES_FILE="sources.json"
URL="https://pokemmo.com/download_file/1/"

echo "Checking for client updates..."

# 1. Get the current hash from the JSON file
CURRENT_HASH=$(jq -r .sha256 "$SOURCES_FILE")

# Prefetch new hash
echo "Prefetching and unpacking (this may take a moment)..."
RAW_HASH=$(nix-prefetch-url --unpack --type sha256 "$URL")
NEW_HASH=$(nix hash convert --hash-algo sha256 --to sri "$RAW_HASH")

# 3. Compare
if [ "$CURRENT_HASH" = "$NEW_HASH" ]; then
    echo "No update required."
    exit 0
else
    echo "Updating..."

    # Update the JSON
    UPDATED_JSON=$(jq -n --arg url "$URL" --arg hash "$NEW_HASH" '{ "url": $url, "sha256": $hash }')
    echo "$UPDATED_JSON" > "$SOURCES_FILE"

    echo "Updated $SOURCES_FILE successfully."
fi
