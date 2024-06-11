#!/bin/bash
# Script to compute the average throughput from JMeter
# Use it as:  podman logs jmetercontainerID | computeAverageThroughput.sh

# Initialize variables to store total and count
total=0
count=0

# Read lines from standard input
while IFS= read -r line; do
  # Filter the line with "summary +" and extract the third token
  value=$(echo "$line" | awk '/summary \+/ {print $3}')
 
  # Check if the extracted value is not empty
  if [ -n "$value" ]; then
    # Add the value to the total
    total=$((total + value))
    # Increment the count
    count=$((count + 1))
  fi
done

# Compute the average
if [ "$count" -gt 0 ]; then
  average=$((total / count))
else
  average=0
fi

# Print the average
echo "Average throughput: $average"
