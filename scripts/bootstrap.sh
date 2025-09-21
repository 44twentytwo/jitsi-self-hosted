#!/usr/bin/env bash
set -euo pipefail

# 1) Docker + Compose plugin
if ! command -v docker >/dev/null 2>&1; then
  apt update
  apt -y install ca-certificates curl gnupg
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu jammy stable" \
    > /etc/apt/sources.list.d/docker.list
  apt update
  apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# 2) Caddy
if ! command -v caddy >/dev/null 2>&1; then
  apt -y install debian-keyring debian-archive-keyring apt-transport-https curl
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
  apt update && apt -y install caddy
fi

# 3) Фаервол
if command -v ufw >/dev/null 2>&1; then
  ufw allow 22/tcp || true
  ufw allow 80/tcp || true
  ufw allow 443/tcp || true
  ufw allow 10000/udp || true
  ufw allow 4443/tcp || true
fi

# 4) Проверка .env
if [ ! -f ".env" ]; then
  echo " Cоздайте .env на основе .env.example и запустите скрипт снова."
  exit 1
fi

# 5) Caddyfile -> /etc/caddy/Caddyfile
install -Dm644 caddy/Caddyfile /etc/caddy/Caddyfile
caddy validate --config /etc/caddy/Caddyfile
systemctl restart caddy

# 6) Jitsi
docker compose pull
docker compose up -d

echo "Готово. Откройте: $(grep -E '^PUBLIC_URL=' .env | cut -d= -f2)"
