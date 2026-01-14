# 🔄 Deploy Script Güncellemeleri

## 📅 Tarih: 14 Ocak 2025

---

## ✅ Yapılan İyileştirmeler

### 1. Environment Variable Yönetimi
**Sorun:** Build sırasında `.env.local` okunmuyordu
**Çözüm:** 
- ✓ `.env.production` dosyası eklendi
- ✓ Build öncesi env variable'lar export ediliyor
- ✓ PM2 config'inde env'ler tanımlandı

### 2. Build Hata Kontrolü
**Eklenen:**
- ✓ Env dosyalarının varlık kontrolü
- ✓ lib/supabase.js kontrolü
- ✓ Build başarısızlığında detaylı hata mesajı

### 3. PM2 Configuration
**Güncellenen:**
- ✓ Frontend için env variable'lar eklendi
- ✓ Backend için env variable'lar eklendi
- ✓ Runtime'da doğru değerlerin kullanılması sağlandı

---

## 🎯 Çözülen Problemler

### Problem 1: Build Hatası
```
Error: Module not found: Can't resolve '../../../../lib/supabase.js'
```

**Neden:** Next.js build time'da `.env.local` okumuyordu
**Çözüm:** `.env.production` + export ile build time env'leri sağlandı

### Problem 2: Runtime Env Eksikliği
**Neden:** PM2 config'de env variable'lar yoktu
**Çözüm:** Ecosystem config'e tüm env'ler eklendi

---

## 📦 Yeni Dosyalar

1. **FIX-BUILD-ERROR.md** - Build hatası düzeltme rehberi
2. **GUNCELLEMELER.md** - Bu dosya
3. **deploy-to-vps.sh** - Güncellenmiş deployment script

---

## 🚀 Kullanım

### Yeni Script'i Kullanın

```bash
cd /root

# Script'i kopyalayın
# (Git, SCP veya manuel)

chmod +x deploy-to-vps.sh
sudo bash deploy-to-vps.sh
```

---

## 🔄 Mevcut Kurulumu Güncelleme

Eğer script'i zaten çalıştırdıysanız ve hata aldıysanız:

```bash
cd /var/www/minecraft-server-list/frontend

# 1. Env dosyalarını oluştur
cat > .env.production << 'ENVEOF'
NEXT_PUBLIC_SUPABASE_URL=https://oouyxbznjuomqxosrkid.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzUwOTAsImV4cCI6MjA4Mjk1MTA5MH0.7E-QNxKZYtquOYnz7t7igwLe_E28iNFHvGY54kedvXs
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzM3NTA5MCwiZXhwIjoyMDgyOTUxMDkwfQ.eFC8yP9NNqTSkjRMgJQ3ZDaufLSS6HZB9dkDLODpBHc
CORS_ORIGINS=https://serverlistrank.com,https://www.serverlistrank.com
ENVEOF

# 2. Export et
export NEXT_PUBLIC_SUPABASE_URL=https://oouyxbznjuomqxosrkid.supabase.co
export NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzUwOTAsImV4cCI6MjA4Mjk1MTA5MH0.7E-QNxKZYtquOYnz7t7igwLe_E28iNFHvGY54kedvXs
export SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY3NjczNzUwOTAsImV4cCI6MjA4Mjk1MTA5MH0.eFC8yP9NNqTSkjRMgJQ3ZDaufLSS6HZB9dkDLODpBHc

# 3. Build
yarn build

# 4. PM2 restart
cd /var/www/minecraft-server-list
pm2 restart all
```

---

## 📊 Karşılaştırma

| Özellik | Eski Script | Yeni Script |
|---------|-------------|-------------|
| .env.production | ❌ | ✅ |
| Build time exports | ❌ | ✅ |
| PM2 env variables | Kısmi | Tam |
| Hata kontrolleri | Minimal | Detaylı |
| lib/supabase.js check | ❌ | ✅ |
| Build error handling | ❌ | ✅ |

---

## 🆘 Sorun Giderme

Hala sorun varsa:
1. `FIX-BUILD-ERROR.md` dosyasını okuyun
2. `pm2 logs` ile logları kontrol edin
3. Build log'unu kaydedin: `yarn build 2>&1 | tee build.log`

---

**Güncellenmiş script ile sorunsuz deployment! 🎉**
