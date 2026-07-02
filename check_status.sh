#!/bin/bash

# 葡萄酒数据分析系统 - 状态检查脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PORT=8086

echo "🔍 葡萄酒数据分析系统 - 状态检查"
echo "========================================"

# 检查端口状态
echo "📡 端口状态检查："
PID=$(lsof -ti :$PORT)
if [ ! -z "$PID" ]; then
    echo -e "${GREEN}✅ 端口 $PORT 正在使用中 (PID: $PID)${NC}"
    PROCESS_INFO=$(ps -p $PID -o pid,ppid,command --no-headers)
    echo "   进程信息: $PROCESS_INFO"
else
    echo -e "${RED}❌ 端口 $PORT 未被使用${NC}"
fi

# 检查Spring Boot状态
echo ""
echo "🍷 Spring Boot状态检查："
if pgrep -f "spring-boot:run" > /dev/null; then
    SPRING_PID=$(pgrep -f "spring-boot:run")
    echo -e "${GREEN}✅ Spring Boot正在运行 (PID: $SPRING_PID)${NC}"
    
    # 测试HTTP响应
    if curl -s http://localhost:$PORT > /dev/null 2>&1; then
        echo -e "${GREEN}✅ HTTP服务正常响应${NC}"
        
        # 获取页面标题
        TITLE=$(curl -s http://localhost:$PORT | grep -o '<title>[^<]*</title>' | head -1)
        echo "   页面标题: $TITLE"
    else
        echo -e "${YELLOW}⚠️  HTTP服务响应异常${NC}"
    fi
else
    echo -e "${RED}❌ Spring Boot未运行${NC}"
fi

# 检查LocalTunnel状态
echo ""
echo "🌐 LocalTunnel状态检查："
if pgrep -f "lt.*$PORT" > /dev/null; then
    LT_PID=$(pgrep -f "lt.*$PORT")
    echo -e "${GREEN}✅ LocalTunnel正在运行 (PID: $LT_PID)${NC}"
    echo "   注意: 公网URL需要查看LocalTunnel进程的输出"
else
    echo -e "${YELLOW}⚠️  LocalTunnel未运行（仅本地访问）${NC}"
fi

# 检查Java环境
echo ""
echo "☕ Java环境检查："
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -1)
    echo -e "${GREEN}✅ Java已安装${NC}"
    echo "   版本信息: $JAVA_VERSION"
else
    echo -e "${RED}❌ Java未安装${NC}"
fi

# 检查日志文件
echo ""
echo "📄 日志文件检查："
if [ -f "/tmp/spring_boot.log" ]; then
    LOG_SIZE=$(du -h /tmp/spring_boot.log | cut -f1)
    LAST_MODIFIED=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" /tmp/spring_boot.log)
    echo -e "${GREEN}✅ 日志文件存在${NC}"
    echo "   文件大小: $LOG_SIZE"
    echo "   最后修改: $LAST_MODIFIED"
    
    # 检查最近的错误
    RECENT_ERRORS=$(tail -20 /tmp/spring_boot.log | grep -i "error\|exception\|failed" | wc -l)
    if [ "$RECENT_ERRORS" -gt 0 ]; then
        echo -e "${YELLOW}⚠️  最近20行日志中发现 $RECENT_ERRORS 个错误${NC}"
    else
        echo -e "${GREEN}✅ 最近日志中未发现错误${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  日志文件不存在${NC}"
fi

# 测试应用功能
echo ""
echo "🧪 应用功能测试："
if curl -s http://localhost:$PORT > /dev/null 2>&1; then
    if curl -X POST -F "file=@/Users/hj/Desktop/-1/sample_wine_data.csv" http://localhost:$PORT/upload -o /tmp/test_status.html 2>&1 | grep -q "100"; then
        echo -e "${GREEN}✅ 文件上传功能正常${NC}"
        
        if grep -q "成功分析" /tmp/test_status.html; then
            echo -e "${GREEN}✅ 数据分析功能正常${NC}"
        else
            echo -e "${YELLOW}⚠️  数据分析结果异常${NC}"
        fi
    else
        echo -e "${RED}❌ 文件上传功能异常${NC}"
    fi
else
    echo -e "${RED}❌ 应用未响应，无法测试功能${NC}"
fi

echo ""
echo "========================================"
echo -e "${BLUE}💡 提示：${NC}"
echo "   - 如果发现问题，请使用 ./restart_app.sh 重启应用"
echo "   - 查看详细日志: tail -f /tmp/spring_boot.log"
echo "   - 停止所有服务: ./stop_app.sh"
echo "========================================"