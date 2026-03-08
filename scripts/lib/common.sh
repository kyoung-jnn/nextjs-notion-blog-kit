#!/bin/bash
# ─── Shared helpers for setup / deploy / doctor scripts ──────────────

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

# ─── Output helpers ──────────────────────────────────────────────────

success() { echo -e "  ${GREEN}✓${NC} $1"; }
warn()    { echo -e "  ${YELLOW}⚠${NC} $1"; }
fail()    { echo -e "  ${RED}✗${NC} $1"; }

print_step() {
    local step="$1" total="$2" title="$3"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Step $step/$total: $title${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

banner() {
    local title="$1"
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   $(printf '%-36s' "$title")║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}"
    echo ""
}

# ─── .env helpers (idempotent) ───────────────────────────────────────

# Read a value from .env file. Returns empty string if not found.
get_env_var() {
    local key="$1" file="${2:-.env}"
    if [ -f "$file" ]; then
        grep -E "^${key}=" "$file" 2>/dev/null | head -1 | cut -d'=' -f2-
    fi
}

# Set a value in .env file. Updates existing or appends new.
set_env_var() {
    local key="$1" value="$2" file="${3:-.env}"

    if [ ! -f "$file" ]; then
        echo "${key}=${value}" > "$file"
        return
    fi

    if grep -qE "^${key}=" "$file" 2>/dev/null; then
        # Update existing line (cross-platform sed)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s|^${key}=.*|${key}=${value}|" "$file"
        else
            sed -i "s|^${key}=.*|${key}=${value}|" "$file"
        fi
    else
        echo "${key}=${value}" >> "$file"
    fi
}

# ─── Prompt helpers ──────────────────────────────────────────────────

# Prompt with current/default value shown. Returns default on empty input.
prompt_with_default() {
    local prompt="$1" default="$2" result
    if [ -n "$default" ]; then
        read -p "  $prompt [$default]: " result
        echo "${result:-$default}"
    else
        read -p "  $prompt: " result
        echo "$result"
    fi
}

# y/n confirmation. Returns 0 for yes, 1 for no.
confirm() {
    local prompt="$1" reply
    read -p "  $prompt (y/n): " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

# ─── Validation helpers ─────────────────────────────────────────────

validate_url() {
    local url="$1"
    [[ "$url" =~ ^https?://[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}(/.*)?$ ]]
}

validate_notion_id() {
    local id="$1"
    # 32-character hexadecimal
    [[ "$id" =~ ^[a-f0-9]{32}$ ]]
}

# ─── Vercel CLI helpers ──────────────────────────────────────────────

# Resolve vercel command (global → npx fallback). Sets VERCEL_CMD.
resolve_vercel() {
    if command -v vercel &> /dev/null; then
        VERCEL_CMD="vercel"
    elif command -v npx &> /dev/null; then
        VERCEL_CMD="npx vercel"
    else
        VERCEL_CMD=""
    fi
}

# Push a single env var to Vercel (production + preview).
vercel_env_push() {
    local key="$1" value="$2"
    if [ -z "$VERCEL_CMD" ]; then return 1; fi

    # Remove existing then add (idempotent)
    $VERCEL_CMD env rm "$key" production preview development -y 2>/dev/null
    echo "$value" | $VERCEL_CMD env add "$key" production preview development 2>/dev/null
}

# Push all non-placeholder env vars from .env to Vercel.
vercel_env_push_all() {
    if [ -z "$VERCEL_CMD" ]; then
        warn "Vercel CLI not available, skipping env push"
        return 1
    fi

    local count=0
    while IFS='=' read -r key value; do
        # Skip comments and empty lines
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        # Skip placeholder values
        [[ "$value" == "your_"* ]] && continue
        # Skip empty values
        [ -z "$value" ] && continue

        vercel_env_push "$key" "$value" && count=$((count + 1))
    done < .env

    success "Pushed $count environment variable(s) to Vercel"
}
