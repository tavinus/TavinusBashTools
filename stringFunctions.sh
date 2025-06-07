#!/usr/bin/env bash

###########################################################################
#
# Tavinus Bash String function helpers
# Examples at the end
#
# These functions are made to be portable
# This means they do not depend on each other
# The exception being the table functions,
# which use the repeatChar function
#
# Examples that cause errors are commented out
# because they break execution
#
###########################################################################

# Version
STRINGFUNCTIONVER=0.1.4





###########################################################################
## Functions


# Print the char in $1 for $2 times
repeatChar() {
    [[ $2 -gt 0 ]] || return
    printf -- "$1%0.s" $(seq 1 $2)
}

# String length
stringLength() {
    echo -n "${#1}"
}

# Substring expansion (position, length)
# $1 string
# $2 position
# $3 length
substring() {
    local str="$1"
    local pos="$2"
    local len="$3"
    echo -n "${str:pos:len}"
}

# Substring removal (shortest prefix pattern)
removePrefix() {
    echo -n "${1#$2}"
}

# Substring removal (longest prefix pattern)
removeLongestPrefix() {
    echo -n "${1##$2}"
}

# Substring removal (shortest suffix pattern)
removeSuffix() {
    echo -n "${1%$2}"
}

# Substring removal (longest suffix pattern)
removeLongestSuffix() {
    echo -n "${1%%$2}"
}

# String replacement (first match)
replaceFirst() {
    echo -n "${1/$2/$3}"
}

# String replacement (all matches)
replaceAll() {
    echo -n "${1//$2/$3}"
}

# Convert to lowercase (POSIX standard)
toLower() {
    echo -n "${1,,}"
}

# Convert to uppercase (POSIX standard)
toUpper() {
    echo -n "${1^^}"
}

# Convert first character to lowercase
toLowerFirst() {
    echo -n "${1,}"
}

# Convert first character to uppercase
toUpperFirst() {
    echo -n "${1^}"
}

# Toggle case of all characters
toggleCase() {
    echo -n "${1~~}"
}

# Toggle case of first character
toggleCaseFirst() {
    echo -n "${1~}"
}

# Check if string matches pattern (returns matched portion)
matchPattern() {
    [[ $1 =~ $2 ]] && echo -n ${BASH_REMATCH[@]} || echo -n ""
}

# Check if string matches regex (returns matched portion)
matchRegex() {
    [[ $1 =~ $2 ]] && echo -n "${BASH_REMATCH[0]}" || echo -n ""
}

# Get all regex matches (through array)
# $1 String to be processed
# $2 Regex
# $3 Separator. Default=,
getAllRegexMatches() {
    local str="$1"
    local regex="$2"
    local matches=()
    local sep=','
    local list=""
    [[ -z "$3" ]] || sep="$3"
    
    while [[ $str =~ $regex ]]; do
        matches+=("${BASH_REMATCH[0]}")
        str=${str#*"${BASH_REMATCH[0]}"}
    done
    
    [[ ${#matches[*]} -gt 0 ]] && list="$(printf "%s$sep" "${matches[@]}")"
    echo -n "${list%$sep}"
}

# Default value if empty
defaultIfEmpty() {
    echo -n "${1:-$2}"
}

# Default value if unset
defaultIfUnset() {
    echo -n "${1-$2}"
}

# Error if empty
errorIfEmpty() {
    echo -n "${1:?$2}"
}

# Error if unset
errorIfUnset() {
    echo -n "${1?$2}"
}

# String concatenation
concat() {
    local r=""
    for s in "$@" ; do
        r+="$s"
    done
    echo -n "$r"
    #printf "%s" "${*}"
}

# Join strings with delimiter
join() {
    local IFS="$1"
    shift
    echo -n "$*"
}

# Trim whitespace from both ends
trim() {
    local str="$1"
    str="${str#"${str%%[![:space:]]*}"}" # trim leading
    str="${str%"${str##*[![:space:]]}"}" # trim trailing
    echo -n "$str"
}



###########################################################################
## Table rendering

# centers $1 into the width of $2
centerText() {
  local text="$1"
  local width="$2"
  local tSize=${#text}
  local pad=$(( (width - tSize) / 2 ))
  local diff=$(( width - pad ))
  printf "%${pad}s%-${diff}s" "" "$text"
}

# Creates a table line with size $1, size >= 3
tableLine() {
    [[ $1 -gt 2 ]] || return
    local s=$1
    printf "+%s+\n" "$(repeatChar '-' $((s-2)))"
}

# Creates a table line with divider sizes from parameters
tableDivider() {
    local r=""
    for c in "$@" ; do
        r+="+""$(repeatChar '-' $c)"
    done
    echo "$r+"
}

# Prints a full line table info
# $1 text data
# $2 width
# $3 alignment (l, r, c)
tableInfo() {
    local o='-'
    [[ "$3" == 'r' ]] && o='+'
    local c=$2
    if [[ "$3" == 'c' ]]; then
        c=$((c-2))
        printf "|%s|\n" "$(centerText "$1" $c)"
    else
        c=$((c-4))
        printf "| %"$o$c"s |\n" "$1"
    fi
}

# Prints a table cell
# $1 text data
# $2 width
# $3 alignment (l, r, c)
tableRowItem() {
    local o='-'
    [[ "$3" == 'r' ]] && o='+'
    local c=$2
    
    if [[ "$3" == 'c' ]]; then
        c=$((c+2))
        printf "|%s" "$(centerText "$1" $c)"
    else
        printf "| %${o}${2}s " "$1"
    fi
}

# Adds the right bar and newline into a tableRowItem
tableRowEnd() {
    printf "%s|\n" "$(tableRowItem "$1" "$2" "$3")"
}









###########################################################################
## Fancy Tables

# Load default theme
ftLoadDefault() {
    ftLoadSingle
}


# ┐ └ ┴ ┬ ├ ─ ┼ ┘ ┌ │ ┤
# ┌───────┐
# │       │
# ├───┬───┤
# │   │   │
# ├───┼───┤
# │   │   │
# ├───┴───┤
# │       │
# └───┬───┘
#     │
#     │
# ┌───┴───┐
# │       │
# │       │
# └───────┘

# Single line theme
ftLoadSingle() {
    MAINBAR='│'
    TOPLEFT='┌'
    TOPMID='┬'
    TOPRIGHT='┐'
    MAINLINE='─'
    LEFTMID='├'
    CENTERMID='┼'
    RIGHTMID='┤'
    BOTMID='┴'
    BOTLEFT='└'
    BOTRIGHT='┘'
}


# ╚ ╔ ╩ ╦ ╠ ═ ╬ ╣ ║ ╗ ╝
# ╔═══════╗
# ║       ║
# ╠═══╦═══╣
# ║   ║   ║
# ╠═══╬═══╣
# ║   ║   ║
# ╠═══╩═══╣
# ║       ║
# ╚═══╦═══╝
#     ║
#     ║
# ╔═══╩═══╗
# ║       ║
# ║       ║
# ╚═══════╝

# Double line theme
ftLoadDouble() {
    MAINBAR='║'
    TOPLEFT='╔'
    TOPMID='╦'
    TOPRIGHT='╗'
    MAINLINE='═'
    LEFTMID='╠'
    CENTERMID='╬'
    RIGHTMID='╣'
    BOTMID='╩'
    BOTLEFT='╚'
    BOTRIGHT='╝'
}


# █ ▄ ▀
# ▄▄▄▄▄▄▄▄▄▄
# █        █
# ▀▀▀▀▀▀▀▀▀▀

# Thick Block theme
ftLoadThick() {
    MAINBAR='█'
    TOPLEFT='▄'
    TOPMID='▄'
    TOPRIGHT='▄'
    MAINLINE='▄'
    LEFTMID='█'
    CENTERMID='█'
    RIGHTMID='█'
    BOTMID='█'
    BOTLEFT='█'
    BOTRIGHT='█'
}


# Plain ascii theme
ftLoadAscii() {
    MAINBAR='|'
    TOPLEFT='+'
    TOPMID='+'
    TOPRIGHT='+'
    MAINLINE='-'
    LEFTMID='+'
    CENTERMID='+'
    RIGHTMID='+'
    BOTMID='+'
    BOTLEFT='+'
    BOTRIGHT='+'
}


ftLoadDefault


# Creates a Top table line with size $1
ftTopLine() {
    [[ $1 -gt 2 ]] || return
    local s=$1
    printf "${TOPLEFT}%s${TOPRIGHT}\n" "$(repeatChar ${MAINLINE} $((s-2)))"
}

# Creates a Bot table line with size $1
ftBotLine() {
    [[ $1 -gt 2 ]] || return
    local s=$1
    printf "${BOTLEFT}%s${BOTRIGHT}\n" "$(repeatChar ${MAINLINE} $((s-2)))"
}

# Creates a table line with divider sizes from parameters
# $1 should be t, m, b (for top, mid, bot), defaults to mid
# $2...@ are the cell sizes
ftDivider() {
    local r="${LEFTMID}"
    local m="${CENTERMID}"
    [[ "$1" == 't' ]] && m="${TOPMID}"
    [[ "$1" == 'b' ]] && m="${BOTMID}"
    shift
    local p=$# j=1
    for c in "$@" ; do
        [[ $j -eq $p ]] && m=''
        r+="$(repeatChar ${MAINLINE} $c)""${m}"
        j=$((j+1))
    done
    echo "$r$RIGHTMID"
}

# Prints top divider
ftDividerTop() {
    printf "%s\n" "$(ftDivider t "${@}")"
}

# Prints mid divider
ftDividerMid() {
    printf "%s\n" "$(ftDivider m "${@}")"
}

# Prints bot divider
ftDividerBot() {
    printf "%s\n" "$(ftDivider b "${@}")"
}


# Prints a table cell
# $1 text data
# $2 width
# $3 alignment l, r, c (left, right, center)
ftCell() {
    local o='-'
    [[ "$3" == 'r' ]] && o='+'
    local c=$2
    c=$((c-2))
    
    if [[ "$3" == 'c' ]]; then
        c=$((c+2))
        printf "${MAINBAR}%s" "$(centerText "$1" $c)"
    else
        printf "${MAINBAR} %${o}${c}s " "$1"
    fi
}

# Adds the right bar and newline into a ftCell
ftCellEnd() {
    printf "%s${MAINBAR}\n" "$(ftCell "$1" "$2" "$3")"
}

# Prints a full line table info
# $1 text data
# $2 width
# $3 alignment (l, r, c)
ftInfoOld() {
    local o='-'
    [[ "$3" == 'r' ]] && o='+'
    local c=$2
    if [[ "$3" == 'c' ]]; then
        c=$((c-2))
        printf "${MAINBAR}%s${MAINBAR}\n" "$(centerText "$1" $c)"
    else
        c=$((c-4))
        printf "${MAINBAR} %"$o$c"s ${MAINBAR}\n" "$1"
    fi
}

# Prints a full line table info
# $1 text data
# $2 width
# $3 alignment (l, r, c)
ftInfo() {
    local s=$2
    s=$((s-2))
    printf "%s\n" "$(ftCellEnd "$1" $s $3)"
}

# Calculates the size of a table by its cells definition
ftSizeByCells() {
    # sum of cell values + sum off cell count + 1 = tSize
    # Example for cels"10 20 30 10"
    # so 10 + 20 + 30 + 10 + 4 + 1 = 75
    local tCells=(${@})
    local tSize=0 
    local cCount=${#tCells[@]}
    for i in "${tCells[@]}"; do
        tSize=$((tSize + i))
    done
    echo -n $((tSize + cCount + 1))
}

# Prints a test table data row
testTableItem() {
    local tCells=(${1})
    ftCell "$2" ${tCells[0]} c
    ftCell "$3" ${tCells[1]} l
    ftCell "$4" ${tCells[2]} c
    ftCellEnd "$5" ${tCells[3]} r
}

# Prints data row and adds top and mid dividers
testTableItemTopMid() {
    ftDividerTop $1
    printf "%s\n" "$(testTableItem "$1" "$2" "$3" "$4" "$5")"
    ftDividerMid $1
}

# Prints data row and adds top and bot dividers
testTableItemTopBot() {
    ftDividerTop $1
    printf "%s\n" "$(testTableItem "$1" "$2" "$3" "$4" "$5")"
    ftDividerBot $1
}

# Prints data row and adds mid divider
testTableItemMid() {
    printf "%s\n" "$(testTableItem "$1" "$2" "$3" "$4" "$5")"
    ftDividerMid $1
}

# Prints data row and adds bot divider
testTableItemBot() {
    printf "%s\n" "$(testTableItem "$1" "$2" "$3" "$4" "$5")"
    ftDividerBot $1
}

runTestTable() {
    local cellSizes='12 19 28 14'
    local tableWidth=$(ftSizeByCells $cellSizes)
    
    ftTopLine $tableWidth
    ftInfo "PRIMARY TABLE" $tableWidth c
    testTableItemTopMid "$cellSizes" "AAA" "BBBBB" "CCCCCCC" "DDDD"
    testTableItemMid "$cellSizes" "123" "45678" "9012345" "1234"
    testTableItemBot "$cellSizes" "A A" "B B B" "C C C C C" "D D D"
    ftInfo "SECONDARY TABLE" $tableWidth c
    testTableItemTopBot "$cellSizes" "AAA" "BBBBB" "CCCCCCC" "DDDD"
    ftInfo "Table information*" $tableWidth r
    ftBotLine $tableWidth
    echo
}

runTestTableTests() {
    echo
    ftLoadSingle
    runTestTable
    ftLoadDouble
    runTestTable
    ftLoadAscii
    runTestTable
    ftLoadThick
    runTestTable
    ftLoadDefault
}


###########################################################################
## Tests

tcount=0

# Print a test into a table
printTest() {
    tcount=$(( tcount + 1))
    ftCell "$tcount" 5 r
    ftCell "$1" 49 l
    ftCellEnd "$2" 25 l
    #[[ -z "$3" ]] && ftDividerMid 5 49 25
}


# Test run examples verbose
runExamples() {
    ftTopLine 83
    ftInfo "RUNNING FUNCTION TESTS" 83 c
    ftDividerTop 5 49 25
    printTest 'repeatChar \# 10' "$(repeatChar \# 10)"
    printTest 'repeatChar - 7' "$(repeatChar - 7)"
    printTest 'stringLength "hello"' "$(stringLength "hello")"
    printTest 'substring "hello world" 6 3' "$(substring "hello world" 6 3)"
    printTest 'removePrefix "hello world" "he"' "$(removePrefix "hello world" "he")"
    printTest 'removeLongestPrefix "hello world" "h*w"' "$(removeLongestPrefix "hello world" "h*w")"
    printTest 'removeSuffix "hello_world.txt" ".txt"' "$(removeSuffix "hello_world.txt" ".txt")"
    printTest 'removeLongestSuffix "hello_world.tar.gz" ".*"' "$(removeLongestSuffix "hello_world.tar.gz" ".*")"
    printTest 'replaceFirst "hello world" "l" "L"' "$(replaceFirst "hello world" "l" "L")"
    printTest 'replaceAll "banana" "a" "o"' "$(replaceAll "banana" "a" "o")"
    printTest 'toLower "HeLLo WoRLD"' "$(toLower "HeLLo WoRLD")"
    printTest 'toLowerFirst "HELLO"' "$(toLowerFirst "HELLO")"
    printTest 'toUpper "hello"' "$(toUpper "hello")"
    printTest 'toUpperFirst "hello"' "$(toUpperFirst "hello")"
    printTest 'toggleCase "HeLLo"' "$(toggleCase "HeLLo")"
    printTest 'toggleCaseFirst "hello"' "$(toggleCaseFirst "hello")"
    printTest 'toggleCaseFirst "HELLO"' "$(toggleCaseFirst "HELLO")"
    printTest 'matchPattern "hello123" "h.*o"' "$(matchPattern "hello123" "h.*o")"
    printTest 'matchRegex "hello123" "[0-9]+"' "$(matchRegex "hello123" "[0-9]+")"
    printTest 'getAllRegexMatches "test123abc456def" "[0-9]+"' "$(getAllRegexMatches "test123abc456def" "[0-9]+" ',')"
    printTest 'defaultIfEmpty "" "default value"' "$(defaultIfEmpty "" "default value")"
    printTest 'defaultIfEmpty "actual" "default value"' "$(defaultIfEmpty "actual" "default value")"
    unset var
    printTest 'unset var ; defaultIfUnset $var "default"' "$(defaultIfUnset $var "default")"
    var="set"
    printTest 'var="set" ; defaultIfUnset $var "default"' "$(defaultIfUnset $var "default")"
    printTest 'concat "hello" " " "world" "!"' "$(concat "hello" " " "world" "!")"
    printTest 'join "," apple banana cherry' "$(join "," apple banana cherry)"
    printTest 'trim "   hello world   "' "$(trim "   hello world   ")" last
    #printTest '' "$()"
    ftDividerBot 5 49 25
    ftInfo "Farewell" 83 r
    ftBotLine 83
}




# Print a test into a table
printTestAscii() {
    tcount=$(( tcount + 1))
    #printf "| %-47s | %-23s |\n" "$1" "$2"
    tableRowItem "$tcount" 3 r
    tableRowItem "$1" 47 l
    tableRowEnd "$2" 23 l
}


# Test run examples verbose
runExamplesAscii() {
    tableLine 83
    tableInfo "RUNNING FUNCTION TESTS" 83 c
    tableDivider 5 49 25
    printTestAscii 'repeatChar \# 10' "$(repeatChar \# 10)"
    printTestAscii 'repeatChar - 7' "$(repeatChar - 7)"
    printTestAscii 'stringLength "hello"' "$(stringLength "hello")"
    printTestAscii 'substring "hello world" 6 3' "$(substring "hello world" 6 3)"
    printTestAscii 'removePrefix "hello world" "he"' "$(removePrefix "hello world" "he")"
    printTestAscii 'removeLongestPrefix "hello world" "h*w"' "$(removeLongestPrefix "hello world" "h*w")"
    printTestAscii 'removeSuffix "hello_world.txt" ".txt"' "$(removeSuffix "hello_world.txt" ".txt")"
    printTestAscii 'removeLongestSuffix "hello_world.tar.gz" ".*"' "$(removeLongestSuffix "hello_world.tar.gz" ".*")"
    printTestAscii 'replaceFirst "hello world" "l" "L"' "$(replaceFirst "hello world" "l" "L")"
    printTestAscii 'replaceAll "banana" "a" "o"' "$(replaceAll "banana" "a" "o")"
    printTestAscii 'toLower "HeLLo WoRLD"' "$(toLower "HeLLo WoRLD")"
    printTestAscii 'toLowerFirst "HELLO"' "$(toLowerFirst "HELLO")"
    printTestAscii 'toUpper "hello"' "$(toUpper "hello")"
    printTestAscii 'toUpperFirst "hello"' "$(toUpperFirst "hello")"
    printTestAscii 'toggleCase "HeLLo"' "$(toggleCase "HeLLo")"
    printTestAscii 'toggleCaseFirst "hello"' "$(toggleCaseFirst "hello")"
    printTestAscii 'toggleCaseFirst "HELLO"' "$(toggleCaseFirst "HELLO")"
    printTestAscii 'matchPattern "hello123" "h.*o"' "$(matchPattern "hello123" "h.*o")"
    printTestAscii 'matchRegex "hello123" "[0-9]+"' "$(matchRegex "hello123" "[0-9]+")"
    printTestAscii 'getAllRegexMatches "test123abc456def" "[0-9]+"' "$(getAllRegexMatches "test123abc456def" "[0-9]+" ',')"
    printTestAscii 'defaultIfEmpty "" "default value"' "$(defaultIfEmpty "" "default value")"
    printTestAscii 'defaultIfEmpty "actual" "default value"' "$(defaultIfEmpty "actual" "default value")"
    unset var
    printTestAscii 'unset var ; defaultIfUnset $var "default"' "$(defaultIfUnset $var "default")"
    var="set"
    printTestAscii 'var="set" ; defaultIfUnset $var "default"' "$(defaultIfUnset $var "default")"
    printTestAscii 'concat "hello" " " "world" "!"' "$(concat "hello" " " "world" "!")"
    printTestAscii 'join "," apple banana cherry' "$(join "," apple banana cherry)"
    printTestAscii 'trim "   hello world   "' "$(trim "   hello world   ")"
    #printTestAscii '' "$()"
    tableDivider 5 49 25
    tableInfo "Farewell" 83 r
    tableLine 83
}


# Test that only print results, include error tests (disabled)
oldExamples() {
    echo && repeatChar \# 10                               # ##########
    echo && repeatChar - 7                                 # -------
    echo && stringLength "hello"                           # 5
    echo && substring "hello world" 6 3                    # wor
    echo && removePrefix "hello world" "he"                # llo world
    echo && removeLongestPrefix "hello world" "h*w"        # orld
    echo && removeSuffix "hello_world.txt" ".txt"          # hello_world
    echo && removeLongestSuffix "hello_world.tar.gz" ".*"  # hello_world
    echo && replaceFirst "hello world" "l" "L"             # heLlo world
    echo && replaceAll "banana" "a" "o"                    # bonono
    echo && toLower "HeLLo WoRLD"                          # hello world
    echo && toLowerFirst "HELLO"                           # hELLO
    echo && toUpper "hello"                                # HELLO
    echo && toUpperFirst "hello"                           # Hello
    echo && toggleCase "HeLLo"                             # hEllO
    echo && toggleCaseFirst "hello"                        # Hello
    echo && toggleCaseFirst "HELLO"                        # hELLO
    echo && matchPattern "hello123" "h.*o"                 # hello
    echo && matchRegex "hello123" "[0-9]+"                 # 123
    echo && getAllRegexMatches "test123abc456def" "[0-9]+" # 123,456
    echo && defaultIfEmpty "" "default value"              # default value
    echo && defaultIfEmpty "actual" "default value"        # actual
    unset var
    echo && defaultIfUnset $var "default"                  # default
    var="set"
    echo && defaultIfUnset $var "default"                  # set
    echo && errorIfEmpty "valid" "Error message"           # valid
    #echo && errorIfEmpty "" "Value cannot be empty"       # bash: 1: Value cannot be empty
    unset var
    #echo && errorIfUnset $var "Variable not set"          # bash: var: Variable not set
    var="set"
    echo && errorIfUnset $var "Variable not set"           # set
    echo && concat "hello" "  " "world"                    # hello world
    echo && join "," apple banana cherry                   # apple,banana,cherry
    echo && trim "   hello world   "                       # hello world
    echo
}


# Run examples
#oldExamples

tcount=0
#runExamplesAscii

tcount=0
runExamples

runTestTableTests
