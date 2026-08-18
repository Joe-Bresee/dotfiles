# ~/dotfiles/zsh/.zshrc

# Zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

# ensure up/down history behaves nice
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Command-line text styling
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=#6c7086,dim'
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,dim'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[function]='fg=#89b4fa'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6c7086,dim'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#94e2d5'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#94e2d5'


# aliases

# nix-darwin
alias renix="sudo darwin-rebuild switch --flake ~/dotfiles/nix-darwin#Joes-MacBook-Pro"
alias zshrc="code ~/dotfiles/zsh/.zshrc"
alias shsrc="source ~/.zshrc"

# nav
alias ..="cd .."
alias ~="cd ~"

# ls (eza)
alias ls="eza"
alias ll="eza -lah --icons"
alias la="eza -a --icons"
alias lt="eza --tree --icons"

# QOL
alias cl="clear"
alias h="history"
alias path="echo -e ${PATH//:/\\n}"
alias ports="lsof -i -P -n | grep LISTEN"
alias vsx-save="code --list-extensions > ~/dotfiles/vscode/extensions.txt"

# git
alias s="git status"
alias a="git add"
alias c="git commit -m"
alias p="git push"

# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"

# fastfetch on new terminal
if [[ -o interactive ]] && [[ -z "$FASTFETCH_SHOWN" ]]; then
    fastfetch
    export FASTFETCH_SHOWN=1
fi

autoload -Uz add-zsh-hook
add-zsh-hook precmd transient-prompt-precmd

TRANSIENT_PROMPT="${PROMPT// prompt / prompt --profile transient }"

function transient-prompt-precmd {
    # Fix ctrl+c behavior
    TRAPINT() {
        zle 2>/dev/null && transient-prompt
        return $(( 128 + $1 ))
    }

    # Save transient prompt
    SAVED_PROMPT="$(eval "printf '%s' \"${TRANSIENT_PROMPT}\"")"
}

autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-finish transient-prompt

function transient-prompt() {
    # Clear RPROMPT so right prompt only shows on the current (active) line
    PROMPT="$SAVED_PROMPT" RPROMPT="" zle .reset-prompt
}

export PATH="$HOME/.local/bin:$PATH"
