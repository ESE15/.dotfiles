#!/bin/bash
set -euo pipefail

#
# Check Prerequisites
#

## Dependences
DEPENDENCES=("git" "zsh" "curl")
for package in ${DEPENDENCES[@]}; do
    if ! (hash $package 2>/dev/null); then
        echo "$package not found"
        exit 1
    fi
done

#
# Auto-installation
#

## zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi

## vim-plug
if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

## direnv
if ! hash direnv 2>/dev/null; then
    if hash brew 2>/dev/null; then
        brew install direnv
    else
        curl -sfL https://direnv.net/install.sh | bash
    fi
fi

#
# Symlinking
#

# macOS BSD ln은 -r(relative) 플래그를 지원하지 않으므로 절대 경로를 사용
BASEDIR="$(cd "$(dirname "$0")" && pwd)"

## zsh
ln -sfn "${BASEDIR}/.zshrc" ~/.zshrc

## p10k
ln -sfn "${BASEDIR}/.p10k.zsh" ~/.p10k.zsh

## git
ln -sfn "${BASEDIR}/.gitconfig" ~/.gitconfig

## vim
ln -sfn "${BASEDIR}/.vimrc" ~/.vimrc

## ideavim
ln -sfn "${BASEDIR}/.ideavimrc" ~/.ideavimrc

## htop
mkdir -p ~/.config/htop
ln -sfn "${BASEDIR}/htoprc" ~/.config/htop/htoprc

## clone script
mkdir -p ~/bin/
ln -sfn "${BASEDIR}/jhlee11-gc" ~/bin/jhlee11-gc
ln -sfn "${BASEDIR}/ese15-gc" ~/bin/ese15-gc

## VSCode user settings (macOS 경로)
VSCODE_USER_DIR="${HOME}/Library/Application Support/Code/User"
if [[ -d "$(dirname "$VSCODE_USER_DIR")" ]]; then
    mkdir -p "$VSCODE_USER_DIR"
    ln -sfn "${BASEDIR}/vscode_user_settings.json" "${VSCODE_USER_DIR}/settings.json"
fi

echo 'Installation Complete!'
