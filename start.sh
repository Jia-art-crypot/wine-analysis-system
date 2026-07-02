#!/bin/bash

# 🍷 葡萄酒数据分析系统 - 一键启动脚本

echo "🍷 葡萄酒数据分析系统"
echo "===================="
echo ""

# 检查Spring Boot
if ! curl -s http://localhost:8086 > /dev/null 2>&1; then
    echo "🚀 启动Spring Boot应用..."
    export JAVA_HOME=~/java/amazon-corretto-17.jdk/Contents/Home
    export PATH="$JAVA_HOME/bin:$PATH"
    pkill -f "spring-boot:run" 2>/dev/null
    sleep 2
    nohup ./mvnw spring-boot:run > /tmp/spring_boot_8086.log 2>&1 &
    
    echo "⏳ 等待启动..."
    sleep 8
fi

# 显示访问地址
echo ""
echo "✅ 系统已启动！"
echo ""
echo "📱 访问地址："
echo "   本地访问: http://localhost:8086"
echo "   公网访问: 运行 ./public_access.sh"
echo ""
echo "🛠️ 管理命令："
echo "   检查状态: ./check_status.sh"
echo "   重启系统: ./restart_app.sh"
echo "   公网访问: ./public_access.sh"
echo ""

# 自动打开浏览器
if command -v open > /dev/null; then
    echo "🌐 正在打开浏览器..."
    open http://localhost:8086
fi

echo "🎉 开始使用吧！"