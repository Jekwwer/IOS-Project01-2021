#!/bin/bash

function test() {
  if [[ "$result" == "$expected" ]]; then
    echo "  Test passed!"
  else
    echo "  Test failed!"
    exit
  fi
}

echo "Tests from the project webpage"
echo "Test #01"
  result=$(cat "stock-2.log" | head -n 5 | ./tradelog.sh)
  expected=$(cat "Control_Tests_Outputs/test01")
  test

echo "Test #02"
  result=$(./tradelog.sh -t TSLA -t V stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test02")
  test

echo "Test #03"
  result=$(./tradelog.sh -t CVX stock-4.log.gz | head -n 3)
  expected=$(cat "Control_Tests_Outputs/test03")
  test

echo "Test #04"
  result=$(./tradelog.sh list-tick stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test04")
  test

echo "Test #05"
  result=$(./tradelog.sh profit stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test05")
  test

echo "Test #06"
  result=$(./tradelog.sh -t TSM -t PYPL profit stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test06")
  test

echo "Test #07"
  result=$(./tradelog.sh pos stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test07")
  test

echo "Test #08"
  result=$(./tradelog.sh -t TSM -t PYPL -t AAPL pos stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test08")
  test

echo "Test #09"
  result=$(./tradelog.sh last-price stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test09")
  test

echo "Test #10"
  result=$(./tradelog.sh hist-ord stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test10")
  test

echo "Test #11"
  result=$(./tradelog.sh -w 100 graph-pos stock-6.log)
  expected=$(cat "Control_Tests_Outputs/test11")
  test

echo "Test #12"
  result=$(./tradelog.sh -w 10 -t FB -t JNJ -t WMT graph-pos stock-6.log)
  expected=$(cat "Control_Tests_Outputs/test12")
  test

echo "Test #13"
  result=$(cat /dev/null | ./tradelog.sh profit)
  expected=$(cat "Control_Tests_Outputs/test13")
  test

echo ""
echo "My own tests"
echo "Test 14"
echo "Test \"graph-pos with default WIDTH\""
  result=$(./tradelog.sh graph-pos my-stock-1.log)
  expected=$(cat "Control_Tests_Outputs/test14")
  test

# TODO Add tests for multiple files
# TODO Add tests for -a and -b options
# TODO Add more tests for graph-pos with default WIDTH