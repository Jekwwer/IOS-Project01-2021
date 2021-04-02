#!/bin/bash

function test() {
  if [[ "$result" == "$expected" ]]; then
    echo "  Test passed!"
  else
    echo "  Test failed!"
    exit
  fi
}

function return_value_test() {
  if ! [ $1 -eq $2 ]; then
    echo "  Wrong return value"
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

echo "Test 15"
echo "Test \"graph-pos with user WIDTH\""
  result=$(./tradelog.sh -w 6 graph-pos my-stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test15")
  test

echo ""
echo "Tests \"'-a' option filtering\""
echo "Test 16"
  result=$(./tradelog.sh -a "2021-07-29 21:18:18" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test16")
  test

echo "Test 17"
  result=$(./tradelog.sh -a "2021-07-29 21:18:00" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test17")
  test

echo ""
echo "Tests \"'-b' option filtering\""
echo "Test 18"
  result=$(./tradelog.sh -b "2021-07-29 21:18:18" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test18")
  test

echo "Test 19"
  result=$(./tradelog.sh -b "2021-07-29 21:18:20" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test19")
  test

echo ""
echo "Tests \"'-a -b' options filtering\""
echo "Test 20"
  result=$(./tradelog.sh -a "2021-07-29 19:02:42" -b "2021-07-29 22:11:05" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test20")
  test

echo "Test 21"
  result=$(./tradelog.sh -a "2021-07-29 22:11:05" -b "2021-07-29 19:02:42" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test21")
  test

echo "Test 22"
  result=$(./tradelog.sh -a "2021-07-29 19:02:42" -b "2021-07-29 19:02:42" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test22")
  test

echo ""
echo "Tests \"'-w' bad arguments\""
echo "Test 23"
  result=$(./tradelog.sh -w graph-pos my-stock-2.log 2>&1)
  expected="Error: WIDTH must be a positive integer"
  return_value_test 1 1
  test

echo "Test 24"
  result=$(./tradelog.sh -w -5 graph-pos my-stock-2.log 2>&1)
  expected="Error: WIDTH must be a positive integer"
  return_value_test 1 1
  test

echo "Test 25"
  result=$(./tradelog.sh -w -5.5 graph-pos my-stock-2.log 2>&1)
  expected="Error: WIDTH must be a positive integer"
  return_value_test 1 1
  test

echo "Test 26"
  result=$(./tradelog.sh -w -1 graph-pos my-stock-2.log 2>&1)
  expected="Error: WIDTH must be a positive integer"
  return_value_test 1 1
  test

echo "Test 27"
  result=$(./tradelog.sh -w 0 graph-pos my-stock-2.log 2>&1)
  expected="Error: WIDTH must be a positive integer"
  return_value_test 1 1
  test

echo "Test 28"
  result=$(./tradelog.sh -w 1 graph-pos my-stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test28")
  return_value_test 1 1
  test

echo "Test 29"
  result=$(./tradelog.sh -w 1.5 graph-pos my-stock-2.log 2>&1)
  expected="Error: WIDTH must be a positive integer"
  return_value_test 1 1
  test

echo "Test 30"
  result=$(./tradelog.sh -w 6 -w 5 graph-pos my-stock-2.log 2>&1)
  expected="Error: option '-w' must occur only once"
  return_value_test 1 1
  test

echo "Test 31"
  result=$(./tradelog.sh -w 6 -w 5.5 graph-pos my-stock-2.log 2>&1)
  expected="Error: option '-w' must occur only once"
  return_value_test 1 1
  test

echo "Test 32"
  result=$(./tradelog.sh -w 6 -w graph-pos my-stock-2.log 2>&1)
  expected="Error: option '-w' must occur only once"
  return_value_test 1 1
  test

echo "Test 33"
  result=$(./tradelog.sh -w 34.69 -w graph-pos my-stock-2.log 2>&1)
  expected="Error: WIDTH must be a positive integer"
  return_value_test 1 1
  test

echo ""
echo "Tests \"Multiple files\""
echo "Test 34.1"
  result=$(./tradelog.sh last-price my-stock-3.log my-stock-4.log)
  expected=$(cat "Control_Tests_Outputs/test34")
  test

echo "Test 34.2"
  result=$(./tradelog.sh last-price my-stock-4.log my-stock-3.log)
  expected=$(cat "Control_Tests_Outputs/test34")
  test

echo "Test #35.1"
  result=$(./tradelog.sh -t CVX stock-4.log.gz my-stock-5.log | head -n 3)
  expected=$(cat "Control_Tests_Outputs/test35_1")
  test

echo "Test #35.2"
  result=$(./tradelog.sh -t CVX my-stock-5.log stock-4.log.gz | head -n 3)
  expected=$(cat "Control_Tests_Outputs/test35_2")
  test

echo "Test #36.1"
  result=$(./tradelog.sh -t CVX stock-4.log.gz my-stock-5.log my-stock-6.log | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36_1")
  test

echo "Test #36.2"
  result=$(./tradelog.sh -t CVX stock-4.log.gz my-stock-6.log my-stock-5.log | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36_2")
  test

echo "Test #36.3"
  result=$(./tradelog.sh -t CVX my-stock-5.log stock-4.log.gz my-stock-6.log | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36_3")
  test

echo "Test #36.4"
  result=$(./tradelog.sh -t CVX my-stock-6.log stock-4.log.gz my-stock-5.log | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36_4")
  test

echo "Test #36.5"
  result=$(./tradelog.sh -t CVX my-stock-5.log my-stock-6.log stock-4.log.gz | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36")
  test

echo "Test #36.6"
  result=$(./tradelog.sh -t CVX my-stock-6.log my-stock-5.log stock-4.log.gz | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36")
  test

echo ""
echo "Tests \"bad options\""
echo "Test 37"
  result=$(./tradelog.sh -r ratata -t AAAA my-stock-2.log 2>&1)
  expected="Error: Option doesn't exist"
  return_value_test 1 1
  test

echo "Test 38"
  result=$(./tradelog.sh -t AAAA -y ayaya my-stock-2.log 2>&1)
  expected="Error: Option doesn't exist"
  return_value_test 1 1
  test

echo "Test 39"
  result=$(./tradelog.sh - my-stock-2.log 2>&1)
  expected="Error: Option doesn't exist"
  return_value_test 1 1
  test
