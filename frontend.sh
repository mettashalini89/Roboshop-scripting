source common.sh

print_head "Installing Nginx"
yum install nginx -y &>>${log_file}
echo $?

print_head "remove old content if any"
rm -rf /usr/share/nginx/html/* &>>${log_file}
echo $?

print_head "download tha content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
echo $?

print_head "move the content to html file"
cd /usr/share/nginx/html &>>${log_file}
echo $?

unzip /tmp/frontend.zip &>>${log_file}
echo $?
print_head "copy the roboshop config file"
cp ${code_dir}/Config/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
echo $?

print_head "enable nginx service"
systemctl enable nginx &>>${log_file}
echo $?

print_head "start nginx service"
systemctl start nginx &>>${log_file}
echo $? #To get the status of previous command 0 is success 1-255 is failure
