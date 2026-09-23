#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

auth=()
if [[ -n "${GITHUB_TOKEN:-}" ]]; then
  auth=(-H "Authorization: Bearer $GITHUB_TOKEN")
fi
version="${1:-$(curl -fsSL "${auth[@]}" https://api.github.com/repos/sn4k3/UVtools/releases/latest | jq -er '.tag_name')}"
version="${version#v}"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Invalid release version" >&2; exit 1; }

url="https://github.com/sn4k3/UVtools/releases/download/v${version}/UVtools_linux-x64_v${version}.AppImage"
hash=$(nix store prefetch-file --json "$url" | jq -er .hash)
jq -n --arg version "$version" --arg hash "$hash" '{version: $version, hash: $hash}' > sources.json
echo "Updated to $version"
