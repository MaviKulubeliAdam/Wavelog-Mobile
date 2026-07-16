# Wavelog Mobile v3.0.2 (build 27) — Sürüm Notları

Play Console'a yapıştırmaya hazır; her blok 500 karakter sınırının altındadır.

## 🇹🇷 Türkçe (tr-TR)

```
• Çevrimdışı kaydedilen QSO'lar artık otomatik senkronize ediliyor (ekleme ve silme)
• ADIF içe/dışa aktarmada Türkçe ve Lehçe karakter sorunları giderildi
• Logbook'ta arama ve filtreleme artık anında çalışıyor
• QSO ekleme ve ana ekranda performans iyileştirmeleri
• DX spot band filtresi düzeltildi
• Bağlantı zaman aşımında QSO kaybı, açılışta takılma ve birçok hata giderildi
```

## 🇬🇧 English (en-US)

```
• QSOs logged offline now sync automatically (adds & deletes)
• Fixed Turkish/Polish characters in ADIF import & export
• Logbook search & filtering is now instant
• Performance improvements on the Add QSO and home screens
• Fixed the DX spot band filter
• Fixed QSO loss on connection timeout, startup freeze and many other bugs
```

## 🇵🇱 Polski (pl-PL)

```
• QSO zapisane offline są teraz synchronizowane automatycznie (dodawanie i usuwanie)
• Poprawiono polskie i tureckie znaki w imporcie/eksporcie ADIF
• Wyszukiwanie i filtrowanie dziennika działa teraz natychmiast
• Poprawiona wydajność ekranu dodawania QSO i ekranu głównego
• Naprawiono filtr pasma w spotach DX
• Naprawiono utratę QSO przy przekroczeniu limitu czasu, zawieszanie przy starcie i wiele innych błędów
```

---

## Geliştirici değişiklik günlüğü (dahili)

### Hata düzeltmeleri
- Zaman aşımında QSO artık yerel kayda düşüyor — veri kaybı yok (`TimeoutException` yakalama)
- Çevrimdışı silinen QSO'lar için bekleyen-silme kuyruğu; bağlantı gelince sunucuda da siliniyor
- Bekleyen kayıt/silme senkronu logbook yenilemesine bağlandı (önceden hiç çağrılmıyordu)
- ADIF alan uzunlukları UTF-8 bayt olarak yazılıyor; dosya okuma UTF-8 çözüyor
- `TIME_ON` saniyeleri okunuyor — aynı dakikadaki QSO'lar önbellekte çakışmıyor
- DX spot filtresinde `copyWith` hatası (mod/sıralama değişince band sıfırlanıyordu)
- Splash, ayar yükleme hatasında sonsuza dek beklemiyor
- Auto-spot cooldown durumu açılışta yarış durumuna düşmüyor
- POTA/SOTA referans aramasında ağ hatası "bulunamadı" olarak gösterilmiyor
- Gradle `versionName` artık pubspec'ten geliyor (2.2.8'de sabitlenmişti)

### Performans
- Tema/ayar değişimi ağ katmanını yeniden kurmuyor (`select` ile hedefli izleme)
- Logbook arama/filtre tamamen yerel — sunucu çekimi yalnızca yenilemede
- Hive önbelleği fark tabanlı yazılıyor; değişmeyen kayıtlar diske dokunmuyor
- QSO ekleme ekranındaki canlı saat izole edildi (form saniyede bir çizilmiyor)
- Ana ekran her çizimde tüm önbelleği taramıyor

### Diğer
- Spot ekranı tek generic yapıda birleştirildi (~700 satır tekrar kaldırıldı)
- Band-frekans tablosu ve UTC ayrıştırıcı tekilleştirildi
- Kullanılmayan kod kaldırıldı; sabit Türkçe metinler EN/PL çevirileriyle l10n'e taşındı
- İşlevsiz "UTC Zaman Kullan" ayarı kaldırıldı
