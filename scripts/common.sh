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
    # Non-interactive: use default
    if [ "$CI" = "true" ] || [ ! -t 0 ]; then
        echo "$default"
        return
    fi
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
    # Non-interactive: default to no
    if [ "$CI" = "true" ] || [ ! -t 0 ]; then
        return 1
    fi
    read -p "  $prompt (y/n): " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

# Arrow-key selector. Usage: select_option "Prompt" "opt1" "opt2" ...
# Sets SELECT_RESULT to the chosen value.
select_option() {
    local prompt="$1"; shift
    local options=("$@")
    local count=${#options[@]}
    local selected=0

    # Non-interactive mode: use first option as default
    if [ "$CI" = "true" ] || [ ! -t 0 ]; then
        SELECT_RESULT="${options[0]}"
        return
    fi

    # Hide cursor
    tput civis 2>/dev/null

    # Print prompt and options
    echo -e "  ${BOLD}${prompt}${NC}"
    for i in "${!options[@]}"; do
        if [ "$i" -eq "$selected" ]; then
            echo -e "  ${GREEN}▸ ${options[$i]}${NC}"
        else
            echo -e "    ${options[$i]}"
        fi
    done

    # Read arrow keys
    while true; do
        read -rsn1 key
        case "$key" in
            $'\x1b')  # ESC sequence
                read -rsn2 arrow
                case "$arrow" in
                    '[A') selected=$(( (selected - 1 + count) % count )) ;;  # Up
                    '[B') selected=$(( (selected + 1) % count )) ;;          # Down
                esac
                ;;
            '')  # Enter
                break
                ;;
        esac

        # Redraw options (move cursor up)
        for (( i=0; i<count; i++ )); do
            tput cuu1 2>/dev/null
            tput el 2>/dev/null
        done
        for i in "${!options[@]}"; do
            if [ "$i" -eq "$selected" ]; then
                echo -e "  ${GREEN}▸ ${options[$i]}${NC}"
            else
                echo -e "    ${options[$i]}"
            fi
        done
    done

    # Show cursor
    tput cnorm 2>/dev/null

    SELECT_RESULT="${options[$selected]}"
}

# ─── Validation helpers ─────────────────────────────────────────────

validate_url() {
    local url="$1"
    [[ "$url" =~ ^https?://[a-zA-Z0-9]([a-zA-Z0-9.-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}(/.*)?$ ]]
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

# Ensure Vercel CLI is available. Offers to install if missing.
# Returns 0 if available, 1 if not.
ensure_vercel() {
    resolve_vercel
    if [ -n "$VERCEL_CMD" ]; then return 0; fi

    echo ""
    if confirm "Vercel CLI not found. Install it?"; then
        npm install -g vercel 2>/dev/null
        VERCEL_CMD="vercel"
        success "Vercel CLI installed"
        return 0
    fi
    return 1
}

# Link project to Vercel if not already linked.
ensure_vercel_linked() {
    if [ -f .vercel/project.json ]; then return 0; fi

    echo ""
    echo -e "  ${BLUE}Linking project to Vercel...${NC}"
    echo -e "  ${YELLOW}Follow the prompts below:${NC}"
    echo ""
    $VERCEL_CMD link
    [ -f .vercel/project.json ]
}

# Push all non-placeholder env vars from .env to Vercel.
vercel_env_push() {
    if [ -z "$VERCEL_CMD" ] || [ ! -f .env ]; then return 1; fi

    local count=0
    while IFS='=' read -r key value; do
        [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
        [[ "$value" == "your_"* || "$value" == "your-"* ]] && continue
        [ -z "$value" ] && continue

        $VERCEL_CMD env rm "$key" production preview development -y 2>/dev/null
        echo "$value" | $VERCEL_CMD env add "$key" production preview development 2>/dev/null
        count=$((count + 1))
    done < .env

    success "Pushed $count env var(s) to Vercel"
}

# Full deploy flow: link → env push → build & deploy
vercel_deploy() {
    local mode="${1:-prod}"

    if ! ensure_vercel; then
        fail "Vercel CLI is required for deployment"
        return 1
    fi

    if ! ensure_vercel_linked; then
        fail "Failed to link project to Vercel"
        return 1
    fi

    # Push .env vars to Vercel if the file has content
    if [ -f .env ] && grep -qE "^[A-Z]" .env 2>/dev/null; then
        echo ""
        echo -e "  ${BLUE}Pushing environment variables...${NC}"
        vercel_env_push
    fi

    echo ""
    if [ "$mode" = "prod" ]; then
        echo -e "  ${BLUE}Deploying to production...${NC}"
        echo ""
        DEPLOY_URL=$($VERCEL_CMD --prod 2>&1 | grep -oE 'https://[^ ]+' | tail -1)
    else
        echo -e "  ${BLUE}Creating preview deployment...${NC}"
        echo ""
        DEPLOY_URL=$($VERCEL_CMD 2>&1 | grep -oE 'https://[^ ]+' | tail -1)
    fi

    if [ -n "$DEPLOY_URL" ]; then
        echo ""
        success "Deployed: $DEPLOY_URL"
        echo ""
        echo -e "  ${BOLD}From now on, just push to GitHub — Vercel auto-builds.${NC}"
        return 0
    else
        fail "Deployment may have failed — check Vercel dashboard"
        return 1
    fi
}

