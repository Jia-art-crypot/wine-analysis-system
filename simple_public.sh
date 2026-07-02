#!/bin/bash

# 🍷 葡萄酒数据分析系统 - 简化版公网访问启动脚本

echo "🌐 启动Ngrok公网访问..."
echo ""

# 确保Spring Boot运行
if ! curl -s http://localhost:8086 > /dev/null 2>&1; then
    echo "⚠️  Spring Boot未运行，正在启动..."
    export JAVA_HOME=~/java/amazon-corretto-17.jdk/Contents/Home
    export PATH="$JAVA_HOME/bin:$PATH"
    nohup ./mvnw spring-boot:run > /tmp/spring_boot_8086.log 2>&1 &
    sleep 8
fi

# 启动ngrok
echo "🚀 Ngrok正在启动..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 请复制下方显示的 HTTPS 地址（类似这样）:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

/tmp/ngrok http 8086