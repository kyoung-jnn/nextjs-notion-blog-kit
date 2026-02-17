#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ─── Helper Functions ────────────────────────────────────────────────

success() { echo -e "${GREEN}✓${NC} $1"; }
warn()    { echo -e "${YELLOW}⚠${NC} $1"; }
fail()    { echo -e "${RED}✗${NC} $1"; }

# Resolve vercel command (global → npx fallback)
resolve_vercel() {
    if command -v vercel &> /dev/null; then
        VERCEL_CMD="vercel"
    elif command -v npx &> /dev/null; then
        VERCEL_CMD="npx vercel"
    else
        fail "Neither vercel CLI nor npx found."
        echo ""
        echo "  Install one of these:"
        echo "    npm install -g vercel"
        echo "    npm install -g npx"
        exit 1
    fi
}

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

# ─── Banner ──────────────────────────────────────────────────────────

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Deploy: $DEPLOY_LABEL $(printf '%-*s' $((24 - ${#DEPLOY_LABEL})) '')║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""

# ─── Pre-flight Checks ──────────────────────────────────────────────

echo -e "${BOLD}Pre-flight checks...${NC}"
echo ""

ERRORS=0
WARNINGS=0

# 1. Vercel CLI
resolve_vercel
success "Vercel CLI: $VERCEL_CMD"

# 2. .env exists and NOTION_PAGE is configured
if [ ! -f .env ]; then
    fail ".env file not found. Run 'pnpm blog:setup' first."
    ERRORS=$((ERRORS + 1))
elif grep -q "NOTION_PAGE=your_notion_page_id_here" .env 2>/dev/null; then
    fail "NOTION_PAGE is not configured in .env"
    ERRORS=$((ERRORS + 1))
else
    success "NOTION_PAGE is configured"
fi

# 3. siteUrl check
if grep -q "siteUrl: ''" src/config/siteConfig.ts 2>/dev/null; then
    warn "siteUrl is empty in siteConfig.ts (SEO will be affected)"
    WARNINGS=$((WARNINGS + 1))
else
    success "siteUrl is configured"
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
    read -p "$(echo -e "${YELLOW}$WARNINGS warning(s) found. Continue anyway? (y/n):${NC} ")" confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo "Deploy cancelled."
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
    echo -e "${GREEN}✓ $DEPLOY_LABEL deploy complete!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
else
    echo ""
    fail "$DEPLOY_LABEL deploy failed."
    exit 1
fi
