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

export PATH="$PATH:$HOME/.local/bin"

eval "$(starship init bash)"

alias ls='ls -a --color=auto'
alias grep='grep --color=auto'
alias setup-project='/usr/bin/setup-proj'
alias build-project='/usr/bin/build-proj'
PS1='[\u@\h \W]\$ '
