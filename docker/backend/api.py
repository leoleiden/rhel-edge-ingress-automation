import http.server
import socketserver
import json
import os
import pwd
from datetime import datetime, timezone

PORT = 8080

def get_current_user():
    # Надійний спосіб визначення користувача в Docker (без прив'язки до TTY)
    try:
        return pwd.getpwuid(os.getuid()).pw_name
    except Exception:
        return os.environ.get("USER", os.environ.get("LOGNAME", "non-root (UID 10001)"))

class FintechApiHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Збираємо заголовки для перевірки роботи Reverse Proxy
        client_ip = self.headers.get('X-Real-IP', self.client_address[0])
        forwarded_for = self.headers.get('X-Forwarded-For', 'None')
        
        response_data = {
            "service": "UKR.PAY Core Banking API (PoC)",
            "status": "OPERATIONAL",
            "environment": "Production-Edge-Tier",
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "security_context": {
                "running_as_user": get_current_user(),
                "client_ip_detected": client_ip,
                "x_forwarded_for": forwarded_for
            },
            "message": "Zero-Trust Edge Gateway routing successful."
        }
        
        self.send_response(200)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.end_headers()
        self.wfile.write(json.dumps(response_data, indent=2).encode('utf-8'))

    def log_message(self, format, *args):
        # Кастомне логування у stdout для Docker logs
        print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] API Request: {args[0]} | From IP: {self.headers.get('X-Real-IP', self.client_address[0])}")

with socketserver.TCPServer(("", PORT), FintechApiHandler) as httpd:
    print(f"[*] UKR.PAY Core API starting on port {PORT} (Non-root mode)...")
    httpd.serve_forever()
