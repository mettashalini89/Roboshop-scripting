source common.sh

roboshop_app_passwd=$1
if [ -z "${roboshop_app_passwd}" ]; then
  echo -e "\e[31m roboshop app user password is missing \e[0m"
  exit 1
fi

print_head "Configure YUM Repos from the script provided by vendor."
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "Install ErLang"
yum install erlang -y &>>${log_file}
status_check $?

print_head "Configure YUM Repos for RabbitMQ."
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${log_file}
status_check $?

print_head "Install RabbitMQ"
yum install rabbitmq-server -y &>>${log_file}
status_check $?

print_head "Enable RabbitMQ service"
systemctl enable rabbitmq-server &>>${log_file}
status_check $?

print_head "Start RabbitMQ service"
systemctl start rabbitmq-server &>>${log_file}
status_check $?

print_head "create one user for the application."
rabbitmqctl add_user roboshop ${roboshop_app_passwd} &>>${log_file}
status_check $?

print_head "set permissions for app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
status_check $?