#!/bin/sh
# Sort ollama model list by usage frequency
# Usage: olc_sort.sh <cache_file> <usage_file>
cache_file="$1"
usage_file="$2"

if [ -f "$usage_file" ]; then
  awk 'NR==FNR{u[$1]=$2;next}{printf "%d|%s\n",($1 in u)?u[$1]:0,$1}' "$usage_file" "$cache_file" | sort -t'|' -k1,1rn -k2,2 | cut -d'|' -f2
else
  cat "$cache_file"
fi