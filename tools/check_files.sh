#!/usr/bin/env bash
# Parallel per-file GDScript parse check. Usage: tools/check_files.sh > out.txt
GODOT="C:/Users/Alex/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe"
PROJ="C:/Users/Alex/gm8tools/godot_port"
cd "$PROJ" || exit 1

check_one() {
  local f="$1"
  local out
  out=$("$GODOT" --headless --path "$PROJ" --check-only --script "$f" 2>&1)
  if printf '%s' "$out" | grep -qE "Parse Error|Failed loading|Can't load script|SCRIPT ERROR"; then
    printf 'FAIL %s\n' "$f"
    printf '%s\n' "$out" | grep -E "Parse Error|Failed loading|Can't load|SCRIPT ERROR" | head -3
  fi
}
export -f check_one
export GODOT PROJ

find gen runtime -name '*.gd' | sort | xargs -P 8 -I{} bash -c 'check_one "$@"' _ {}
echo "SWEEP done $(find gen runtime -name '*.gd' | wc -l) files"
