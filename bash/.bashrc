#
# ~/.bashrc
#

function tat {
  name=$(basename $(pwd) | sed -e 's/\.//g')

  if tmux ls 2>&1 | grep "$name"; then
    tmux attach -t "$name"
  elif [ -f .envrc ]; then
    direnv exec / tmux new-session -s "$name"
  else
    tmux new-session -s "$name"
  fi
}

function cdf {
  dir=$(tree -adfi --noreport ~/ | grep -v '/.steam/' | fzf)
  [ -d "$dir" ] && cd "$dir"
}

function mkcd {
  mkdir $1
  cd $1
}

alias find='fzf --preview "cat {}"'

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always --line-range :100 {} || cat {}" --preview-window=right:60%'
export FZF_DEFAULT_COMMAND='find . -type d \( -path "./.steam" -o -path "./.cache" \) -prune -o -print'
export PATH="$PATH:$HOME/.local/bin"

eval "$(starship init bash)"

alias ls='ls -a --color=auto'
alias grep='grep --color=auto'
alias clf='clear;neofetch'
alias setup-project='~/.local/bin/setup-proj.sh'
alias build-project='~/.local/bin/build-proj.sh'
PS1='[\u@\h \W]\$ '
