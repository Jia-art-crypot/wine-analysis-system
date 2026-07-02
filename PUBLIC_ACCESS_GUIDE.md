# 🌐 公网访问解决方案

## ⚠️ 当前问题
LocalTunnel (https://itchy-swans-sink.loca.lt) 在某些地区可能需要VPN或网络不稳定。

## ✅ 本地访问（推荐，稳定可靠）
**地址**: http://localhost:8086
**特点**: 
- ✅ 无需VPN
- ✅ 速度极快
- ✅ 完全稳定
- ✅ 所有功能正常

## 🚀 公网访问解决方案

### 方案1：使用Ngrok（推荐）
Ngrok是更稳定的内网穿透工具：

```bash
# 1. 下载并安装ngrok
# 访问 https://ngrok.com/download 下载适合您系统的版本

# 2. 注册获取免费token
# 访问 https://dashboard.ngrok.com/signup

# 3. 配置ngrok
./ngrok authtoken YOUR_TOKEN

# 4. 启动隧道
./ngrok http 8086
```

**优点**:
- 🚀 速度更快，更稳定
- 🌍 全球可访问
- 🛡️ 更好的安全性
- 📊 提供访问统计

### 方案2：使用Cloudflare Tunnel（免费且稳定）
```bash
# 1. 安装cloudflared
brew install cloudflared  # macOS
# 或访问 https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/

# 2. 登录
cloudflared tunnel login

# 3. 创建隧道
cloudflared tunnel create wine-analysis

# 4. 启动隧道
cloudflared tunnel run wine-analysis
```

### 方案3：部署到云服务器（长期稳定）
推荐使用腾讯云轻量服务器：
- **价格**: 约50元/月
- **配置**: 2核4G足够
- **优点**: 
  - 🏢 企业级稳定性
  - 🌍 全球访问
  - 🔒 更高的安全性
  - 💾 数据持久化

部署步骤：
```bash
# 1. 购买服务器后SSH连接
ssh root@your_server_ip

# 2. 安装Java环境
apt install openjdk-17-jdk  # Ubuntu/Debian
yum install java-17-openjdk  # CentOS

# 3. 上传项目文件
scp -r /Users/hj/Desktop/-1 root@your_server_ip:/root/

# 4. 启动应用
cd /root/-1
./mvnw spring-boot:run
```

### 方案4：暂时使用VPN
如果必须使用LocalTunnel：
```bash
# 连接VPN后重新启动LocalTunnel
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
lt --port 8086 &
```

## 🎯 推荐方案

### 临时使用
**首选**: 本地访问 http://localhost:8086
- 无需任何额外工具
- 稳定可靠
- 速度最快

### 短期分享
**选择**: Ngrok
- 免费版足够使用
- 稳定性较好
- 配置简单

### 长期部署
**推荐**: 云服务器
- 企业级稳定性
- 全球可访问
- 适合商业用途

## 📱 当前可用功能

### ✅ 完全正常的功能
- **本地访问**: http://localhost:8086
- **文件上传**: ✅ 正常
- **数据分析**: ✅ 正常  
- **图表展示**: ✅ 正常
- **Word导出**: ✅ 正常
- **所有界面**: ✅ 已优化，不会卡死

### ⚠️ 公网访问状态
- **LocalTunnel**: ❌ 网络不稳定，可能需要VPN
- **建议**: 使用其他公网访问方案

## 💡 使用建议

### 日常使用
```bash
# 直接使用本地地址
open http://localhost:8086
```

### 需要分享时
```bash
# 使用ngrok创建临时公网地址
./ngrok http 8086
```

### 商业部署
```bash
# 部署到云服务器
# 参考"方案3：部署到云服务器"
```

## 🛠️ 快速启动指南

### 本地使用（推荐）
```bash
# 检查系统状态
./check_status.sh

# 访问系统
open http://localhost:8086

# 如有问题重启
./restart_app.sh
```

### 设置Ngrok公网访问
```bash
# 1. 下载ngrok
# 访问 https://ngrok.com/download

# 2. 配置并启动
./ngrok http 8086

# 3. 复制显示的公网地址分享给他人
```

## 📞 技术支持

### 常见问题
- **Q**: LocalTunnel无法访问？
  - **A**: 使用ngrok或本地访问代替

- **Q**: 想要长期稳定服务？
  - **A**: 部署到云服务器（约50元/月）

- **Q**: 只是临时使用？
  - **A**: 直接使用本地访问http://localhost:8086

### 获取帮助
- 本地访问：http://localhost:8086
- 系统状态：`./check_status.sh`
- 重启系统：`./restart_app.sh`

---

**🎉 推荐使用本地访问，稳定可靠！**