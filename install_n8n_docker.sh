#!/bin/bash

# إعداد سكربت تثبيت n8n مع PostgreSQL عبر Docker Compose على Raspberry Pi
# إعداد: أحمد داود

echo "🚀 إنشاء مجلد المشروع n8n-docker..."
mkdir -p ~/n8n-docker && cd ~/n8n-docker || exit

echo "📝 إنشاء ملف البيئة (.env)..."
cat <<EOF > .env
POSTGRES_USER=user
POSTGRES_PASSWORD=AAaa@@425425
POSTGRES_DB=n8n
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=admin123
N8N_SMTP_USER=ahmedprosoft2013@gmail.com
N8N_SMTP_PASS=xwlwvjknwsxjnagm
EOF

echo "🧱 إنشاء ملف docker-compose.yml..."
cat <<EOF > docker-compose.yml
version: '3.7'

services:
  postgres:
    image: postgres:15.8
    restart: always
    environment:
      - POSTGRES_USER=\${POSTGRES_USER}
      - POSTGRES_PASSWORD=\${POSTGRES_PASSWORD}
      - POSTGRES_DB=\${POSTGRES_DB}
      - TZ=Asia/Baghdad
    volumes:
      - postgres_data:/var/lib/postgresql/data

  n8n:
    image: n8nio/n8n
    user: "root"
    restart: always
    ports:
      - "8443:5678"
    environment:
      - N8N_HOST=0.0.0.0
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - NODE_ENV=production
      - TZ=Asia/Baghdad
      - N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true
      - WEBHOOK_URL=https://auto.ahmedds.us
      - NODE_FUNCTION_ALLOW_BUILTIN=*
      - NODE_FUNCTION_ALLOW_EXTERNAL=*
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=\${POSTGRES_DB}
      - DB_POSTGRESDB_USER=\${POSTGRES_USER}
      - DB_POSTGRESDB_PASSWORD=\${POSTGRES_PASSWORD}
      - N8N_EMAIL_MODE=smtp
      - N8N_SMTP_HOST=smtp.gmail.com
      - N8N_SMTP_PORT=465
      - N8N_SMTP_USER=\${N8N_SMTP_USER}
      - N8N_SMTP_PASS=\${N8N_SMTP_PASS}
      - N8N_SMTP_SENDER=\${N8N_SMTP_USER}
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=\${N8N_BASIC_AUTH_USER}
      - N8N_BASIC_AUTH_PASSWORD=\${N8N_BASIC_AUTH_PASSWORD}
    volumes:
      - ./n8n_data:/home/node/.n8n
    depends_on:
      - postgres
    env_file:
      - .env

volumes:
  postgres_data:
EOF

echo "🔄 تشغيل الحاويات..."
docker compose up -d

echo "✅ تم التثبيت! افتح المتصفح واذهب إلى: http://$(hostname -I | awk '{print $1}'):8443"
