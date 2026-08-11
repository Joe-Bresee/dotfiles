# ~/dotfiles/zsh/.zshrc

# Zinit plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions


# aliases

# nix-darwin
alias dr="sudo darwin-rebuild switch --flake ~/dotfiles/nix-darwin#Joes-MacBook-Pro"
alias zshrc="code ~/dotfiles/zsh/.zshrc"
alias reload="source ~/.zshrc"

# nav
alias .. "cd .."
alias ~ "cd ~"

# ls
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"

# QOL
alias c "clear"
alias h "history"
alias path='echo -e ${PATH//:/\\n}'
alias ports="lsof -i -P -n | grep LISTEN"

# git
alias s "git status"
alias a "git add"
alias cm "commit -m"
alias p "git push"