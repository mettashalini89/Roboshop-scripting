source common.sh

roboshop_app_passwd=$1
if [ -z "${roboshop_app_passwd}" ]; then
  echo -e "\e[31m roboshop app user password is missing \e[0m"
  exit 1
fi

component=payment
python