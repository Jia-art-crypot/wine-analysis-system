# 🍷 葡萄酒数据分析系统 - 公网访问完整指南

## 🎯 目标：让朋友在手机、平板、电脑上访问你的网站

### ⚡ 最快方案（5分钟搞定）

#### 方法1：使用LocalTunnel（推荐）

**前提条件：**
- 已安装Node.js（如果没有，访问 https://nodejs.org/ 下载安装）

**操作步骤：**

```bash
# 1. 进入项目目录
cd /Users/hj/Desktop/-1

# 2. 编译项目（如果还没编译）
./mvnw clean package -DskipTests

# 3. 启动Spring Boot应用
java -jar target/demo-0.0.1-SNAPSHOT.jar &

# 4. 安装并启动LocalTunnel
npm install -g localtunnel
lt --port 8083
```

**完成后：**
- 复制显示的公网地址（如：https://random-name.loca.lt）
- 分享给朋友，他们可以在任何设备上访问

---

### 🌟 稳定方案（长期使用）

#### 方法2：购买云服务器

**推荐配置：**
- **腾讯云轻量服务器**：50元/月，2核2G，4M带宽
- **阿里云ECS**：87元/月，2核2G，1M带宽

**部署步骤：**

1. **购买服务器**
   - 访问：https://cloud.tencent.com/act/lighthouse
   - 选择：Ubuntu 20.04，2核2G，50元/月
   - 购买并设置密码

2. **连接服务器**
```bash
ssh root@你的服务器IP
# 输入购买时设置的密码
```

3. **安装环境**
```bash
# 安装Java
apt update
apt install openjdk-11-jre -y

# 验证安装
java -version
```

4. **部署应用**
```bash
# 在你的本地电脑上，上传jar文件
scp target/demo-0.0.1-SNAPSHOT.jar root@服务器IP:/root/

# 在服务器上运行
cd /root
nohup java -jar demo-0.0.1-SNAPSHOT.jar > app.log 2>&1 &

# 检查是否运行成功
tail -f app.log
```

5. **开放端口**
```bash
# 腾讯云需要在控制台安全组开放8083端口
# 阿里云需要在安全组规则中添加
```

6. **访问地址**
```
http://你的服务器IP:8083
```

---

### 💰 免费方案（零成本）

#### 方法3：使用Render.com

**操作步骤：**

1. **注册账号**
   - 访问：https://render.com/
   - 使用GitHub账号登录

2. **准备代码**
   - 将项目上传到GitHub
   - 确保根目录有pom.xml

3. **创建Web Service**
   - 点击"New +"
   - 选择"Web Service"
   - 连接你的GitHub仓库
   - Render会自动检测Spring Boot项目

4. **配置构建**
   - Build Command: `mvn clean package -DskipTests`
   - Start Command: `java -jar target/demo-0.0.1-SNAPSHOT.jar`

5. **等待部署**
   - 大约5-10分钟
   - 完成后会得到公网URL

---

### 🔧 工具推荐

| 工具 | 优点 | 缺点 | 价格 |
|------|------|------|------|
| LocalTunnel | 极其简单 | 不稳定，需重新安装 | 免费 |
| 花生壳 | 国内稳定 | 需要实名认证 | 免费/付费 |
| Natapp | 功能强大 | 免费版有限制 | 免费/付费 |
| 腾讯云 | 稳定快速 | 需要付费 | 50元/月起 |
| Render.com | 完全免费 | 部署稍慢 | 免费 |

---

### 📱 分享给朋友的步骤

无论选择哪种方案，完成后：

1. **获取公网地址**
   - LocalTunnel：复制显示的URL
   - 云服务器：`http://IP:8083`
   - Render.com：使用提供的域名

2. **分享方式**
   - 微信/QQ：直接发送链接
   - 短信：复制链接发送
   - 二维码：使用在线工具生成二维码

3. **访问测试**
   - 朋友在浏览器中打开链接
   - 应该能看到葡萄酒数据分析系统

---

### ⚠️ 常见问题

**Q: LocalTunnel显示错误？**
A: 确保Spring Boot应用正在运行，检查8083端口是否被占用

**Q: 云服务器无法访问？**
A: 检查安全组设置，确保8083端口已开放

**Q: 朋友访问很慢？**
A: 可能是网络问题，建议使用云服务器获得更好体验

**Q: 想要自定义域名？**
A: 购买域名后在云服务器配置nginx反向代理

---

### 🚀 推荐流程

**今天测试**：使用LocalTunnel
**下周使用**：购买腾讯云轻量服务器
**长期运营**：配置域名和SSL证书

需要帮助配置哪个方案？我可以提供详细的步骤指导！