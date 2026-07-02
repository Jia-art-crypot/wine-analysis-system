# 🍷 葡萄酒数据分析系统 - 快速公网部署指南

## ⚡ 快速解决方案（推荐）

由于Java环境配置问题，我为您提供最简单的公网访问方案：

### 方案一：使用免费内网穿透工具

#### 1. 花生壳（最简单）
- 下载：https://hsk.oray.com/download/
- 注册免费账号
- 映射内网端口8083
- 获得公网域名访问

#### 2. Natapp
- 下载：https://natapp.cn/
- 注册免费账号
- 获得隧道token
- 运行：`natapp -authtoken=你的token`

#### 3. LocalTunnel
```bash
# 安装node.js后
npm install -g localtunnel

# 启动隧道
lt --port 8083
```

### 方案二：云服务器部署（稳定）

#### 腾讯云轻量服务器（推荐）
- **价格**：50元/月（2核2G）
- **购买地址**：https://cloud.tencent.com/act/lighthouse
- **部署步骤**：

```bash
# 1. 购买服务器后，SSH连接
ssh root@你的服务器IP

# 2. 安装Java
yum install java-11-openjdk -y

# 3. 上传jar文件到服务器
# 在本地执行：
scp target/demo-0.0.1-SNAPSHOT.jar root@服务器IP:/root/

# 4. 在服务器上运行
cd /root
nohup java -jar demo-0.0.1-SNAPSHOT.jar &

# 5. 开放防火墙
firewall-cmd --permanent --add-port=8083/tcp
firewall-cmd --reload

# 6. 访问地址
http://服务器IP:8083
```

### 方案三：免费云平台（零成本）

#### Render.com
1. 注册：https://render.com/
2. 创建Web Service
3. 连接GitHub仓库
4. 自动部署

#### Railway.app
1. 注册：https://railway.app/
2. 新建项目
3. 选择Deploy from GitHub
4. 自动部署

## 🚀 立即开始（最快速）

### 使用LocalTunnel（5分钟搞定）

```bash
# 1. 安装node.js（如果没有）
# 访问：https://nodejs.org/

# 2. 安装localtunnel
npm install -g localtunnel

# 3. 先编译并启动Spring Boot应用
./mvnw spring-boot:run &

# 4. 启动内网穿透
lt --port 8083

# 5. 复制显示的公网URL分享给朋友
```

## 📱 让朋友访问的步骤

### 选择方案后：

1. **获取公网URL**（如：https://xxx.localtunnel.me）
2. **分享链接**：通过微信、QQ等分享给朋友
3. **跨设备访问**：朋友可以在电脑、平板、手机上打开
4. **实时测试**：你们可以同时使用，看到相同的分析结果

## 🎯 推荐配置

**临时测试**：LocalTunnel（免费）
**个人项目**：腾讯云轻量服务器（50元/月）
**团队使用**：阿里云ECS（87元/月起）

## ⚠️ 注意事项

1. **免费服务**可能有流量限制和广告
2. **云服务器**需要基本的Linux操作知识
3. **安全性**：公网访问建议添加密码保护
4. **流量费用**：注意云服务器的流量限制

需要我帮您配置具体的部署方案吗？

---

**💡 提示**：如果您选择云服务器部署，我可以帮您写一个完整的自动化部署脚本！