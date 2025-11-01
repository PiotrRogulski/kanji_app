#!/usr/bin/env bash

set -xeou pipefail

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

OUTPUT_ASSET=assets/kanji.jsonl.xz

for f in entries/*.json; do
  jq -c '.' "$f" >> "$TMP"
done

xz -c "$TMP" > "$OUTPUT_ASSET"
