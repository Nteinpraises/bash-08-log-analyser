# Log Analyser

This Bash script that turns a raw web server access log into a short report a manager can read in one minute.

## Problem Statement

A busy site writes thousands of lines to its access log every day. When
the site is slow or a page disappears, the answer is somewhere in those
lines, but nobody has time to read them all. `loganalyse.sh` reads the log
and prints the numbers that matter: how many requests came in, who sent
them, what failed, and how much data was served.

## Project Goals

- Turn thousands of log lines into one readable report
- Count responses by class (2xx, 3xx, 4xx, 5xx) with exact field tests
- Find the most requested pages, the busiest IP addresses and the broken links
- Fail clearly on bad input and never crash on an empty log

## Tech Stack

- Bash
- awk, sort, uniq, head and wc
- Git and GitHub (feature branch and pull request workflow)
- Ubuntu terminal, VS Code

## Features

- Total requests and unique IP addresses
- Count of 2xx, 3xx, 4xx and 5xx responses
- Top 5 pages and top 5 IP addresses, with their counts
- The 5 most frequent 404 pages (the broken links)
- Total data sent in MB with one decimal
- Exact awk field tests for status codes, such as `$9 == 404` and `$9 ~ /^4/`
- One function for each section of the report
- A clear error and exit status 1 for a missing or unreadable file
- A "no data" message on an empty log instead of a crash

## Installation and Usage

Clone the repository and make the scripts executable:

```bash
git clone https://github.com/Nteinpraises/bash-08-log-analyser.git
cd bash-08-log-analyser
chmod +x loganalyse.sh make-sample-log.sh
```

Run it on a log file:

```bash
./loganalyse.sh access.log
```

## Sample Report

```text
$ ./loganalyse.sh access.log
=======================
Log report: access.log
=======================
Total requests :5000
Unique visitors :10
3932 / 177
4xx / 5xx :794 / 97
Data sent  :33.9 MB
```

## Screenshots

![alt text](<assets/img/Pasted image (2).png>)
![alt text](<assets/img/Pasted image.png>)

## How to Test It

Generate a small log first, so you can check the numbers by eye:

```bash
./make-sample-log.sh 20 > small.log
./loganalyse.sh small.log
```

1. The four status counts must add up to the total requests.
2. `./loganalyse.sh; echo $?` must print the usage message and `1`.
3. `./loganalyse.sh nofile.log; echo $?` must print an error and `1`.
4. An empty log must print the "no data" message and not crash.

## Challenges Faced

- **Mixing up the digit 1 and the letter l.** I typed `wc -1` instead of
  `wc -l`, and the script printed a confusing error. Reading the message
  carefully showed that `wc` was the command at fault.
- **Counting a whole class of status codes.** A loose `grep 200` also
  matches file sizes and page names, so I used exact awk tests on field 9.
- **Empty logs.** An empty file made every count blank, so the script
  checks for an empty file first and exits with a clear message.

## What I Learned

- Splitting log lines into fields with awk (`$1`, `$7`, `$9`, `$10`)
- Matching exact values with `==` and whole classes with `~ /^4/`
- Building top lists with `sort | uniq -c | sort -rn | head -5`
- Splitting a script into functions with `local` variables
- Using exit codes and stderr for clear error handling

## Notes and Limits

- The script expects the common web server log format used by the course.
- An empty log exits with status 0, because an empty log is not an error.

## Author

Ntein Praises
