#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

MODE="${1:-help}"

resolve_vercel
if [ -z "$VERCEL_CMD" ]; then
    fail "Vercel CLI not found. Install with: npm install -g vercel"
    exit 1
fi

if [ ! -f .vercel/project.json ]; then
    fail "Project not linked to Vercel. Run 'pnpm blog:setup' first."
    exit 1
fi

case "$MODE" in
    push)
        banner "Env Push: Local → Vercel"

        if [ ! -f .env ]; then
            fail ".env file not found"
            exit 1
        fi

        vercel_env_push_all
        ;;

    pull)
        banner "Env Pull: Vercel → Local"

        $VERCEL_CMD env pull .env.local
        success "Pulled Vercel env vars to .env.local"
        echo ""
        echo "  Note: .env.local takes precedence over .env in development"
        ;;

    diff)
        banner "Env Diff: Local vs Vercel"

        if [ ! -f .env ]; then
            fail ".env file not found"
            exit 1
        fi

        # Pull Vercel env to temp file
        TEMP_ENV=$(mktemp)
        $VERCEL_CMD env pull "$TEMP_ENV" 2>/dev/null

        echo ""
        echo -e "${BOLD}Comparing .env (local) vs Vercel:${NC}"
        echo ""

        HAS_DIFF=false

        while IFS='=' read -r key value; do
            [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue

            VERCEL_VAL=$(grep -E "^${key}=" "$TEMP_ENV" 2>/dev/null | cut -d'=' -f2-)

            if [ -z "$VERCEL_VAL" ]; then
                echo -e "  ${YELLOW}+ $key${NC} (local only)"
                HAS_DIFF=true
            elif [ "$value" != "$VERCEL_VAL" ]; then
                echo -e "  ${RED}~ $key${NC} (values differ)"
                HAS_DIFF=true
            fi
        done < .env

        # Check Vercel-only vars
        while IFS='=' read -r key value; do
            [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
            LOCAL_VAL=$(grep -E "^${key}=" .env 2>/dev/null | cut -d'=' -f2-)
            if [ -z "$LOCAL_VAL" ]; then
                echo -e "  ${BLUE}- $key${NC} (Vercel only)"
                HAS_DIFF=true
            fi
        done < "$TEMP_ENV"

        rm -f "$TEMP_ENV"

        if [ "$HAS_DIFF" = false ]; then
            echo -e "  ${GREEN}✓ Local and Vercel env vars are in sync${NC}"
        fi

        echo ""
        ;;

    *)
        echo "Usage: bash scripts/sync-env.sh <command>"
        echo ""
        echo "Commands:"
        echo "  push   Push local .env to Vercel (production + preview)"
        echo "  pull   Pull Vercel env vars to .env.local"
        echo "  diff   Compare local .env with Vercel env vars"
        echo ""
        ;;
esac
