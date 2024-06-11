#!/bin/bash

# Please note if you need to replace any strings other than the default value provided here. You can use ./searchReplaceNs.sh [target string]. 
# The script will utilize the CURRENTNS value to substitute the target string. For example, running "./searchReplaceNs.sh scclab-rm" will 
# replace the scclab-rm with CURRENTNS value.

default_namespace="scclab-[Your_initial]"
default_service_acct="instanton-sa-[Your_initial]"

if [ "$#" -eq 0 ]; then
    old_namespace=$default_namespace
elif [ "$#" -eq 1 ]; then
    old_namespace=$1
else
    echo "Usage: $0 [<old_namespace>]"
    exit 1
fi

new_namespace=$CURRENT_NS
selected_files=(./Knative/*.yaml ./Knative/*.sh)
changes=0

if [[ -z "${new_namespace}" ]]; then
    echo "Warning: The CURRENT_NS variable is empty. Please verify the export command in step 6. The script will now terminate."
    exit 1
fi

for file in "${selected_files[@]}"; do
    if [ "$old_namespace" == "scclab-[Your_initial]" ]; then
        sed -i "s/scclab-\[Your_initial\]/$new_namespace/g" "$file"
        sed -i "s/instanton-sa-\[Your_initial\]/instanton-sa-$new_namespace/g" "$file"
    else 
        sed -i "s/$old_namespace/$new_namespace/g" "$file"
        sed -i "s/instanton-sa-$old_namespace/instanton-sa-$new_namespace/g" "$file"
    fi
    
    changes=$((changes + 1))
done
echo "Changed $changes files to replace $old_namespace with $new_namespace"