#!/usr/bin/env bash
# Builds the Typst Universe bundle of each package named on the command line
# into <out>/<name>/<version>/: the package directory plus LICENSE, with
# `@local/<pkg>:<ver>` imports rewritten to `@preview/<pkg>:<ver>`.
#
#   scripts/bundle.sh <out> ttrpg-core ttrpg-script heartweaver
#
# Checks what Typst Universe asks of a package (docs/manifest.md in
# typst/packages): manifest fields, README, no @local imports left, and that
# each dependency it imports is bundled in the same run or already published.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
out="$1"; shift
status=0

field() { sed -n "s/^$2 = \"\(.*\)\"/\1/p" "$1/typst.toml"; }

for name in "$@"; do
  src="$repo/packages/$name"
  [ -f "$src/typst.toml" ] || { echo "error: no package $name" >&2; exit 1; }
  ver="$(field "$src" version)"
  dest="$out/$name/$ver"
  rm -rf "$dest"; mkdir -p "$dest"
  cp -R "$src/." "$dest/"
  cp "$repo/LICENSE" "$dest/LICENSE"
  find "$dest" -name '*.typ' -print0 | xargs -0 sed -i.bak -E 's#@local/([a-z0-9-]+):([0-9.]+)#@preview/\1:\2#g'
  find "$dest" -name '*.bak' -delete

  for key in name version entrypoint authors license description repository compiler; do
    grep -q "^$key = " "$dest/typst.toml" || { echo "error: $name: typst.toml lacks \`$key\`" >&2; status=1; }
  done
  [ -f "$dest/README.md" ] || { echo "error: $name: no README.md" >&2; status=1; }
  if grep -rq '@local/' "$dest" --include='*.typ'; then echo "error: $name: @local imports left" >&2; status=1; fi
  # Dependencies: bundled in this run, or already on Universe.
  for dep in $(grep -rhoE '@preview/[a-z0-9-]+:[0-9.]+' "$dest" --include='*.typ' | sort -u); do
    d="${dep#@preview/}"; dname="${d%%:*}"; dver="${d#*:}"
    if [[ " $* " == *" $dname "* ]]; then
      [ "$(field "$repo/packages/$dname" version)" = "$dver" ] || { echo "error: $name imports $dep but $dname is $(field "$repo/packages/$dname" version)" >&2; status=1; }
    elif ! curl -sfI "https://packages.typst.org/preview/$dname-$dver.tar.gz" >/dev/null; then
      echo "error: $name imports $dep, which is neither bundled here nor published" >&2; status=1
    fi
  done
  echo "bundled $name $ver -> $dest"
done
exit $status
