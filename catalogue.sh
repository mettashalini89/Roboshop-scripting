source common.sh

print_head "download nodejs setup"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "Install nodejs"
yum install nodejs -y &>>${log_file}

print_head "add user roboshop"
useradd roboshop &>>${log_file}

print_head "crate app directory/folder"
mkdir /app &>>${log_file}

print_head "remove old content in app directory if any"
rm -rf /app/* &>>${log_file}

print_head "download catalogue content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}

print_head "move app directory and unzip the catalogue content"
cd /app &>>${log_file}
unzip /tmp/catalogue.zip &>>${log_file}

print_head "install nodejs dependencies"
npm install &>>${log_file}

print_head "copy catelogue service"
cp ${code_dir}/Config/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "reload systemd"
systemctl daemon-reload &>>${log_file}

print_head "enable catalogue service"
systemctl enable catalogue &>>${log_file}

print_head "start catalogue service"
systemctl start catalogue &>>${log_file}

print_head "copy mongodb repo"
cp ${code_dir}Config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "install mongodb"
yum install mongodb-org-shell -y &>>${log_file}

print_head "load mongo schema"
mongo --host mongodb.devopsb71.live </app/schema/catalogue.js &>>${log_file}
