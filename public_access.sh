#!/bin/bash

# 葡萄酒数据分析系统 - 一键公网访问解决方案

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo "🍷 葡萄酒数据分析系统 - 一键公网访问"
echo "========================================"
echo ""

# 检查ngrok
if [ ! -f "/tmp/ngrok" ]; then
    echo -e "${YELLOW}📥 首次使用，正在下载Ngrok...${NC}"
    cd /tmp
    curl -s https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-amd64.zip -o ngrok.zip 2>&1 | \
        while IFS= read -r line; do echo "   下载中..."; done
    unzip -o ngrok.zip
    chmod +x ngrok
    echo -e "${GREEN}✅ Ngrok下载完成${NC}"
    echo ""
fi

# 检查ngrok配置
if /tmp/ngrok config check 2>&1 | grep -q "authtoken.*not set"; then
    echo -e "${CYAN}🔐 首次使用需要配置Ngrok账号${NC}"
    echo ""
    echo "📋 请按以下步骤操作："
    echo "1. 访问 https://dashboard.ngrok.com/signup 注册免费账号"
    echo "2. 登录后点击 'Your Authtoken' 获取token"
    echo "3. 复制token并运行: /tmp/ngrok config add-authtoken YOUR_TOKEN"
    echo ""
    read -p "是否已获取token并配置？(y/n): " configured
    if [ "$configured" != "y" ]; then
        echo ""
        echo -e "${YELLOW}💡 提示：配置后重新运行此脚本${NC}"
        exit 0
    fi
fi

# 检查Spring Boot
echo -e "${BLUE}🔍 检查Spring Boot状态...${NC}"
if ! curl -s http://localhost:8086 > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Spring Boot未运行，正在启动...${NC}"
    export JAVA_HOME=~/java/amazon-corretto-17.jdk/Contents/Home
    export PATH="$JAVA_HOME/bin:$PATH"
    
    # 先停止现有进程
    pkill -f "spring-boot:run" 2>/dev/null
    sleep 2
    
    # 启动新进程
    nohup ./mvnw spring-boot:run > /tmp/spring_boot_8086.log 2>&1 &
    
    echo "⏳ 等待Spring Boot启动..."
    for i in {1..30}; do
        if curl -s http://localhost:8086 > /dev/null 2>&1; then
            echo -e "${GREEN}✅ Spring Boot启动成功${NC}"
            break
        fi
        if [ $i -eq 30 ]; then
            echo -e "${RED}❌ Spring Boot启动失败，请检查日志${NC}"
            echo "日志位置: /tmp/spring_boot_8086.log"
            exit 1
        fi
        sleep 1
        echo "   等待中... ($i/30)"
    done
else
    echo -e "${GREEN}✅ Spring Boot已运行${NC}"
fi

echo ""

# 停止现有ngrok
echo -e "${BLUE}🔍 检查并停止现有ngrok进程...${NC}"
pkill -f "ngrok.*8086" 2>/dev/null
sleep 2

# 启动ngrok
echo ""
echo "========================================"
echo -e "${GREEN}🌐 启动Ngrok公网隧道${NC}"
echo "========================================"
echo ""
echo -e "${CYAN}📱 Ngrok优势：${NC}"
echo "   🚀 速度快，稳定性高"
echo "   🌍 全球可访问，无需VPN" 
echo "   🔒 安全可靠，企业级服务"
echo "   📊 提供访问统计和监控"
echo ""
echo -e "${YELLOW}📋 重要提示：${NC}"
echo "   1. 下方显示的公网地址可以分享给任何人"
echo "   2. 此地址持续有效，直到您按Ctrl+C停止"
echo "   3. 每次启动会生成新的地址"
echo "   4. 建议收藏或分享给需要的人"
echo ""
echo "========================================"
echo -e "${GREEN}🔗 您的公网访问地址（请复制）：${NC}"
echo "========================================"
echo ""

# 启动ngrok
/tmp/ngrok http 8086

# 如果ngrok退出
echo ""
echo -e "${YELLOW}Ngrok已停止${NC}"
echo -e "${CYAN}💡 重新运行此脚本可再次启动公网访问${NC}"