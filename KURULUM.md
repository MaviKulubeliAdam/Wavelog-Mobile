# Wavelog Mobile - Kurulum Talimatları

## Gereksinimler

1. **Flutter SDK** kurulumu:
   - https://docs.flutter.dev/get-started/install/windows adresinden indirin
   - ZIP'i çıkartın, örneğin `C:\flutter`
   - PATH'e ekleyin: `C:\flutter\bin`
   - `flutter doctor` çalıştırarak doğrulayın

2. **Android Studio** veya Android SDK:
   - https://developer.android.com/studio adresinden indirin
   - Android SDK + emülatör veya gerçek cihaz

3. **Java JDK 17** (Android derleme için gerekli)

---

## Proje Kurulum Adımları

### 1. Flutter Projesini Başlatın

Bu klasörde (`wavelog_mobile/`) terminal açın ve:

```powershell
# Bağımlılıkları yükleyin
flutter pub get

# Kod üretimi çalıştırın (Hive adaptörleri zaten elle yazıldı, bu adım opsiyonel)
# dart run build_runner build --delete-conflicting-outputs
```

### 2. Android Cihaz/Emülatör Bağlayın

```powershell
# Bağlı cihazları listele
flutter devices

# Emülatör başlat
flutter emulators --launch <emulator_id>
```

### 3. Uygulamayı Çalıştırın

```powershell
# Debug modda çalıştır
flutter run

# Release APK derle
flutter build apk --release --split-per-abi

# APK konumu:
# build\app\outputs\flutter-apk\app-arm64-v8a-release.apk
# build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk
```

---

## İlk Kullanım

1. Uygulamayı açın → Ayarlar ekranı açılır
2. **Wavelog Sunucu URL**: `https://sizin-wavelog-sunucunuz.com`
3. **API Anahtarı**: Wavelog'dan alın: Ayarlar → API Keys → Read/Write key
4. **"Bağlantıyı Test Et"** butonuna tıklayın
5. İstasyon seçin/oluşturun
6. Ana sayfaya gidin, QSO ekleyin!

---

## Özellikler

| Özellik | Durum |
|---|---|
| QSO Ekleme | ✅ |
| QSO Listesi + Filtre | ✅ |
| Çağrı İşareti Sorgulama (QRZ.com via Wavelog) | ✅ |
| İstasyon Oluşturma/Seçme | ✅ |
| ADIF İçe Aktarma | ✅ |
| ADIF Dışa Aktarma + Paylaşım | ✅ |
| Offline Mod + Senkronizasyon | ✅ |
| İstatistik Kartları | ✅ |
| Koyu/Açık Tema | ✅ |

---

## Sorun Giderme

### `flutter doctor` hataları
- Android SDK bulunamıyorsa: Android Studio'yu kurun
- Chrome eksikse: Web desteği gerekmiyorsa görmezden gelin

### Derleme hataları
```powershell
flutter clean
flutter pub get
flutter run
```

### API bağlantı hatası
- Wavelog URL'nin `https://` ile başladığından emin olun
- API key'in Read/Write yetkisi olduğundan emin olun
- Wavelog sunucunuzun dışarıdan erişilebilir olduğunu kontrol edin
