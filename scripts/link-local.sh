#!/usr/bin/env bash
# Symlink every packages/<name> into Typst's local package dir as
# <name>/<version>, so `@local/<name>:<version>` resolves to this repo.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
case "$(uname)" in
  Darwin) local_dir="$HOME/Library/Application Support/typst/packages/local" ;;
  *)      local_dir="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages/local" ;;
esac

for pkg in "$repo"/packages/*/; do
  pkg="${pkg%/}"
  name="$(sed -n 's/^name = "\(.*\)"/\1/p' "$pkg/typst.toml")"
  ver="$(sed -n 's/^version = "\(.*\)"/\1/p' "$pkg/typst.toml")"
  target="$local_dir/$name/$ver"
  mkdir -p "$local_dir/$name"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "skip: $target exists and is not a symlink" >&2
    continue
  fi
  ln -sfn "$pkg" "$target"
  echo "@local/$name:$ver -> $pkg"
done
