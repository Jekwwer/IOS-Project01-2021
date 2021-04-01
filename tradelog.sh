#!/bin/bash

## VARIABLES ##
# Some variables exports for correct script working
export POSIXLY_CORRECT=yes
export LC_NUMERIC=en_US.UTF-8

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

## FUNCTIONS ##
# Function that prints help message for the user
function print_help() {
  echo "Usage: tradelog [-h|--help] [FILTER] [COMMAND] [LOG FILES]"
  echo "Shows stocks information(analyzing, statistics, filtering) by user requirements"
  echo ""
  echo "FILTERS"
  echo "  -a DATETIME       process records AFTER given date(without it)"
  echo "                      DATETIME is given in the format YYYY-MM-DD HH:MM:SS"
  echo "  -b DATETIME       process records BEFORE given date(without it)"
  echo "                      DATETIME is given in the format YYYY-MM-DD HH:MM:SS"
  echo "  -t TICKER         process records with given TICKER"
  echo "                      TICKER is a string without semicolon(:) and white characters"
  echo "                      if the filter acquires multiple times, will be processed"
  echo "                      all records with these TICKERS"
  echo "  -w WIDTH          sets maximum width of the longest line in graphs "
  echo "  -h --help         display this help and exit"
  echo ""
  echo "COMMANDS"
  echo "  list_tick         print records by given TICKERS"
  echo "  profit            print total gain"
  echo "  pos               print list of obtained stocks in descending order by value"
  echo "  last-price        print last price for each ticket"
  echo "  hist-ord          print a histogram of transaction number for each ticket"
  echo "  graph-pos         print a graph of obtained stocks values for each ticket"
  exit
}

# Function that processes input
function process_the_input() {
  if [ "$LOG_FILE" != "" ]; then
    if [[ "$LOG_FILE" == *".gz"* ]]; then
      gzip -dc "$LOG_FILE"
    else
      cat "$LOG_FILE"
    fi
  else
    cat
  fi | filtr_the_input
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
  ARRAY_OF_TICKERS=($TICKERS)
  awk -v t="${ARRAY_OF_TICKERS[*]}" -F';' '
  BEGIN {
  n = split(t,array," ");
  for (i = 1; i <= n; i++)
    tickers[array[i]]
  }
  $2 in tickers {print}'
}

# Function that prints the list of tickets
function list_tick() {
  awk -F';' '{print $2}' $1 | sort -u
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

# Functions that prints list of obtained stocks in descending order by value
function pos() {
  ARRAY_OF_TICKERS=($(list_tick "-"))
  for TICKER in ${ARRAY_OF_TICKERS[*]}; do
    printf "$INPUT\n" | awk -v ticker=$TICKER -F';' '
    BEGIN {num = 0}
    {if ($2 == ticker && $3 == "buy")
      num = num + $6
    if ($2 == ticker && $3 == "sell")
      num = num - $6
    if ($2 == ticker)
      last = $4}
    END {printf("%-10s:%12.2f\n", ticker, last*num)}'
  done
}

# Function that prints last price of a stock of each ticket
function last_price() {
  ARRAY_OF_TICKERS=($(list_tick "-"))
  printf "$INPUT\n" | for TICKER in ${ARRAY_OF_TICKERS[*]}; do
    printf "$INPUT\n" | awk -v ticker=$TICKER -F';' '
    BEGIN {last=0}
    {if ($2 == ticker)
      last = $4}
    END {printf("%-10s:%8.2f\n", ticker, last)}'
  done
}

# Function that finds the maximum number of transactions by each ticket
function find_max_num_of_transactions() {
  ARRAY_OF_TICKERS=($(printf "$INPUT\n" | list_tick "-"))
  MAX_NUM_OF_TRNSC=0
  for TICKER in ${ARRAY_OF_TICKERS[*]}; do
    tmp=$(printf "$INPUT\n" | awk -v ticker=$TICKER -F';' '
    BEGIN {num = 0}
    {if ($2 == ticker)
      num++}
    END {print num}')
    if [ $tmp -gt $MAX_NUM_OF_TRNSC ]; then
      MAX_NUM_OF_TRNSC=$tmp
    fi
  done
}

# Function that prints a histogram of the number of transactions according to the ticker
# with maximum width given by user (if any)
function hist_ord() {
  if [ $WIDTH -eq -1 ]; then # default value
    MAX_NUM_OF_TRNSC=$WIDTH
  else
    find_max_num_of_transactions
  fi

  ARRAY_OF_TICKERS=($(list_tick "-"))
  for TICKER in ${ARRAY_OF_TICKERS[*]}; do
    printf "$INPUT\n" | awk -v ticker="$TICKER" -v max=$MAX_NUM_OF_TRNSC -v width=$WIDTH -F';' '
    BEGIN {num = 0}
    {if ($2 == ticker)
      num++}
    END {
      printf("%-10s: ", ticker)
      for (i = 1; i <= num/(max/width); i++)
        printf("#")
        if (i = num - 1)
          printf("\n")}'
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
  printf "$INPUT\n" | pos | awk -v max="$ABS_VALUE" -v width=$WIDTH -F':' '
    {printf("%s: ", $1)
    if ($2 >= 0)
      {for (i = 1; i <= $2/(max/width); i++)
        printf("#")
      printf("\n")}
    else
      {for (i = -1; i >= $2/(max/width); i--)
        printf("!")
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
    WIDTH="$OPTARG"
    ;;
  *)
    echo "ERROR: Option doesn't exist" #TODO
    exit
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
