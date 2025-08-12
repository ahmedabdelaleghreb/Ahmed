#!/usr/bin/env bash
set -e
MAP_FILE="assets/image_map.csv"
if [ ! -f "$MAP_FILE" ]; then
  echo "Missing $MAP_FILE"
  exit 1
fi
while IFS=, read -r filename url; do
  if [[ "$filename" == "filename" ]]; then continue; fi
  echo "Downloading $filename ..."
  dir=$(dirname "$filename")
  mkdir -p "$dir"
  curl -L -o "$filename" "$url?w=1024&auto=format&fit=crop"
done < "$MAP_FILE"
echo "Done."
