#!/bin/bash

# 葡萄酒数据分析系统 - 停止脚本

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PORT=8086

echo "🛑 葡萄酒数据分析系统 - 停止脚本"
echo "========================================"

# 停止Spring Boot应用
echo "🔍 停止Spring Boot应用..."
if pkill -f "spring-boot:run"; then
    echo -e "${GREEN}✅ Spring Boot应用已停止${NC}"
else
    echo -e "${YELLOW}⚠️  没有找到运行中的Spring Boot应用${NC}"
fi

# 停止LocalTunnel
echo "🔍 停止LocalTunnel..."
if pkill -f "lt.*$PORT"; then
    echo -e "${GREEN}✅ LocalTunnel已停止${NC}"
else
    echo -e "${YELLOW}⚠️  没有找到运行中的LocalTunnel${NC}"
fi

# 停止占用端口的进程
echo "🔍 释放端口 $PORT..."
PID=$(lsof -ti :$PORT)
if [ ! -z "$PID" ]; then
    kill -9 $PID
    echo -e "${GREEN}✅ 端口 $PORT 已释放${NC}"
else
    echo -e "${GREEN}✅ 端口 $PORT 已经空闲${NC}"
fi

echo ""
echo "========================================"
echo -e "${GREEN}✅ 所有服务已停止${NC}"
echo "========================================"