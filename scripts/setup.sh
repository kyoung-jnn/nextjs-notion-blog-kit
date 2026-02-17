#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# ─── Helper Functions ────────────────────────────────────────────────

# Escape sed special characters in replacement string
escape_sed_replacement() {
    printf '%s' "$1" | sed 's/[&\\/|]/\\&/g'
}

# Cross-platform sed wrapper (safe against special characters)
update_file() {
    local file="$1" pattern="$2" replacement="$3"
    if [ ! -f "$file" ]; then
        fail "File not found: $file"
        return 1
    fi
    local safe_replacement
    safe_replacement=$(escape_sed_replacement "$replacement")
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|$pattern|$safe_replacement|" "$file"
    else
        sed -i "s|$pattern|$safe_replacement|" "$file"
    fi
    if [ $? -ne 0 ]; then
        fail "Failed to update $file"
        return 1
    fi
}

# Validate URL format
validate_url() {
    local url="$1"
    if [[ "$url" =~ ^https?://[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}(/.*)?$ ]]; then
        return 0
    fi
    return 1
}

print_step() {
    local step="$1" total="$2" title="$3"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Step $step/$total: $title${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

fail() {
    echo -e "${RED}✗${NC} $1"
}

TOTAL_STEPS=6

# ─── Banner ──────────────────────────────────────────────────────────

echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Next.js Notion Blog Kit Setup       ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""

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

success "Project structure verified"
echo ""

# ─── Step 1: Environment Variables ───────────────────────────────────

print_step 1 $TOTAL_STEPS "Environment Variables"

# Check if .env already exists
if [ -f .env ]; then
    warn ".env file already exists!"
    read -p "Do you want to overwrite it? (y/n): " overwrite
    if [[ ! $overwrite =~ ^[Yy]$ ]]; then
        echo -e "  Keeping existing .env file"
        ENV_EXISTS=true
    fi
fi

# Copy .env.example to .env if needed
if [ "$ENV_EXISTS" != true ]; then
    cp .env.example .env
    success "Created .env file from .env.example"
fi

# Prompt for Notion Page ID
echo ""
echo "Please follow these steps to get your Notion Database Page ID:"
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

read -p "Enter your Notion Page ID: " notion_page_id

if [ -z "$notion_page_id" ]; then
    fail "Notion Page ID is required!"
    exit 1
fi

# Sanitize input - keep only alphanumeric characters
notion_page_id=$(echo "$notion_page_id" | tr -cd '[:alnum:]')

# Validate Notion Page ID format (32-character hexadecimal)
if [[ ! "$notion_page_id" =~ ^[a-f0-9]{32}$ ]]; then
    fail "Invalid Notion Page ID format."
    echo "  Expected: 32 hexadecimal characters (e.g., 1f4d55b8837780519a27c4f1f7e4b1a9)"
    exit 1
fi

update_file ".env" "NOTION_PAGE=.*" "NOTION_PAGE=$notion_page_id"
success "Updated NOTION_PAGE in .env"

# Optional: Revalidation token
echo ""
read -p "Do you want to set up a revalidation token? (y/n): " setup_token
if [[ $setup_token =~ ^[Yy]$ ]]; then
    random_token=$(openssl rand -hex 32)
    echo -e "  ${YELLOW}Generated token:${NC} $random_token"
    update_file ".env" "TOKEN_FOR_REVALIDATE=.*" "TOKEN_FOR_REVALIDATE=$random_token"
    success "Updated TOKEN_FOR_REVALIDATE in .env"
fi

# ─── Step 2: Site Configuration ──────────────────────────────────────

print_step 2 $TOTAL_STEPS "Site Configuration"

read -p "Do you want to configure your site info now? (y/n): " setup_site

if [[ $setup_site =~ ^[Yy]$ ]]; then
    SITE_CONFIG="src/config/siteConfig.ts"

    read -p "Blog title: " blog_title
    read -p "Blog description: " blog_description
    read -p "Author name (locale): " author_locale
    read -p "Author name (English): " author_en
    read -p "Author bio: " author_bio
    read -p "Site URL (e.g., https://yourblog.vercel.app): " site_url
    read -p "Email: " author_email
    read -p "GitHub URL: " github_url
    read -p "LinkedIn URL (optional, press Enter to skip): " linkedin_url
    read -p "Twitter/X URL (optional, press Enter to skip): " twitter_url

    if [ -n "$blog_title" ]; then
        update_file "$SITE_CONFIG" "title: \`blog title\`" "title: \`$blog_title\`"
    fi

    if [ -n "$blog_description" ]; then
        update_file "$SITE_CONFIG" "description: 'blog description'" "description: '$blog_description'"
    fi

    if [ -n "$author_locale" ]; then
        update_file "$SITE_CONFIG" "localeName: 'Author Locale Name'" "localeName: '$author_locale'"
    fi

    if [ -n "$author_en" ]; then
        update_file "$SITE_CONFIG" "enName: 'Author En Name'" "enName: '$author_en'"
    fi

    if [ -n "$author_bio" ]; then
        update_file "$SITE_CONFIG" "bio: 'Write a brief introduction about yourself'" "bio: '$author_bio'"
    fi

    if [ -n "$site_url" ]; then
        if validate_url "$site_url"; then
            update_file "$SITE_CONFIG" "siteUrl: ''" "siteUrl: '$site_url'"

            # Also update robots.txt with the site URL
            if [ -f "public/robots.txt" ]; then
                update_file "public/robots.txt" "https://example.com" "$site_url"
                success "Updated robots.txt with site URL"
            fi
        else
            warn "Invalid URL format: $site_url (skipped siteUrl and robots.txt)"
        fi
    fi

    if [ -n "$author_email" ]; then
        update_file "$SITE_CONFIG" "email: 'your-email@example.com'" "email: '$author_email'"
    fi

    if [ -n "$github_url" ]; then
        if validate_url "$github_url"; then
            update_file "$SITE_CONFIG" "github: 'https://github.com/your-username'" "github: '$github_url'"
        else
            warn "Invalid GitHub URL format (skipped)"
        fi
    fi

    if [ -n "$linkedin_url" ]; then
        if validate_url "$linkedin_url"; then
            update_file "$SITE_CONFIG" "linkedin: 'https://www.linkedin.com/in/your-linkedin/'" "linkedin: '$linkedin_url'"
        else
            warn "Invalid LinkedIn URL format (skipped)"
        fi
    fi

    if [ -n "$twitter_url" ]; then
        if validate_url "$twitter_url"; then
            update_file "$SITE_CONFIG" "twitter: ''" "twitter: '$twitter_url'"
        else
            warn "Invalid Twitter/X URL format (skipped)"
        fi
    fi

    success "Updated siteConfig.ts"
fi

# ─── Step 3: Comment System (Giscus) ────────────────────────────────

print_step 3 $TOTAL_STEPS "Comment System (Giscus)"

echo "Giscus provides GitHub-based comments for your blog."
echo ""
read -p "Do you want to configure Giscus comments? (y/n): " setup_giscus

if [[ $setup_giscus =~ ^[Yy]$ ]]; then
    COMMENT_CONFIG="src/config/commentConfig.ts"

    # Try to auto-detect GitHub repo from git remote
    DETECTED_REPO=""
    if command -v git &> /dev/null && git remote get-url origin &> /dev/null; then
        REMOTE_URL=$(git remote get-url origin)
        # Extract owner/repo from SSH or HTTPS URL
        DETECTED_REPO=$(echo "$REMOTE_URL" | sed -E 's|.*github\.com[:/]([^/]+/[^/]+)(\.git)?/?$|\1|')
    fi

    if [ -n "$DETECTED_REPO" ]; then
        echo -e "  Detected GitHub repository: ${YELLOW}$DETECTED_REPO${NC}"
        read -p "  Use this repository? (y/n): " use_detected
        if [[ $use_detected =~ ^[Yy]$ ]]; then
            giscus_repo="$DETECTED_REPO"
        else
            read -p "  Enter GitHub repo (owner/repo): " giscus_repo
        fi
    else
        read -p "Enter GitHub repo (owner/repo): " giscus_repo
    fi

    echo ""
    echo "To get your repoId and categoryId:"
    echo "  1. Visit https://giscus.app/"
    echo "  2. Enter your repository name"
    echo "  3. Select 'Comments' as the Discussion Category"
    echo "  4. Copy the repoId and categoryId from the generated script"
    echo ""

    read -p "Enter repoId: " giscus_repo_id
    read -p "Enter categoryId: " giscus_category_id

    if [ -n "$giscus_repo" ]; then
        update_file "$COMMENT_CONFIG" "repo: 'your-github-username/your-blog-repo-name'" "repo: '$giscus_repo'"
    fi

    if [ -n "$giscus_repo_id" ]; then
        update_file "$COMMENT_CONFIG" "repoId: ''" "repoId: '$giscus_repo_id'"
    fi

    if [ -n "$giscus_category_id" ]; then
        update_file "$COMMENT_CONFIG" "categoryId: ''" "categoryId: '$giscus_category_id'"
    fi

    success "Updated commentConfig.ts"
else
    echo "  Skipped. You can configure comments later in src/config/commentConfig.ts"
fi

# ─── Step 4: Install Dependencies ────────────────────────────────────

print_step 4 $TOTAL_STEPS "Installing Dependencies"

echo "Installing dependencies with pnpm..."
pnpm install
success "Dependencies installed"

# ─── Step 5: Vercel Deployment Setup ─────────────────────────────────

print_step 5 $TOTAL_STEPS "Vercel Deployment Setup"

# Resolve vercel command (global → npx fallback)
VERCEL_CMD=""
if command -v vercel &> /dev/null; then
    VERCEL_CMD="vercel"
    success "Vercel CLI found"
elif command -v npx &> /dev/null; then
    VERCEL_CMD="npx vercel"
    success "Vercel CLI available via npx"
else
    warn "Vercel CLI not found"
    echo ""
    read -p "Would you like to install Vercel CLI globally? (y/n): " install_vercel

    if [[ $install_vercel =~ ^[Yy]$ ]]; then
        echo "Installing Vercel CLI..."
        npm install -g vercel
        VERCEL_CMD="vercel"
        success "Vercel CLI installed"
    else
        echo ""
        echo "  You can install it later with:"
        echo "    npm install -g vercel"
        echo "  Or deploy scripts will use npx as a fallback."
    fi
fi

# Setup Vercel project
if [ -n "$VERCEL_CMD" ]; then
    echo ""
    read -p "Would you like to link this project to Vercel now? (y/n): " link_vercel

    if [[ $link_vercel =~ ^[Yy]$ ]]; then
        echo ""
        echo "Running vercel link..."
        echo -e "${YELLOW}Please follow the prompts to link your project${NC}"
        $VERCEL_CMD link

        # Push environment variables to Vercel
        echo ""
        read -p "Push environment variables to Vercel? (y/n): " push_env
        if [[ $push_env =~ ^[Yy]$ ]]; then
            echo "$notion_page_id" | $VERCEL_CMD env add NOTION_PAGE production
            success "Pushed NOTION_PAGE to Vercel"

            if [ -n "$random_token" ]; then
                echo "$random_token" | $VERCEL_CMD env add TOKEN_FOR_REVALIDATE production
                success "Pushed TOKEN_FOR_REVALIDATE to Vercel"
            fi
        fi
    fi
fi

# ─── Step 6: Verification & Summary ─────────────────────────────────

print_step 6 $TOTAL_STEPS "Verification"

WARNINGS=0

# Check NOTION_PAGE is set
if grep -q "NOTION_PAGE=your_notion_page_id_here" .env 2>/dev/null; then
    warn "NOTION_PAGE is not configured in .env"
    WARNINGS=$((WARNINGS + 1))
else
    success "NOTION_PAGE is configured"
fi

# Check siteUrl
if grep -q "siteUrl: ''" src/config/siteConfig.ts 2>/dev/null; then
    warn "siteUrl is not set in siteConfig.ts (robots.txt will use example.com)"
    WARNINGS=$((WARNINGS + 1))
else
    success "siteUrl is configured"
fi

# Check commentConfig
if grep -q "repoId: ''" src/config/commentConfig.ts 2>/dev/null; then
    warn "Giscus comments are not configured (commentConfig.ts)"
    WARNINGS=$((WARNINGS + 1))
else
    success "Comment system is configured"
fi

# Summary
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [ "$WARNINGS" -eq 0 ]; then
    echo -e "${GREEN}✓ Setup Complete!${NC}"
else
    echo -e "${GREEN}✓ Setup Complete!${NC} (${YELLOW}$WARNINGS warning(s)${NC})"
fi
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Next steps:"
echo ""
echo -e "  1. Start the development server:"
echo -e "     ${BLUE}pnpm dev${NC}"
echo ""
echo -e "  2. Deploy to production:"
echo -e "     ${BLUE}pnpm blog:deploy${NC}"
echo ""
echo -e "  3. Preview deployment:"
echo -e "     ${BLUE}pnpm blog:deploy:preview${NC}"
echo ""

if [ "$WARNINGS" -gt 0 ]; then
    echo -e "${YELLOW}Optional: Review the warnings above to complete your setup.${NC}"
    echo ""
fi

# Offer to start dev server
read -p "Would you like to start the dev server now? (y/n): " start_dev
if [[ $start_dev =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${BLUE}Starting development server...${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
    echo ""
    pnpm dev
else
    echo ""
    echo -e "${BLUE}Happy blogging!${NC}"
    echo ""
fi
