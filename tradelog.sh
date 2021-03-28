#!/bin/bash

export POSIXLY_CORRECT=yes
export LC_NUMERIC=en_US.UTF-8

function print_help() {
    echo "help" #TODO
}

while getopts :ha:b:t:w: o
do  case "$o" in
      h)  print_help
        ;;
      a)  #TODO
        ;;
      b)  #TODO
        ;;
      t)  #TODO
        ;;
      w)  #TODO
        ;;
    esac
done
