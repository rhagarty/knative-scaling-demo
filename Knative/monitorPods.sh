#!/bin/bash

# Check if the number of arguments is correct
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 baseline | small | scc- | instanton | sccio"
    exit 1
fi

arg="$1"
active_pods=()
terminated_pods=()
pending_pods=()
max_pod_count=0
active_pod_count=0
total_pod_count=0
terminated_pod_count=0
pending_pod_count=0
sum_start_times=0
sum_end_times=0
total_restarts=0
first_activity=true
pod_base_name=""

# set base pod name when looking at logs where pod just started
if [ "$arg" == "baseline" ]
then
	pod_base_name="acmeair-baseline"
elif [ "$arg" == "small" ]
then
	pod_base_name="acmeair-baseline-sm"
elif [ "$arg" == "instanton" ]
then
        pod_base_name="acmeair-instanton"
elif [ "$arg" == "sccio" ]
then
	pod_base_name="acmeair-sccio"
else
	pod_base_name="acmeair-scc"
fi

# this is required to make variables global
shopt -s lastpipe

while true
do
	# get running pods
 	kubectl get pods | grep ${pod_base_name} | while read -r pod ready status restarts age1 age2 age3; do
		# echo "pod: $pod, status: $status, restarts: $restarts, age1: $age1, age2: $age2, age3: $age3"

		if [ "$status" == "Pending" ]
		then
			if [ "$first_activity" = true ]
			then
				first_activity=false
				SECONDS=0
			fi

			if [[ ${pending_pods[@]} =~ $pod ]]
                        then
                                # echo "pod already listed as pending"
                                test=0
                        else
                                echo "adding pod to pending list"
				pending_pods=("${pending_pods[@]}" $pod)
                        	pending_pod_count=${#pending_pods[@]}
			fi
		
		elif [ "$status" == "Running" ]
		then
			if [ "$first_activity" = true ]
                        then
                                first_activity=false
                                SECONDS=0
                        fi

			# remove from pending list
                        new_array=()
                        for value in "${pending_pods[@]}"
                        do
                                [[ $value != $pod ]] && new_array+=("$value")
                        done
                        pending_pods=("${new_array[@]}")
                        unset new_array
                        pending_pod_count=${#pending_pods[@]}

			# echo "status = running"
 			# if new pod, save it
			if [[ ${active_pods[@]} =~ $pod ]]
			then
				# echo "pod already listed as started"
				test=0
			else
				# get startup time from logs
				# only save pod if we have the start time from the log
				# echo $pod
				startStr=$(kubectl logs ${pod} -c ${pod_base_name} | grep "defaultServer server started in") 
				# echo "startStr: ${startStr}"
			    	IFS=' ' read -ra words <<< "$startStr"
				for i in "${words[@]}"; do
					# echo $i
					if [[ "$i" =~ ^[0-9]+(\.[0-9]+)?$ ]]
					then
						# echo number found: $i
						sum_start_times=$(echo $sum_start_times + $i | bc)
						# echo sum of start times: $sum_start_times

						# echo "adding pod to active list"
						active_pods=("${active_pods[@]}" $pod)
                                		# echo "active_pods: ${active_pods[@]}"
                                		active_pod_count=${#active_pods[@]}
						total_pod_count=$((total_pod_count+1))
                                		# echo "active_pod_count: $active_pod_count"
					fi
				done	
			fi

		elif [ "$status" == "Terminating" ]
		then
			# echo "status = terminating"
			# remove from active list
			new_array=()
			for value in "${active_pods[@]}"
			do
				[[ $value != $pod ]] && new_array+=("$value")
			done
			active_pods=("${new_array[@]}")
			unset new_array
			active_pod_count=${#active_pods[@]}
                        # echo "active_pod_count: $active_pod_count"

			# keep track of terminated pods
			if [[ ${terminated_pods[@]} =~ $pod ]]
			then
				# echo "pod already listed as terminated"
				test=0
			else
				# echo "adding pod to termination list"
				terminated_pods=("${terminated_pods[@]}" $pod)
				terminated_pod_count=${#terminated_pods[@]}
			       
			       	# keep track of how long the pod lived	
				total_secs=0
				age=$age1
				total_restarts=$((total_restarts+restarts))

				if [[ $restarts != "0" ]]
				then
					if [[ $age1 == *"("* ]]
					then
						age=$age3
					else
						age=$age1
					fi
				fi

				# echo age: $age
				if [[ $age == *"m"* ]]
				then
					IFS='m' read -ra words <<< "$age"
					mins=${words[0]}
					secs=${words[1]}
					# echo mins: $mins
					# ensure valid value
					if test -z "$secs"
					then
						secs="0s"
					fi
					
					# format final string
                                	# echo secs: $secs
                                	# remove s from seconds string
                                	secs2=${secs::${#secs}-1}
                                	# echo secs2: $secs2
                                	# handle mins
                                	total_secs=$((mins*60))
                                	total_secs=$((total_secs+secs2))
                                	sum_end_times=$((sum_end_times+total_secs))
                                	# echo total_secs: $total_secs
                                	# echo sum_end_times: $sum_end_times
				else
					# format final string
					# remove s from seconds string
					secs=${age::${#age}-1}
					sum_end_times=$((sum_end_times+secs))	
					# echo total_secs: $total_secs
					# echo sum_end_times: $sum_end_times
				fi
			fi
 		fi
	done

	printf '%s\n' "Pending pods:"
	printf '%s\n' "${pending_pods[@]}"

	printf '\n%s\n' "Total pods started: $total_pod_count"
	if (( $total_pod_count > 0)) 
	then	
		printf '%s\n' "Avg start time: $(echo "scale=4;$sum_start_times/$total_pod_count" | bc)"
	else
		printf '%s\n' "Avg start time: N/A"
	fi
	printf '%s\n' "Active pods:"
	printf '%s\n' "${active_pods[@]}"
	printf '\n%s\n' "Total pods terminated: $terminated_pod_count"
        if (( $terminated_pod_count > 0))
        then
                raw_time=$(echo "scale=4;$sum_end_times/$terminated_pod_count" | bc)
		int_time=$(awk '{$0=int($0)}1' <<< $raw_time)
                mins=$((int_time/60%60))
                secs=$((int_time%60))
		printf 'Avg pod life time: %dm%ds\n' $mins $secs
        else
                printf '%s\n' "Avg pod life time: N/A"
        fi
	printf '%s\n' "Terminated pods:"
	printf '%s\n' "${terminated_pods[@]}"
	printf '%s\n' "Total pod restarts: $total_restarts"

	if (( $terminated_pod_count > 0)) 
	then
		if (( $active_pod_count == 0)) 
		then
			duration=$SECONDS
			echo "$((duration / 60)) minutes and $((duration % 60)) seconds elapsed."
			echo "##############################"
			exit 0
		fi
	fi

	echo "Press [CTRL+C] to stop."
	echo "##############################"
	sleep 2
done

