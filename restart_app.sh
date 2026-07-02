#!/bin/bash

# 葡萄酒数据分析系统 - 启动管理脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PORT=8086

echo "🍷 葡萄酒数据分析系统 - 启动管理脚本"
echo "========================================"

# 检查Java环境
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java未安装，请先安装Java 17+${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Java环境检查通过${NC}"

# 停止占用端口的进程
echo "🔍 检查端口 $PORT..."
PID=$(lsof -ti :$PORT)
if [ ! -z "$PID" ]; then
    echo -e "${YELLOW}⚠️  端口 $PORT 被进程 $PID 占用，正在停止...${NC}"
    kill -9 $PID
    sleep 2
    echo -e "${GREEN}✅ 端口已释放${NC}"
else
    echo -e "${GREEN}✅ 端口 $PORT 可用${NC}"
fi

# 启动Spring Boot应用
echo "🚀 启动Spring Boot应用..."
export JAVA_HOME=~/java/amazon-corretto-17.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

nohup ./mvnw spring-boot:run > /tmp/spring_boot.log 2>&1 &
SPRING_PID=$!

# 等待应用启动
echo "⏳ 等待应用启动..."
for i in {1..30}; do
    if curl -s http://localhost:$PORT > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 应用启动成功！(PID: $SPRING_PID)${NC}"
        break
    fi
    if [ $i -eq 30 ]; then
        echo -e "${RED}❌ 应用启动超时，请检查日志：tail -f /tmp/spring_boot.log${NC}"
        exit 1
    fi
    sleep 1
    echo "   等待中... ($i/30)"
done

# 测试功能
echo "🧪 测试应用功能..."
if curl -X POST -F "file=@/Users/hj/Desktop/-1/sample_wine_data.csv" http://localhost:$PORT/upload -o /tmp/test_result.html 2>&1 | grep -q "100"; then
    echo -e "${GREEN}✅ 文件上传功能正常${NC}"
else
    echo -e "${YELLOW}⚠️  文件上传可能有问题，请手动测试${NC}"
fi

# 设置公网访问
echo "🌐 设置公网访问..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

if command -v lt &> /dev/null; then
    # 停止旧的LocalTunnel
    pkill -f "lt.*$PORT" 2>/dev/null
    sleep 2
    
    # 启动新的LocalTunnel
    lt --port $PORT &
    LT_PID=$!
    
    sleep 5
    echo -e "${GREEN}✅ LocalTunnel已启动 (PID: $LT_PID)${NC}"
    echo "📱 公网访问地址将在几秒钟内生成，请查看LocalTunnel输出"
else
    echo -e "${YELLOW}⚠️  LocalTunnel未安装，仅提供本地访问${NC}"
fi

echo ""
echo "========================================"
echo -e "${GREEN}🎉 系统启动完成！${NC}"
echo ""
echo "📱 访问地址："
echo "   本地访问：http://localhost:$PORT"
echo "   公网访问：请查看LocalTunnel输出的URL"
echo ""
echo "📊 日志文件："
echo "   Spring Boot: /tmp/spring_boot.log"
echo "   测试结果: /tmp/test_result.html"
echo ""
echo "🛠️  管理命令："
echo "   查看日志: tail -f /tmp/spring_boot.log"
echo "   停止应用: pkill -f 'spring-boot:run'"
echo "   重启应用: ./restart_app.sh"
echo ""
echo "💡 提示：如果遇到问题，请检查日志文件获取详细信息"
echo "========================================"

# 保持脚本运行，显示LocalTunnel URL
if command -v lt &> /dev/null; then
    echo "📡 等待LocalTunnel生成公网URL..."
    sleep 10
    echo "✅ 公网访问已设置完成！"
fi