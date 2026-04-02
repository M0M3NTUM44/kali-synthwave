#!/bin/bash
# ╔══════════════════════════════════════════════════════════════╗
# ║         KALI SYNTHWAVE TERMINAL SETUP                       ║
# ║         by M0M3NTUM44                                       ║
# ╚══════════════════════════════════════════════════════════════╝
#
# One-shot script to transform any fresh Kali Linux terminal
# into a synthwave-themed, fully equipped hacker environment.
#
# Usage: bash setup.sh

set -e

# ── Colors ───────────────────────────────────────────────────
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
RESET='\033[0m'

banner() {
    echo ""
    echo -e "${MAGENTA}${BOLD}"
    echo '  ██████╗ ██╗   ██╗███╗   ██╗████████╗██╗  ██╗██╗    ██╗ █████╗ ██╗   ██╗███████╗'
    echo '  ██╔════╝╚██╗ ██╔╝████╗  ██║╚══██╔══╝██║  ██║██║    ██║██╔══██╗██║   ██║██╔════╝'
    echo '  ███████╗ ╚████╔╝ ██╔██╗ ██║   ██║   ███████║██║ █╗ ██║███████║██║   ██║█████╗  '
    echo '  ╚════██║  ╚██╔╝  ██║╚████║   ██║   ██╔══██║██║███╗██║██╔══██║╚██╗ ██╔╝██╔══╝  '
    echo '  ███████║   ██║   ██║ ╚███║   ██║   ██║  ██║╚███╔███╔╝██║  ██║ ╚████╔╝ ███████╗'
    echo '  ╚══════╝   ╚═╝   ╚═╝  ╚══╝   ╚═╝   ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝  ╚═══╝  ╚══════╝'
    echo -e "${RESET}"
    echo -e "${CYAN}  Kali Linux Terminal Setup — Synthwave Edition${RESET}"
    echo -e "${MAGENTA}  ─────────────────────────────────────────────${RESET}"
    echo ""
}

step() { echo -e "${CYAN}[${BOLD}${1}${RESET}${CYAN}]${RESET} ${2}"; }
ok()   { echo -e "  ${GREEN}✓ ${1}${RESET}"; }
warn() { echo -e "  ${YELLOW}⚠ ${1}${RESET}"; }

banner

# ── 1. Dependencies ──────────────────────────────────────────
step "1/8" "Installing dependencies..."
sudo apt-get update -qq 2>/dev/null
sudo apt-get install -y -qq zsh git curl wget fontconfig fastfetch lolcat 2>/dev/null || \
    sudo apt-get install -y -qq zsh git curl wget fontconfig 2>/dev/null
ok "Dependencies installed"

# ── 2. MesloLGS Nerd Font ────────────────────────────────────
step "2/8" "Installing MesloLGS Nerd Font (required for icons)..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"
for variant in "Regular" "Bold" "Italic" "Bold%20Italic"; do
    fname="MesloLGS NF ${variant//%20/ }.ttf"
    [ -f "$FONT_DIR/$fname" ] && continue
    curl -sfLo "$FONT_DIR/$fname" "${BASE_URL}/MesloLGS%20NF%20${variant}.ttf" || true
done
fc-cache -f "$FONT_DIR" 2>/dev/null || true

# Copy globally for Qt/system apps
sudo mkdir -p /usr/share/fonts/truetype/meslo
sudo cp "$FONT_DIR"/MesloLGS*.ttf /usr/share/fonts/truetype/meslo/ 2>/dev/null || true
sudo fc-cache -fv 2>/dev/null || true

ok "MesloLGS NF installed (local & global) → set it in your terminal preferences"

# ── 3. Oh-My-Zsh ─────────────────────────────────────────────
step "3/8" "Installing Oh-My-Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null
fi
ok "Oh-My-Zsh ready"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ── 4. Plugins ───────────────────────────────────────────────
step "4/8" "Installing zsh plugins..."
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone -q https://github.com/zsh-users/zsh-autosuggestions.git \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ] && \
    git clone -q https://github.com/zsh-users/zsh-history-substring-search.git \
    "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
ok "Plugins: syntax-highlighting, autosuggestions, history-search"

# ── 5. Powerlevel10k ─────────────────────────────────────────
step "5/8" "Installing Powerlevel10k theme..."
[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && \
    git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
ok "Powerlevel10k installed"

# ── write_user_config <home> <user> ──────────────────────────
# Writes all per-user dotfiles and terminal themes.
# Call once for a normal user, then again (via sudo) for root.
write_user_config() {
  local UHOME="$1"
  local UNAME="$2"
  local ZSH_DIR="$UHOME/.oh-my-zsh"
  local ZSH_CUSTOM="$ZSH_DIR/custom"

  # ── Powerlevel10k theme (needs p10k install) ──────────────
  # Clone Powerlevel10k if not already in this user's oh-my-zsh
  [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ] && \
    sudo -u "$UNAME" git clone -q --depth=1 \
      https://github.com/romkatv/powerlevel10k.git \
      "$ZSH_CUSTOM/themes/powerlevel10k" 2>/dev/null || true

# ── 6. P10k config ───────────────────────────────────────────
step "6/8" "Writing Powerlevel10k config for $UNAME..."
cat > "$UHOME/.p10k.zsh" << 'P10K'
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'
  autoload -Uz is-at-least && is-at-least 5.1 || return

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir vcs prompt_char
  )
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status command_execution_time
  )

  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=

  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#00FFFF'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#FF5555'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'

  typeset -g POWERLEVEL9K_DIR_FOREGROUND='#BD93F9'
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#6272A4'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#FF79C6'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=0

  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#FF79C6'

  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#50FA7B'
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#FFB86C'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#F1FA8C'
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND='#FF5555'

  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#FF5555'
  typeset -g POWERLEVEL9K_STATUS_ERROR_CONTENT_EXPANSION='✘ $P9K_CONTENT'

  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#F1FA8C'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  typeset -g POWERLEVEL9K_TIME_FOREGROUND='#6272A4'
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M}'

  typeset -g POWERLEVEL9K_CONTEXT_SSH_FOREGROUND='#FF79C6'
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#FF5555'
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_CONTENT_EXPANSION=

  typeset -g POWERLEVEL9K_IP_FOREGROUND='#8BE9FD'
  typeset -g POWERLEVEL9K_IP_INTERFACE='eth0'

  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
} "$@"

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
P10K
ok ".p10k.zsh written for $UNAME"

# ── 7. Fastfetch config ──────────────────────────────────────
step "7/8" "Configuring fastfetch banner for $UNAME..."
mkdir -p "$UHOME/.config/fastfetch"

cat > "$UHOME/.config/fastfetch/logo.txt" << 'LOGO'
  ██╗  ██╗ █████╗  ██████╗██╗  ██╗
  ██║  ██║██╔══██╗██╔════╝██║ ██╔╝
  ███████║███████║██║     █████╔╝ 
  ██╔══██║██╔══██║██║     ██╔═██╗ 
  ██║  ██║██║  ██║╚██████╗██║  ██╗
  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
LOGO

cat > "$UHOME/.config/fastfetch/config.jsonc" << 'FFCONF'
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "source": "~/.config/fastfetch/logo.txt",
        "color": { "1": "magenta", "2": "cyan" },
        "padding": { "top": 1, "left": 2 }
    },
    "display": {
        "separator": "  →  ",
        "color": { "keys": "cyan", "title": "magenta" }
    },
    "modules": [
        { "type": "title", "format": "{user-name}@{host-name}" },
        "separator",
        { "type": "os",       "key": " OS"       },
        { "type": "kernel",   "key": " Kernel"   },
        { "type": "uptime",   "key": " Uptime"   },
        { "type": "shell",    "key": " Shell"    },
        { "type": "terminal", "key": " Terminal" },
        { "type": "cpu",      "key": " CPU"      },
        { "type": "memory",   "key": " RAM"      },
        { "type": "disk",     "key": " Disk", "folders": "/" },
        { "type": "localip",  "key": " IP"       },
        "break",
        { "type": "colors", "paddingLeft": 2, "symbol": "circle" }
    ]
}
FFCONF
ok "Fastfetch configured for $UNAME"

# ── 8. .zshrc ────────────────────────────────────────────────
step "8/8" "Writing .zshrc for $UNAME..."
cat > "$UHOME/.zshrc" << 'ZSHRC'
# ──────────────────────────────────────────────────────────────
#  SYNTHWAVE ZSH — M0M3NTUM44
# ──────────────────────────────────────────────────────────────

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-history-substring-search
    history
    colored-man-pages
    command-not-found
    sudo
)

source $ZSH/oh-my-zsh.sh

# ── Autosuggestions ──────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6B5B8B"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '→' autosuggest-accept
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ── Syntax highlighting colors ───────────────────────────────
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#00FFFF,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#BD93F9,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#50FA7B'
ZSH_HIGHLIGHT_STYLES[function]='fg=#FFB86C'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5555,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=#F8F8F2,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#F1FA8C'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#F1FA8C'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#F1FA8C'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#FF79C6,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FF79C6'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#FF79C6,italic'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#FF79C6,italic'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#BD93F9'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#50FA7B'

# ── History ──────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS SHARE_HISTORY

# ── Hacker Aliases ───────────────────────────────────────────

## Recon / Nmap
alias nmapq='nmap -sV -sC -oA scan'
alias nmapfull='nmap -sV -sC -p- -T4 -oA fullscan'
alias nmapudp='sudo nmap -sU -T4 --top-ports 200 -oA udpscan'
alias nmapvuln='nmap --script=vuln -oA vulnscan'
alias nmappng='nmap -sn'

## Web
alias ffd='ffuf -w /usr/share/wordlists/dirb/common.txt -u'
alias gobust='gobuster dir -w /usr/share/wordlists/dirb/common.txt -u'
alias ferox='feroxbuster --url'

## Network
alias myip='curl -s ifconfig.me && echo'
alias localip="ip addr show | grep 'inet ' | awk '{print \$2}'"
alias ports='ss -tulpn'
alias listening='ss -tlnp'
alias sniff='sudo tcpdump -i eth0 -w capture.pcap'

## Tools
alias burp='java -jar /opt/BurpSuiteCommunity/burpsuite_community.jar &>/dev/null &'
alias msf='msfconsole -q'
alias python='python3'
alias py='python3'
alias serve='python3 -m http.server'
alias revshell='python3 -c "import pty;pty.spawn(\"/bin/bash\")"'

## Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lah --color=auto'
alias la='ls -lA --color=auto'

## Quality of life
alias grep='grep --color=auto'
alias cls='clear'
alias reload='source ~/.zshrc'
alias tf='tail -f'

## Git
alias gs='git status'
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# ── Startup ──────────────────────────────────────────────────
if command -v fastfetch &>/dev/null; then
    fastfetch
fi

# ── The Quote ────────────────────────────────────────────────
echo ""
echo -e "\033[0;35m  ┌─────────────────────────────────────────────────────────────┐\033[0m"
echo -e "\033[0;35m  │\033[0m                                                               \033[0;35m│\033[0m"
echo -e "\033[0;35m  │\033[0m  \033[1;36m\"If The Rule You Followed Brought You To This...\033[0m              \033[0;35m│\033[0m"
echo -e "\033[0;35m  │\033[0m   \033[1;35mOf What Use Was The Rule?\033[0m\033[1;36m....\033[0m\033[0;35m\"\033[0m                              \033[0;35m│\033[0m"
echo -e "\033[0;35m  │\033[0m                                                               \033[0;35m│\033[0m"
echo -e "\033[0;35m  └─────────────────────────────────────────────────────────────┘\033[0m"
echo ""

# P10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSHRC
ok ".zshrc written for $UNAME"

  # ── Fix ownership ─────────────────────────────────────────
  chown -R "$UNAME:$UNAME" "$UHOME/.p10k.zsh" "$UHOME/.zshrc" \
    "$UHOME/.config/fastfetch" 2>/dev/null || true

  # ── XFCE4 Terminal color scheme ──────────────────────────
  mkdir -p "$UHOME/.local/share/xfce4/terminal/colorschemes"
cat > "$UHOME/.local/share/xfce4/terminal/colorschemes/Synthwave Dark.theme" << 'THEME'
[Scheme]
Name=Synthwave Dark
ColorForeground=#E0D0FF
ColorBackground=#0D0D1E
ColorCursor=#00FFFF
ColorBold=#FF79C6
TabActivityColor=#FF00FF
ColorPalette=#1A1A2E;#FF5555;#50FA7B;#F1FA8C;#6272A4;#FF79C6;#00FFFF;#BFBFBF;#44475A;#FF6E6E;#69FF94;#FFFFA5;#8BE9FD;#FF92DF;#A4FFFF;#E0D0FF
THEME
  chown -R "$UNAME:$UNAME" \
    "$UHOME/.local/share/xfce4" 2>/dev/null || true

} # ── end write_user_config ──────────────────────────────────

# ── 6-8. Apply configs for both users ───────────────────────
step "*" "Applying configs for user: $USER"
write_user_config "$HOME" "$USER"

# Apply to root as well (only if we're not already root)
if [ "$USER" != "root" ]; then
    step "*" "Applying configs for user: root"
    # Ensure root has oh-my-zsh installed too
    if [ ! -d /root/.oh-my-zsh ]; then
        sudo RUNZSH=no CHSH=no sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
            -- --unattended 2>/dev/null || true
    fi
    # Copy plugins & theme to root's oh-my-zsh custom
    ROOT_CUSTOM=/root/.oh-my-zsh/custom
    for plugin in zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search; do
        sudo mkdir -p "$ROOT_CUSTOM/plugins/$plugin"
        sudo rsync -a "$ZSH_CUSTOM/plugins/$plugin/" "$ROOT_CUSTOM/plugins/$plugin/" 2>/dev/null || true
    done
    sudo mkdir -p "$ROOT_CUSTOM/themes/powerlevel10k"
    sudo rsync -a "$ZSH_CUSTOM/themes/powerlevel10k/" "$ROOT_CUSTOM/themes/powerlevel10k/" 2>/dev/null || true

    write_user_config /root root
fi

# ── QTerminal color scheme ───────────────────────────────────
QT5_SCHEME_DIR="$HOME/.local/share/qtermwidget5/color-schemes"
QT6_SCHEME_DIR="$HOME/.local/share/qtermwidget6/color-schemes"
QTERM_SCHEME_DIR="$HOME/.config/qterminal.org/color-schemes"
mkdir -p "$QT5_SCHEME_DIR" "$QT6_SCHEME_DIR" "$QTERM_SCHEME_DIR"

cat > "$QT5_SCHEME_DIR/Synthwave Dark.colorscheme" << 'QTHEME'
[Background]
Color=#0d0d1e

[BackgroundIntense]
Color=#1a1a2e

[Color0]
Color=#1a1a2e

[Color0Intense]
Color=#44475a

[Color1]
Color=#ff5555

[Color1Intense]
Color=#ff6e6e

[Color2]
Color=#50fa7b

[Color2Intense]
Color=#69ff94

[Color3]
Color=#f1fa8c

[Color3Intense]
Color=#ffffa5

[Color4]
Color=#6272a4

[Color4Intense]
Color=#8be9fd

[Color5]
Color=#ff79c6

[Color5Intense]
Color=#ff92df

[Color6]
Color=#00ffff

[Color6Intense]
Color=#a4ffff

[Color7]
Color=#bfbfbf

[Color7Intense]
Color=#e0d0ff

[Foreground]
Color=#e0d0ff

[ForegroundIntense]
Color=#ffffff

[General]
Description=Synthwave Dark
Opacity=1
QTHEME

cp "$QT5_SCHEME_DIR/Synthwave Dark.colorscheme" "$QT6_SCHEME_DIR/" 2>/dev/null || true
cp "$QT5_SCHEME_DIR/Synthwave Dark.colorscheme" "$QTERM_SCHEME_DIR/" 2>/dev/null || true
sudo mkdir -p /usr/share/qtermwidget5/color-schemes 2>/dev/null || true
sudo mkdir -p /usr/share/qtermwidget6/color-schemes 2>/dev/null || true
sudo cp "$QT5_SCHEME_DIR/Synthwave Dark.colorscheme" /usr/share/qtermwidget5/color-schemes/ 2>/dev/null || true
sudo cp "$QT5_SCHEME_DIR/Synthwave Dark.colorscheme" /usr/share/qtermwidget6/color-schemes/ 2>/dev/null || true

# ── Set zsh as default for kali and root ────────────────────
ZSH_PATH="$(which zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
    chsh -s "$ZSH_PATH" 2>/dev/null || \
        sudo chsh -s "$ZSH_PATH" "$USER" 2>/dev/null || true
fi
sudo chsh -s "$ZSH_PATH" root 2>/dev/null || true
ok "zsh set as default shell for $USER and root"

echo ""
echo -e "${MAGENTA}${BOLD}══════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}  ✅ SYNTHWAVE SETUP COMPLETE${RESET}"
echo -e "${MAGENTA}${BOLD}══════════════════════════════════════════════════${RESET}"
echo ""
echo -e "${CYAN}  Next steps:${RESET}"
echo -e "  ${YELLOW}1.${RESET} Set terminal preferences:"
echo -e "     ${MAGENTA}QTerminal (Kali default):${RESET} Preferences -> Appearance"
echo -e "     -> Color Scheme: ${CYAN}Synthwave Dark${RESET}"
echo -e "     -> Font: ${CYAN}MesloLGS NF${RESET}"
echo -e "     ${MAGENTA}XFCE4:${RESET} Preferences -> Appearance -> Font: ${CYAN}MesloLGS NF 12${RESET}"
echo -e "     -> Colors -> Presets -> ${CYAN}Synthwave Dark${RESET}"
echo ""
echo -e "  ${YELLOW}2.${RESET} Restart terminal or run: ${CYAN}exec zsh${RESET}"
echo ""
echo -e "  ${MAGENTA}\"If The Rule You Followed Brought You To This..."
echo -e "   Of What Use Was The Rule?....\"${RESET}"
echo ""
