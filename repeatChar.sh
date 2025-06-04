#!/usr/bin/env bash

repeat_char() {
  printf "%${2}s" | tr ' ' "$1"
}

# Examples
repeatChar '*' 5  # Output: *****
repeatChar '-' 10 # Output: ----------
repeatChar 'A' 3  # Output: AAA
