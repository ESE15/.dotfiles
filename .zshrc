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
    atclone'PYENV_ROOT=$PWD ./bin/pyenv init - | grep -v "^command pyenv rehash$" > zpyenv.zsh' \
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
    zsh-users/zsh-history-substring-search \
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

export PATH="$PATH:$(yarn global bin 2>/dev/null)"

source <(kubectl completion zsh)

# zsh 세팅
HISTSIZE=50000
SAVEHIST=50000
setopt INC_APPEND_HISTORY # 명령어 실행할 때마다 히스토리 추가
#setopt SHARE_HISTORY # 터미널 간 같은 히스토리 공유 
setopt EXTENDED_HISTORY # 타임스탬프 저장


alias kctl='kubectl'
alias k='kubectl'
alias kk='k9s'
alias kn='kubens'
alias kx='kubectx'
alias kgi='k get all,ingress'
alias ls='lsd --no-symlink'
alias ll='lsd -l --no-symlink'
alias lt='lsd --tree --no-symlink'
alias la='ls -la'
alias tf='terraform'
alias curlTime="curl -w \"@$HOME/.dotfiles/benchFormat.txt\" "
#alias curl=curlTime
alias dps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"'
alias dpsa='dps -a'
alias clean-branches="git branch -r | awk '{print \$1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print \$1}' | xargs git branch -D"
alias clean-local-branches="git branch -vv | awk '\$3 !~ /\\[origin/ {print \$1}' | xargs -r git branch -D"
alias branch-clear="clean-branches || clean-local-branches"
alias hist="history -i -50" 
alias cdsp='claude --dangerously-skip-permissions'

#source ~/.profile

# pnpm
export PNPM_HOME="/home/jhlee11/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

PATH=$PATH:/mnt/c/Users/Cookapps/AppData/Local/Programs/cursor
export PATH="$HOME/.local/bin:$PATH"

alias idea='open -na "IntelliJ IDEA.app" --args "$@"'

alias ascii-art='/home/jhlee11/playgrounds/high-res-ascii-painter/ascii-painter.sh '
saveclip() {
  local name=${1:-clip-$(date +%Y%m%d_%H%M%S).png}
  local win=$(wslpath -w "$PWD/$name")
  powershell.exe -NoProfile -Command "\$img = Get-Clipboard -Format Image; if (-not \$img) { Write-Error '클립보드에 이미지가 없습니다.'; exit 1 }; \$img.Save('$win',[System.Drawing.Imaging.ImageFormat]::Png)" \
    && echo "Saved: $name"
}
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

eval "$(direnv hook zsh)"


# openjdk@21 (added by Claude)
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"

hive-kill() {
    local target="${1:-all}"
    local found=0

    # Backend services (Java)
    local be_pattern
    if [[ "$target" == "all" ]]; then
      be_pattern='(ops-api|platform-api|game-api)'
    elif [[ "$target" != "hive-admin" ]]; then
      be_pattern="$target"
    fi

    if [[ -n "$be_pattern" ]]; then
      local be_pids
      be_pids=$(ps aux | grep -E "$be_pattern" | grep java | grep -v grep | awk '{print $2}')
      if [[ -n "$be_pids" ]]; then
        found=1
        echo "$be_pids" | while read pid; do
          local name=$(ps -p "$pid" -o args= | grep -oE '(ops-api|platform-api|game-api)')
          echo "Killing $name (PID: $pid)"
          kill "$pid"
        done
      fi
    fi

    # Frontend service (Node.js)
    if [[ "$target" == "all" || "$target" == "hive-admin" ]]; then
      local fe_pids
      fe_pids=$(ps aux | grep -E 'hive-admin|platform-web' | grep node | grep -v grep | awk '{print $2}')
      if [[ -n "$fe_pids" ]]; then
        found=1
        echo "$fe_pids" | while read pid; do
          echo "Killing hive-admin (PID: $pid)"
          kill "$pid"
        done
      fi
    fi

    if [[ $found -eq 0 ]]; then
      echo "No running process found for: $target"
    fi
  }

