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
alias c="clear"
alias h="history"
alias path="echo -e ${PATH//:/\\n}"
alias ports="lsof -i -P -n | grep LISTEN"

# zoxide
alias z="zoxide"

# git
alias s="git status"
alias a="git add"
alias cm="git commit -m"
alias p="git push"

# fzf
source <(fzf --zsh)

# zoxide
eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"