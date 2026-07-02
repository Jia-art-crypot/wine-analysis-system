# 葡萄酒数据分析系统 - 公网部署指南

由于当前环境限制，我为您提供几种部署方案让网站公开访问：

## 方案一：使用ngrok内网穿透（推荐）

### 步骤：
1. **启动Spring Boot应用**
```bash
# 在项目目录下
java -jar target/demo-0.0.1-SNAPSHOT.jar
```

2. **使用ngrok创建公网隧道**
```bash
# 下载ngrok: https://ngrok.com/download
# 解压后运行
./ngrok http 8083
```

3. **获取公网地址**
ngrok会显示一个公网URL，如：`https://xxxx-xx-xx-xx-xx.ngrok-free.app`

## 方案二：使用云服务器部署

### 1. 购买云服务器
- 阿里云ECS（最便宜约87元/月）
- 腾讯云CVM（最便宜约50元/月）
- 华为云ECS（最便宜约99元/月）

### 2. 部署步骤
```bash
# 上传jar文件到服务器
scp target/demo-0.0.1-SNAPSHOT.jar root@your-server:/root/

# SSH连接到服务器
ssh root@your-server

# 安装Java（如果没有）
yum install java-11-openjdk -y  # CentOS/RHEL
# 或
apt install openjdk-11-jre -y    # Ubuntu/Debian

# 运行应用
nohup java -jar demo-0.0.1-SNAPSHOT.jar &

# 开放防火墙端口
firewall-cmd --permanent --add-port=8083/tcp  # CentOS
# 或
ufw allow 8083  # Ubuntu
```

## 方案三：使用免费云平台

### 1. Render.com
- 注册账号：https://render.com/
- 连接GitHub仓库
- 创建Web Service
- 自动部署

### 2. Railway.app
- 注册账号：https://railway.app/
- 新建项目
- 部署Spring Boot应用

### 3. Vercel（需要配置）
- 适合静态网站
- 需要将Spring Boot改为API服务

## 方案四：本地网络共享

### 同一局域网内访问
```bash
# 获取本机IP地址
ifconfig | grep "inet " | grep -v 127.0.0.1

# 启动应用
java -jar target/demo-0.0.1-SNAPSHOT.jar

# 局域网内设备访问
http://[你的IP地址]:8083
```

## 当前推荐方案：

**快速测试：** 使用ngrok
**长期使用：** 购买云服务器部署
**免费方案：** Render.com或Railway.app

需要我帮您配置具体的部署方案吗？