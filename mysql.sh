source common.sh
mysql_root_passwd=$1
if [ -z "${mysql_root_passwd}" ]; then
  echo -e "\e[31m sql root password is nissing \e[0m"
  exit 1
fi

print_head "Disabling sql8"
dnf module disable mysql -y
status_check $?

print_head "setup sql5.7 repo"
cp ${code_dir}/Config/mysql.repo /etc/yum.repos.d/mysql.repo
status_check $?

print_head "Install Mysql"
yum install mysql-community-server -y
status_check $?

print_head "enable MySQL Service"
systemctl enable mysqld
status_check $?

print_head "Start MySQL Service"
systemctl start mysqld
status_check $?

print_head "Set use password to RoboShop@1"
mysql_secure_installation --set-root-pass ${mysql_root_passwd}
status_check $?


