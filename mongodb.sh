source common.sh

print_head "prepare mongo repo"
cp ${code_dir}/Config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}


print_head "install mongodb"
yum install mongodb-org -y &>>${log_file}

print_head "update  listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}

print_head "Enable mongo server"
systemctl enable mongod &>>${log_file}

print_head "Start mongo server"
systemctl restart mongod &>>${log_file}


