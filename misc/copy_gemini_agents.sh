#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
BASE=$(pwd)

TARGET_DIR="$HOME/.gemini/agents"

echo "Ensuring target directory exists: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

echo "Copying gemini agents..."
for file in "$BASE/gemini_agents"/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        cp "$file" "$TARGET_DIR/$filename"
    fi
done
