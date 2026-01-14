# ⚡ HIZLI BAŞLANGIÇ - 3 Adımda Kurulum

## 🎯 Tek Komutla Kurulum

Bu 3 adımı takip edin, 10 dakika sonra siteniz hazır!

---

## 📱 ADIM 1: VPS'e Bağlanın

Terminal veya PuTTY ile:

```bash
ssh root@VPS_IP_ADRESINIZ
```

**Şifrenizi girin** ve Enter'a basın.

---

## 📦 ADIM 2: Script Dosyasını Oluşturun

### Yöntem A: Tek komut (kopyala-yapıştır)

```bash
cd /root && curl -o deploy-to-vps.sh https://raw.githubusercontent.com/KULLANICI/REPO/main/deploy-to-vps.sh && chmod +x deploy-to-vps.sh
```

### Yöntem B: Manuel (daha güvenli)

```bash
cd /root
nano deploy-to-vps.sh
```

**`deploy-to-vps.sh` dosyasının TAMAMINI kopyalayıp yapıştırın**

Kaydetmek için:
- `Ctrl + O` (kaydet)
- `Enter` (onayla)  
- `Ctrl + X` (çık)

Yürütme izni verin:
```bash
chmod +x deploy-to-vps.sh
```

---

## 🚀 ADIM 3: Kurulumu Başlatın

```bash
sudo bash deploy-to-vps.sh
```

**İşlem süresi:** 5-10 dakika

Kurulum sırasında ekranda:
- ✅ Yeşil: Başarılı adımlar
- ⚠️ Sarı: Bilgilendirme
- ❌ Kırmızı: Hata (varsa)

---

## 🔒 BONUS: SSL (HTTPS) Kurulumu

Kurulum tamamlandıktan sonra:

```bash
sudo certbot --nginx -d serverlistrank.com -d www.serverlistrank.com
```

**E-posta sorarsa:** admin@serverlistrank.com (veya kendi e-postanız)

**Sertifika otomatik yenileme:**
```bash
sudo certbot renew --dry-run
```

---

## ✅ Test Edin

### 1. Tarayıcıda açın:
- http://serverlistrank.com
- https://serverlistrank.com (SSL sonrası)

### 2. Durum kontrolü:
```bash
pm2 status
```

**Beklenen:**
```
minecraft-frontend   │ online
minecraft-backend    │ online
```

### 3. Logları görün:
```bash
pm2 logs
```

---

## 🎉 Tamamlandı!

Siteniz yayında! 🚀

**Admin Panel:** https://serverlistrank.com/admin

---

## 🛠️ Hızlı Komutlar

```bash
# Durumu kontrol et
pm2 status

# Yeniden başlat
pm2 restart all

# Logları görüntüle
pm2 logs

# Nginx durumu
sudo systemctl status nginx
```

---

## ❓ Sorun mu var?

**Frontend açılmıyorsa:**
```bash
pm2 restart minecraft-frontend
pm2 logs minecraft-frontend
```

**502 Bad Gateway:**
```bash
pm2 restart all
sudo systemctl restart nginx
```

**Domain açılmıyorsa:**
```bash
# DNS kontrol
nslookup serverlistrank.com

# Firewall kontrol
sudo ufw status
```

---

## 📚 Daha Fazla Bilgi

Detaylı rehber: `VPS-KURULUM-REHBERI.md`

---

**Başarılar! 🎊**
