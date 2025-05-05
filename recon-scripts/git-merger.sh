#!/bin/bash
#
# ┌─────────────────────────────────────────────────────────────┐
# │   git-merger.sh                                              │
# │   Merge all text-based files from a dumped Git repo         │
# │   Author: Jean (https://github.com/jeanpt)                  │
# │   Date: 2025-05                                              │
# │   License: MIT                                               │
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
#

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

# Help or missing path
if [[ "$1" == "-h" || "$1" == "--help" || -z "$1" ]]; then
  print_help
fi

GIT_REPO_PATH="$1"
OUTPUT_FILE="$2"
MODE="php"

# Handle optional output and --txt flag
if [[ "$2" == "--txt" ]]; then
  OUTPUT_FILE="merged_$(basename "$GIT_REPO_PATH").txt"
  MODE="txt"
elif [[ "$3" == "--txt" ]]; then
  MODE="txt"
fi

# Default output if not specified
if [[ -z "$OUTPUT_FILE" ]]; then
  OUTPUT_FILE="merged_$(basename "$GIT_REPO_PATH").php"
fi

# Validate directory
if [ ! -d "$GIT_REPO_PATH" ]; then
  echo "[-] Error: '$GIT_REPO_PATH' is not a valid directory."
  exit 1
fi

echo "[*] Merging text files from '$GIT_REPO_PATH' into '$OUTPUT_FILE' (mode: $MODE)..."
> "$OUTPUT_FILE"

find "$GIT_REPO_PATH" -type f | while read file; do
  if file "$file" | grep -qE 'ASCII|UTF-8|text'; then
    if [[ "$MODE" == "php" ]]; then
      echo -e "\n\n<?php\n/* =====================================================================" >> "$OUTPUT_FILE"
      echo "   FILE: $file" >> "$OUTPUT_FILE"
      echo "   ===================================================================== */\n?>" >> "$OUTPUT_FILE"
    else
      echo -e "\n\n/* =====================================================================" >> "$OUTPUT_FILE"
      echo "   FILE: $file" >> "$OUTPUT_FILE"
      echo "   ===================================================================== */" >> "$OUTPUT_FILE"
    fi
    cat "$file" >> "$OUTPUT_FILE"
  else
    echo "[-] Skipped binary file: $file"
  fi
done

echo "[+] Done. Output saved to '$OUTPUT_FILE'"
