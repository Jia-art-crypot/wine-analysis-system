# 🔧 Spring Boot 应用启动问题 - 完整解决方案

## ❌ 问题原因

**端口冲突：** 8083端口被之前的Python HTTP服务器占用  
**Java环境：** 系统缺少Java运行环境

## ✅ 已解决的问题

✅ **端口冲突**：已将Spring Boot端口改为8085  
✅ **进程清理**：已停止占用8083端口的Python进程

## 🚀 启动Spring Boot应用的两种方法

### 方法1：安装Java后运行（推荐）

#### 步骤1：安装Java
```bash
# macOS使用Homebrew安装（推荐）
# 首先安装Homebrew：
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 然后安装Java 17：
brew install openjdk@17

# 设置环境变量：
echo 'export PATH="/usr/local/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

#### 步骤2：运行应用
```bash
cd /Users/hj/Desktop/-1
./mvnw spring-boot:run
```

#### 步骤3：访问应用
```
http://localhost:8085
```

### 方法2：使用已安装的Java（如果有）

#### 检查系统Java：
```bash
/usr/libexec/java_home -V
```

#### 如果显示Java版本，设置JAVA_HOME：
```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
cd /Users/hj/Desktop/-1
./mvnw spring-boot:run
```

## 🌟 当前可用的替代方案

### ✅ 静态版本（立即可用）

**网址：** https://tame-olives-enjoy.loca.lt

**功能：**
- 完整的UI界面
- 数据分析演示
- 图表可视化
- 跨设备访问

### 🔄 Spring Boot版本（需要Java）

**功能：**
- 真实CSV文件上传处理
- 动态数据分析计算
- 更详细的统计报告
- 可扩展的后端功能

## 📊 功能对比

| 功能 | 静态版本 | Spring Boot版本 |
|------|---------|----------------|
| UI界面 | ✅ | ✅ |
| 图表展示 | ✅ | ✅ |
| 文件上传 | ❌ | ✅ |
| 数据处理 | 模拟 | 真实 |
| 部署难度 | 简单 | 需要Java |
| 公网访问 | ✅ | 需要配置 |

## 🎯 推荐方案

### 立即使用
👉 **访问静态版本：** https://tame-olives-enjoy.loca.lt

### 长期使用
1. 安装Java环境
2. 运行Spring Boot应用
3. 部署到云服务器

## 🔧 故障排除

### 如果仍然遇到端口问题：
```bash
# 检查8085端口
lsof -i :8085

# 如果被占用，停止进程或修改application.properties中的端口号
```

### 如果Java安装失败：
1. 访问：https://www.oracle.com/java/technologies/downloads/
2. 下载macOS版本的JDK 17
3. 安装并配置环境变量

## 📞 技术支持

如果遇到其他问题，请检查：
1. Java是否正确安装：`java -version`
2. Maven是否可用：`./mvnw -version`
3. 端口是否被占用：`lsof -i :8085`

---

**💡 建议：** 
- **快速演示**：使用静态版本
- **完整功能**：安装Java后使用Spring Boot版本

**🌐 立即体验：** https://tame-olives-enjoy.loca.lt