#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

# ─── Parse Arguments ─────────────────────────────────────────────────

MODE="${1:-prod}"

if [[ "$MODE" != "prod" && "$MODE" != "preview" ]]; then
    fail "Unknown deploy mode: $MODE"
    echo "  Usage: bash scripts/deploy.sh [prod|preview]"
    exit 1
fi

if [ "$MODE" = "prod" ]; then
    DEPLOY_LABEL="Production"
    VERCEL_FLAGS="--prod"
else
    DEPLOY_LABEL="Preview"
    VERCEL_FLAGS=""
fi

banner "Deploy: $DEPLOY_LABEL"

# ─── Pre-flight Checks ──────────────────────────────────────────────

echo -e "${BOLD}Pre-flight checks...${NC}"
echo ""

ERRORS=0
WARNINGS=0

# 1. Vercel CLI
resolve_vercel
if [ -n "$VERCEL_CMD" ]; then
    success "Vercel CLI: $VERCEL_CMD"
else
    fail "Neither vercel CLI nor npx found."
    echo ""
    echo "  Install one of these:"
    echo "    npm install -g vercel"
    echo "    npm install -g npx"
    exit 1
fi

# 2. .env exists and NOTION_PAGE is configured
if [ ! -f .env ]; then
    fail ".env file not found. Run 'pnpm blog:setup' first."
    ERRORS=$((ERRORS + 1))
else
    NOTION_VAL=$(get_env_var "NOTION_PAGE")
    if [ -z "$NOTION_VAL" ] || [ "$NOTION_VAL" = "your_notion_page_id_here" ]; then
        fail "NOTION_PAGE is not configured in .env"
        ERRORS=$((ERRORS + 1))
    else
        success "NOTION_PAGE is configured"
    fi
fi

# 3. siteUrl check
SITE_URL=$(get_env_var "NEXT_PUBLIC_SITE_URL")
if [ -z "$SITE_URL" ]; then
    warn "NEXT_PUBLIC_SITE_URL is empty (SEO will be affected)"
    WARNINGS=$((WARNINGS + 1))
else
    success "Site URL is configured: $SITE_URL"
fi

# 4. Dependencies installed
if [ ! -d node_modules ]; then
    fail "node_modules not found. Run 'pnpm install' first."
    ERRORS=$((ERRORS + 1))
else
    success "Dependencies installed"
fi

# 5. Git uncommitted changes warning
if command -v git &> /dev/null && git rev-parse --is-inside-work-tree &> /dev/null; then
    DIRTY_FILES=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [ "$DIRTY_FILES" -gt 0 ]; then
        warn "$DIRTY_FILES uncommitted change(s) detected"
        WARNINGS=$((WARNINGS + 1))
    else
        success "Working tree is clean"
    fi
fi

echo ""

# Abort on errors
if [ "$ERRORS" -gt 0 ]; then
    fail "Pre-flight failed with $ERRORS error(s). Fix the issues above and try again."
    exit 1
fi

# Confirm on warnings
if [ "$WARNINGS" -gt 0 ]; then
    read -p "$(echo -e "  ${YELLOW}$WARNINGS warning(s) found. Continue anyway? (y/n):${NC} ")" confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "  Deploy cancelled."
        exit 0
    fi
    echo ""
fi

# ─── Build ───────────────────────────────────────────────────────────

echo -e "${BOLD}Building project...${NC}"
echo ""

if ! pnpm build; then
    fail "Build failed. Fix the errors above and try again."
    exit 1
fi

echo ""
success "Build completed"
echo ""

# ─── Deploy ──────────────────────────────────────────────────────────

echo -e "${BOLD}Deploying to Vercel ($DEPLOY_LABEL)...${NC}"
echo ""

if $VERCEL_CMD $VERCEL_FLAGS; then
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  ✓ $DEPLOY_LABEL deploy complete!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
else
    echo ""
    fail "$DEPLOY_LABEL deploy failed."
    exit 1
fi
