#!/bin/bash

source ./get_machines.sh

inventory_filename="${1:-ansible-inv.yml}"

declare -A machines
get_machines "heroic-oarlock-329616" machines

echo "all:" > "$inventory_filename"
echo "    hosts:" >> "$inventory_filename"

for i in $(seq 1 ${machines[count]})
do
    if [[ "${machines["$i,external_ip"]}" != "" ]]
    then
        echo "        ${machines["$i,name"]}:" >> "$inventory_filename"
        echo "            ansible_host: ${machines["$i,external_ip"]}" >> "$inventory_filename"
    fi
done
