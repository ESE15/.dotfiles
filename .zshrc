#vim: sw=2 ts=2

#
# macOS considerations
#


#
# zinit
#
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ -f ${ZINIT_HOME}/zinit.zsh ]]; then
  source "${ZINIT_HOME}/zinit.zsh"
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit

  # zinit annexes
  zinit for \
    light-mode zdharma-continuum/zinit-annex-bin-gem-node

  # nodenv
  zinit wait"" lucid for \
    atinit'export NODENV_ROOT=$PWD' \
    atclone'NODENV_ROOT=$PWD ./bin/nodenv init - > znodenv.zsh' \
    atpull"%atclone" \
    src"znodenv.zsh" nocompile"!" sbin"bin/nodenv" \
    @nodenv/nodenv
  zinit wait"(( $+commands[nodenv] ))" lucid for \
    as"null" \
    atclone'
      mkdir -p "$(nodenv root)"/plugins
      ln -sf $PWD "$(nodenv root)"/plugins/node-build
    ' \
    atpull"%atclone" \
    @nodenv/node-build

  # pyenv
  zinit wait"" lucid for \
    atinit'export PYENV_ROOT=$PWD' \
    atclone'PYENV_ROOT=$PWD ./bin/pyenv init - > zpyenv.zsh' \
    atpull"%atclone" \
    src"zpyenv.zsh" nocompile"!" sbin"bin/pyenv" \
    pyenv/pyenv
  # pyenv-virtualenv is temporarily disabled due to poor shell performance
  # zinit wait"(( $+commands[pyenv] ))" lucid for \
  #   atclone'
  #     mkdir -p "$(pyenv root)"/plugins
  #     ln -sf $PWD "$(pyenv root)"/plugins/pyenv-virtualenv
  #     ./bin/pyenv-virtualenv-init - > zpyenv-virtualenv.zsh
  #   ' \
  #   atpull"%atclone" \
  #   src"zpyenv-virtualenv.zsh" nocompile"!" \
  #   pyenv/pyenv-virtualenv


  # useful tools
  zinit for \
    from"gh-r" sbin"fzf" nocompile junegunn/fzf \
    https://github.com/junegunn/fzf/raw/master/shell/{"completion","key-bindings"}.zsh \
    sbin"kubectx;kubens" nocompile ahmetb/kubectx \
    from"gh-r" mv"yq* -> yq" sbin"yq" nocompile mikefarah/yq

  # completions
  zinit wait"" lucid light-mode for \
    atinit'zicompinit; zicdreplay' zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-syntax-highlighting \
    blockf atpull'zinit creinstall -q .' zsh-users/zsh-completions


  # other plugins
  zinit wait"" lucid for \
    as"program" pick"git-select-branch" autoload"git-select-branch" tirr-c/git-select-branch

  # powerlevel10k
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi

  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  zinit for \
    atload"! [[ ! -f ~/.p10k.zsh ]] | source ~/.p10k.zsh" \
    romkatv/powerlevel10k
fi

# 
# zsh configuration
#
zstyle ':completion:*' menu select
#zstyle ':autocomplete:*' default-context history-incremental-search-backward
# History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

# term
export TERM="xterm-256color"

#
# Path
#

## ~/.local/bin
if [[ -d ~/.local/bin ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

## ~/.local/lib
if [[ -d ~/.local/lib ]]; then
  export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
fi


## yarn
if [[ -d ~/.yarn ]]; then
  export PATH="$HOME/.yarn/bin:$PATH"
fi

#
# aliases
#

## exa
if (( $+commands[exa] )); then
  alias l='exa -algb --time-style iso --group-directories-first --color=always'
else
  alias l='ls -alh --time-style iso --group-directories-first --color=always'
fi

## vim
if (( $+commands[vim] )); then
  typeset -gx EDITOR=vim
  alias vi='vim'
fi

#
# Completions
#
autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

## terraform
if (( $+commands[terraform] )); then
  alias tf='terraform'
  complete -o nospace -C $(which terraform) terraform
fi

#
# Useful Scripts
#

# Docker
if hash dockerd 2>/dev/null; then
  # Start Docker daemon automatically when logging in if not running.
  RUNNING=`ps aux | grep dockerd | grep -v grep`
  if [ -z "$RUNNING" ]; then
    sudo dockerd > /dev/null 2>&1 &
    disown
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source <(kubectl completion zsh)

alias kctl='kubectl'
alias ls='lsd --no-symlink'
alias ll='lsd -l --no-symlink'
alias lt='lsd --tree --no-symlink'
alias tf='terraform'
