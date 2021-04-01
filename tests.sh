#!/bin/bash

echo "Test #1"
  result=$(cat "stock-2.log" | head -n 5 | ./tradelog.sh)
  expected=$(cat "Control_Tests_Outputs/test01")

if [[ "$result" == "$expected" ]]; then
  echo "Test passed!"
else
  echo "Test failed!"
  exit 1
fi