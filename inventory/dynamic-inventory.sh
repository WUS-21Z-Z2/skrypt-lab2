#!/bin/bash

get_machines () {
    # Pull the information
    local IFS=""
    mapfile -t args <<< "$(gcloud compute instances list --project $1 --sort-by=NAME)"
    if (($? > 0)); then
        echo "Failed to pull information about the project."
        exit 1
    fi
    array=$2
    set ${args[@]}
    header=$1
    shift

    # Measuring bounds, for extracting
    name_start=0
    zone_start=${header%%ZONE*}
    zone_start=${#zone_start}
    name_length=$(($zone_start - $name_start))
    machine_type_start=${header%%MACHINE_TYPE*}
    machine_type_start=${#machine_type_start}
    zone_length=$(($machine_type_start - $zone_start))
    preemptible_start=${header%%PREEMPTIBLE*}
    preemptible_start=${#preemptible_start}
    machine_type_length=$(($preemptible_start - $machine_type_start))
    internal_ip_start=${header%%INTERNAL_IP*}
    internal_ip_start=${#internal_ip_start}
    preemptible_length=$(($internal_ip_start - $preemptible_start))
    external_ip_start=${header%%EXTERNAL_IP*}
    external_ip_start=${#external_ip_start}
    internal_ip_length=$(($external_ip_start - $internal_ip_start))
    status_start=${header%%STATUS*}
    status_start=${#status_start}
    external_ip_length=$(($status_start - $external_ip_start))

    # Fill the array
    declare -n m="$array"
    unset IFS
    m[count]=$#
    for i in $(seq 1 $#)
    do
        m[$i,name]=$(sed 's/ //g' <<< ${1:$name_start:$name_length})
        m[$i,zone]=$(sed 's/ //g' <<< ${1:$zone_start:$zone_length})
        m[$i,machine_type]=$(sed 's/ //g' <<< ${1:$machine_type_start:$machine_type_length})
        m[$i,preemptible]=$(sed 's/ //g' <<< ${1:$preemptible_start:$preemptible_length})
        m[$i,internal_ip]=$(sed 's/ //g' <<<${1:$internal_ip_start:$internal_ip_length})
        m[$i,external_ip]=$(sed 's/ //g' <<<${1:$external_ip_start:$external_ip_length})
        m[$i,status]=$(sed 's/ //g' <<<${1:$status_start})
        shift
    done
}

declare -A machines
get_machines "heroic-oarlock-329616" machines

if [ "$1" == '--list' ]
then
    echo -n '{ "_meta": { "hostvars": '
    use_comma=""
    for i in $(seq 1 ${machines[count]})
    do
        if [[ "${machines["$i,external_ip"]}" != "" ]]
        then
            echo -n "${use_comma:+, }{ \"${machines["$i,name"]}\": { \"ansible_host\": \"${machines["$i,external_ip"]}\" }"
            use_comma="true"
        fi
    done
    echo -n ' } }, "all": { "children": [ "ungrouped" ] }, "ungrouped": { "hosts": [ '
    use_comma=""
    for i in $(seq 1 ${machines[count]})
    do
        if [[ "${machines["$i,external_ip"]}" != "" ]]
        then
            echo -n "${use_comma:+, }\"${machines["$i,name"]}\""
            use_comma="true"
        fi
    done
    echo ' ] } }'
elif [ "$1" == '--host' ]; then
    for i in $(seq 1 ${machines[count]})
    do
        if [[ "${machines["$i,name"]}" = "$2" ]] && [[ "${machines["$i,external_ip"]}" != "" ]]
        then
            echo "{ \"ansible_host\": \"${machines["$i,external_ip"]}\" }"
        fi
    done
else
  echo '{}'
fi
