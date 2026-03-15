#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

banner "Blog Doctor — Health Check"

WARNINGS=0
ERRORS=0

# ─── 1. Environment ─────────────────────────────────────────────────

echo -e "${BOLD}Environment${NC}"
echo ""

if command -v node &> /dev/null; then
    success "Node.js $(node -v)"
else
    fail "Node.js not found"
    ERRORS=$((ERRORS + 1))
fi

if command -v pnpm &> /dev/null; then
    success "pnpm v$(pnpm -v)"
else
    fail "pnpm not found"
    ERRORS=$((ERRORS + 1))
fi

if [ -d node_modules ]; then
    success "Dependencies installed"
else
    fail "node_modules not found — run 'pnpm install'"
    ERRORS=$((ERRORS + 1))
fi

# ─── 2. Blog Configuration ──────────────────────────────────────────

echo ""
echo -e "${BOLD}Configuration${NC}"
echo ""

if [ -f src/config/blog.config.ts ]; then
    success "blog.config.ts exists"

    # Check for default/placeholder values
    if grep -q "'My Blog'" src/config/blog.config.ts; then
        warn "Blog title is default — edit src/config/blog.config.ts"
        WARNINGS=$((WARNINGS + 1))
    else
        TITLE=$(sed -n "s/.*title: '\([^']*\)'.*/\1/p" src/config/blog.config.ts | head -1)
        success "Title: $TITLE"
    fi

    if grep -q "siteUrl: ''," src/config/blog.config.ts; then
        warn "Site URL is empty (affects SEO, sitemap, RSS)"
        WARNINGS=$((WARNINGS + 1))
    else
        URL=$(sed -n "s/.*siteUrl: '\([^']*\)'.*/\1/p" src/config/blog.config.ts | head -1)
        success "URL: $URL"
    fi

    if grep -q "repoId: ''," src/config/blog.config.ts; then
        warn "Giscus not configured — edit src/config/blog.config.ts"
        WARNINGS=$((WARNINGS + 1))
    else
        success "Giscus configured"
    fi
else
    fail "src/config/blog.config.ts not found — run 'pnpm blog:setup'"
    ERRORS=$((ERRORS + 1))
fi

# ─── 3. Blog Content ────────────────────────────────────────────────

echo ""
echo -e "${BOLD}Content${NC}"
echo ""

if [ -d "blog/📝 posts" ]; then
    POST_COUNT=$(find "blog/📝 posts" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    success "Posts: $POST_COUNT post(s)"
else
    fail "blog/📝 posts/ not found — run 'pnpm blog:setup'"
    ERRORS=$((ERRORS + 1))
fi

if [ -d ".obsidian" ]; then
    success "Obsidian vault configured"
else
    warn ".obsidian/ not found"
    WARNINGS=$((WARNINGS + 1))
fi

if [ -d "public/images" ]; then
    success "Image directory (public/images/)"
else
    warn "public/images/ not found"
    WARNINGS=$((WARNINGS + 1))
fi

# ─── 4. Vercel ───────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}Deployment${NC}"
echo ""

resolve_vercel
if [ -n "$VERCEL_CMD" ]; then
    success "Vercel CLI: $VERCEL_CMD"

    if [ -f .vercel/project.json ]; then
        success "Project linked to Vercel"
    else
        warn "Not linked — run 'pnpm blog:deploy'"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    warn "Vercel CLI not installed"
    WARNINGS=$((WARNINGS + 1))
fi

# ─── 5. Build check ─────────────────────────────────────────────────

echo ""
echo -e "${BOLD}Build${NC}"
echo ""

echo -e "  ${BLUE}Running type check...${NC}"
if pnpm type-check &> /dev/null; then
    success "TypeScript OK"
else
    fail "TypeScript errors — run 'pnpm type-check'"
    ERRORS=$((ERRORS + 1))
fi

# ─── Summary ─────────────────────────────────────────────────────────

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    echo -e "${GREEN}  ✓ All checks passed!${NC}"
elif [ "$ERRORS" -eq 0 ]; then
    echo -e "${YELLOW}  ⚠ $WARNINGS warning(s), no errors${NC}"
else
    echo -e "${RED}  ✗ $ERRORS error(s), $WARNINGS warning(s)${NC}"
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

exit $ERRORS
