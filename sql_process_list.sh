#!/bin/bash
#@lroehrs / Profihost AG 2020

#-CONFIG-#

#required
user="user"
pw="password"

#optional
db=""
host=""
port="3306"
log_file="" #if set, adapt find
log_path=""


#-SCRIPT-#
set -e
xdate="$(date "+%d_%m_%Y")"
xtime="$(date "+TIME: %H:%M:%S")"
cd $(dirname "$0")

if [[ -z $db ]]; then
  db="usrdb_${user}"
fi

if [[ -z $log_path ]]; then
  log_path="/home/$(whoami)/custom_log/"
  if [[ ! -d $log_path ]]; then
    mkdir "$log_path"
  fi
fi

if [[ -z $host ]]; then
  host="127.0.0.1"
fi

if [[ -z $port ]]; then
  port="3306"
fi

if [[ -z $log_file ]];then
  log_file="sql_process_${xdate}.log"
fi

log="${log_path}${log_file}"
xmysql="/usr/local/mysql5/bin/mysql --user=${user} --password=${pw} --host=${host} --port=${port} ${db}"

echo -e "\n $xtime \n\n $($xmysql -e "SELECT ID, USER, DB, COMMAND, TIME, STATE, INFO FROM INFORMATION_SCHEMA.PROCESSLIST ORDER BY TIME DESC") \n---------------------------------------------------" >> $log

for a in $(find $log_path -mtime +30 -name "sql_process_*" -print); do
  rm -v $a
done
