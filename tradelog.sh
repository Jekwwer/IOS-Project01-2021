#!/bin/bash

## VARIABLES ##
# Some variables exports for correct script working
export POSIXLY_CORRECT=yes
export LC_NUMERIC=en_US.UTF-8

# Some variables for storing arguments
TICKERS=""
LOG_FILE=""
STDINPUT=""

TICK=0
PROF=0

## FUNCTIONS ##

# Function of printing help message for user
function print_help() {
  echo "help" #TODO
}

# Function of printing by tickers, which are given by user
function print_by_tickers() {
  ARRAY_OF_TICKETS=($TICKERS)
  awk -v t="${ARRAY_OF_TICKETS[*]}" -F ';' '
  BEGIN { n=split(t,list," "); for (i=1;i<=n;i++) tickers[list[i]] }
  $2 in tickers {print}' $1
}

# Function of printing the list of tickets
function list_tick() {
  awk -F';' '{print $2}' $LOG_FILE | sort -u
}

function profit() {
  awk -F';' 'BEGIN {profit = 0}
  {if ($3 == "buy")
      profit = profit - ($4 * $6)
   else
      profit = profit + ($4 * $6)}
  END {printf("%.2f\n", profit)}' $1
}

COMMAND_SECVENCE=()

## START OF THE PROGRAM
# OPTIONS PROCESSING
while getopts :ha:b:t:w: o; do
  case "$o" in
  h)
    print_help
    ;;
  a) #TODO
    ;;
  b) #TODO
    ;;
  t)
    TICKERS="$TICKERS $OPTARG"
    if ! [[ " ${COMMAND_SECVENCE[*]} " =~ " print_by_tickers " ]]; then
      COMMAND_SECVENCE+=("print_by_tickers")
    fi
    ;;
  w) #TODO
    ;;
  *)
    #TODO
    ;;
  esac
done

# ARGUMENTS PROCESSING
((OPTIND--))
shift $OPTIND
for i in $*; do
  if [[ $1 == "list-tick" ]]; then
    TICK=1
  elif [ $1 == "profit" ]; then
    PROF=1
  else
    LOG_FILE=$1
  fi
  shift
done

# COMMAND PROCESSING
if [[ "$TICKERS" != "" ]]; then
  if [[ $TICK -eq 1 ]]; then
    print_by_tickers $LOG_FILE | list_tick $STDINPUT
  elif [[ $PROF -eq 1 ]]; then
    print_by_tickers $LOG_FILE | profit $STDINPUT
  else
    print_by_tickers $LOG_FILE
  fi
else
  if [[ $TICK -eq 1 ]]; then
    list_tick $LOG_FILE
  elif [[ $PROF -eq 1 ]]; then
    profit $LOG_FILE
  else
    while read A; do
    echo $A
    done
  fi
fi

## END OF THE PROGRAM