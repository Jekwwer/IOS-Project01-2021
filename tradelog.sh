#!/bin/bash

## VARIABLES ##
# Some variables exports for correct script working
export POSIXLY_CORRECT=yes
export LC_ALL=C

# Some variables for storing arguments
TICKERS=""
LOG_FILE=""

# Default values for option variables
WIDTH=-1

# Default values for command-flag variables
IS_LIST_TICK=0
IS_PROFIT=0
IS_POS=0
IS_LAST_PRICE=0
IS_HIST_ORD=0
IS_GRAPH_POS=0
IS_WIDTH=0

## FUNCTIONS ##
# Function that prints help message for the user
function print_help() {
  echo "Usage: tradelog [-h|--help] [FILTER] [COMMAND] [LOG FILES]"
  echo "Shows stocks information(analyzing, statistics, filtering) by user requirements"
  echo ""
  echo "FILTERS"
  echo "  -a DATETIME       process records AFTER the given date(without it)"
  echo "                      DATETIME is given in the format YYYY-MM-DD HH:MM:SS"
  echo "  -b DATETIME       process records BEFORE given date(without it)"
  echo "                      DATETIME is given in the format YYYY-MM-DD HH:MM:SS"
  echo "  -t TICKER         process records with given TICKER"
  echo "                      TICKER is a string without a semicolon(;) and white characters"
  echo "                      if the filter acquires multiple times process"
  echo "                      records with the given TICKERS"
  echo "  -w WIDTH          set the maximum width of the longest line in graphs "
  echo "  -h --help         display this help message and exit"
  echo ""
  echo "COMMANDS"
  echo "  list_tick         print a list of tickers found in the LOG"
  echo "  profit            print total gain"
  echo "  pos               print a list of obtained stocks in descending order by value"
  echo "  last-price        print the last known price for each ticker"
  echo "  hist-ord          print a histogram of the transaction number for each ticker"
  echo "  graph-pos         print a graph of obtained stocks values for each ticker"
  exit
}

# Function that processes input
function process_the_input() {
  if [ "$LOG_FILE" != "" ]; then
    if [[ "$LOG_FILE" == *".gz"* ]]; then
      gzip -dc "$LOG_FILE" # TODO what if script get ,log and ,gz files
    else
      cat "$LOG_FILE"
    fi
  else
    cat
  fi | filter_the_input
}

# Function that filters input
function filter_the_input() {
  # -a -b -t
  if [ "$BEFORE_TIME" != "" ] && [ "$AFTER_TIME" != "" ] && [ "$TICKERS" != "" ]; then
    print_by_tickers | print_before_time | print_after_time
  # -a -b
  elif [ "$BEFORE_TIME" != "" ] && [ "$AFTER_TIME" != "" ]; then
    print_before_time | print_after_time
  # -b -t
  elif [ "$BEFORE_TIME" != "" ] && [ "$TICKERS" != "" ]; then
    print_by_tickers | print_before_time
  # -a -t
  elif [ "$AFTER_TIME" != "" ] && [ "$TICKERS" != "" ]; then
    print_by_tickers | print_after_time
  # -b
  elif [ "$BEFORE_TIME" != "" ]; then
    print_before_time
  # -a
  elif [ "$AFTER_TIME" != "" ]; then
    print_after_time
  # -t
  elif [ "$TICKERS" != "" ]; then
    print_by_tickers
  # none
  else
    cat
  fi
}

# Function that processes entered by user commands into sequence of operations
function process_the_commands() {
  if [ $IS_LIST_TICK -eq 1 ]; then
    list_tick
  elif [ $IS_PROFIT -eq 1 ]; then
    profit
  elif [ $IS_POS -eq 1 ]; then
    pos | sort -k2nr -t:
  elif [ $IS_LAST_PRICE -eq 1 ]; then
    last_price
  elif [ $IS_HIST_ORD -eq 1 ]; then
    hist_ord
  elif [ $IS_GRAPH_POS -eq 1 ]; then
    graph_pos
  else
    cat
  fi
}

function error_exit() {
  echo "$1" 1>&2
  exit 1
}

# Function that prints records after date time given by user
function print_after_time() {
  awk -v at="$AFTER_TIME" -F';' '
  {if (at < $1)
    print $0}'
}

# Function that prints records before date time given by user
function print_before_time() {
  awk -v bt="$BEFORE_TIME" -F';' '
  {if (bt > $1)
    print $0}'
}

# Function that prints records by tickers, which are given by user
function print_by_tickers() {
  ARRAY_OF_TICKERS=("$TICKERS")
  awk -v t="${ARRAY_OF_TICKERS[*]}" -F';' '
  BEGIN {
  n = split(t,array," ");
  for (i = 1; i <= n; i++)
    tickers[array[i]]
  }
  $2 in tickers {print}'
}

# Function that prints the list of tickers
function list_tick() {
  echo "$INPUT" | awk -F';' '{print $2}' | sort -u
}

# Function that prints profit of deals
function profit() {
  awk -F';' '
  BEGIN {profit = 0}
  {if ($3 == "buy")
    profit = profit - ($4 * $6)
  else
    profit = profit + ($4 * $6)}
  END {printf("%.2f\n", profit)}'
}

# TODO REFACTORING
# Function that finds the longest num in 'pos' output and returns its length
function get_length_of_the_longest_num_pos() {
  ARRAY_OF_TICKERS=($(list_tick))
  MAX_LENGTH=0
  for TICKER in ${ARRAY_OF_TICKERS[*]}; do
    NUM=$(echo "$INPUT" | awk -v ticker="$TICKER" -F';' '
    BEGIN {num = 0; len = 12}
    {if ($2 == ticker && $3 == "buy")
      num = num + $6
    if ($2 == ticker && $3 == "sell")
      num = num - $6
    if ($2 == ticker)
      last = $4}
    END {printf("%.2f", last * num)}')
    if [ ${#NUM} -gt $MAX_LENGTH ]; then
      MAX_LENGTH=${#NUM}
    fi
  done
  echo "$MAX_LENGTH"
}

# Functions that prints list of obtained stocks in descending order by value
function pos() {
  COLUMN_WIDTH=$(get_length_of_the_longest_num_pos)
  ARRAY_OF_TICKERS=($(list_tick))
  for TICKER in ${ARRAY_OF_TICKERS[*]}; do
    echo "$INPUT" | awk -v ticker="$TICKER" -v len="$COLUMN_WIDTH" -F';' '
    BEGIN {num = 0; len++}
    {if ($2 == ticker && $3 == "buy")
      num = num + $6
    if ($2 == ticker && $3 == "sell")
      num = num - $6
    if ($2 == ticker)
      last = $4}
    END {printf("%-10s:%*.2f\n", ticker, len, last * num)}'
  done
}

# TODO REFACTORING
# Function that finds the longest num in 'last_price' output and returns its length
function get_length_of_the_longest_num_lp() {
  ARRAY_OF_TICKERS=($(list_tick))
  MAX_LENGTH=0
  for TICKER in ${ARRAY_OF_TICKERS[*]}; do
    NUM=$(echo "$INPUT" | awk -v ticker="$TICKER" -F';' '
    BEGIN {last = 0}
    {if ($2 == ticker)
      last = $4}
    END {printf("%.2f", last)}')
    if [ ${#NUM} -gt $MAX_LENGTH ]; then
      MAX_LENGTH=${#NUM}
    fi
  done
  echo "$MAX_LENGTH"
}

# Function that prints last price of a stock of each ticker
function last_price() {
  COLUMN_WIDTH=$(get_length_of_the_longest_num_lp)
  ARRAY_OF_TICKERS=($(list_tick))
  for TICKER in ${ARRAY_OF_TICKERS[*]}; do
    echo "$INPUT" | awk -v ticker="$TICKER" -v len="$COLUMN_WIDTH" -F';' '
    BEGIN {last = 0; len++}
    {if ($2 == ticker)
      last = $4}
    END {printf("%-10s:%*.2f\n", ticker, len, last)}'
  done
}

# Function that finds the maximum number of transactions by each ticker
function find_max_num_of_transactions() {
  ARRAY_OF_TICKERS=($(list_tick))
  MAX_NUM_OF_TRNSC=0
  for TICKER in ${ARRAY_OF_TICKERS[*]}; do
    tmp=$(echo "$INPUT" | awk -v ticker="$TICKER" -F';' '
    BEGIN {num = 0}
    {if ($2 == ticker)
      num++}
    END {print num}')
    if [ "$tmp" -gt $MAX_NUM_OF_TRNSC ]; then
      MAX_NUM_OF_TRNSC=$tmp
    fi
  done
}

# Function that prints a histogram of the number of transactions according to the ticker
# with maximum width given by user (if any)
function hist_ord() {
  # Setting the width
  if [ $WIDTH -eq -1 ]; then # if user doesn't set WIDTH
    MAX_NUM_OF_TRNSC=$WIDTH
  else
    find_max_num_of_transactions
  fi
  # Printing the histogram
  ARRAY_OF_TICKERS=($(list_tick))
  for TICKER in ${ARRAY_OF_TICKERS[*]}; do
    echo "$INPUT" | awk -v ticker="$TICKER" -v max=$MAX_NUM_OF_TRNSC -v width=$WIDTH -F';' '
    BEGIN {num = 0}
    {if ($2 == ticker)
      num++}
    END {
      {printf("%-10s: ", ticker)
      for (i = 1; i <= num/(max/width); i++)
        printf("#")
      printf("\n")}}'
  done
}

# Function that finds the largest absolute value from output of 'pos' function
function find_largest_abs_value_of_pos() {
  ABS_VALUE=$(awk -F':' '
    BEGIN {num = 0; max = 0}
    {if ($2 >= 0)
      num = $2
    else
      num = -$2
    if (num > max)
      max = num}
    END {printf("%.2f\n", max)}')

  echo "$ABS_VALUE"
}

# Function that prints a graph of obtained stocks values
function graph_pos() {
  ABS_VALUE=$(pos | find_largest_abs_value_of_pos)
  # Setting the width
  if [ $WIDTH -eq -1 ]; then # if user doesn't set WIDTH
    WIDTH=$(awk -v max="$ABS_VALUE" 'BEGIN{print max/1000}' "$INPUT")
  fi
  # Printing the graph
  pos | awk -v max="$ABS_VALUE" -v width="$WIDTH" -F':' '
    {printf("%s:", $1)
    if ($2 >= 0)
    {for (i = 1; i <= $2/(max/width); i++){
        if (i == 1)
          printf(" ")
        printf("#")}
      printf("\n")}
    else
      {for (i = -1; i >= $2/(max/width); i--){
        if (i == -1)
          printf(" ")
        printf("!")}
      printf("\n")}}'
}

## START OF THE PROGRAM
# OPTIONS PROCESSING
while getopts :ha:b:t:w: o; do
  case "$o" in
  h)
    print_help
    ;;
  a)
    AFTER_TIME="$OPTARG"
    ;;
  b)
    BEFORE_TIME="$OPTARG"
    ;;
  t)
    TICKERS="$TICKERS $OPTARG"
    ;;
  w)
    # Argument checking
    if [ $IS_WIDTH -eq 0 ]; then
      IS_WIDTH=1
      WIDTH="$OPTARG"
      WIDTH_CHECK='^[0-9]+$'
      # if WIDTH is a positive integer
      if ! [[ $WIDTH =~ $WIDTH_CHECK ]] || [ $WIDTH -le 0 ]; then
        error_exit "Error: WIDTH must be a positive integer"
      fi
    else
      error_exit "Error: option '-w' must occur only once"
    fi
    ;;
  *)
    if [[ "$*" != *"--help"* ]]; then
      echo "ERROR: Option doesn't exist" #TODO
      exit
    fi
    ;;
  esac
done

# ARGUMENTS PROCESSING
((OPTIND--))
shift $OPTIND
for _ in $*; do
  if [ "$1" == "list-tick" ]; then
    IS_LIST_TICK=1
  elif [ "$1" == "profit" ]; then
    IS_PROFIT=1
  elif [ "$1" == "pos" ]; then
    IS_POS=1
  elif [ "$1" == "last-price" ]; then
    IS_LAST_PRICE=1
  elif [ "$1" == "hist-ord" ]; then
    IS_HIST_ORD=1
  elif [ "$1" == "graph-pos" ]; then
    IS_GRAPH_POS=1
  elif [ "$1" == "--help" ]; then
    print_help
  else
    LOG_FILE=$1
  fi
  shift
done

#INPUT PROCESSING
INPUT="$(process_the_input)"

# RESULT PROCESSING
echo "$INPUT" | process_the_commands

## END OF THE PROGRAM
