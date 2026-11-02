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

total=$(wc -1 < "$logfile")
unique=$(awk '{ print $1 }' "$logfile" | sort -u | wc -1)

echo "Total requests: $total"
echo "Unique visitors: $unique"