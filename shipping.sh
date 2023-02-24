source common.sh
mysql_root_passwd=$1
if [ -z "${mysql_root_passwd}" ]; then
  echo -e "\e[31m sql root password is missing \e[0m"
  exit 1
fi

component=shipping
schema_type="mysql"
java