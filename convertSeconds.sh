#!/usr/bin/env bash

# Convert seconds to years, months, days, hours, minutes, seconds
convert_seconds() {
    [[ ! $1 =~ ^[0-9]+$ ]] && { echo "Error: Non-negative integer required"; return 1; }
    local s=$1 y=0 mo=0 d=0 h=0 m=0 r=0 out=""
    [ $s -ge 31536000 ] && { y=$((s/31536000)); s=$((s%31536000)); }
    [ $s -ge 2592000 ] && { mo=$((s/2592000)); s=$((s%2592000)); }
    [ $s -ge 86400 ] && { d=$((s/86400)); s=$((s%86400)); }
    [ $s -ge 3600 ] && { h=$((s/3600)); s=$((s%3600)); }
    [ $s -ge 60 ] && { m=$((s/60)); r=$((s%60)); } || r=$s
    [ $y -gt 0 ] && out="${y} year$([ $y -gt 1 ] && echo s)"
    [ $mo -gt 0 ] && out="${out:+$out, }${mo} month$([ $mo -gt 1 ] && echo s)"
    [ $d -gt 0 ] && out="${out:+$out, }${d} day$([ $d -gt 1 ] && echo s)"
    [ $h -gt 0 ] && out="${out:+$out, }${h} hour$([ $h -gt 1 ] && echo s)"
    [ $m -gt 0 ] && out="${out:+$out, }${m} minute$([ $m -gt 1 ] && echo s)"
    [ $r -gt 0 ] || [ -z "$out" ] && out="${out:+$out, }${r} second$([ $r -gt 1 ] && echo s)"
    echo "$out"
}

# Execute the function with the provided argument
[ $# -ne 1 ] && { echo "Usage: $0 <seconds>"; exit 1; }
convert_seconds "$1"
