cp Config/mongodb.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod

#problem: need to update  listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
