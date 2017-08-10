# cluster_log
A bash script that saves cluster job's log

If you use `showq`, you only see running and idle jobs in cluster.
if you want to know:
	>> each users Jobs
	>> how many cores that job used to compelete
	>> how much time jobs take to finish
you can use this script!!!

#Installation

`$ git clone https://github.com/salehiali1374/cluster_log.git`
`$ cd cluster_log`
`$ chmod +x job.sh`
`$ chmod +x jobsInfo.sh`

you can run job.sh in system startup or using nohup!!!
after runnig job.sh if you want to check gathering data you have to use jobsInfo.sh
fo more information about how to use jobsInfo.sh try this command

`$ ./jobsInfo.sh -h`

hope you enjoy it !!!
