#!/bin/bash

# ------------------------------------------------------------------------------
# git-merger: Merge all PHP files from a dumped Git directory into one PHP file
# ------------------------------------------------------------------------------
# Author: Jean
# Use case: Simplify triage of dumped Git repositories by combining all .php files
#           into a single searchable document with section headers.
#
# Usage:
#   ./git-merger.sh <git_repo_path> <output_file>
#
# Example:
#   ./git-merger.sh dumped_repo merged.php
#
# Output:
#   merged.php — one file containing all PHP files, separated by headers.
# ------------------------------------------------------------------------------

print_help() {
  echo "Usage:"
  echo "  git-merger.sh <git_repo_path> <output_file>"
  echo
  echo "Example:"
  echo "  git-merger.sh dumped_repo merged.php"
  echo
  echo "Description:"
  echo "  Searches all .php files inside the specified Git dump directory and"
  echo "  combines them into a single file with large section headers for each file."
  exit 0
}

# Help flag or missing arguments
if [[ "$1" == "-h" || "$1" == "--help" || -z "$2" ]]; then
  print_help
fi

GIT_REPO_PATH="$1"
OUTPUT_FILE="$2"

# Check if directory is valid
if [ ! -d "$GIT_REPO_PATH" ]; then
  echo "[-] Error: '$GIT_REPO_PATH' is not a valid directory."
  exit 1
fi

echo "[*] Merging PHP files from '$GIT_REPO_PATH' into '$OUTPUT_FILE'..."
> "$OUTPUT_FILE"

find "$GIT_REPO_PATH" -type f -name "*.php" | while read file; do
  echo -e "\n\n<?php\n// =====================================================================" >> "$OUTPUT_FILE"
  echo -e "// FILE: $file" >> "$OUTPUT_FILE"
  echo -e "// =====================================================================\n?>" >> "$OUTPUT_FILE"
  cat "$file" >> "$OUTPUT_FILE"
done

echo "[+] Done. Output saved to '$OUTPUT_FILE'"
