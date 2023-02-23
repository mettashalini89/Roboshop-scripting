source common.sh

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
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file}
status_check $?

print_head "Change to directory /app"
cd /app &>>${log_file}
status_check $? &>>${log_file}

print_head "Unzip the code"
unzip /tmp/user.zip &>>${log_file}
status_check $?

print_head "Doenload dependencies"
npm install &>>${log_file}
status_check $?

print_head "Setup SystemD User Service"
cp ${code_dir}/Config/user.service /etc/systemd/system/user.service &>>${log_file}
status_check $?

print_head "Reload systemd"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable user service"
systemctl enable user &>>${log_file}
status_check $?

print_head "Start user service"
systemctl start user &>>${log_file}
status_check $?

print_head "copy mongodb repo"
cp ${code_dir}/Config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "install mongodb"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "load mongo schema"
mongo --host mongodb.devopsb71.live </app/schema/user.js &>>${log_file}
status_check $?

