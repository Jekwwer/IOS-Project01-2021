#!/bin/bash

export POSIXLY_CORRECT=yes
export LC_NUMERIC=en_US.UTF-8

TICKERS=""
LOG_FILE=""

function print_help() {
  echo "help" #TODO
}

function print_by_tickers() {
  ARRAY_OF_TICKETS=($TICKERS)
  awk -v t="${ARRAY_OF_TICKETS[*]}" -F ';' '
  BEGIN { n=split(t,list," "); for (i=1;i<=n;i++) tickers[list[i]] }
    $2 in tickers' "$LOG_FILE"
}

function list_tick() {
  if [[ $LOG_FILE != "" ]]; then
    awk -F';' '{print $2}' $LOG_FILE | sort -u
  fi
}

# ARGUMENTS PROCESSING
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
    ;;
  w) #TODO
    ;;
  *)
    #TODO
    ;;
  esac
done

((OPTIND--))
shift $OPTIND
for i in $*; do
  echo "1"
  if [[ $1 == "list-tick" ]]; then
    TICK=1
  else
    LOG_FILE=$1
  fi
  shift
done

if [[ $TICK -eq 1 ]]; then
  list_tick
fi

if [[ "$TICKERS" != "" ]]; then
  print_by_tickers
fi

if [[ "$LOG_FILE" == "" ]] && [[ $TICKERS == "" ]]; then
  while read A; do
    echo $A
  done
fi
