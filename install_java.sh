#!/bin/bash

# Java 安装脚本 for macOS

echo "🍷 葡萄酒数据分析系统 - Java 安装助手"
echo "====================================="

# 检查系统架构
ARCH=$(uname -m)
echo "系统架构: $ARCH"

# 选择安装方法
echo ""
echo "请选择Java安装方法："
echo "1) 使用Homebrew安装（推荐）"
echo "2) 手动下载安装"
echo "3) 跳过Java安装，使用静态版本"
echo ""
read -p "请输入选项 (1-3): " choice

case $choice in
    1)
        echo "📦 使用Homebrew安装Java..."
        
        # 检查Homebrew是否安装
        if ! command -v brew &> /dev/null; then
            echo "Homebrew未安装，正在安装Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # 设置Homebrew环境
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                export PATH="/opt/homebrew/bin:$PATH"
            elif [[ -f "/usr/local/bin/brew" ]]; then
                export PATH="/usr/local/bin:$PATH"
            fi
        fi
        
        # 安装Java
        echo "正在安装OpenJDK 17..."
        brew install openjdk@17
        
        # 设置环境变量
        if [[ -f "/opt/homebrew/opt/openjdk@17/bin/java" ]]; then
            echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
            echo 'export JAVA_HOME="/opt/homebrew/opt/openjdk@17"' >> ~/.zshrc
            export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
            export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
        elif [[ -f "/usr/local/opt/openjdk@17/bin/java" ]]; then
            echo 'export PATH="/usr/local/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
            echo 'export JAVA_HOME="/usr/local/opt/openjdk@17"' >> ~/.zshrc
            export PATH="/usr/local/opt/openjdk@17/bin:$PATH"
            export JAVA_HOME="/usr/local/opt/openjdk@17"
        fi
        
        source ~/.zshrc
        
        echo "✅ Java安装完成！"
        java -version
        ;;
    
    2)
        echo "📥 手动下载Java..."
        
        if [[ "$ARCH" == "arm64" ]]; then
            echo "检测到ARM64架构，下载对应版本..."
            DOWNLOAD_URL="https://github.com/AdoptOpenJDK/openjdk17-binaries/releases/download/jdk-17.0.9%2B9/OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.9_9.tar.gz"
        else
            echo "检测到x64架构，下载对应版本..."
            DOWNLOAD_URL="https://github.com/AdoptOpenJDK/openjdk17-binaries/releases/download/jdk-17.0.9%2B9/OpenJDK17U-jdk_x64_mac_hotspot_17.0.9_9.tar.gz"
        fi
        
        echo "下载地址: $DOWNLOAD_URL"
        echo "正在下载... (这可能需要几分钟)"
        
        curl -L "$DOWNLOAD_URL" -o /tmp/openjdk17.tar.gz
        
        echo "正在解压..."
        mkdir -p ~/java
        tar -xzf /tmp/openjdk17.tar.gz -C ~/java
        
        # 设置环境变量
        JAVA_HOME=~/java/jdk-17.0.9+9
        echo "export JAVA_HOME=\"$JAVA_HOME\"" >> ~/.zshrc
        echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.zshrc
        
        source ~/.zshrc
        
        echo "✅ Java安装完成！"
        java -version
        ;;
    
    3)
        echo "⏭️ 跳过Java安装"
        echo "当前可用的静态版本："
        echo "https://tame-olives-enjoy.loca.lt"
        echo ""
        echo "如需使用完整Spring Boot版本，请稍后手动安装Java。"
        exit 0
        ;;
    
    *)
        echo "❌ 无效选项"
        exit 1
        ;;
esac

echo ""
echo "🚀 下一步："
echo "1. 重新加载shell: source ~/.zshrc"
echo "2. 验证Java安装: java -version"
echo "3. 启动应用: cd /Users/hj/Desktop/-1 && ./mvnw spring-boot:run"
echo ""
echo "💡 提示：如果遇到权限问题，请运行: chmod +x install_java.sh"