code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e "\e[35m $1 \e[0m"
}

print_head "Installing Nginx"
yum install nginx -y &>>${log_file}

print_head "remove old content if any"
rm -rf /usr/share/nginx/html/* &>>${log_file}
print_head "download tha content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
print_head "move the content to html file"
cd /usr/share/nginx/html &>>${log_file}
unzip /tmp/frontend.zip &>>${log_file}
print_head "copy the roboshop config file"
cp ${code_dir}/Config/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "enable nginx service"
systemctl enable nginx &>>${log_file}

print_head "start nginx service"
systemctl start nginx &>>${log_file}

