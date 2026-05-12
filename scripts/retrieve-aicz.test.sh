#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SCRIPT="$SCRIPT_DIR/retrieve-aicz.sh"
HOSTED_ENDPOINT="https://persona.market/app/api/skills/aicz/retrieve"

assert_contains() {
  haystack=$1
  needle=$2
  label=$3

  case "$haystack" in
    *"$needle"*) ;;
    *)
      printf 'not ok - %s\nExpected to find: %s\nOutput:\n%s\n' "$label" "$needle" "$haystack" >&2
      exit 1
      ;;
  esac
}

default_output=$("$SCRIPT" "CZ current work" --limit 5 --dry-run)
assert_contains "$default_output" "$HOSTED_ENDPOINT" "default endpoint uses hosted Persona.market API"

output=$("$SCRIPT" "CZ current work" --limit 7 --dry-run)
assert_contains "$output" "curl -fsSL --get" "dry-run uses curl GET"
assert_contains "$output" "--data-urlencode q=CZ current work" "dry-run keeps query for curl encoding"
assert_contains "$output" "--data-urlencode limit=7" "dry-run passes limit"
assert_contains "$output" "$HOSTED_ENDPOINT" "dry-run uses hosted Persona.market API"

low_limit=$("$SCRIPT" "test" --limit 0 --dry-run)
assert_contains "$low_limit" "--data-urlencode limit=1" "limit is clamped to minimum"

high_limit=$("$SCRIPT" "test" --limit 99 --dry-run)
assert_contains "$high_limit" "--data-urlencode limit=10" "limit is clamped to maximum"

bad_limit=$("$SCRIPT" "test" --limit bad --dry-run)
assert_contains "$bad_limit" "--data-urlencode limit=5" "invalid limit falls back to default"

fixture='{"query":"YZi Labs","limit":5,"data":[{"topic":"YZi Labs current focus","content":"YZi Labs supports AI, crypto, and biotech builders.","source":"YZi Labs update","similarity":0.82}]}'
formatted=$(printf '%s' "$fixture" | "$SCRIPT" --format-only)
assert_contains "$formatted" "Query: YZi Labs" "formatted output includes query"
assert_contains "$formatted" "1. YZi Labs current focus" "formatted output includes topic"
assert_contains "$formatted" "Source: YZi Labs update" "formatted output includes source"
assert_contains "$formatted" "Similarity: 0.82" "formatted output includes similarity"

json=$(printf '%s' "$fixture" | "$SCRIPT" --format-only --json)
assert_contains "$json" '"query":"YZi Labs"' "json output preserves raw payload"

printf 'ok - retrieve-aicz.sh\n'
