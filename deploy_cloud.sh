#!/bin/bash

# 葡萄酒数据分析系统 - 云服务器部署脚本

echo "🚀 准备部署到云服务器"
echo "===================="
echo ""

# 检查是否有云服务器配置
if [ ! -f "server_config.txt" ]; then
    cat > server_config.txt << EOF
# 云服务器配置信息
# 请填写您的云服务器信息
SERVER_IP=""
SSH_USER="root"
SSH_KEY=""
SSH_PASSWORD=""
EOF
    echo "📝 需要配置云服务器信息"
    echo "已创建配置文件: server_config.txt"
    echo ""
    echo "请编辑 server_config.txt 填写服务器信息，然后重新运行此脚本"
    exit 0
fi

# 读取配置
source server_config.txt

if [ -z "$SERVER_IP" ]; then
    echo "❌ 请先配置服务器IP地址"
    exit 1
fi

echo "📦 开始打包应用..."
# 创建部署包
tar -czf wine-analysis.tar.gz \
    src/ \
    pom.xml \
    mvnw \
    sample_wine_data.csv \
    USER_GUIDE.md

echo "✅ 应用打包完成"
echo ""

echo "🚀 开始上传到服务器..."
if [ -n "$SSH_KEY" ]; then
    scp -i "$SSH_KEY" wine-analysis.tar.gz $SSH_USER@$SERVER_IP:/tmp/
else
    scp wine-analysis.tar.gz $SSH_USER@$SERVER_IP:/tmp/
fi

echo "✅ 上传完成"
echo ""

echo "⚙️  开始部署..."
# 创建部署脚本
cat > deploy_remote.sh << 'DEPLOY_SCRIPT'
#!/bin/bash
cd /tmp
tar -xzf wine-analysis.tar.gz
cd wine-analysis

# 安装Java
if ! command -v java &> /dev/null; then
    apt update
    apt install -y openjdk-17-jdk
fi

# 启动应用
nohup ./mvnw spring-boot:run > /app/wine-analysis.log 2>&1 &

echo "✅ 部署完成"
echo "应用运行在: http://SERVER_IP:8086"
DEPLOY_SCRIPT

# 上传并执行部署脚本
if [ -n "$SSH_KEY" ]; then
    scp -i "$SSH_KEY" deploy_remote.sh $SSH_USER@$SERVER_IP:/tmp/
    ssh -i "$SSH_KEY" $SSH_USER@$SERVER_IP "chmod +x /tmp/deploy_remote.sh && /tmp/deploy_remote.sh"
else
    scp deploy_remote.sh $SSH_USER@$SERVER_IP:/tmp/
    ssh $SSH_USER@$SERVER_IP "chmod +x /tmp/deploy_remote.sh && /tmp/deploy_remote.sh"
fi

echo ""
echo "🎉 部署完成！"
echo "访问地址: http://$SERVER_IP:8086"