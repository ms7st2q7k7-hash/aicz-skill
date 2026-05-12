#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
OUT_DIR=${ADAPTERS_OUT_DIR:-/tmp/aicz-skill-adapters}

write_file() {
  path=$1
  mkdir -p "$(dirname "$path")"
  cat > "$path"
}

write_retrieve_skill() {
  path=$1
  platform=$2

  write_file "$path" <<EOF
---
name: retrieve-aicz
description: Retrieve source-backed AICZ persona context from Persona.market, then answer in concise CZ style. Use when the user asks for AICZ evidence, current CZ-related context, Persona.market metadata, YZi Labs, Giggle Academy, BNB Chain ecosystem context, or explicitly wants to retrieve AICZ knowledge.
---

# Retrieve AICZ

Use this skill as the ${platform} command entry for AICZ retrieval.

## Workflow

1. Take the user's request as the retrieval query.
2. Run the repository script:

\`\`\`bash
sh scripts/retrieve-aicz.sh "<query>" --limit 5
\`\`\`

3. Use returned snippets as supporting context only.
4. Answer in concise CZ style when the user expects persona output.
5. Do not expose raw retrieval mechanics unless the user asks.
6. If retrieval fails, say that retrieval is unavailable and fall back to local AICZ skill knowledge when safe.

## Endpoint

Production retrieval endpoint:

\`\`\`http
GET https://persona.market/app/api/skills/aicz/retrieve?q=<query>&limit=5
\`\`\`

## Boundaries

- Do not give specific investment advice.
- Do not operate user accounts or place trades.
- Do not claim to be the real CZ.
- Do not invent latest facts when retrieval fails.
EOF
}

write_file "$ROOT_DIR/commands/retrieve-aicz.command.yaml" <<'EOF'
name: retrieve-aicz
description: Retrieve AICZ persona context and answer in CZ style.
input:
  query:
    type: string
    required: true
    description: User question or retrieval query.
runtime:
  type: shell
  script: scripts/retrieve-aicz.sh
  default_limit: 5
default_endpoint: https://persona.market/app/api/skills/aicz/retrieve
outputs:
  format: source_snippets
  style: concise_cz
platforms:
  - claude-code
  - codex-cli
  - codex-app
  - gemini-cli
EOF

write_retrieve_skill "$OUT_DIR/claude/skills/retrieve-aicz/SKILL.md" "Claude Code"
write_retrieve_skill "$OUT_DIR/codex/skills/retrieve-aicz/SKILL.md" "Codex CLI"

write_file "$OUT_DIR/codex/skills/retrieve-aicz/agents/openai.yaml" <<'EOF'
interface:
  display_name: "Retrieve AICZ"
  short_description: "Retrieve source-backed AICZ context"
  default_prompt: "Use $retrieve-aicz to retrieve AICZ context for:"

policy:
  allow_implicit_invocation: true
EOF

write_file "$OUT_DIR/gemini/gemini-extension.json" <<'EOF'
{
  "name": "aicz",
  "version": "1.0.0",
  "description": "AICZ persona retrieval commands and skills",
  "commands": [
    {
      "name": "retrieve-aicz",
      "description": "Retrieve source-backed AICZ persona context"
    }
  ]
}
EOF

write_file "$OUT_DIR/gemini/commands/retrieve-aicz.toml" <<'EOF'
description = "Retrieve AICZ persona context"
prompt = """
Use the retrieve-aicz skill for the following query:

{{args}}

Run the repository shell helper when available:

sh scripts/retrieve-aicz.sh "{{args}}" --limit 5

Use returned snippets as supporting context only. Answer concisely in CZ style when persona output is expected. If retrieval fails, say retrieval is unavailable and do not invent latest facts.
"""
EOF

write_retrieve_skill "$OUT_DIR/gemini/skills/retrieve-aicz/SKILL.md" "Gemini CLI"

printf 'Generated retrieve-aicz adapters for Claude Code, Codex CLI/App, and Gemini CLI at %s.\n' "$OUT_DIR"
