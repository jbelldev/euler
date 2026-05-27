#!/usr/bin/env bash
set -euo pipefail

problem="$1"
shift

answer=$(grep -oP "(?<=^$problem: ).*" solutions.dat)

if [[ -z "$answer" ]]; then
    echo "No expected answer for $problem in solutions.dat" >&2
    exit 2
fi

fails=0
for solution in "$@"; do
    result=$("./$solution")
    if [[ "$result" == "$answer" ]]; then
        printf '  ✓ %s\n' "$solution"
    else
        printf '  ✗ %s (got %q, want %q)\n' "$solution" "$result" "$answer"
        fails=$((fails + 1))
    fi
done

exit $(( fails > 0 ? 1 : 0 ))
