#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

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

# ─── 2. Required env vars ───────────────────────────────────────────

echo ""
echo -e "${BOLD}Required Configuration${NC}"
echo ""

if [ ! -f .env ]; then
    fail ".env file not found — run 'pnpm blog:setup'"
    ERRORS=$((ERRORS + 1))
else
    # NOTION_PAGE
    val=$(get_env_var "NOTION_PAGE")
    if [ -z "$val" ] || [ "$val" = "your_notion_page_id_here" ]; then
        fail "NOTION_PAGE is not configured"
        ERRORS=$((ERRORS + 1))
    else
        success "NOTION_PAGE: ${val:0:8}..."

        # Test Notion accessibility
        HTTP_STATUS=$(curl -sf -o /dev/null -w "%{http_code}" \
            "https://notion-api.splitbee.io/v1/table/$val" 2>/dev/null)
        if [ "$HTTP_STATUS" = "200" ]; then
            success "Notion page is accessible"
        else
            warn "Notion page may not be accessible (HTTP $HTTP_STATUS)"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi

    # Site title
    val=$(get_env_var "NEXT_PUBLIC_SITE_TITLE")
    if [ -z "$val" ] || [ "$val" = "blog title" ]; then
        warn "NEXT_PUBLIC_SITE_TITLE is default"
        WARNINGS=$((WARNINGS + 1))
    else
        success "Site title: $val"
    fi

    # Site URL
    val=$(get_env_var "NEXT_PUBLIC_SITE_URL")
    if [ -z "$val" ]; then
        warn "NEXT_PUBLIC_SITE_URL is empty (affects SEO, sitemap, RSS)"
        WARNINGS=$((WARNINGS + 1))
    else
        success "Site URL: $val"

        # DNS check
        DOMAIN=$(echo "$val" | sed -E 's|https?://||' | sed 's|/.*||')
        if dig +short "$DOMAIN" A &> /dev/null && [ -n "$(dig +short "$DOMAIN" A 2>/dev/null)" ]; then
            success "Domain DNS resolves: $DOMAIN"
        else
            warn "Domain DNS not resolving: $DOMAIN"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi

    # Author
    val=$(get_env_var "NEXT_PUBLIC_AUTHOR_LOCALE_NAME")
    if [ -z "$val" ] || [ "$val" = "Author Locale Name" ]; then
        warn "Author name is default"
        WARNINGS=$((WARNINGS + 1))
    else
        success "Author: $val"
    fi
fi

# ─── 3. Optional configuration ──────────────────────────────────────

echo ""
echo -e "${BOLD}Optional Configuration${NC}"
echo ""

val=$(get_env_var "TOKEN_FOR_REVALIDATE")
if [ -z "$val" ] || [ "$val" = "your_secret_token_here" ]; then
    warn "TOKEN_FOR_REVALIDATE not set (on-demand revalidation disabled)"
    WARNINGS=$((WARNINGS + 1))
else
    success "Revalidation token configured"
fi

val=$(get_env_var "NEXT_PUBLIC_GISCUS_REPO_ID")
if [ -z "$val" ]; then
    warn "Giscus comments not configured"
    WARNINGS=$((WARNINGS + 1))
else
    success "Giscus configured (repo: $(get_env_var NEXT_PUBLIC_GISCUS_REPO))"
fi

# ─── 4. Vercel ───────────────────────────────────────────────────────

echo ""
echo -e "${BOLD}Vercel${NC}"
echo ""

resolve_vercel
if [ -n "$VERCEL_CMD" ]; then
    success "Vercel CLI: $VERCEL_CMD"

    if [ -f .vercel/project.json ]; then
        success "Project is linked to Vercel"

        # Compare env var count
        VERCEL_ENV_COUNT=$($VERCEL_CMD env ls production 2>/dev/null | grep -cE "^[A-Z_]" || echo "0")
        LOCAL_ENV_COUNT=$(grep -cE "^[A-Z]" .env 2>/dev/null || echo "0")

        if [ "$VERCEL_ENV_COUNT" -gt 0 ]; then
            success "Vercel has $VERCEL_ENV_COUNT env var(s) (local: $LOCAL_ENV_COUNT)"
        else
            warn "No env vars found on Vercel — run 'pnpm blog:env:push'"
            WARNINGS=$((WARNINGS + 1))
        fi
    else
        warn "Project not linked to Vercel — run 'pnpm blog:setup' step 5"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    warn "Vercel CLI not available"
    WARNINGS=$((WARNINGS + 1))
fi

# ─── 5. Build check ─────────────────────────────────────────────────

echo ""
echo -e "${BOLD}Build${NC}"
echo ""

echo -e "  ${BLUE}Running type check...${NC}"
if pnpm type-check &> /dev/null; then
    success "TypeScript compilation passed"
else
    fail "TypeScript compilation failed"
    echo "    Run 'pnpm type-check' for details"
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
