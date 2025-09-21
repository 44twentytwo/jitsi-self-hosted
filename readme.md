# 0) Подготовить DNS A-запись на сервер
# 1) Забрать репо и запустить
git clone https://github.com/44twentytwo/jisti-self-hosted /opt/jitsi
cd /opt/jitsi

# 2) Создать .env из шаблона и заполнить
cp .env.example .env
# сгенерируй секреты:
openssl rand -hex 16 | tee /tmp/JICOFO_COMPONENT_SECRET
openssl rand -hex 16 | tee /tmp/JICOFO_AUTH_PASSWORD
openssl rand -hex 16 | tee /tmp/JVB_AUTH_PASSWORD
# перенеси их в .env (и PUBLIC_URL, DOCKER_HOST_ADDRESS)

# 3) Один скрипт — всё развернёт
bash scripts/bootstrap.sh
