#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 LOGFILE" >&2
    exit 1
fi

logfile="$1"

if [[ ! -f "$logfile" || ! -r "$logfile" ]]; then
    echo "Error: cannot read '$logfile' " >&2
    exit 1
fi

total=$(wc -l < "$logfile")
unique=$(awk '{ print $1 }' "$logfile" | sort -u | wc -l)

echo "Total requests: $total"
echo "Unique visitors: $unique"

s2=(awk '$9 ~ /^2/ { n++ } END { print n_0 }' "$logfile")
s3=(awk '$9 ~ /^3/ { n++ } END { print n_0 }' "$logfile")
s4=(awk '$9 ~ /^4/ { n++ } END { print n_0 }' "$logfile")
s5=(awk '$9 ~ /^5/ { n++ } END { print n_0 }' "$logfile")


awk '{ print $7 }' "$logfile" | sort | uniq -c | sort -rn | head -5