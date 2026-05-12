#!/bin/sh
set -eu

DEFAULT_ENDPOINT="https://persona.market/app/api/skills/aicz/retrieve"
DEFAULT_LIMIT=5
MIN_LIMIT=1
MAX_LIMIT=10

query=
limit=$DEFAULT_LIMIT
endpoint=$DEFAULT_ENDPOINT
json=0
dry_run=0
format_only=0

usage() {
  cat <<'EOF'
Usage:
  sh scripts/retrieve-aicz.sh "YZi Labs recent focus"
  sh scripts/retrieve-aicz.sh "AICZ source evidence" --limit 3 --json

Options:
  -l, --limit <n>       Number of snippets, 1-10. Default: 5
      --json            Print raw JSON response
      --dry-run         Print the curl request without executing it
      --format-only     Read JSON from stdin and format it
  -h, --help            Show this help
EOF
}

normalize_limit() {
  raw=${1:-}
  case "$raw" in
    ''|*[!0-9]*) printf '%s\n' "$DEFAULT_LIMIT" ;;
    *)
      if [ "$raw" -lt "$MIN_LIMIT" ]; then
        printf '%s\n' "$MIN_LIMIT"
      elif [ "$raw" -gt "$MAX_LIMIT" ]; then
        printf '%s\n' "$MAX_LIMIT"
      else
        printf '%s\n' "$raw"
      fi
      ;;
  esac
}

append_query_part() {
  if [ -z "$query" ]; then
    query=$1
  else
    query="$query $1"
  fi
}

format_payload() {
  payload=$(cat)

  if [ "$json" -eq 1 ]; then
    printf '%s\n' "$payload"
    return 0
  fi

  if command -v python3 >/dev/null 2>&1; then
    printf '%s' "$payload" | python3 -c '
import json
import sys

data = sys.stdin.read()
try:
    payload = json.loads(data)
except Exception:
    sys.stdout.write(data)
    raise SystemExit(0)

rows = payload.get("data") if isinstance(payload, dict) else []
if not isinstance(rows, list):
    rows = []

query_value = payload.get("query", "") if isinstance(payload, dict) else ""
limit_value = payload.get("limit", len(rows)) if isinstance(payload, dict) else len(rows)
print(f"Query: {query_value}")
print(f"Limit: {limit_value}")
print()

if not rows:
    print("No retrieval results.")
    raise SystemExit(0)

for index, row in enumerate(rows, 1):
    if not isinstance(row, dict):
        continue
    topic = row.get("topic") or "Untitled"
    print(f"{index}. {topic}")
    source = row.get("source")
    if source:
        print(f"   Source: {source}")
    similarity = row.get("similarity")
    if isinstance(similarity, (int, float)):
        print(f"   Similarity: {similarity:.2f}")
    content = row.get("content") or ""
    print(f"   {content}")
    print()
'
  else
    printf '%s\n' "$payload"
  fi
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --json)
      json=1
      ;;
    --dry-run)
      dry_run=1
      ;;
    --format-only)
      format_only=1
      ;;
    -l|--limit)
      shift
      limit=$(normalize_limit "${1:-}")
      ;;
    *)
      append_query_part "$1"
      ;;
  esac
  shift
done

if [ "$format_only" -eq 1 ]; then
  format_payload
  exit 0
fi

if [ -z "$query" ]; then
  usage
  exit 1
fi

if [ "$dry_run" -eq 1 ]; then
  printf 'curl -fsSL --get --data-urlencode q=%s --data-urlencode limit=%s -H accept:application/json -H "user-agent: Mozilla/5.0 (compatible; aicz-skill-retrieval)" %s\n' "$query" "$limit" "$endpoint"
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  printf 'curl is required to retrieve AICZ context.\n' >&2
  exit 1
fi

response=$(curl -fsSL --get \
  --data-urlencode "q=$query" \
  --data-urlencode "limit=$limit" \
  -H "accept: application/json" \
  -H "user-agent: Mozilla/5.0 (compatible; aicz-skill-retrieval)" \
  "$endpoint") || exit $?

printf '%s' "$response" | format_payload
