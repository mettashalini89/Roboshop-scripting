code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e "\e[35m $1 \e[0m"
}

status_check(){
  if [ $1 -eq 0 ]; then
    echo Success
  else
    echo Failure
    exit 1 #exit command is to exit the execution and 0 is its default value, to remove confusion(as exit status 0 is success) we can give no as 1 here.
  fi
}