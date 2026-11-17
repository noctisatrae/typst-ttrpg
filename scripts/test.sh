#!/usr/bin/env bash
# Compiles every tests/*.typ (must succeed; failed asserts fail the compile)
# and every tests/fail/*.typ (must fail, and the error must contain each
# `// expect: <text>` line of the file).
set -uo pipefail
repo="$(cd "$(dirname "$0")/.." && pwd)"
out="$(mktemp -d)"
trap 'rm -rf "$out"' EXIT
status=0

for t in "$repo"/tests/*.typ; do
  name="$(basename "$t")"
  if err="$(typst compile --root "$repo" "$t" "$out/out.pdf" 2>&1)"; then
    echo "ok   $name"
  else
    echo "FAIL $name"; echo "$err" | sed 's/^/     /'; status=1
  fi
done

for t in "$repo"/tests/fail/*.typ; do
  name="fail/$(basename "$t")"
  if err="$(typst compile --root "$repo" "$t" "$out/out.pdf" 2>&1)"; then
    echo "FAIL $name (compiled, expected an error)"; status=1; continue
  fi
  missing=""
  while IFS= read -r want; do
    grep -qF -- "$want" <<<"$err" || missing+="       missing: $want"$'\n'
  done < <(sed -n 's|^// expect: ||p' "$t")
  if [ -z "$missing" ]; then
    echo "ok   $name"
  else
    echo "FAIL $name"; printf '%s' "$missing"; echo "$err" | sed 's/^/     /'; status=1
  fi
done
exit $status
