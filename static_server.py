#!/usr/bin/env python3
import http.server
import socketserver
import os
import webbrowser
from pathlib import Path

PORT = 8083
DIRECTORY = "src/main/resources/static"

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)
    
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        super().end_headers()

def main():
    # 确保目录存在
    if not os.path.exists(DIRECTORY):
        print(f"❌ 目录不存在: {DIRECTORY}")
        return
    
    os.chdir(DIRECTORY)
    
    with socketserver.TCPServer(("", PORT), MyHTTPRequestHandler) as httpd:
        print(f"🚀 静态服务器启动在端口 {PORT}")
        print(f"📁 服务目录: {os.path.abspath(DIRECTORY)}")
        print(f"🌐 本地访问: http://localhost:{PORT}")
        print(f"📱 局域网访问: http://[你的IP]:{PORT}")
        print("按 Ctrl+C 停止服务器")
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n🛑 服务器已停止")

if __name__ == "__main__":
    main()