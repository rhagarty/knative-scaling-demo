#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <old_ip_address> <new_ip_address>"
    exit 1
fi

old_ip="$1"
new_ip="$2"
changes=0


# Find all .sh files in the current directory and its subdirectories
targetFiles=$(find . -type f -name "*.sh")
for file in $targetFiles; do
	if grep -q "$old_ip" "$file"; then
		sed -i "s/$old_ip/$new_ip/g" "$file"
		changes=$((changes + 1))
	fi
done
echo "Changed $changes files to replace $old_ip with $new_ip"


