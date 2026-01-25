#!/usr/bin/env bash

set -eou pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <source_dir> <output_path>"
  exit 1
fi

SOURCE_DIR=$1
OUTPUT_PATH=$2

echo -n '' > "$OUTPUT_PATH"

for f in "$SOURCE_DIR"/*.json; do
  jq -c '.' "$f" >> "$OUTPUT_PATH"
done
