#!/bin/bash

# 葡萄酒数据分析系统 - 部署脚本

echo "🍷 葡萄酒数据分析系统部署助手"
echo "================================"

# 检查Java环境
if command -v java &> /dev/null; then
    echo "✅ Java已安装: $(java -version 2>&1 | head -n 1)"
else
    echo "❌ Java未安装，请先安装Java 11或更高版本"
    echo "   访问: https://www.oracle.com/java/technologies/downloads/"
    exit 1
fi

# 检查Maven环境
if command -v mvn &> /dev/null; then
    echo "✅ Maven已安装: $(mvn -version | head -n 1)"
else
    echo "❌ Maven未安装，正在下载Maven Wrapper..."
    # 如果没有mvnw，尝试使用已有的
    if [ ! -f "./mvnw" ]; then
        echo "   请先安装Maven或使用IDE打包项目"
        exit 1
    fi
fi

# 编译项目
echo "📦 开始编译项目..."
if [ -f "./mvnw" ]; then
    ./mvnw clean package -DskipTests
elif command -v mvn &> /dev/null; then
    mvn clean package -DskipTests
else
    echo "❌ 无法找到Maven来编译项目"
    exit 1
fi

# 检查编译结果
if [ -f "target/demo-0.0.1-SNAPSHOT.jar" ]; then
    echo "✅ 编译成功: target/demo-0.0.1-SNAPSHOT.jar"
else
    echo "❌ 编译失败，请检查项目配置"
    exit 1
fi

# 启动应用
echo "🚀 启动应用..."
nohup java -jar target/demo-0.0.1-SNAPSHOT.jar > app.log 2>&1 &
APP_PID=$!

echo "✅ 应用已启动，PID: $APP_PID"
echo "📝 日志文件: app.log"

# 等待应用启动
echo "⏳ 等待应用启动..."
sleep 10

# 检查应用是否运行
if ps -p $APP_PID > /dev/null; then
    echo "✅ 应用运行中"
    echo "🌐 本地访问地址: http://localhost:8083"
    
    # 检查ngrok
    if [ -f "/tmp/ngrok" ]; then
        echo "🔗 检测到ngrok，正在创建公网隧道..."
        /tmp/ngrok http 8083 > ngrok.log 2>&1 &
        NGROK_PID=$!
        
        sleep 5
        
        if ps -p $NGROK_PID > /dev/null; then
            echo "✅ Ngrok隧道已创建"
            echo "📝 Ngrok日志: ngrok.log"
            echo "🔗 请查看ngrok.log获取公网访问地址"
        else
            echo "❌ Ngrok启动失败"
        fi
    else
        echo "📥 未检测到ngrok，如需公网访问请安装ngrok"
        echo "   下载地址: https://ngrok.com/download"
    fi
    
    echo ""
    echo "🎉 部署完成！"
    echo ""
    echo "停止应用: kill $APP_PID"
    echo "查看日志: tail -f app.log"
    
else
    echo "❌ 应用启动失败，请查看日志: app.log"
    exit 1
fi