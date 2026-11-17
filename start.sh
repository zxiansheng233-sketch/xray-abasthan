#!/bin/bash
set -e

# Xray VLESS + WebSocket on Abasthan free tier.
# UUID comes from the UUID environment variable set in the Abasthan dashboard,
# never from this repo.

if [ -z "$UUID" ]; then
  echo "ERROR: UUID env var is not set" >&2
  exit 1
fi

if [ ! -x ./xray ]; then
  echo "Downloading Xray..."
  URL=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep browser_download_url | grep "Xray-linux-64.zip" | head -1 | cut -d '"' -f 4)
  if [ -z "$URL" ]; then
    echo "ERROR: could not resolve Xray download URL" >&2
    exit 1
  fi
  curl -L -o xray.zip "$URL"
  if command -v unzip >/dev/null 2>&1; then
    unzip -o xray.zip xray
  else
    python3 -c "import zipfile; zipfile.ZipFile('xray.zip').extract('xray')"
  fi
  chmod +x xray
  rm -f xray.zip
fi

PORT=${PORT:-8080}

cat > config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "$UUID" }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "/vless" }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF

echo "Starting Xray on port $PORT"
exec ./xray run -c config.json
