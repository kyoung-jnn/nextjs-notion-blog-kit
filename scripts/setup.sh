#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}   🔲 Next.js Notion Blog Kit Setup       ${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
echo ""

# Check if .env already exists
if [ -f .env ]; then
    echo -e "${YELLOW}⚠️  .env file already exists!${NC}"
    read -p "Do you want to overwrite it? (y/n): " overwrite
    if [[ ! $overwrite =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}ℹ️  Keeping existing .env file${NC}"
        ENV_EXISTS=true
    fi
fi

# Copy .env.example to .env if needed
if [ "$ENV_EXISTS" != true ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}✓${NC} Created .env file from .env.example"
    else
        echo -e "${RED}✗${NC} .env.example not found!"
        exit 1
    fi
fi

# Prompt for Notion Page ID
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 1: Notion Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Please follow these steps to get your Notion Page ID:"
echo ""
echo "1. Visit: https://kyoung-jnn.notion.site/1f4d55b8837780519a27c4f1f7e4b1a9?v=1f4d55b8837781328546000cc33d2d96"
echo "2. Click 'Duplicate' to copy the template to your workspace"
echo "3. Open the duplicated page and click 'Share'"
echo "4. Toggle 'Share to web' ON"
echo "5. Copy the URL from browser address bar"
echo -e "   ${YELLOW}💡 Quick tip:${NC} Press ⌘+L (Mac) or Ctrl+L (Windows) to select the URL"
echo "6. Your page ID is the string before '?v='"
echo ""
echo -e "${YELLOW}Example URL:${NC} https://notion.site/1f4d55b8837780519a27c4f1f7e4b1a9?v=..."
echo -e "${YELLOW}Page ID:${NC} 1f4d55b8837780519a27c4f1f7e4b1a9"
echo ""

read -p "Enter your Notion Page ID: " notion_page_id

if [ -z "$notion_page_id" ]; then
    echo -e "${RED}✗${NC} Notion Page ID is required!"
    exit 1
fi

# Update .env file
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/NOTION_PAGE=.*/NOTION_PAGE=$notion_page_id/" .env
else
    # Linux
    sed -i "s/NOTION_PAGE=.*/NOTION_PAGE=$notion_page_id/" .env
fi

echo -e "${GREEN}✓${NC} Updated NOTION_PAGE in .env"

# Optional: Revalidation token
echo ""
read -p "Do you want to set up a revalidation token? (y/n): " setup_token
if [[ $setup_token =~ ^[Yy]$ ]]; then
    # Generate a random token
    random_token=$(openssl rand -hex 32)
    echo ""
    echo -e "${YELLOW}Generated token:${NC} $random_token"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/TOKEN_FOR_REVALIDATE=.*/TOKEN_FOR_REVALIDATE=$random_token/" .env
    else
        sed -i "s/TOKEN_FOR_REVALIDATE=.*/TOKEN_FOR_REVALIDATE=$random_token/" .env
    fi

    echo -e "${GREEN}✓${NC} Updated TOKEN_FOR_REVALIDATE in .env"
fi

# Install dependencies
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 2: Installing Dependencies${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if command -v pnpm &> /dev/null; then
    echo "Installing dependencies with pnpm..."
    pnpm install
    echo -e "${GREEN}✓${NC} Dependencies installed"
else
    echo -e "${YELLOW}⚠️  pnpm not found. Please install it first:${NC}"
    echo "   npm install -g pnpm"
    echo ""
    echo "Or use npm/yarn to install dependencies manually."
fi

# Check for Vercel CLI
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Step 3: Vercel Setup${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

if ! command -v vercel &> /dev/null; then
    echo -e "${YELLOW}⚠️  Vercel CLI not found${NC}"
    echo ""
    read -p "Would you like to install Vercel CLI globally? (y/n): " install_vercel

    if [[ $install_vercel =~ ^[Yy]$ ]]; then
        echo "Installing Vercel CLI..."
        npm install -g vercel
        echo -e "${GREEN}✓${NC} Vercel CLI installed"
    else
        echo ""
        echo -e "${YELLOW}You can install it later with:${NC}"
        echo "   npm install -g vercel"
    fi
else
    echo -e "${GREEN}✓${NC} Vercel CLI already installed"
fi

# Setup Vercel project
if command -v vercel &> /dev/null; then
    echo ""
    read -p "Would you like to link this project to Vercel now? (y/n): " link_vercel

    if [[ $link_vercel =~ ^[Yy]$ ]]; then
        echo ""
        echo "Running vercel link..."
        echo -e "${YELLOW}Please follow the prompts to link your project${NC}"
        vercel link
    fi
fi

# Summary
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Setup Complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Next steps:"
echo ""
echo -e "  1. Update your site configuration:"
echo -e "     ${BLUE}src/config/siteConfig.ts${NC}"
echo ""
echo -e "  2. Start the development server:"
echo -e "     ${BLUE}pnpm dev${NC}"
echo ""
echo -e "  3. Deploy to Vercel:"
echo -e "     ${BLUE}pnpm deploy:setup${NC}"
echo ""
echo "For more information, check the README.md"
echo ""
echo -e "${BLUE}🔲 Happy blogging!${NC}"
echo ""
