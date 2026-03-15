#!/bin/bash
# ─── Deploy to Vercel ────────────────────────────────────────────────
#
# Usage:
#   pnpm blog:deploy           # Production deploy
#   pnpm blog:deploy:preview   # Preview deploy
#
# First run: links project + pushes env vars + deploys
# After that: just push to GitHub for auto-deploy

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

MODE="${1:-prod}"

if [[ "$MODE" != "prod" && "$MODE" != "preview" ]]; then
    echo "Usage: pnpm blog:deploy [prod|preview]"
    exit 1
fi

if [ "$MODE" = "prod" ]; then
    banner "Deploy: Production"
else
    banner "Deploy: Preview"
fi

# Pre-flight
if [ ! -d "blog/📝 posts" ]; then
    fail "Blog not set up. Run 'pnpm blog:setup' first."
    exit 1
fi

POST_COUNT=$(find "blog/📝 posts" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
success "$POST_COUNT post(s) found"

# Deploy
vercel_deploy "$MODE"
