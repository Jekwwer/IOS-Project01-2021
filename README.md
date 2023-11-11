# IOS-Project01-2021:

### **Stock Exchange Trading Log Analyzer**

> 🎓 **University**: [VUT FIT](https://www.fit.vut.cz/)
>
> 📚 **Course**: [Operating Systems (IOS)](https://www.fit.vut.cz/study/course/268251/)
>
> 📅 **Academic Year**: 2020/21

---

## 📈 **Assignment Overview**

**Script**: `tradelog` - a shell script for analyzing stock exchange trading logs.

### Features:

- 📊 **list-tick**: List the occurring stock symbols (tickers).
- 💹 **profit**: Display the total profit from closed positions.
- 🏦 **pos**: List the values of current positions, sorted by value.
- 💵 **last-price**: Show the last known price for each ticker.
- 📉 **hist-ord**: Display a histogram of transactions by ticker.
- 📈 **graph-pos**: Output a graph of the values of held positions.

### 🛠 **Instructions**

- Implement script with usage: `tradelog [-h|--help] [FILTER] [COMMAND] [LOG [LOG2 [...]]`
- Include filters for date/time, ticker, and output width.
- Support processing of gzip-compressed records.
- The script should not create or modify files, and expects chronological record order.

### 📋 **Requirements**

- Compatible with common shells (dash, ksh, bash) on GNU/Linux, BSD, MacOS.
- Print numbers with two decimal places in decimal notation.
- Do not use temporary files for script operations.

### 🚀 **Submission**

- Submit the `tradelog` script as is, without compression.

## 📊 **Evaluation Results**

| Test                                             |     Result |
| :----------------------------------------------- | ---------: |
| copy of input file to output                     |         ok |
| copy multiple input files to output              |         ok |
| copy multiple input files including gz to output |         ok |
| copy stdin to stdout                             |         ok |
| command graph-pos                                |         ok |
| command hist-ord                                 |         ok |
| command last-price                               |         ok |
| command list-tick                                |         ok |
| command pos                                      |         ok |
| command profit                                   |         ok |
| filter -a                                        |         ok |
| filters -a and -b                                |         ok |
| filter -b                                        |         ok |
| filter -t                                        |         ok |
| filter -t -t                                     |         ok |
| filter -t pos                                    |         ok |
| filter -t profit                                 |         ok |
| temporary files                                  |         ok |
|                                                  |            |
| **Total score:**                                 |  **18/18** |
| **Total points:**                                |  **15/15** |
|                                                  | 🟢🟢🟢🟢🟡 |
