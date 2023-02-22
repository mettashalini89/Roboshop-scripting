code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e "\e[35m $1 \e[0m"
}

print_head "prepare mongo repo"
cp ${code_dir}/Config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "install mongodb"
yum install mongodb-org -y &>>${log_file}

print_head "Enable mongo server"
systemctl enable mongod &>>${log_file}

print_head "Start mongo server"
systemctl start mongod &>>${log_file}

#problem: need to update  listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
