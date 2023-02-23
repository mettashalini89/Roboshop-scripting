source common.sh

print_head "download nodejs setup"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install nodejs"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "add user roboshop"
id roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log_file}
fi
status_check $?

print_head "crate app directory/folder"
mkdir /app &>>${log_file}
status_check $?

print_head "remove old content in app directory if any"
rm -rf /app/* &>>${log_file}
status_check $?

print_head "download catalogue content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?

print_head "move app directory and unzip the catalogue content"
cd /app &>>${log_file}
status_check $?

unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head "install nodejs dependencies"
npm install &>>${log_file}
status_check $?

print_head "copy catelogue service"
cp ${code_dir}/Config/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "reload systemd"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "enable catalogue service"
systemctl enable catalogue &>>${log_file}
status_check $?

print_head "start catalogue service"
systemctl start catalogue &>>${log_file}
status_check $?

print_head "copy mongodb repo"
cp ${code_dir}/Config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "install mongodb"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "load mongo schema"
mongo --host mongodb.devopsb71.live </app/schema/catalogue.js &>>${log_file}
status_check $?
