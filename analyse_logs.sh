#!/bin/bash

# A simple script to find the top 10 IPs from a WordPress brute-force attempt.

echo "--- Finding Top 10 Attacking IPs ---"

cat access.log* | grep "POST /wp-login.php" | sed 's/"//g' | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 10

echo "------------------------------------"
