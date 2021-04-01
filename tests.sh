#!/bin/bash

function test() {
  if [[ "$result" == "$expected" ]]; then
    echo "Test passed!"
  else
    echo "Test failed!"
    exit
  fi
}

echo "Test #1"
  result=$(cat "stock-2.log" | head -n 5 | ./tradelog.sh)
  expected=$(cat "Control_Tests_Outputs/test01")
  test

echo "Test #2"
  result=$(./tradelog.sh -t TSLA -t V stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test02")
  test

echo "Test #3"
  result=$(./tradelog.sh -t CVX stock-4.log.gz | head -n 3)
  expected=$(cat "Control_Tests_Outputs/test03")
  test