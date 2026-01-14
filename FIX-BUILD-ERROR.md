# 🔧 Build Hatası Düzeltme Rehberi

## Hata: "Module not found: Can't resolve '../../../../lib/supabase.js'"

Bu hata, Next.js build sırasında environment variable'ların yüklenmemesinden kaynaklanıyor.

---

## ✅ ÇÖZÜM 1: Manuel Düzeltme (VPS'teyseniz)

Eğer script sırasında bu hatayı aldıysanız ve VPS'teyseniz:

### Adım 1: Frontend dizinine gidin
```bash
cd /var/www/minecraft-server-list/frontend
```

### Adım 2: Tüm env dosyalarını oluşturun

```bash
# .env.local oluştur
cat > .env.local << 'EOF'
NEXT_PUBLIC_SUPABASE_URL=https://oouyxbznjuomqxosrkid.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzUwOTAsImV4cCI6MjA4Mjk1MTA5MH0.7E-QNxKZYtquOYnz7t7igwLe_E28iNFHvGY54kedvXs
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzM3NTA5MCwiZXhwIjoyMDgyOTUxMDkwfQ.eFC8yP9NNqTSkjRMgJQ3ZDaufLSS6HZB9dkDLODpBHc
CORS_ORIGINS=https://serverlistrank.com,https://www.serverlistrank.com
EOF

# .env.production oluştur
cat > .env.production << 'EOF'
NEXT_PUBLIC_SUPABASE_URL=https://oouyxbznjuomqxosrkid.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzUwOTAsImV4cCI6MjA4Mjk1MTA5MH0.7E-QNxKZYtquOYnz7t7igwLe_E28iNFHvGY54kedvXs
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzM3NTA5MCwiZXhwIjoyMDgyOTUxMDkwfQ.eFC8yP9NNqTSkjRMgJQ3ZDaufLSS6HZB9dkDLODpBHc
CORS_ORIGINS=https://serverlistrank.com,https://www.serverlistrank.com
EOF

# .env oluştur (backup)
cat > .env << 'EOF'
NEXT_PUBLIC_SUPABASE_URL=https://oouyxbznjuomqxosrkid.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzUwOTAsImV4cCI6MjA4Mjk1MTA5MH0.7E-QNxKZYtquOYnz7t7igwLe_E28iNFHvGY54kedvXs
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzM3NTA5MCwiZXhwIjoyMDgyOTUxMDkwfQ.eFC8yP9NNqTSkjRMgJQ3ZDaufLSS6HZB9dkDLODpBHc
CORS_ORIGINS=https://serverlistrank.com,https://www.serverlistrank.com
EOF
```

### Adım 3: Environment variable'ları export edin

```bash
export NEXT_PUBLIC_SUPABASE_URL=https://oouyxbznjuomqxosrkid.supabase.co
export NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzUwOTAsImV4cCI6MjA4Mjk1MTA5MH0.7E-QNxKZYtquOYnz7t7igwLe_E28iNFHvGY54kedvXs
export SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdXl4YnpuanVvbXF4b3Nya2lkIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzM3NTA5MCwiZXhwIjoyMDgyOTUxMDkwfQ.eFC8yP9NNqTSkjRMgJQ3ZDaufLSS6HZB9dkDLODpBHc
```

### Adım 4: Kontrol edin

```bash
# Dosyaların varlığını kontrol et
ls -la .env*

# lib/supabase.js dosyasını kontrol et
ls -la lib/supabase.js

# Env variable'ları kontrol et
echo $NEXT_PUBLIC_SUPABASE_URL
```

### Adım 5: Build'i tekrar çalıştırın

```bash
yarn build
```

### Adım 6: PM2 ile başlatın

```bash
# Ana dizine dön
cd /var/www/minecraft-server-list

# PM2'yi başlat
pm2 start ecosystem.config.js
pm2 save
```

---

## ✅ ÇÖZÜM 2: Script'i Tekrar Çalıştırın

Güncellenmiş script'i çalıştırın:

```bash
cd /root
sudo bash deploy-to-vps.sh
```

Yeni script otomatik olarak:
- ✓ Tüm env dosyalarını oluşturur (.env.local, .env.production, .env)
- ✓ Build öncesi environment variable'ları export eder
- ✓ PM2 config'inde env variable'ları ayarlar

---

## ✅ ÇÖZÜM 3: Dosyaları Kontrol Edin

Eğer hala sorun devam ediyorsa:

```bash
cd /var/www/minecraft-server-list/frontend

# 1. lib/supabase.js var mı?
if [ -f lib/supabase.js ]; then
    echo "✓ lib/supabase.js MEVCUT"
else
    echo "✗ lib/supabase.js EKSIK!"
    echo "Projeyi yeniden kopyalayın!"
fi

# 2. Node modules kurulu mu?
if [ -d node_modules ]; then
    echo "✓ node_modules MEVCUT"
else
    echo "✗ node_modules EKSIK!"
    yarn install
fi

# 3. Env dosyaları var mı?
ls -la .env* 2>/dev/null || echo "✗ ENV DOSYALARI EKSIK!"
```

---

## 🔍 Neden Bu Hata Oluyor?

Next.js build process'i 3 aşamada çalışır:

1. **Build Time** - Kodun compile edildiği aşama
   - `.env.production` veya export edilen env'ler kullanılır
   - `NEXT_PUBLIC_*` prefix'li değişkenler build'e embed edilir

2. **Runtime** - Uygulamanın çalıştığı aşama
   - `.env.local` veya PM2 env'leri kullanılır
   - Server-side değişkenler runtime'da okunur

3. **Problem**: `.env.local` sadece runtime'da okunur, build time'da değil!

**Çözüm**: Hem `.env.production` hem de export kullanarak her iki aşamayı da karşılıyoruz.

---

## 📊 Başarı Kontrolü

Build başarılı olduğunda göreceğiniz çıktı:

```
✓ Compiled successfully
✓ Collecting page data
✓ Generating static pages (15/15)
✓ Finalizing page optimization

Route (app)                              Size     First Load JS
┌ ○ /                                    5.2 kB          87 kB
├ ○ /admin                               2.1 kB          85 kB
└ ○ /api/servers                         0 B             0 B

○  (Static)  prerendered as static content
```

---

## 🆘 Hala Çalışmıyor mu?

### Debug Adımları:

```bash
# 1. Detaylı build log
cd /var/www/minecraft-server-list/frontend
yarn build 2>&1 | tee build.log

# 2. Supabase bağlantısını test et
node -e "
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
console.log('Supabase URL:', supabaseUrl);
"

# 3. Module resolution test
node -e "
try {
  const path = './lib/supabase.js';
  require(path);
  console.log('✓ Module bulundu');
} catch (e) {
  console.log('✗ Module bulunamadı:', e.message);
}
"
```

### Son Çare: Temiz Kurulum

```bash
cd /var/www/minecraft-server-list/frontend

# Node modules'ı temizle
rm -rf node_modules .next

# Yeniden yükle
yarn install

# Build
yarn build
```

---

## 📞 Destek

Sorun devam ederse:
- Build log'unu kaydedin: `yarn build > build.log 2>&1`
- Env dosyalarını listeleyin: `ls -la .env*`
- lib/supabase.js içeriğini kontrol edin: `cat lib/supabase.js`

Bu bilgileri paylaşın, yardımcı olalım!

---

**Güncellenmiş script'i kullanırsanız bu sorun otomatik çözülür! 🚀**
