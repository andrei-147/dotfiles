#!/bin/bash

mainDir=$(pwd)

mkdir -p "$mainDir/dependencies/lib"
mkdir -p "$mainDir/dependencies/include"
mkdir -p "$mainDir/include"
mkdir -p "$mainDir/src"
mkdir -p "$mainDir/Build/Debug"
mkdir -p "$mainDir/Build/Release"

touch "$mainDir/build.conf"
touch "$mainDir/src/main.cpp"

build_type=""

ask_yes_no() {
  while true; do
    read -rp "$1 [Y/n]: " answer
    case "${answer,,}" in
    y | yes | "") return 0 ;;
    n | no) return 1 ;;
    esac
  done
}

choose_build_type() {
  while true; do
    read -rp "Choose build type (Debug/Release): " input
    case "${input,,}" in
    debug)
      build_type="Debug"
      break
      ;;
    release)
      build_type="Release"
      break
      ;;
    esac
  done
}

if [[ -n "$1" ]]; then
  arg_lower=${1,,}
  if [[ "$arg_lower" == "debug" || "$arg_lower" == "release" ]]; then
    build_type="${arg_lower^}"
  else
    choose_build_type
  fi
else
  choose_build_type
fi

build_dir="$mainDir/Build/$build_type"
mkdir -p "$build_dir"

if [[ "$build_type" == "Debug" ]]; then
  CFLAGS="-Wall -g"
  clear
elif [[ "$build_type" == "Release" ]]; then
  CFLAGS="-O2"
fi

# Recursively find all include directories under include and dependencies/include
include_dirs=()
while IFS= read -r -d '' dir; do
  include_dirs+=("-I$dir")
done < <(find "$mainDir/include" "$mainDir/dependencies/include" -type d -print0)

src_files=($(find "$mainDir/src" -name '*.cpp'))

obj_dir="$build_dir/obj"
mkdir -p "$obj_dir"

obj_files=()
for src_file in "${src_files[@]}"; do
  src_filename=$(basename "$src_file")
  obj_file="$obj_dir/${src_filename%.cpp}.o"
  gcc $CFLAGS "${include_dirs[@]}" -c "$src_file" -o "$obj_file"
  if [[ $? -ne 0 ]]; then
    echo "Compilation failed for $src_file"
    exit 1
  fi
  obj_files+=("$obj_file")
done

libs=()
# Recursively find all .a files in dependencies/lib
while IFS= read -r -d '' lib; do
  libs+=("$lib")
done < <(find "$mainDir/dependencies/lib" -name '*.a' -type f -print0)

exe_file="$build_dir/app"
gcc "${obj_files[@]}" "${libs[@]}" -o "$exe_file"
if [[ $? -ne 0 ]]; then
  echo "Linking failed."
  exit 1
fi

if [[ "$build_type" == "Release" ]]; then
  clear
fi

echo "Build complete. Executable at: $exe_file"

if [[ -x "$exe_file" ]]; then
  "$exe_file"
fi
