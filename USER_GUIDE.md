# 🍷 葡萄酒数据分析系统 - 使用说明

## ✅ 问题已解决！

端口占用问题已修复，系统现在运行正常。

## 🚀 快速启动

### 方法1：使用自动化脚本（推荐）
```bash
# 重启系统
./restart_app.sh

# 检查状态
./check_status.sh

# 停止系统
./stop_app.sh
```

### 方法2：手动启动
```bash
# 1. 停止占用端口的进程
lsof -ti :8085 | xargs kill -9

# 2. 启动Spring Boot应用
export JAVA_HOME=~/java/amazon-corretto-17.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"
nohup ./mvnw spring-boot:run > /tmp/spring_boot.log 2>&1 &

# 3. 启动LocalTunnel（可选，用于公网访问）
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
lt --port 8085 &
```

## 📱 访问地址

### 本地访问
- **地址**: http://localhost:8085
- **状态**: ✅ 正常运行
- **速度**: 极快（本地网络）

### 公网访问
- **地址**: https://beige-items-eat.loca.lt
- **状态**: ✅ 已启用
- **用途**: 可分享给其他人访问

## 🎯 系统功能

### ✨ 核心功能
- **文件上传**: 支持CSV格式文件
- **数据分析**: 自动计算统计指标和相关性
- **图表展示**: 柱状图、直方图、散点图
- **Word导出**: 生成专业分析报告
- **实时反馈**: 加载状态和错误提示

### 🔧 改进内容
1. **文件格式验证**: 只接受CSV文件，自动检测格式
2. **AJAX上传**: 避免页面卡死，提供超时保护
3. **加载动画**: 清晰的进度指示和用户反馈
4. **错误处理**: 详细的错误分类和解决建议
5. **数据验证**: 自动跳过无效数据，记录处理结果

## 📋 CSV文件格式要求

### 标准格式
```csv
country,description,designation,points,rating,people,price
US,红酒描述,Reserve,96,4.8,1200,230.0
Italy,红酒描述,Riserva,92,4.6,850,85.0
```

### 列说明
1. `country`: 国家
2. `description`: 描述
3. `designation`: 设计名称
4. `points`: 评分点数
5. `rating`: **评分** (必需，0-5)
6. `people`: **评分人数** (必需，正数)
7. `price`: **价格** (必需，正数)

### 示例文件
系统包含示例文件：`sample_wine_data.csv`

## 🛠️ 管理命令

### 查看运行状态
```bash
./check_status.sh
```

### 查看日志
```bash
# Spring Boot日志
tail -f /tmp/spring_boot.log

# 查看最近错误
tail -50 /tmp/spring_boot.log | grep -i "error\|exception"
```

### 测试功能
```bash
# 使用示例文件测试
curl -X POST -F "file=@sample_wine_data.csv" http://localhost:8085/upload

# 查看测试结果
cat /tmp/test_result.html
```

### 重启应用
```bash
# 完全重启
./stop_app.sh
./restart_app.sh

# 仅重启Spring Boot
pkill -f "spring-boot:run"
./mvnw spring-boot:run &
```

## ⚠️ 常见问题

### 端口占用
**问题**: 端口8085被占用
**解决**: 
```bash
lsof -ti :8085 | xargs kill -9
./restart_app.sh
```

### 文件上传失败
**问题**: 上传CSV文件时出现错误
**解决**:
1. 检查文件格式是否正确
2. 确认文件包含至少7列数据
3. 查看日志文件获取详细错误

### 界面卡住
**问题**: 上传时界面没有响应
**解决**:
- 现已改进，不会再出现此问题
- 如仍有问题，请检查网络连接
- 查看浏览器控制台错误信息

### LocalTunnel连接失败
**问题**: 公网访问地址无法访问
**解决**:
```bash
pkill -f "lt.*8085"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
lt --port 8085 &
```

## 📊 系统特性

### 性能优化
- **文件大小限制**: 最大10MB
- **上传超时**: 30秒保护
- **数据清洗**: 自动跳过无效数据
- **错误恢复**: 详细的错误提示

### 安全特性
- **文件类型验证**: 只接受CSV文件
- **数据范围检查**: 验证数值合理性
- **异常处理**: 完善的错误处理机制

### 用户体验
- **实时反馈**: 即时的操作反馈
- **加载状态**: 清晰的进度指示
- **错误提示**: 友好的错误消息
- **成功确认**: 处理结果展示

## 🎉 使用建议

### 日常使用
1. 使用 `./check_status.sh` 检查系统状态
2. 访问 http://localhost:8085 进行数据分析
3. 遇到问题时使用 `./restart_app.sh` 重启

### 分享给他人
1. 启动LocalTunnel获取公网地址
2. 分享公网URL给需要的人
3. 告知他们正确的CSV文件格式

### 长期使用
1. 定期检查日志文件
2. 监控系统资源使用
3. 及时更新数据和清理日志

## 📞 技术支持

### 获取帮助
- 查看日志: `tail -f /tmp/spring_boot.log`
- 检查状态: `./check_status.sh`
- 重启系统: `./restart_app.sh`

### 联系方式
如遇问题请检查：
1. Java是否正确安装: `java -version`
2. Maven是否可用: `./mvnw -version`
3. 端口是否被占用: `lsof -i :8085`
4. 应用是否启动: 检查日志输出

---

**🎊 祝您使用愉快！**

**📱 当前访问地址:**
- 本地: http://localhost:8085
- 公网: https://beige-items-eat.loca.lt