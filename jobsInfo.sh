#!/bin/bash
clear

while getopts "htu:a" options; do
	case "$options" in
		h)
			echo -e "##########################################"
			echo -e "######## welcome to the jobs Info ########"
			echo -e "##########################################"
			echo -e "\t -h  :: gives you more help if you want to!!!"
			echo -e "\t -a  :: show you all finished jobs until now. it has the information such as \"Username\", \"NO. Core\" \"Total Time\" for each job."
			echo -e "\t -u  :: show information about specific \"USER\". Remind that you have to insert a username in front of this commanad in double quotation!!!"
			echo -e "\t -t  :: show the total use of cores and times for each users."
		;;
		a)
			echo -e "pid\tusername\tNo.Core(s)\ttime"
			echo -e "--------------------------------------------"
			result=(`sqlite3 jobsDB.db "SELECT * from jobsData"`)
			
			for i in "${result[@]}"; do
				echo -e "$i\t"
			done
		;;
		u)
			username="$OPTARG"
			echo -e "pid\tusername\tNo.Core(s)\ttime"
			echo -e "--------------------------------------------"
			result=(`sqlite3 jobsDB.db "SELECT * from jobsData where username = '$username'"`)
			for i in "${result[@]}";do
				echo -e "$i\t"
			done
			echo -e "--------------------------------------------"
			echo -e "----------total use for $username-----------"
			echo -e "-username | total_Core(s) | total_time(min)-"
			echo -e "--------------------------------------------"
			total=(`sqlite3 jobsDB.db "SELECT username, sum(No_Core), sum(time) from jobsData where username = '$username'"`)
			echo -e "${total[@]}"
		;;
		t)
			echo -e "-username | total_Core(s) | total_time(min)-"
			echo -e "--------------------------------------------"
			total=(`sqlite3 jobsDB.db "SELECT username,sum(No_Core),sum(time) from jobsData GROUP BY username"`)
			for i in "${total[@]}";do
				echo -e "$i\t"
			done
		;;
		*)
			echo -e "incorrect input. for more information use -h "
		;;
	esac
done
