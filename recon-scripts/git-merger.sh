#!/bin/bash
#
# ┌─────────────────────────────────────────────────────────────┐
# │   git-merger.sh                                             │
# │   Merge all text-based files from a dumped Git repo         │
# │   Author: Jean (https://github.com/jeanpt)                  │
# │   Date: 2025-05                                             │
# │   License: MIT                                              │
# └─────────────────────────────────────────────────────────────┘
#
# Description:
#   Recursively merges all text-based files in a dumped Git repo
#   into a single output file with labeled headers.
#
# Usage:
#   git-merger <git_repo_path> [output_file] [--txt]
#
# Examples:
#   git-merger dumped_repo                    => merged_dumped_repo.php
#   git-merger dumped_repo out.txt --txt      => out.txt (non-PHP mode)

print_help() {
  echo "Usage:"
  echo "  git-merger <git_repo_path> [output_file] [--txt]"
  echo
  echo "Examples:"
  echo "  git-merger dumped_repo                       # -> merged_dumped_repo.php"
  echo "  git-merger dumped_repo output.txt --txt      # -> output.txt"
  echo
  echo "Description:"
  echo "  Recursively finds all text-based files in the Git dump directory"
  echo "  and merges them into a single output file with labeled headers."
  exit 0
}

if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
  print_help
fi

GIT_REPO_PATH="$1"
OUTPUT_FILE="$2"
MODE="php"

if [[ "$2" == "--txt" ]]; then
  OUTPUT_FILE="merged_$(basename "$GIT_REPO_PATH").txt"
  MODE="txt"
elif [[ "$3" == "--txt" ]]; then
  MODE="txt"
fi

if [[ -z "$OUTPUT_FILE" ]]; then
  OUTPUT_FILE="merged_$(basename "$GIT_REPO_PATH").php"
fi

if [ ! -d "$GIT_REPO_PATH" ]; then
  echo "[-] Error: '$GIT_REPO_PATH' is not a valid directory."
  exit 1
fi

# Prevent overwriting an existing output file accidentally
if [[ -f "$OUTPUT_FILE" ]]; then
  echo "[-] Error: '$OUTPUT_FILE' already exists. Remove it or specify a different output file."
  exit 1
fi

echo "[*] Merging text files from '$GIT_REPO_PATH' into '$OUTPUT_FILE' (mode: $MODE)..."

file_count=0
skipped_count=0

find "$GIT_REPO_PATH" -type f | sort | while read -r file; do
  if file "$file" | grep -qE 'ASCII|UTF-8|text'; then
    if [[ "$MODE" == "php" ]]; then
      printf '\n\n<?php\n/* =====================================================================\n   FILE: %s\n   ===================================================================== */\n?>\n' "$file" >> "$OUTPUT_FILE"
    else
      printf '\n\n/* =====================================================================\n   FILE: %s\n   ===================================================================== */\n' "$file" >> "$OUTPUT_FILE"
    fi
    cat "$file" >> "$OUTPUT_FILE"
  else
    echo "[-] Skipped binary: $file"
  fi
done

echo "[+] Done. Output saved to '$OUTPUT_FILE'"
