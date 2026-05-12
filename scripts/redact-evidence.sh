#!/usr/bin/env bash

INPUT="$1"
OUTPUT="$2"

if [ -z "$INPUT" ]; then
  echo "[FAIL] usage: scripts/redact-evidence.sh <input-file> [output-file]"
  exit 1
fi

if [ ! -f "$INPUT" ]; then
  echo "[FAIL] input file not found: $INPUT"
  exit 1
fi

if [ -z "$OUTPUT" ]; then
  OUTPUT="${INPUT}.redacted"
fi

sed -E \
  -e 's/(Authorization: Bearer )[A-Za-z0-9._~+\/=-]+/\1<REDACTED>/g' \
  -e 's/(iam_token|access_token|refresh_token|id_token)(["=: ]+)[A-Za-z0-9._~+\/=-]+/\1\2<REDACTED>/gi' \
  -e 's/(secret|password|private_key)(["=: ]+)[^", ]+/\1\2<REDACTED>/gi' \
  -e 's/(cloud_id|folder_id|organization_id|service_account_id)(["=: ]+)[a-z0-9-]+/\1\2<REDACTED>/gi' \
  -e 's/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/<EMAIL_REDACTED>/g' \
  "$INPUT" > "$OUTPUT"

echo "[OK] redacted file saved: $OUTPUT"
