#!/bin/bash

clear
getCurrentJobs(){
    # save Current Running Jobs into current_jobs
	current_jobs=()
	current_jobs=(`showq | grep "Running"`)
	current_pid=()
	counter="0"
	for line in "${current_jobs[@]}";do
		#id=`echo "$line" | cut -f 1`
		if [ $(($counter % 9)) = "0" ];then
			current_pid+=("$line")
		fi
		((counter++))
	done
#	echo -e "current jobs are :::\n${current_jobs[@]}"
}
getCurrentJobsLength(){
    #save the length of Current Running Jobs into current_jobs_length
	current_jobs_length="${#current_pid[@]}"
	#echo -e "current jobs length :: $current_jobs_length"
}
getPreviousJobsLength(){
    # save the length of Previous Running Jobs into pre_jobs_length
	pre_jobs_length="${#previous_pid[@]}"
#	echo -e "pre jobs length :: $pre_jobs_length"
}
getPreviousJobs(){
	previous_jobs=()
	previous_jobs=(${current_jobs[@]})
	previous_pid=()
	previous_pid=(${current_pid[@]})
}
findFinishedJobs(){
    # check which Jobs were at Pre Jobs and are not in Current Jobs
	finished_jobs=()
	local flag="0"
	for (( i=0 ; i< "${#previous_pid[@]}" ; i++));do
		for (( j=0; j< "${#current_pid[@]}"; j++ ));do
			if [ "${current_pid[$j]}" == "${previous_pid[$i]}" ];then
				flag="1"
				break
			fi
		done
		if [ "$flag" == "0" ];then
			finished_jobs+=("${previous_jobs[$i*9]} ${previous_jobs[$i*9+1]} ${previous_jobs[$i*9+3]} ${previous_jobs[$i*9+6]} ${previous_jobs[$i*9+7]} ${previous_jobs[$i*9+8]} ")
		fi
		flag="0"
	done
#	echo -e "finished jobs are ::\n${finished_jobs[@]}"
}
dateDiff(){
    # calculate each finished Job's Running Time
    local start_date=$(date -d "$1" +%s)
    local end_date=$(date -d now +%s)
    date_diff=$(( ($end_date - $start_date) / 60 ))
#	echo -e "date diff done!!!"
}
checkFinishedJobs(){
    # extract specific data from finished Jobs to save in DB
   for i in "${finished_jobs[@]}"; do
        # split finished Jobs String
        split_data=$( echo "$i" | tr " " "\n" )
        k="0"
        date_arr=()
        for j in ${split_data[@]}; do
            #split date string to find dateDiff
            if [ "$k" == "0" ];then
                my_pid="$j"
#		echo -e "pid :: $my_pid\n"
            elif [ "$k" == "1" ]; then
                username="$j"
#		echo -e "username :: $username\n"
            elif [ "$k" == "2" ];then
                No_core="$j"
#		echo -e "no_Core :: $No_core\n"
            elif [ "$k" -ge "3" ];then
                date_arr+="$j "
#		echo -e "date :: ${date_arr[@]}"
            fi
            ((k++))
        done
        dateDiff "$date_arr"
        saveInDB
    done
}
saveInDB(){
    # Save in jobsDB >> jobsData table
    sqlite3 jobsDB.db "insert into jobsData (pid,username,No_Core,time) values ('$my_pid','$username','$No_core','$date_diff')"
#	echo -e "****saved in data base****"
}
# main program :)))
getCurrentJobs
getCurrentJobsLength
while [ "1" == "1" ];do
	sleep 1m
	clear
	getPreviousJobs
	getPreviousJobsLength
	getCurrentJobs
	getCurrentJobsLength
	findFinishedJobs
	checkFinishedJobs
done
