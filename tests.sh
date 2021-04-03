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
  return_value_test 0 0
  test

echo "Test #02"
  result=$(./tradelog.sh -t TSLA -t V stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test02")
  return_value_test 0 0
  test

echo "Test #03"
  result=$(./tradelog.sh -t CVX stock-4.log.gz | head -n 3)
  expected=$(cat "Control_Tests_Outputs/test03")
  return_value_test 0 0
  test

echo "Test #04"
  result=$(./tradelog.sh list-tick stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test04")
  return_value_test 0 0
  test

echo "Test #05"
  result=$(./tradelog.sh profit stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test05")
  return_value_test 0 0
  test

echo "Test #06"
  result=$(./tradelog.sh -t TSM -t PYPL profit stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test06")
  return_value_test 0 0
  test

echo "Test #07"
  result=$(./tradelog.sh pos stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test07")
  return_value_test 0 0
  test

echo "Test #08"
  result=$(./tradelog.sh -t TSM -t PYPL -t AAPL pos stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test08")
  return_value_test 0 0
  test

echo "Test #09"
  result=$(./tradelog.sh last-price stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test09")
  return_value_test 0 0
  test

echo "Test #10"
  result=$(./tradelog.sh hist-ord stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test10")
  return_value_test 0 0
  test

echo "Test #11"
  result=$(./tradelog.sh -w 100 graph-pos stock-6.log)
  expected=$(cat "Control_Tests_Outputs/test11")
  return_value_test 0 0
  test

echo "Test #12"
  result=$(./tradelog.sh -w 10 -t FB -t JNJ -t WMT graph-pos stock-6.log)
  expected=$(cat "Control_Tests_Outputs/test12")
  return_value_test 0 0
  test

echo "Test #13"
  result=$(cat /dev/null | ./tradelog.sh profit)
  expected=$(cat "Control_Tests_Outputs/test13")
  return_value_test 0 0
  test

echo ""
echo "My own tests"
echo "Test 14"
echo "Test \"graph-pos with default WIDTH\""
  result=$(./tradelog.sh graph-pos my-stock-1.log)
  expected=$(cat "Control_Tests_Outputs/test14")
  return_value_test 0 0
  test

echo "Test 15"
echo "Test \"graph-pos with user WIDTH\""
  result=$(./tradelog.sh -w 6 graph-pos my-stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test15")
  return_value_test 0 0
  test

echo ""
echo "Tests \"'-a' option filtering\""
echo "Test 16"
  result=$(./tradelog.sh -a "2021-07-29 21:18:18" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test16")
  return_value_test 0 0
  test

echo "Test 17"
  result=$(./tradelog.sh -a "2021-07-29 21:18:00" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test17")
  return_value_test 0 0
  test

echo ""
echo "Tests \"'-b' option filtering\""
echo "Test 18"
  result=$(./tradelog.sh -b "2021-07-29 21:18:18" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test18")
  return_value_test 0 0
  test

echo "Test 19"
  result=$(./tradelog.sh -b "2021-07-29 21:18:20" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test19")
  return_value_test 0 0
  test

echo ""
echo "Tests \"'-a -b' options filtering\""
echo "Test 20"
  result=$(./tradelog.sh -a "2021-07-29 19:02:42" -b "2021-07-29 22:11:05" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test20")
  return_value_test 0 0
  test

echo "Test 21"
  result=$(./tradelog.sh -a "2021-07-29 22:11:05" -b "2021-07-29 19:02:42" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test21")
  return_value_test 0 0
  test

echo "Test 22"
  result=$(./tradelog.sh -a "2021-07-29 19:02:42" -b "2021-07-29 19:02:42" stock-2.log)
  expected=$(cat "Control_Tests_Outputs/test22")
  return_value_test 0 0
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
  return_value_test 0 0
  test

echo "Test 34.2"
  result=$(./tradelog.sh last-price my-stock-4.log my-stock-3.log)
  expected=$(cat "Control_Tests_Outputs/test34")
  return_value_test 0 0
  test

echo "Test #35.1"
  result=$(./tradelog.sh -t CVX stock-4.log.gz my-stock-5.log | head -n 3)
  expected=$(cat "Control_Tests_Outputs/test35_1")
  return_value_test 0 0
  test

echo "Test #35.2"
  result=$(./tradelog.sh -t CVX my-stock-5.log stock-4.log.gz | head -n 3)
  expected=$(cat "Control_Tests_Outputs/test35_2")
  return_value_test 0 0
  test

echo "Test #36.1"
  result=$(./tradelog.sh -t CVX stock-4.log.gz my-stock-5.log my-stock-6.log | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36_1")
  return_value_test 0 0
  test

echo "Test #36.2"
  result=$(./tradelog.sh -t CVX stock-4.log.gz my-stock-6.log my-stock-5.log | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36_2")
  return_value_test 0 0
  test

echo "Test #36.3"
  result=$(./tradelog.sh -t CVX my-stock-5.log stock-4.log.gz my-stock-6.log | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36_3")
  return_value_test 0 0
  test

echo "Test #36.4"
  result=$(./tradelog.sh -t CVX my-stock-6.log stock-4.log.gz my-stock-5.log | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36_4")
  return_value_test 0 0
  test

echo "Test #36.5"
  result=$(./tradelog.sh -t CVX my-stock-5.log my-stock-6.log stock-4.log.gz | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36_5")
  return_value_test 0 0
  test

echo "Test #36.6"
  result=$(./tradelog.sh -t CVX my-stock-6.log my-stock-5.log stock-4.log.gz | head -n 5)
  expected=$(cat "Control_Tests_Outputs/test36_6")
  return_value_test 0 0
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
  expected="Error: input file - doesn't exist"
  return_value_test 1 1
  test

echo ""
echo "Tests \"bad input files\""
echo "Test 40"
  result=$(./tradelog.sh hist-ord not-my-stock-34.log 2>&1)
  expected="Error: input file not-my-stock-34.log doesn't exist"
  return_value_test 1 1
  test

echo "Test 41"
  result=$(./tradelog.sh -t OLOL last-price not-my-stock-69.log.gz 2>&1)
  expected="Error: input file not-my-stock-69.log.gz doesn't exist"
  return_value_test 1 1
  test

echo "Test 42"
  result=$(./tradelog.sh graph-pos my-stock-3.log not-my-stock-34.log 2>&1)
  expected="Error: input file not-my-stock-34.log doesn't exist"
  return_value_test 1 1
  test

echo "Test 43"
  result=$(./tradelog.sh hist-ord my-stock-2.log not-my-stock-69.log.gz 2>&1)
  expected="Error: input file not-my-stock-69.log.gz doesn't exist"
  return_value_test 1 1
  test

echo ""
echo "Tests \"bad DATETIME format\""
echo "Test 44.1"
  result=$(./tradelog.sh -a "2o21-04-01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 44.2"
  result=$(./tradelog.sh -b "2o21-04-01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 45.1"
  result=$(./tradelog.sh -a "2021-0A-01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 45.2"
  result=$(./tradelog.sh -b "2021-0A-01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 46.1"
  result=$(./tradelog.sh -a "2021-04-0! 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 46.2"
  result=$(./tradelog.sh -b "2021-04-0! 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 47.1"
  result=$(./tradelog.sh -a "2021-04-01 1E:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 47.2"
  result=$(./tradelog.sh -b "2021-04-01 1E:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 48.1"
  result=$(./tradelog.sh -a "2021-04-01 13:ET:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 48.2"
  result=$(./tradelog.sh -b "2021-04-01 13:ET:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 49.1"
  result=$(./tradelog.sh -a "2021-04-01 13:ET:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 49.2"
  result=$(./tradelog.sh -b "2021-04-01 13:ET:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 50.1"
  result=$(./tradelog.sh -a "2021-04-01 13:37:EA" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 50.2"
  result=$(./tradelog.sh -b "2021-04-01 13:37:EA" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 51.1"
  result=$(./tradelog.sh -a "21-04-01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 51.2"
  result=$(./tradelog.sh -b "21-04-01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 52.1"
  result=$(./tradelog.sh -a "2021-4-01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 52.2"
  result=$(./tradelog.sh -b "2021-4-01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 53.1"
  result=$(./tradelog.sh -a "2021-04-1 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 53.2"
  result=$(./tradelog.sh -b "2021-04-1 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 54.1"
  result=$(./tradelog.sh -a "2021-04-01 5:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 54.2"
  result=$(./tradelog.sh -b "2021-04-01 5:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

 echo "Test 55.1"
  result=$(./tradelog.sh -a "2021-13-01 13:7:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

 echo "Test 55.2"
  result=$(./tradelog.sh -b "2021-13-01 13:7:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 56.1"
  result=$(./tradelog.sh -a "2021-13-01 13:37:4" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 56.2"
  result=$(./tradelog.sh -b "2021-13-01 13:37:4" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 57.1"
  result=$(./tradelog.sh -a "2021-20-01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 57.2"
  result=$(./tradelog.sh -b "2021-20-01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 58.1"
  result=$(./tradelog.sh -a "2021-04-69 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 58.2"
  result=$(./tradelog.sh -b "2021-04-69 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 59.1"
  result=$(./tradelog.sh -a "2021-12-01 34:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 59.2"
  result=$(./tradelog.sh -b "2021-12-01 34:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 60.1"
  result=$(./tradelog.sh -a "2021-13-01 13:69:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 60.2"
  result=$(./tradelog.sh -a "2021-13-01 13:69:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 61.1"
  result=$(./tradelog.sh -a "2021-13-01 13:37:99" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 61.2"
  result=$(./tradelog.sh -b "2021-13-01 13:37:99" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 62.1"
  result=$(./tradelog.sh -a "2021/13/01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 62.2"
  result=$(./tradelog.sh -b "2021/13/01 13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 63.1"
  result=$(./tradelog.sh -a "2021-13-01 13.37.34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 63.2"
  result=$(./tradelog.sh -b "2021-13-01 13.37.34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 64.1"
  result=$(./tradelog.sh -a "2021-13-01_13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo "Test 64.2"
  result=$(./tradelog.sh -b "2021-13-01_13:37:34" -t AAA list-tick my-stock-2.log 2>&1)
  expected="Error: DATETIME argument is not in format YYYY-MM-DD HH:MM:SS or given invalid time"
  return_value_test 1 1
  test

echo ""
echo "Tests \"bad TICKER format\""
echo "Test 65"
  result=$(./tradelog.sh -t "A A" last-price my-stock-3.log 2>&1)
  expected="Error: TICKER must be a string without a semicolon(;) and white characters"
  return_value_test 1 1
  test

echo "Test 66"
  result=$(./tradelog.sh -t "A;A" last-price my-stock-3.log 2>&1)
  expected="Error: TICKER must be a string without a semicolon(;) and white characters"
  return_value_test 1 1
  test

echo "Test 67"
  result=$(./tradelog.sh -t ";AA" last-price my-stock-3.log 2>&1)
  expected="Error: TICKER must be a string without a semicolon(;) and white characters"
  return_value_test 1 1
  test

echo "Test 68"
  result=$(./tradelog.sh -t " AA" last-price my-stock-3.log 2>&1)
  expected="Error: TICKER must be a string without a semicolon(;) and white characters"
  return_value_test 1 1
  test

echo "Test 69"
  result=$(./tradelog.sh -t "AA;" last-price my-stock-3.log 2>&1)
  expected="Error: TICKER must be a string without a semicolon(;) and white characters"
  return_value_test 1 1
  test

echo "Test 70"
  result=$(./tradelog.sh -t "AA_" last-price my-stock-3.log 2>&1)
  expected="Error: TICKER must be a string without a semicolon(;) and white characters"
  return_value_test 1 1
  test

echo "Test 71"
  result=$(./tradelog.sh -t "AAA" last-price my-stock-3.log 2>&1)
  expected=$(cat "Control_Tests_Outputs/test71")
  return_value_test 0 0
  test

echo ""
echo "Tests \"no argument after an option\""
echo "Test 72"
  result=$(./tradelog.sh -t 2>&1)
  expected="Error: no argument after the -t option"
  return_value_test 1 1
  test

echo "Test 73"
  result=$(./tradelog.sh -a 2>&1)
  expected="Error: no argument after the -a option"
  return_value_test 1 1
  test

echo "Test 74"
  result=$(./tradelog.sh -b 2>&1)
  expected="Error: no argument after the -b option"
  return_value_test 1 1
  test

echo "Test 75"
  result=$(./tradelog.sh -w 2>&1)
  expected="Error: no argument after the -w option"
  return_value_test 1 1
  test