code_dir=$(pwd)
echo -e "\e[35m Installing Nginx \e[0m"
yum install nginx -y

echo -e "\e[35m remove old content if any \e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[35m download tha content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
echo -e "\e[35m move the content to html file \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
echo -e "\e[35m copy the roboshop config file \e[0m"
cp ${code_dir}/Config/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[35m enable nginx service \e[0m"
systemctl enable nginx

echo -e "\e[35m start nginx service \e[0m"
systemctl start nginx

