source common.sh

print_head " the repo file as a rpm"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head "enable package module of redis"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status_check $?

print_head "Install redis"
yum install redis -y &>>${log_file}
status_check $?

print_head "listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?

print_head "enable redis service"
systemctl enable redis &>>${log_file}
status_check $?

print_head "start redis service"
systemctl start redis &>>${log_file}
status_check $?