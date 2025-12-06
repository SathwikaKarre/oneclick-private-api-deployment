#!/bin/bash -xe

yum update -y
yum install -y python3 python3-pip

# ---------------------------
# REST API APP
# ---------------------------
cat << 'EOF' > /opt/app.py
from flask import Flask, Response
import sys

app = Flask(__name__)

@app.route("/")
def root():
    print("Received request on /", file=sys.stdout, flush=True)
    return Response("Hello from private EC2!\n", mimetype="text/plain")

@app.route("/health")
def health():
    print("Health check hit", file=sys.stdout, flush=True)
    return Response("ok\n", mimetype="text/plain")

if __name__ == "__main__":
    port = 8080
    print(f"Starting app on port {port}", file=sys.stdout, flush=True)
    app.run(host="0.0.0.0", port=port)
EOF

pip3 install flask

cat << 'EOF' > /etc/systemd/system/app.service
[Unit]
Description=Simple Flask App
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/app.py
Restart=always
User=root
WorkingDirectory=/opt
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable app
systemctl start app


# ---------------------------
# CLOUDWATCH LOGS CONFIG
# ---------------------------
yum install -y amazon-cloudwatch-agent

cat << 'EOF' > /opt/cwagent-config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/OneClick/App",
            "log_stream_name": "{instance_id}-messages"
          }
        ]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/cwagent-config.json \
  -s