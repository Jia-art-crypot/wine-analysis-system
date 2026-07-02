# 🚀 免费云服务器部署方案

## 方案选择：Render.com（推荐）

### ✅ 为什么选择Render.com
- **完全免费**：提供免费托管服务
- **稳定可靠**：企业级基础设施
- **简单易用**：一键部署
- **HTTPS支持**：自动配置SSL
- **无需VPN**：全球可访问

## 📋 部署步骤

### 1. 注册Render账号
1. 访问 https://render.com
2. 点击 "Sign Up"
3. 使用GitHub账号注册（推荐）
4. 验证邮箱

### 2. 创建新的Web Service
1. 登录Render.com
2. 点击 "New +"
3. 选择 "Web Service"

### 3. 连接代码仓库
**选项A：使用GitHub（推荐）**
1. 选择 "Connect GitHub"
2. 授权GitHub访问
3. 选择您的仓库（如果代码在GitHub上）

**选项B：上传代码**
1. 如果没有GitHub，先创建GitHub仓库
2. 将代码上传到GitHub
3. 然后按照选项A操作

### 4. 配置部署设置

**基本信息**:
- **Name**: wine-analysis-system
- **Region**: Singapore (离中国近，速度快)

**构建和运行**:
- **Runtime**: Docker
- **Dockerfile**: 自动检测

**环境变量**:
```
SERVER_PORT=8080
```

### 5. 启动部署
1. 点击 "Create Web Service"
2. 等待构建完成（约3-5分钟）
3. 部署完成后会显示公网地址

## 🎯 部署完成后的访问

### 公网地址格式
```
https://wine-analysis-system.onrender.com
```

### 特点
- ✅ 全球可访问
- ✅ 无需VPN
- ✅ 自动HTTPS
- ✅ 24/7在线
- ✅ 免费使用

## 💡 备选方案

### 方案2：Railway.app
- 免费额度：$5/月
- 访问：https://railway.app
- 特点：更稳定，支持数据库

### 方案3：Fly.io
- 免费额度：有限但可用
- 访问：https://fly.io
- 特点：全球部署

### 方案4：Vercel（需调整代码）
- 完全免费
- 需要将Spring Boot改为Node.js

## 🛠️ 快速部署指南

### 立即开始
```bash
# 1. 如果代码还没在GitHub，先推送
git init
git add .
git commit -m "Initial commit"

# 2. 创建GitHub仓库后连接
git remote add origin YOUR_GITHUB_REPO_URL
git push -u origin main

# 3. 访问Render.com部署
# https://render.com
```

### Docker文件已准备
- 文件位置：`/Users/hj/Desktop/-1/Dockerfile`
- 包含完整的构建和运行配置

## 📱 部署后使用

### 访问地址
```
https://YOUR_APP_NAME.onrender.com
```

### 功能
- 📊 葡萄酒数据分析
- 📈 图表可视化
- 📝 Word报告导出
- 🌐 全球访问

## 🎉 对比：Render vs LocalTunnel

| 特性 | LocalTunnel | Render.com |
|------|-------------|------------|
| 稳定性 | ⚠️ 不稳定 | ✅ 很稳定 |
| 速度 | ⚠️ 慢 | ✅ 快 |
| 需要VPN | ❌ 需要 | ✅ 不需要 |
| 24/7在线 | ❌ 不支持 | ✅ 支持 |
| 配置难度 | 🟢 简单 | 🟡 中等 |
| 成本 | ✅ 免费 | ✅ 免费 |

## 🚀 开始部署

**推荐方案**：
1. 注册Render.com
2. 推送代码到GitHub
3. 一键部署到Render
4. 获得稳定的公网地址

**预计时间**：
- 注册：2分钟
- 配置：3分钟
- 部署：5分钟
- 总计：10分钟

---

**💡 建议：使用Render.com获得稳定免费的公网访问！**