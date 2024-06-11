server_address=$(kubectl get all | grep http | grep -v Warning | awk -F'apps.|.cloud' '{print $2}' | sort | uniq)

echo "$server_address"

#!/bin/bash

default_ocp_server_name="[OCP server name]"

new_ocp_server_name=$server_address
selected_files=(./runJMeter.sh)

if [[ -z "${server_address}" ]]; then
    echo "Warning: The ocp server_address variable is empty. Please verify the output of kubectl get all | grep http. The script will now terminate."
    exit 1
fi

for file in "${selected_files[@]}"; do
    sed -i "s/\[OCP server name\]/$new_ocp_server_name/g" "$file"
done
echo "Changed file runJMeter.sh to replace $default_ocp_server_name with $new_ocp_server_name"