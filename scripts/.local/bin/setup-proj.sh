#!/bin/bash

mainDir=$(pwd)

mkdir -p "$mainDir/dependencies/lib"
mkdir -p "$mainDir/dependencies/include"
mkdir -p "$mainDir/include"
mkdir -p "$mainDir/src"

touch "$mainDir/build.conf"
touch "$mainDir/src/main.cpp"

ask_yes_no() {
  while true; do
    read -rp "$1 [Y/n]: " answer
    case "${answer,,}" in
    y | yes | "") return 0 ;;
    n | no) return 1 ;;
    esac
  done
}

init_git() {
  git -C "$mainDir" init
  echo "# README" >"$mainDir/README.md"
  git -C "$mainDir" add README.md
  git -C "$mainDir" commit -m "Initial commit"
}

if [[ "$1" == "--git" ]]; then
  init_git
else
  if ask_yes_no "Initialize git repository?"; then
    init_git
  fi
fi
