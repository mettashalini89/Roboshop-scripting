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

NodeJS(){
  print_head "setup NodeJs repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?

  print_head "Install NodeJS"
  yum install nodejs -y &>>${log_file}
  status_check $?

  print_head "Add app user roboshop"
  id roboshop &>>${log_file} #if user roboshop doesnt exit then add user
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log_file}
  fi
  status_check $?

  print_head "Add a app directory"
  if [ ! -d /app ]; then  #if app directory/folder doesnt exist then add /app directory
    mkdir /app &>>${log_file}
  fi
  status_check $?

  print_head "remove old content if any"
  rm -rf /app/* &>>${log_file}
  status_check $?

  print_head "Download the user app application code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  status_check $?

  print_head "Change to directory /app"
  cd /app &>>${log_file}
  status_check $? &>>${log_file}

  print_head "Unzip the code"
  unzip /tmp/${component}.zip &>>${log_file}
  status_check $?

  print_head "Doenload dependencies"
  npm install &>>${log_file}
  status_check $?

  print_head "Setup SystemD User Service"
  cp ${code_dir}/Config/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  status_check $?

  print_head "Reload systemd"
  systemctl daemon-reload &>>${log_file}
  status_check $?

  print_head "Enable ${component} service"
  systemctl enable ${component} &>>${log_file}
  status_check $?

  print_head "Start ${component} service"
  systemctl start ${component} &>>${log_file}
  status_check $?

  print_head "copy mongodb repo"
  cp ${code_dir}/Config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
  status_check $?

  print_head "install mongodb"
  yum install mongodb-org-shell -y &>>${log_file}
  status_check $?

  print_head "load mongo schema"
  mongo --host mongodb.devopsb71.live </app/schema/${component}.js &>>${log_file}
  status_check $?

}