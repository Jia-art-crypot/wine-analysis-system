#!/bin/bash

echo "🚀 葡萄酒数据分析系统 - 一键公网部署"
echo "====================================="

# 检查node.js
if ! command -v node &> /dev/null; then
    echo "❌ 未检测到Node.js"
    echo "📥 请先安装Node.js: https://nodejs.org/"
    echo "   下载LTS版本并安装"
    exit 1
fi

echo "✅ Node.js已安装: $(node -v)"

# 检查npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm未安装"
    exit 1
fi

echo "✅ npm已安装: $(npm -v)"

# 安装localtunnel
echo "📦 正在安装LocalTunnel..."
npm install -g localtunnel

# 检查Spring Boot应用
if [ -f "target/demo-0.0.1-SNAPSHOT.jar" ]; then
    echo "✅ 找到编译好的jar文件"
else
    echo "❌ 未找到编译好的jar文件"
    echo "🔧 正在尝试编译..."
    
    if [ -f "./mvnw" ]; then
        ./mvnw clean package -DskipTests
    elif command -v mvn &> /dev/null; then
        mvn clean package -DskipTests
    else
        echo "❌ 无法编译项目，请手动编译"
        exit 1
    fi
fi

# 启动Spring Boot应用
echo "🍷 正在启动葡萄酒数据分析系统..."
nohup java -jar target/demo-0.0.1-SNAPSHOT.jar > wine-app.log 2>&1 &
APP_PID=$!

echo "✅ 应用已启动，PID: $APP_PID"
echo "⏳ 等待应用完全启动..."
sleep 15

# 检查应用是否成功启动
if ! ps -p $APP_PID > /dev/null; then
    echo "❌ 应用启动失败，请查看日志: wine-app.log"
    cat wine-app.log
    exit 1
fi

echo "✅ 应用启动成功！"

# 启动LocalTunnel
echo "🌐 正在创建公网访问隧道..."
echo ""
echo "🔗 正在获取公网地址..."
echo ""

lt --port 8083 --local-host localhost &

echo ""
echo "🎉 部署完成！"
echo ""
echo "📱 复制上面的公网地址分享给朋友"
echo "💻 朋友可以在电脑、平板、手机上访问"
echo ""
echo "📝 管理命令："
echo "   查看应用日志: tail -f wine-app.log"
echo "   停止应用: kill $APP_PID"
echo "   重启应用: ./quick_deploy.sh"
echo ""
echo "⚠️  注意：LocalTunnel是免费服务，每次重启会得到新的地址"
echo "💡 建议：长期使用请购买云服务器（参考PUBLIC_DEPLOYMENT.md）"

# 保持脚本运行
wait