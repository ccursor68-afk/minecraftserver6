#!/bin/bash

# Minecraft Server List - Ubuntu VPS Deployment Script
# Domain: serverlistrank.com

set -e

echo "🚀 Minecraft Server List VPS Deployment Başlıyor..."
echo "================================================"

# Renk kodları
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Root kontrolü
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}❌ Bu script root yetkisi ile çalıştırılmalıdır!${NC}"
    echo "Lütfen: sudo bash deploy-to-vps.sh şeklinde çalıştırın"
    exit 1
fi

# Domain ve dizin yapılandırması
DOMAIN="serverlistrank.com"
APP_DIR="/var/www/minecraft-server-list"
USER_HOME="/root"

echo -e "${GREEN}✓ Domain: $DOMAIN${NC}"
echo -e "${GREEN}✓ Uygulama Dizini: $APP_DIR${NC}"
echo ""

# 1. Sistem güncellemesi
echo "${YELLOW}[1/10] Sistem güncelleniyor...${NC}"
apt update && apt upgrade -y

# 2. Gerekli paketleri yükle
echo "${YELLOW}[2/10] Gerekli paketler kuruluyor...${NC}"
apt install -y curl wget git nginx certbot python3-certbot-nginx ufw build-essential

# 3. Node.js 20.x kurulumu
echo "${YELLOW}[3/10] Node.js 20.x kuruluyor...${NC}"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
else
    echo "Node.js zaten kurulu: $(node -v)"
fi

# 4. Yarn kurulumu
echo "${YELLOW}[4/10] Yarn kuruluyor...${NC}"
if ! command -v yarn &> /dev/null; then
    npm install -g yarn
else
    echo "Yarn zaten kurulu: $(yarn -v)"
fi

# 5. Python ve pip kurulumu
echo "${YELLOW}[5/10] Python ve pip kuruluyor...${NC}"
apt install -y python3 python3-pip python3-venv

# 6. PM2 kurulumu
echo "${YELLOW}[6/10] PM2 kuruluyor...${NC}"
if ! command -v pm2 &> /dev/null; then
    npm install -g pm2
    pm2 startup systemd -u root --hp $USER_HOME
else
    echo "PM2 zaten kurulu: $(pm2 -v)"
fi

# 7. Uygulama dizinini oluştur ve dosyaları kopyala
echo "${YELLOW}[7/10] Uygulama dosyaları hazırlanıyor...${NC}"
mkdir -p $APP_DIR

# Mevcut dizindeki tüm dosyaları kopyala
echo "Dosyalar kopyalanıyor..."
cp -r /app/* $APP_DIR/ 2>/dev/null || cp -r ./* $APP_DIR/ 2>/dev/null || echo "Dosyalar zaten hedef konumda"

cd $APP_DIR

# 8. Frontend kurulumu
echo "${YELLOW}[8/10] Frontend bağımlılıkları kuruluyor...${NC}"
cd $APP_DIR/frontend

# Environment dosyaları oluştur (.env.local VE .env.production)
cat > .env.local << 'EOF'
NEXT_PUBLIC_SUPABASE_URL=https://oouyxbznjuomqxosrkid.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzUwOTAsImV4cCI6MjA4Mjk1MTA5MH0.7E-QNxKZYtquOYnz7t7igwLe_E28iNFHvGY54kedvXs
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzM3NTA5MCwiZXhwIjoyMDgyOTUxMDkwfQ.eFC8yP9NNqTSkjRMgJQ3ZDaufLSS6HZB9dkDLODpBHc
CORS_ORIGINS=https://serverlistrank.com,https://www.serverlistrank.com
EOF

# .env.production dosyası da oluştur (build için)
cat > .env.production << 'EOF'
NEXT_PUBLIC_SUPABASE_URL=https://oouyxbznjuomqxosrkid.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzUwOTAsImV4cCI6MjA4Mjk1MTA5MH0.7E-QNxKZYtquOYnz7t7igwLe_E28iNFHvGY54kedvXs
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzM3NTA5MCwiZXhwIjoyMDgyOTUxMDkwfQ.eFC8yP9NNqTSkjRMgJQ3ZDaufLSS6HZB9dkDLODpBHc
CORS_ORIGINS=https://serverlistrank.com,https://www.serverlistrank.com
EOF

echo "Yarn install çalıştırılıyor (bu biraz zaman alabilir)..."
yarn install --network-timeout 100000

echo "Frontend build ediliyor..."
# Environment variable'ları export et (build için)
export NEXT_PUBLIC_SUPABASE_URL=https://oouyxbznjuomqxosrkid.supabase.co
export NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzUwOTAsImV4cCI6MjA4Mjk1MTA5MH0.7E-QNxKZYtquOYnz7t7igwLe_E28iNFHvGY54kedvXs
export SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzM3NTA5MCwiZXhwIjoyMDgyOTUxMDkwfQ.eFC8yP9NNqTSkjRMgJQ3ZDaufLSS6HZB9dkDLODpBHc
export CORS_ORIGINS=https://serverlistrank.com,https://www.serverlistrank.com

yarn build

# 9. Backend kurulumu
echo "${YELLOW}[9/10] Backend bağımlılıkları kuruluyor...${NC}"
cd $APP_DIR/backend

# Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Environment dosyası oluştur
cat > .env << 'EOF'
SUPABASE_URL=https://oouyxbznjuomqxosrkid.supabase.co
SUPABASE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzM3NTA5MCwiZXhwIjoyMDgyOTUxMDkwfQ.eFC8yP9NNqTSkjRMgJQ3ZDaufLSS6HZB9dkDLODpBHc
EOF

pip install -r requirements.txt

# 10. PM2 yapılandırması
echo "${YELLOW}[10/10] PM2 yapılandırması...${NC}"
cd $APP_DIR

# PM2 ecosystem dosyası oluştur
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [
    {
      name: 'minecraft-frontend',
      cwd: '/var/www/minecraft-server-list/frontend',
      script: 'node_modules/.bin/next',
      args: 'start -p 3000',
      env: {
        NODE_ENV: 'production',
        PORT: 3000
      },
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G'
    },
    {
      name: 'minecraft-backend',
      cwd: '/var/www/minecraft-server-list/backend',
      script: 'venv/bin/uvicorn',
      args: 'server:app --host 0.0.0.0 --port 8001',
      env: {
        PYTHONPATH: '/var/www/minecraft-server-list/backend'
      },
      instances: 1,
      autorestart: true,
      watch: false
    }
  ]
};
EOF

# PM2 uygulamalarını başlat
pm2 delete all 2>/dev/null || true
pm2 start ecosystem.config.js
pm2 save

# Nginx yapılandırması
echo "${YELLOW}Nginx yapılandırılıyor...${NC}"
cat > /etc/nginx/sites-available/$DOMAIN << 'EOF'
server {
    listen 80;
    server_name serverlistrank.com www.serverlistrank.com;

    # Frontend (Next.js)
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Backend API (FastAPI)
    location /api/backend {
        rewrite ^/api/backend/(.*) /$1 break;
        proxy_pass http://localhost:8001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Nginx'i aktifleştir
ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Nginx test ve restart
nginx -t
systemctl restart nginx
systemctl enable nginx

# UFW Firewall yapılandırması
echo "${YELLOW}Firewall yapılandırılıyor...${NC}"
ufw --force enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 'Nginx Full'

echo ""
echo "${GREEN}================================================${NC}"
echo "${GREEN}✅ Kurulum tamamlandı!${NC}"
echo "${GREEN}================================================${NC}"
echo ""
echo "📋 Durum Kontrolü:"
echo "Frontend: $(pm2 list | grep minecraft-frontend || echo 'Başlatılıyor...')"
echo "Backend: $(pm2 list | grep minecraft-backend || echo 'Başlatılıyor...')"
echo ""
echo "🌐 Siteniz: http://serverlistrank.com"
echo ""
echo "${YELLOW}⚠️  ÖNEMLİ: SSL Sertifikası için şu komutu çalıştırın:${NC}"
echo "${GREEN}certbot --nginx -d serverlistrank.com -d www.serverlistrank.com --non-interactive --agree-tos -m admin@serverlistrank.com${NC}"
echo ""
echo "${YELLOW}📊 Yararlı Komutlar:${NC}"
echo "  pm2 status              - Uygulamaların durumunu görüntüle"
echo "  pm2 logs                - Tüm logları görüntüle"
echo "  pm2 logs minecraft-frontend  - Frontend logları"
echo "  pm2 logs minecraft-backend   - Backend logları"
echo "  pm2 restart all         - Tüm uygulamaları yeniden başlat"
echo "  nginx -t                - Nginx yapılandırmasını test et"
echo "  systemctl status nginx  - Nginx durumunu kontrol et"
echo ""
echo "${GREEN}🎉 Başarılar! Siteniz yayında!${NC}"
