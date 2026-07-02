#!/bin/bash

# 葡萄酒数据分析系统 - Ngrok公网访问启动脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "🌐 葡萄酒数据分析系统 - Ngrok公网访问启动"
echo "========================================"

# 检查ngrok
if [ ! -f "/tmp/ngrok" ]; then
    echo -e "${RED}❌ Ngrok未安装，正在下载...${NC}"
    cd /tmp
    curl -s https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-amd64.zip -o ngrok.zip
    unzip -o ngrok.zip
    chmod +x ngrok
    echo -e "${GREEN}✅ Ngrok下载完成${NC}"
fi

# 检查Spring Boot是否运行
if ! curl -s http://localhost:8086 > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Spring Boot未运行，正在启动...${NC}"
    export JAVA_HOME=~/java/amazon-corretto-17.jdk/Contents/Home
    export PATH="$JAVA_HOME/bin:$PATH"
    nohup ./mvnw spring-boot:run > /tmp/spring_boot_8086.log 2>&1 &
    
    echo "⏳ 等待Spring Boot启动..."
    for i in {1..30}; do
        if curl -s http://localhost:8086 > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Spring Boot启动成功${NC}"
            break
        fi
        if [ $i -eq 30 ]; then
            echo -e "${RED}❌ Spring Boot启动失败${NC}"
            exit 1
        fi
        sleep 1
    done
fi

# 停止现有的ngrok进程
echo "🔍 检查并停止现有ngrok进程..."
pkill -f "ngrok.*8086" 2>/dev/null
sleep 2

# 启动ngrok
echo "🚀 启动Ngrok隧道..."
echo ""
echo -e "${BLUE}📱 Ngrok将提供稳定的公网访问地址${NC}"
echo -e "${BLUE}🌍 全球可访问，无需VPN${NC}"
echo -e "${BLUE}🔒 安全可靠，速度稳定${NC}"
echo ""
echo "========================================"
echo "🌐 公网访问地址（请复制下方URL）："
echo "========================================"
echo ""

# 启动ngrok并保持运行
/tmp/ngrok http 8086