# 🌐 DNS Ayarları Rehberi

## Domain: serverlistrank.com

---

## 📋 Yapılması Gerekenler

VPS'inizdeki uygulamanın domain adıyla çalışması için DNS kayıtlarını doğru yapılandırmalısınız.

---

## 🎯 Gerekli DNS Kayıtları

Domain sağlayıcınızın (GoDaddy, Namecheap, vb.) panel'ine giriş yapın ve aşağıdaki kayıtları ekleyin:

### 1. A Kaydı (Ana domain)

```
Type: A
Name: @
Value: VPS_IP_ADRESINIZ
TTL: 3600 (veya Auto)
```

**Örnek:**
```
Type: A
Name: @
Value: 123.456.789.100
TTL: 3600
```

### 2. A Kaydı (www subdomain)

```
Type: A
Name: www
Value: VPS_IP_ADRESINIZ
TTL: 3600
```

**Örnek:**
```
Type: A  
Name: www
Value: 123.456.789.100
TTL: 3600
```

### 3. CNAME Kaydı (Alternatif - www için)

A kaydı yerine CNAME de kullanabilirsiniz:

```
Type: CNAME
Name: www
Value: serverlistrank.com
TTL: 3600
```

---

## ⏱️ Propagasyon Süresi

DNS değişikliklerinin dünya genelinde yayılması:
- **Minimum:** 5-10 dakika
- **Maksimum:** 48 saat (genelde 2-4 saat)

---

## ✅ DNS Kontrolü

### Yöntem 1: Terminal ile

VPS'inizde veya lokal bilgisayarınızda:

```bash
# Domain IP kontrolü
nslookup serverlistrank.com

# www subdomain kontrolü
nslookup www.serverlistrank.com

# Detaylı DNS bilgisi
dig serverlistrank.com
```

**Beklenen çıktı:**
```
Server:         8.8.8.8
Address:        8.8.8.8#53

Non-authoritative answer:
Name:   serverlistrank.com
Address: VPS_IP_ADRESINIZ
```

### Yöntem 2: Online araçlar

Tarayıcınızda şu sitelere gidin:

1. **DNS Checker:** https://dnschecker.org/
   - Domain: `serverlistrank.com` yazın
   - Dünya genelindeki propagasyonu görebilirsiniz

2. **What's My DNS:** https://www.whatsmydns.net/
   - Domain adınızı kontrol edin

3. **MXToolbox:** https://mxtoolbox.com/DNSLookup.aspx
   - Detaylı DNS analizi

---

## 🔧 Popüler DNS Sağlayıcıları için Rehberler

### GoDaddy

1. https://dcc.godaddy.com/control/portfolio/dns adresine gidin
2. Domain adınızı seçin
3. "DNS" sekmesine tıklayın
4. "Add" butonuna tıklayın
5. Yukarıdaki kayıtları ekleyin

### Namecheap

1. Namecheap hesabınıza giriş yapın
2. "Domain List" → Domain seçin
3. "Advanced DNS" sekmesine gidin
4. "Add New Record" ile kayıtları ekleyin

### Cloudflare (Önerilen)

1. Cloudflare'e domain ekleyin (ücretsiz)
2. Nameserver'ları değiştirin (Cloudflare vereceği)
3. DNS kayıtlarını Cloudflare'den yönetin
4. **Bonus:** Ücretsiz CDN + DDoS koruması

**Cloudflare Kurulum:**
```
1. https://dash.cloudflare.com/ → Add Site
2. Domain adınızı girin: serverlistrank.com
3. Free plan seçin
4. DNS kayıtlarını otomatik bulacak, kontrol edin
5. Cloudflare'in verdiği nameserver'ları domain sağlayıcınızda güncelleyin
6. 24 saat içinde aktif olur
```

---

## 📊 DNS Kayıt Örnekleri (Tam Liste)

| Type  | Name | Value            | TTL  | Açıklama           |
|-------|------|------------------|------|--------------------|  
| A     | @    | 123.456.789.100  | 3600 | Ana domain         |
| A     | www  | 123.456.789.100  | 3600 | www subdomain      |
| A     | *    | 123.456.789.100  | 3600 | Wildcard (opsiyonel) |

**Wildcard (*):** Tüm subdomain'leri (api.serverlistrank.com, test.serverlistrank.com vb.) VPS'e yönlendirir.

---

## 🔒 SSL Sertifikası için Gereksinimler

Let's Encrypt SSL sertifikası alabilmek için:

1. ✅ DNS kayıtları doğru yapılandırılmış olmalı
2. ✅ Domain VPS IP'sine yönlendirilmiş olmalı
3. ✅ 80 ve 443 portları açık olmalı

**Kontrol:**
```bash
# Domain'in IP'sini kontrol et
curl -I http://serverlistrank.com

# VPS'ten test et
curl -I http://$(hostname -I | awk '{print $1}')
```

Her ikisi de aynı sonucu veriyorsa DNS doğru yapılandırılmış demektir.

---

## ⚠️ Yaygın Hatalar

### Hata 1: Nameserver'lar yanlış

**Kontrol:**
```bash
nslookup -type=ns serverlistrank.com
```

Domain sağlayıcınızın nameserver'larını göstermeli.

### Hata 2: Eski IP kayıtlı

**Çözüm:** 
- DNS kayıtlarını sil ve yeniden ekle
- TTL'yi düşür (300 saniye)
- 10 dakika bekle

### Hata 3: DNS cache

**Lokal cache temizleme:**

```bash
# Linux/Mac
sudo systemd-resolve --flush-caches

# Mac
sudo dscacheutil -flushcache

# Windows
ipconfig /flushdns
```

---

## 🎯 Kurulum Sonrası Kontrol Listesi

- [ ] A kaydı (@ → VPS IP) eklendi
- [ ] A kaydı (www → VPS IP) eklendi  
- [ ] `nslookup serverlistrank.com` doğru IP gösteriyor
- [ ] `nslookup www.serverlistrank.com` doğru IP gösteriyor
- [ ] http://serverlistrank.com tarayıcıda açılıyor
- [ ] http://www.serverlistrank.com tarayıcıda açılıyor
- [ ] SSL sertifikası kuruldu (https çalışıyor)

---

## 📞 Destek

DNS ayarlarında sorun yaşıyorsanız:

1. Domain sağlayıcınızın destek ekibine ulaşın
2. "A kaydı eklemek istiyorum" deyin ve VPS IP'nizi verin
3. Cloudflare kullanmayı düşünün (daha kolay yönetim)

---

## 🎉 Sonuç

DNS ayarları doğru yapıldıktan sonra:

✅ http://serverlistrank.com → VPS'inize yönlendirilecek
✅ SSL kurulumu yapılabilecek
✅ https://serverlistrank.com çalışacak

**Şimdi VPS kurulumuna geçebilirsiniz!**

Rehber: `HIZLI-BASLANGIC.md`
