#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

TOTAL_STEPS=6

# ─── Banner ──────────────────────────────────────────────────────────

banner "Next.js Notion Blog Kit Setup"

# ─── Pre-flight Checks ──────────────────────────────────────────────

echo -e "${BOLD}Pre-flight checks...${NC}"
echo ""

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v | sed 's/v//')
    NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)
    if [ "$NODE_MAJOR" -lt 18 ]; then
        warn "Node.js v$NODE_VERSION detected. v18+ is recommended."
    else
        success "Node.js v$NODE_VERSION"
    fi
else
    fail "Node.js is not installed. Please install Node.js v18+ first."
    echo "   https://nodejs.org/"
    exit 1
fi

# Check pnpm
if command -v pnpm &> /dev/null; then
    PNPM_VERSION=$(pnpm -v)
    success "pnpm v$PNPM_VERSION"
else
    fail "pnpm is not installed."
    echo ""
    echo "  Install pnpm with one of these commands:"
    echo "    corepack enable && corepack prepare pnpm@latest --activate"
    echo "    npm install -g pnpm"
    exit 1
fi

# Check .env.example
if [ ! -f .env.example ]; then
    fail ".env.example not found! Are you in the project root?"
    exit 1
fi

# Check gh CLI
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    success "GitHub CLI (authenticated)"
    GH_AVAILABLE=true
else
    warn "GitHub CLI not available — Giscus will require manual setup"
    GH_AVAILABLE=false
fi

# Check Vercel CLI
resolve_vercel
if [ -n "$VERCEL_CMD" ]; then
    success "Vercel CLI: $VERCEL_CMD"
else
    warn "Vercel CLI not found — deployment setup will be skipped"
fi

success "Project structure verified"
echo ""

# ─── Prepare .env ────────────────────────────────────────────────────

if [ ! -f .env ]; then
    cp .env.example .env
    success "Created .env from .env.example"
else
    success "Using existing .env file"
fi

# ─── Step 1: Notion Page ID ─────────────────────────────────────────

print_step 1 $TOTAL_STEPS "Notion Page ID"

CURRENT_NOTION=$(get_env_var "NOTION_PAGE")

if [ "$CURRENT_NOTION" != "your_notion_page_id_here" ] && [ -n "$CURRENT_NOTION" ]; then
    echo -e "  Current: ${YELLOW}$CURRENT_NOTION${NC}"
    if ! confirm "Update Notion Page ID?"; then
        success "Keeping existing NOTION_PAGE"
        SKIP_NOTION=true
    fi
fi

if [ "$SKIP_NOTION" != true ]; then
    echo ""
    echo "  How to get your Notion Database Page ID:"
    echo ""
    echo "  1. Visit the database template:"
    echo "     https://kyoung-jnn.notion.site/256d55b883778070ab14e9ca4b56f037"
    echo "  2. Click 'Duplicate' to copy the database to your workspace"
    echo "  3. Open the duplicated page and click 'Share'"
    echo "  4. Toggle 'Share to web' ON"
    echo "  5. Copy the URL from browser address bar"
    echo -e "     ${YELLOW}Tip:${NC} Press ⌘+L (Mac) or Ctrl+L (Windows) to select the URL"
    echo "  6. Your page ID is the string before '?v='"
    echo ""
    echo -e "  ${YELLOW}Example URL:${NC} https://notion.site/256d55b883778070ab14e9ca4b56f037?v=..."
    echo -e "  ${YELLOW}Page ID:${NC}     256d55b883778070ab14e9ca4b56f037"
    echo ""

    read -p "  Enter your Notion Page ID: " notion_page_id

    if [ -z "$notion_page_id" ]; then
        fail "Notion Page ID is required!"
        exit 1
    fi

    # Sanitize input
    notion_page_id=$(echo "$notion_page_id" | tr -cd '[:alnum:]')

    if ! validate_notion_id "$notion_page_id"; then
        fail "Invalid Notion Page ID format."
        echo "  Expected: 32 hexadecimal characters (e.g., 1f4d55b8837780519a27c4f1f7e4b1a9)"
        exit 1
    fi

    set_env_var "NOTION_PAGE" "$notion_page_id"
    success "Updated NOTION_PAGE"
fi

# Optional: Revalidation token
echo ""
CURRENT_TOKEN=$(get_env_var "TOKEN_FOR_REVALIDATE")
if [ "$CURRENT_TOKEN" = "your_secret_token_here" ] || [ -z "$CURRENT_TOKEN" ]; then
    if confirm "Generate a revalidation token?"; then
        random_token=$(openssl rand -hex 32)
        set_env_var "TOKEN_FOR_REVALIDATE" "$random_token"
        success "Generated TOKEN_FOR_REVALIDATE"
    fi
else
    success "TOKEN_FOR_REVALIDATE already configured"
fi

# ─── Step 2: Site Configuration ─────────────────────────────────────

print_step 2 $TOTAL_STEPS "Site Configuration"

if confirm "Configure your site info?"; then
    echo ""

    val=$(prompt_with_default "Blog title" "$(get_env_var NEXT_PUBLIC_SITE_TITLE)")
    [ -n "$val" ] && set_env_var "NEXT_PUBLIC_SITE_TITLE" "$val"

    val=$(prompt_with_default "Blog description" "$(get_env_var NEXT_PUBLIC_SITE_DESCRIPTION)")
    [ -n "$val" ] && set_env_var "NEXT_PUBLIC_SITE_DESCRIPTION" "$val"

    val=$(prompt_with_default "Locale (ko/en)" "$(get_env_var NEXT_PUBLIC_SITE_LOCALE)")
    [ -n "$val" ] && set_env_var "NEXT_PUBLIC_SITE_LOCALE" "$val"

    val=$(prompt_with_default "Author name (locale)" "$(get_env_var NEXT_PUBLIC_AUTHOR_LOCALE_NAME)")
    [ -n "$val" ] && set_env_var "NEXT_PUBLIC_AUTHOR_LOCALE_NAME" "$val"

    val=$(prompt_with_default "Author name (English)" "$(get_env_var NEXT_PUBLIC_AUTHOR_EN_NAME)")
    [ -n "$val" ] && set_env_var "NEXT_PUBLIC_AUTHOR_EN_NAME" "$val"

    val=$(prompt_with_default "Author bio" "$(get_env_var NEXT_PUBLIC_AUTHOR_BIO)")
    [ -n "$val" ] && set_env_var "NEXT_PUBLIC_AUTHOR_BIO" "$val"

    val=$(prompt_with_default "Site URL (e.g., https://yourblog.vercel.app)" "$(get_env_var NEXT_PUBLIC_SITE_URL)")
    if [ -n "$val" ]; then
        if validate_url "$val"; then
            set_env_var "NEXT_PUBLIC_SITE_URL" "$val"
        else
            warn "Invalid URL format: $val (skipped)"
        fi
    fi

    val=$(prompt_with_default "Email" "$(get_env_var NEXT_PUBLIC_AUTHOR_EMAIL)")
    [ -n "$val" ] && set_env_var "NEXT_PUBLIC_AUTHOR_EMAIL" "$val"

    val=$(prompt_with_default "GitHub URL" "$(get_env_var NEXT_PUBLIC_AUTHOR_GITHUB)")
    [ -n "$val" ] && set_env_var "NEXT_PUBLIC_AUTHOR_GITHUB" "$val"

    val=$(prompt_with_default "LinkedIn URL (optional)" "$(get_env_var NEXT_PUBLIC_AUTHOR_LINKEDIN)")
    [ -n "$val" ] && set_env_var "NEXT_PUBLIC_AUTHOR_LINKEDIN" "$val"

    val=$(prompt_with_default "Twitter/X URL (optional)" "$(get_env_var NEXT_PUBLIC_AUTHOR_TWITTER)")
    [ -n "$val" ] && set_env_var "NEXT_PUBLIC_AUTHOR_TWITTER" "$val"

    success "Updated site configuration in .env"
else
    echo "  Skipped. Edit .env directly to configure later."
fi

# ─── Step 3: Comment System (Giscus) ────────────────────────────────

print_step 3 $TOTAL_STEPS "Comment System (Giscus)"

echo "  Giscus provides GitHub-based comments for your blog."
echo ""

if confirm "Configure Giscus comments?"; then
    # Detect repo from git remote
    DETECTED_REPO=""
    if command -v git &> /dev/null && git remote get-url origin &> /dev/null; then
        REMOTE_URL=$(git remote get-url origin)
        DETECTED_REPO=$(echo "$REMOTE_URL" | sed -E 's|.*github\.com[:/]([^/]+/[^/]+)(\.git)?/?$|\1|')
    fi

    CURRENT_REPO=$(get_env_var "NEXT_PUBLIC_GISCUS_REPO")
    DEFAULT_REPO="${CURRENT_REPO:-$DETECTED_REPO}"

    if [ -n "$DEFAULT_REPO" ] && [ "$DEFAULT_REPO" != "your-github-username/your-blog-repo-name" ]; then
        giscus_repo=$(prompt_with_default "GitHub repo (owner/repo)" "$DEFAULT_REPO")
    else
        if [ -n "$DETECTED_REPO" ]; then
            echo -e "  Detected repository: ${YELLOW}$DETECTED_REPO${NC}"
            if confirm "Use this repository?"; then
                giscus_repo="$DETECTED_REPO"
            else
                giscus_repo=$(prompt_with_default "GitHub repo (owner/repo)" "")
            fi
        else
            giscus_repo=$(prompt_with_default "GitHub repo (owner/repo)" "")
        fi
    fi

    if [ -n "$giscus_repo" ]; then
        set_env_var "NEXT_PUBLIC_GISCUS_REPO" "$giscus_repo"

        OWNER=$(echo "$giscus_repo" | cut -d'/' -f1)
        REPO=$(echo "$giscus_repo" | cut -d'/' -f2)

        # Try auto-detection via GitHub GraphQL API
        if [ "$GH_AVAILABLE" = true ]; then
            echo ""
            echo -e "  ${BLUE}Fetching Giscus config via GitHub API...${NC}"

            GRAPHQL_RESULT=$(gh api graphql -f query='
                query($owner: String!, $repo: String!) {
                    repository(owner: $owner, name: $repo) {
                        id
                        hasDiscussionsEnabled
                        discussionCategories(first: 20) {
                            nodes { id name }
                        }
                    }
                }
            ' -f owner="$OWNER" -f repo="$REPO" 2>/dev/null)

            if [ $? -eq 0 ] && [ -n "$GRAPHQL_RESULT" ]; then
                REPO_ID=$(echo "$GRAPHQL_RESULT" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
                HAS_DISCUSSIONS=$(echo "$GRAPHQL_RESULT" | grep -o '"hasDiscussionsEnabled":[a-z]*' | cut -d':' -f2)

                if [ "$HAS_DISCUSSIONS" = "false" ]; then
                    warn "GitHub Discussions is not enabled on $giscus_repo"
                    if confirm "Enable Discussions now?"; then
                        gh repo edit "$giscus_repo" --enable-discussions 2>/dev/null
                        if [ $? -eq 0 ]; then
                            success "Enabled GitHub Discussions"
                            # Re-fetch to get discussion categories
                            GRAPHQL_RESULT=$(gh api graphql -f query='
                                query($owner: String!, $repo: String!) {
                                    repository(owner: $owner, name: $repo) {
                                        id
                                        discussionCategories(first: 20) {
                                            nodes { id name }
                                        }
                                    }
                                }
                            ' -f owner="$OWNER" -f repo="$REPO" 2>/dev/null)
                        else
                            fail "Could not enable Discussions — please enable manually in repo settings"
                        fi
                    fi
                fi

                if [ -n "$REPO_ID" ]; then
                    set_env_var "NEXT_PUBLIC_GISCUS_REPO_ID" "$REPO_ID"
                    success "Auto-detected repoId: $REPO_ID"
                fi

                # Find "Comments" category (or first available)
                CATEGORY_ID=$(echo "$GRAPHQL_RESULT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
nodes = data.get('data', {}).get('repository', {}).get('discussionCategories', {}).get('nodes', [])
for n in nodes:
    if n['name'].lower() == 'comments':
        print(n['id'])
        sys.exit(0)
# Fallback: use first category if 'Comments' not found
if nodes:
    print(nodes[0]['id'])
" 2>/dev/null)

                if [ -n "$CATEGORY_ID" ]; then
                    set_env_var "NEXT_PUBLIC_GISCUS_CATEGORY_ID" "$CATEGORY_ID"
                    success "Auto-detected categoryId: $CATEGORY_ID"
                else
                    warn "No discussion category found. Please create a 'Comments' category in GitHub Discussions."
                fi

                AUTO_GISCUS=true
            else
                warn "GitHub API query failed — falling back to manual setup"
            fi
        fi

        # Manual fallback
        if [ "$AUTO_GISCUS" != true ]; then
            echo ""
            echo "  To get your repoId and categoryId:"
            echo "  1. Visit https://giscus.app/"
            echo "  2. Enter your repository name"
            echo "  3. Select 'Comments' as the Discussion Category"
            echo "  4. Copy the repoId and categoryId from the generated script"
            echo ""

            CURRENT_REPO_ID=$(get_env_var "NEXT_PUBLIC_GISCUS_REPO_ID")
            CURRENT_CAT_ID=$(get_env_var "NEXT_PUBLIC_GISCUS_CATEGORY_ID")

            val=$(prompt_with_default "repoId" "$CURRENT_REPO_ID")
            [ -n "$val" ] && set_env_var "NEXT_PUBLIC_GISCUS_REPO_ID" "$val"

            val=$(prompt_with_default "categoryId" "$CURRENT_CAT_ID")
            [ -n "$val" ] && set_env_var "NEXT_PUBLIC_GISCUS_CATEGORY_ID" "$val"
        fi

        success "Giscus configuration saved to .env"
    fi
else
    echo "  Skipped. Edit .env directly to configure later."
fi

# ─── Step 4: Install Dependencies ───────────────────────────────────

print_step 4 $TOTAL_STEPS "Installing Dependencies"

echo "  Installing dependencies with pnpm..."
pnpm install
success "Dependencies installed"

# ─── Step 5: Vercel Deployment Setup ─────────────────────────────────

print_step 5 $TOTAL_STEPS "Vercel Deployment Setup"

if [ -z "$VERCEL_CMD" ]; then
    echo ""
    if confirm "Install Vercel CLI globally?"; then
        npm install -g vercel
        VERCEL_CMD="vercel"
        success "Vercel CLI installed"
    else
        echo ""
        echo "  You can install it later with:"
        echo "    npm install -g vercel"
        echo "  Skipping Vercel setup."
    fi
fi

if [ -n "$VERCEL_CMD" ]; then
    echo ""
    if confirm "Link this project to Vercel?"; then
        echo ""
        echo -e "  ${YELLOW}Please follow the prompts to link your project${NC}"
        $VERCEL_CMD link

        echo ""
        if confirm "Push all environment variables to Vercel?"; then
            vercel_env_push_all
        fi

        # Domain setup
        SITE_URL=$(get_env_var "NEXT_PUBLIC_SITE_URL")
        if [ -n "$SITE_URL" ] && validate_url "$SITE_URL"; then
            DOMAIN=$(echo "$SITE_URL" | sed -E 's|https?://||' | sed 's|/.*||')
            echo ""
            echo -e "  Site URL domain: ${YELLOW}$DOMAIN${NC}"
            if confirm "Add this domain to Vercel?"; then
                $VERCEL_CMD domains add "$DOMAIN" 2>/dev/null
                success "Domain add requested — check Vercel Dashboard for DNS instructions"
            fi
        fi
    fi
fi

# ─── Step 6: Verification ───────────────────────────────────────────

print_step 6 $TOTAL_STEPS "Verification"

WARNINGS=0

# Required checks
NOTION_VAL=$(get_env_var "NOTION_PAGE")
if [ -z "$NOTION_VAL" ] || [ "$NOTION_VAL" = "your_notion_page_id_here" ]; then
    warn "NOTION_PAGE is not configured"
    WARNINGS=$((WARNINGS + 1))
else
    success "NOTION_PAGE is configured"
fi

SITE_URL_VAL=$(get_env_var "NEXT_PUBLIC_SITE_URL")
if [ -z "$SITE_URL_VAL" ]; then
    warn "NEXT_PUBLIC_SITE_URL is not set (SEO will be affected)"
    WARNINGS=$((WARNINGS + 1))
else
    success "Site URL is configured: $SITE_URL_VAL"
fi

TITLE_VAL=$(get_env_var "NEXT_PUBLIC_SITE_TITLE")
if [ "$TITLE_VAL" = "blog title" ]; then
    warn "NEXT_PUBLIC_SITE_TITLE is still the default value"
    WARNINGS=$((WARNINGS + 1))
else
    success "Site title is configured: $TITLE_VAL"
fi

GISCUS_REPO_ID=$(get_env_var "NEXT_PUBLIC_GISCUS_REPO_ID")
if [ -z "$GISCUS_REPO_ID" ]; then
    warn "Giscus comments are not configured"
    WARNINGS=$((WARNINGS + 1))
else
    success "Comment system is configured"
fi

# Type check
echo ""
echo -e "  ${BLUE}Running type check...${NC}"
if pnpm type-check &> /dev/null; then
    success "TypeScript compilation passed"
else
    warn "TypeScript compilation failed — run 'pnpm type-check' for details"
    WARNINGS=$((WARNINGS + 1))
fi

# ─── Summary ─────────────────────────────────────────────────────────

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ "$WARNINGS" -eq 0 ]; then
    echo -e "${GREEN}  ✓ Setup Complete!${NC}"
else
    echo -e "${GREEN}  ✓ Setup Complete!${NC} (${YELLOW}$WARNINGS warning(s)${NC})"
fi
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  Next steps:"
echo ""
echo -e "    1. Start the development server:"
echo -e "       ${BLUE}pnpm dev${NC}"
echo ""
echo -e "    2. Deploy to production:"
echo -e "       ${BLUE}pnpm blog:deploy${NC}"
echo ""
echo -e "    3. Run diagnostics anytime:"
echo -e "       ${BLUE}pnpm blog:doctor${NC}"
echo ""

if [ "$WARNINGS" -gt 0 ]; then
    echo -e "  ${YELLOW}Review the warnings above to complete your setup.${NC}"
    echo ""
fi

# Offer to start dev server
if confirm "Start the dev server now?"; then
    echo ""
    echo -e "  ${BLUE}Starting development server...${NC}"
    echo -e "  ${YELLOW}Press Ctrl+C to stop the server${NC}"
    echo ""
    pnpm dev
else
    echo ""
    echo -e "  ${BLUE}Happy blogging!${NC}"
    echo ""
fi
