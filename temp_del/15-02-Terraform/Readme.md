#Так как нет в Path то пишем полный путь к исполняемому файлу.
D:\Programs\Terraform\bin\terraform apply


#Задание 3. Загрузить несколько ЕС2-инстансов с веб-страницей, на которой будет картинка из S3.
#Сделать Launch configurations с использованием bootstrap скрипта с созданием веб-странички на которой будет ссылка на картинку в S3.
#Загрузить 3 ЕС2-инстанса и настроить LB с помощью Autoscaling Group.
bootstrap скрипт:
#!/bin/bash
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1> This server 1 </h1></html>" >> index.html