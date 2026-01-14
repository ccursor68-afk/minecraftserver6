# 🚀 Ubuntu VPS Kurulum Rehberi

## Domain: serverlistrank.com

Bu rehber, Minecraft Server List uygulamanızı Ubuntu VPS'inize **tek komut** ile kurmak için hazırlanmıştır.

---

## 📋 Ön Gereksinimler

✅ Ubuntu VPS (18.04, 20.04, 22.04 veya 24.04)
✅ Root veya sudo yetkisi
✅ En az 2GB RAM
✅ Domain DNS kayıtları VPS IP'sine yönlendirilmiş

---

## 🎯 Hızlı Kurulum (3 Adım)

### Adım 1: VPS'inize Bağlanın

```bash
ssh root@VPS_IP_ADRESINIZ
```

Ya da sudo yetkili kullanıcı ile:
```bash
ssh kullanici@VPS_IP_ADRESINIZ
```

### Adım 2: Dosyaları VPS'e Yükleyin

#### Seçenek A: Git ile (Önerilen)

Eğer GitHub'da reponuz varsa:
```bash
cd /root
git clone https://github.com/KULLANICI_ADI/REPO_ADI.git
cd REPO_ADI
```

#### Seçenek B: SCP ile

Lokal bilgisayarınızdan VPS'e dosya gönderin:
```bash
# Lokal bilgisayarınızda çalıştırın
scp -r /path/to/minecraft-server-list root@VPS_IP:/root/
```

#### Seçenek C: Manuel (Yeni başlayanlar için)

1. VPS'te dizin oluşturun:
```bash
mkdir -p /root/minecraft-app
cd /root/minecraft-app
```

2. Script dosyasını oluşturun:
```bash
nano deploy-to-vps.sh
```

3. Bu repodan `deploy-to-vps.sh` içeriğini kopyalayın ve yapıştırın
4. Ctrl+O → Enter → Ctrl+X ile kaydedin

### Adım 3: Kurulumu Başlatın

```bash
chmod +x deploy-to-vps.sh
sudo bash deploy-to-vps.sh
```

**İşlem süresi:** 5-10 dakika

---

## 🔒 SSL Sertifikası Kurulumu (HTTPS)

Kurulum tamamlandıktan sonra SSL için:

```bash
sudo certbot --nginx -d serverlistrank.com -d www.serverlistrank.com --non-interactive --agree-tos -m admin@serverlistrank.com
```

**E-posta adresini** kendi e-postanızla değiştirin!

---

## ✅ Kurulum Sonrası Kontrol

### 1. Uygulamaların Durumunu Kontrol Edin

```bash
pm2 status
```

**Beklenen çıktı:**
```
┌─────┬──────────────────────┬─────────┬─────────┬──────────┐
│ id  │ name                 │ status  │ restart │ uptime   │
├─────┼──────────────────────┼─────────┼─────────┼──────────┤
│ 0   │ minecraft-frontend   │ online  │ 0       │ 5m       │
│ 1   │ minecraft-backend    │ online  │ 0       │ 5m       │
└─────┴──────────────────────┴─────────┴─────────┴──────────┘
```

### 2. Logları İnceleyin

```bash
# Tüm loglar
pm2 logs

# Sadece frontend
pm2 logs minecraft-frontend

# Sadece backend
pm2 logs minecraft-backend
```

### 3. Web Tarayıcıda Test Edin

- HTTP: http://serverlistrank.com
- HTTPS: https://serverlistrank.com (SSL kurulumundan sonra)

---

## 🛠️ Yararlı Komutlar

### PM2 Komutları

```bash
pm2 status              # Durum kontrolü
pm2 restart all         # Tüm uygulamaları yeniden başlat
pm2 stop all            # Tüm uygulamaları durdur
pm2 start all           # Tüm uygulamaları başlat
pm2 delete all          # Tüm uygulamaları sil
pm2 logs --lines 100    # Son 100 log satırını göster
pm2 monit               # Canlı monitoring
```

### Nginx Komutları

```bash
sudo nginx -t                    # Yapılandırmayı test et
sudo systemctl restart nginx     # Nginx'i yeniden başlat
sudo systemctl status nginx      # Nginx durumunu kontrol et
sudo tail -f /var/log/nginx/error.log   # Nginx hata logları
```

### Sistem Komutları

```bash
df -h                   # Disk kullanımı
free -h                 # RAM kullanımı
top                     # CPU ve RAM monitoring
htop                    # Gelişmiş monitoring (kurulu ise)
```

---

## 🔧 Sorun Giderme

### Problem: Frontend başlamıyor

**Çözüm:**
```bash
cd /var/www/minecraft-server-list/frontend
pm2 logs minecraft-frontend --lines 50

# Yeniden build
yarn build
pm2 restart minecraft-frontend
```

### Problem: Backend başlamıyor

**Çözüm:**
```bash
cd /var/www/minecraft-server-list/backend
source venv/bin/activate
python server.py  # Test amaçlı manuel çalıştır

# Hata yoksa PM2 ile başlat
pm2 restart minecraft-backend
```

### Problem: 502 Bad Gateway

**Nedeni:** Frontend veya backend çalışmıyor

**Çözüm:**
```bash
pm2 status  # Hangisi down kontrol et
pm2 restart all
sudo systemctl restart nginx
```

### Problem: Domain açılmıyor

**Kontrol listesi:**
1. DNS kayıtları VPS IP'sine yönlendirilmiş mi?
   ```bash
   nslookup serverlistrank.com
   ```

2. Firewall portları açık mı?
   ```bash
   sudo ufw status
   ```

3. Nginx çalışıyor mu?
   ```bash
   sudo systemctl status nginx
   ```

### Problem: SSL sertifikası hata veriyor

**Çözüm:**
```bash
# Sertifikayı yeniden dene
sudo certbot --nginx -d serverlistrank.com -d www.serverlistrank.com --force-renewal

# Nginx'i yeniden başlat
sudo systemctl restart nginx
```

---

## 🔄 Güncelleme Yapmak

### Kod güncellemesi:

```bash
cd /var/www/minecraft-server-list

# Git üzerinden güncelle (eğer repo kullanıyorsanız)
git pull

# Frontend güncelle
cd frontend
yarn install
yarn build
pm2 restart minecraft-frontend

# Backend güncelle
cd ../backend
source venv/bin/activate
pip install -r requirements.txt
pm2 restart minecraft-backend
```

---

## 📊 Performans İzleme

### PM2 Plus (Opsiyonel - Ücretsiz)

```bash
pm2 register
# Ekranda çıkan linke gidin ve hesap oluşturun
# Web arayüzünden tüm metriklerinizi izleyebilirsiniz
```

---

## 🗄️ Backup Alma

### Otomatik backup scripti:

```bash
# Backup script oluştur
sudo nano /root/backup.sh
```

İçeriği:
```bash
#!/bin/bash
DATE=$(date +%Y-%m-%d-%H%M)
BACKUP_DIR="/root/backups"
mkdir -p $BACKUP_DIR

# Uygulama dosyalarını yedekle
tar -czf $BACKUP_DIR/app-backup-$DATE.tar.gz /var/www/minecraft-server-list

# Eski yedekleri sil (30 günden eski)
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete

echo "Backup tamamlandı: $DATE"
```

Cron ile otomatikleştir:
```bash
crontab -e

# Her gün saat 03:00'te backup al
0 3 * * * /root/backup.sh
```

---

## 📞 Destek

Sorun yaşarsanız:
1. Yukarıdaki sorun giderme adımlarını deneyin
2. Logları kontrol edin: `pm2 logs`
3. Sistem kaynaklarını kontrol edin: `htop`

---

## 🎉 Tebrikler!

Minecraft Server List uygulamanız artık canlıda! 🚀

**Siteniz:** https://serverlistrank.com

**Admin Panel:** https://serverlistrank.com/admin

---

**Not:** Bu kurulum production-ready bir yapıdır. Monitoring, backup ve güvenlik önlemleri dahildir.
