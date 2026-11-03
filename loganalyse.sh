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

if [[ ! -s "$logfile" || ! -r "$logfile" ]]; then
    echo "No data: '$logfile' is empty"
    exit 0
fi

print_header() {
    echo "======================="
    echo "log report: $logfile"
    echo "======================="
}

print_totals() {
    local total unique
    total=$(wc -l < "$logfile")
    unique=$(awk '{ print $1 }' "$logfile" | sort -u | wc -l)

    echo "Total requests: $total"
    echo "Unique visitors: $unique"
}

print_status() {
    local s2 s3 s4 s5
    s2=$(awk '$9 ~ /^2/ { n++ } END { print n_0 }' "$logfile")
    s3=$(awk '$9 ~ /^3/ { n++ } END { print n_0 }' "$logfile")
    s4=$(awk '$9 ~ /^4/ { n++ } END { print n_0 }' "$logfile")
    s5=$(awk '$9 ~ /^5/ { n++ } END { print n_0 }' "$logfile")
    echo "2xx / 3xx :  $s2 / $s3"
    echo "4xx / 5xx : $s4 / $s5"
}

print_data_sent() {
    local mb
    mb=$(awk '{ sum += $10} END { printf "%.1f", sum / 1048576 }' "$logfile")
    echo "data sent: $mb MB"
}

print_top_pages() {
    echo "Top 5 pages"
    awk '{ print $7 }' "$logfile" | sort | uniq -c | sort -rn | head -5
}

print_top_ips() {
    echo "Top 5 IP addresses"
    awk '{ print $1 }' "$logfile" | sort | uniq -c | sort -rn | head -5
}

print_top_404() {
    echo "Top five broken links (404)"
    awk '$9 == 404 { print $7 }' "$logfile" | sort | uniq -c | sort -rn | head -5
}

print_header
print_totals
print_status
print_data_sent
print_top_pages
print_top_ips
print_top_404
