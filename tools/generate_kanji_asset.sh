#!/usr/bin/env bash

set -eou pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <source_dir> <output_path>"
  exit 1
fi

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

SOURCE_DIR=$1
OUTPUT_PATH=$2

for f in "$SOURCE_DIR"/*.json; do
  jq -c '.' "$f" >> "$TMP"
done

xz -c "$TMP" > "$OUTPUT_PATH"
