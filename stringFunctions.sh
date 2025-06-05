#!/usr/bin/env bash

# Print the char in $1 for $2 times
repeatChar() {
    [[ $2 -gt 0 ]] || return
    printf -- "$1%0.s" $(seq 1 $2)
}

# String length
stringLength() {
    echo "${#1}"
}

# Substring expansion (position, length)
substring() {
    local str="$1"
    local pos="$2"
    local len="$3"
    echo "${str:pos:len}"
}

# Substring removal (shortest prefix pattern)
removePrefix() {
    echo "${1#$2}"
}

# Substring removal (longest prefix pattern)
removeLongestPrefix() {
    echo "${1##$2}"
}

# Substring removal (shortest suffix pattern)
removeSuffix() {
    echo "${1%$2}"
}

# Substring removal (longest suffix pattern)
removeLongestSuffix() {
    echo "${1%%$2}"
}

# String replacement (first match)
replaceFirst() {
    echo "${1/$2/$3}"
}

# String replacement (all matches)
replaceAll() {
    echo "${1//$2/$3}"
}

# Convert to lowercase (POSIX standard)
toLower() {
    echo "${1,,}"
}

# Convert to uppercase (POSIX standard)
toUpper() {
    echo "${1^^}"
}

# Convert first character to lowercase
toLowerFirst() {
    echo "${1,}"
}

# Convert first character to uppercase
toUpperFirst() {
    echo "${1^}"
}

# Toggle case of all characters
toggleCase() {
    echo "${1~~}"
}

# Toggle case of first character
toggleCaseFirst() {
    echo "${1~}"
}

# Check if string matches pattern (returns matched portion)
matchPattern() {
    [[ $1 = $2 ]] && echo "$BASH_REMATCH" || echo ""
}

# Check if string matches regex (returns matched portion)
matchRegex() {
    [[ $1 =~ $2 ]] && echo "${BASH_REMATCH[0]}" || echo ""
}

# Get all regex matches (through array)
getAllRegexMatches() {
    local str="$1"
    local regex="$2"
    local matches=()
    
    while [[ $str =~ $regex ]]; do
        matches+=("${BASH_REMATCH[0]}")
        str=${str#*"${BASH_REMATCH[0]}"}
    done
    
    printf '%s\n' "${matches[@]}"
}

# Default value if empty
defaultIfEmpty() {
    echo "${1:-$2}"
}

# Default value if unset
defaultIfUnset() {
    echo "${1-$2}"
}

# Error if empty
errorIfEmpty() {
    echo "${1:?$2}"
}

# Error if unset
errorIfUnset() {
    echo "${1?$2}"
}

# String concatenation
concat() {
    printf "%s" "$*"
}

# Join strings with delimiter
join() {
    local IFS="$1"
    shift
    echo "$*"
}

# Trim whitespace from both ends
trim() {
    local str="$1"
    str="${str#"${str%%[![:space:]]*}"}" # trim leading
    str="${str%"${str##*[![:space:]]}"}" # trim trailing
    echo "$str"
}

# How to use these functions
runExamples() {
    stringLength "hello"                           # 5
    substring "hello world" 6 3                    # wor
    removePrefix "hello world" "he"                # llo world
    removeLongestPrefix "hello world" "h*w"        # orld
    removeSuffix "hello_world.txt" ".txt"          # hello_world
    removeLongestSuffix "hello_world.tar.gz" ".*"  # hello_world
    replaceFirst "hello world" "l" "L"             # heLlo world
    replaceAll "banana" "a" "o"                    # bonono
    toLower "HeLLo WoRLD"                          # hello world
    toLowerFirst "HELLO"                           # hELLO
    toUpper "hello"                                # HELLO
    toUpperFirst "hello"                           # Hello
    toggleCase "HeLLo"                             # hEllO
    toggleCaseFirst "hello"                        # Hello
    toggleCaseFirst "HELLO"                        # hELLO
    matchPattern "hello123" "h*o*"                 # hello
    matchRegex "hello123" "[0-9]+"                 # 123
    getAllRegexMatches "test123abc456def" "[0-9]+" # 123 \n 456
    defaultIfEmpty "" "default value"              # default value
    defaultIfEmpty "actual" "default value"        # actual
    unset var
    defaultIfUnset "$var" "default"                # default
    var="set"
    defaultIfUnset "$var" "default"                # set
    #errorIfEmpty "valid" "Error message"          # valid
    #errorIfEmpty "" "Value cannot be empty"       # bash: 1: Value cannot be empty
    unset var
    #errorIfUnset "$var" "Variable not set"        # bash: var: Variable not set
    var="set"
    #errorIfUnset "$var" "Variable not set"        # set
    concat "hello" " " "world"                     # hello world
    join "," apple banana cherry                   # apple,banana,cherry
    trim "   hello world   "                       # hello world
}

# Run examples
runExamples
