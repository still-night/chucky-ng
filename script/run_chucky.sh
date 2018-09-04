#!/bin/bash
export PATH=/bin:$PATH
date #| tee -a chucky.log
echo "start joern" # |tee -a chucky.log
run_joern #1>>chucky.log 2>>chucky.log
neo4j start # >>chucky.log
date # | tee -a chucky.log
echo "start chucky" #|tee -a chucky.log 
chucky $@  |tee -a chucky-result.txt
date # | tee -a chucky.log
echo "end chucky" # | tee -a chucky.log
