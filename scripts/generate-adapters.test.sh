#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SCRIPT="$ROOT_DIR/scripts/generate-adapters.sh"
OUT_DIR="/tmp/aicz-skill-adapters-test"

assert_file_contains() {
  file=$1
  needle=$2
  label=$3

  if [ ! -f "$file" ]; then
    printf 'not ok - %s\nMissing file: %s\n' "$label" "$file" >&2
    exit 1
  fi

  if ! grep -Fq "$needle" "$file"; then
    printf 'not ok - %s\nExpected to find: %s\nFile: %s\n' "$label" "$needle" "$file" >&2
    exit 1
  fi
}

rm -rf "$OUT_DIR"
ADAPTERS_OUT_DIR="$OUT_DIR" "$SCRIPT"

assert_file_contains "$ROOT_DIR/commands/retrieve-aicz.command.yaml" "name: retrieve-aicz" "command spec has command name"
assert_file_contains "$ROOT_DIR/commands/retrieve-aicz.command.yaml" "script: scripts/retrieve-aicz.sh" "command spec points to shell runtime"
if grep -Fq "AICZ_RETRIEVE_ENDPOINT" "$ROOT_DIR/commands/retrieve-aicz.command.yaml"; then
  printf 'not ok - command spec should not expose endpoint override\n' >&2
  exit 1
fi

assert_file_contains "$OUT_DIR/claude/skills/retrieve-aicz/SKILL.md" "name: retrieve-aicz" "Claude skill has retrieve-aicz name"
assert_file_contains "$OUT_DIR/claude/skills/retrieve-aicz/SKILL.md" "sh scripts/retrieve-aicz.sh" "Claude skill calls shell runtime"
if grep -Fq "127.0.0.1" "$OUT_DIR/claude/skills/retrieve-aicz/SKILL.md"; then
  printf 'not ok - generated Claude skill should not include local endpoint\n' >&2
  exit 1
fi

assert_file_contains "$OUT_DIR/codex/skills/retrieve-aicz/SKILL.md" "name: retrieve-aicz" "Codex skill has retrieve-aicz name"
assert_file_contains "$OUT_DIR/codex/skills/retrieve-aicz/agents/openai.yaml" "display_name: \"Retrieve AICZ\"" "Codex UI metadata has display name"
assert_file_contains "$OUT_DIR/codex/skills/retrieve-aicz/agents/openai.yaml" "Use \$retrieve-aicz" "Codex UI metadata has default prompt"

assert_file_contains "$OUT_DIR/gemini/gemini-extension.json" "\"name\": \"aicz\"" "Gemini extension has package name"
assert_file_contains "$OUT_DIR/gemini/commands/retrieve-aicz.toml" "description = \"Retrieve AICZ persona context\"" "Gemini command has description"
assert_file_contains "$OUT_DIR/gemini/skills/retrieve-aicz/SKILL.md" "name: retrieve-aicz" "Gemini skill has retrieve-aicz name"

printf 'ok - generate-adapters.sh\n'
