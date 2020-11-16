# Spring Boot 安装指南

## 安装环境

* Centos

## 安装步骤

### 安装 MariaDB

安装 MariaDB：

	sudo yum install MariaDB-server

开机启动 MariaDB：

	sudo systemctl enable mariadb

启动 MariaDB：

	sudo systemctl start mariadb

### 安装 Oracle Java

下载 Java 安装包：
	https://github.com/frekele/oracle-java/releases/download/8u212-b10/jdk-8u212-linux-x64.rpm

安装 Java：

	yum install jdk-8u212-linux-x64.rpm
	
### 安装启动脚本

下载启动脚本：

	wget https://raw.githubusercontent.com/alexfu2011/spring-boot-setup/master/boot.sh

打开启动脚本：

	nano boot.sh

修改如下变量，如果应用程序目录相同可不修改：

	JAVA_OPT=-Xmx1024m
	JARPATH=/root

添加执行权限：

	chmod 744 boot.sh

创建服务：

	ln -s /root/boot.sh /etc/init.d/boot

添加自启动：

	chkconfig --add boot

重启服务：

	systemctl daemon-reload

启动 Spring Boot：

	service boot start

### 安装 Nginx

安装 Nginx：

	yum install nginx

开机启动 nginx：

	systemctl enable nginx

打开配置文件：

	nano /etc/nginx/nginx.conf

添加内容（需替换端口）：

	location / {
		proxy_pass http://localhost:8080/;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
		proxy_set_header X-Forwarded-Port $server_port;
	}

重启 Nginx：

	systemctl restart nginx

