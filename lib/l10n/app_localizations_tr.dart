// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Wavelog Mobile';

  @override
  String get splashConnecting => 'BAĞLANIYOR';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navLogbook => 'Logbook';

  @override
  String get navLookup => 'Sorgula';

  @override
  String get navStation => 'İstasyon';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get refresh => 'Yenile';

  @override
  String get continueBtn => 'Devam Et';

  @override
  String get close => 'Kapat';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get error => 'Hata';

  @override
  String get success => 'Başarılı';

  @override
  String get change => 'Değiştir';

  @override
  String get goWeb => 'Git →';

  @override
  String get editOnWeb => 'Web\'de Düzenle';

  @override
  String get openInBrowser => 'Tarayıcıda Aç';

  @override
  String get serverSetupTitle => 'Sunucu Kurulumu';

  @override
  String get serverSetupSubtitle => 'Wavelog sunucunuzu yapılandırın';

  @override
  String get serverUrlLabel => 'Wavelog Sunucu URL';

  @override
  String get serverUrlHint => 'https://log.example.com';

  @override
  String get testConnection => 'Bağlantıyı Test Et';

  @override
  String get testingConnection => 'Test ediliyor...';

  @override
  String get connectionSuccess => 'Bağlantı başarılı!';

  @override
  String get connectionFailed => 'Bağlantı başarısız';

  @override
  String get apiKeyCopied => 'API anahtarı kopyalandı';

  @override
  String get loginTitle => 'Giriş';

  @override
  String get serverBtn => 'Sunucu';

  @override
  String get addAccountBtn => 'Hesap Ekle';

  @override
  String get signInBtn => 'Giriş Yap';

  @override
  String get deleteProfile => 'Sil';

  @override
  String get deleteProfileTitle => 'Hesabı Sil';

  @override
  String deleteProfileConfirm(String name) {
    return '$name bu cihazdan kaldırılsın mı?';
  }

  @override
  String get displayName => 'Görünen Ad';

  @override
  String get callsign => 'Çağrı İşareti';

  @override
  String get apiKeyLabel => 'API Anahtarı';

  @override
  String get validating => 'Doğrulanıyor...';

  @override
  String get profileSaved => 'Hesap kaydedildi';

  @override
  String get loginFailed => 'Giriş başarısız';

  @override
  String get noStationFound =>
      'Eşleşen istasyon bulunamadı — çağrı işareti kullanılıyor';

  @override
  String get homeTitle => 'Ana Sayfa';

  @override
  String get addQso => 'QSO Ekle';

  @override
  String get recentQsos => 'Son QSOlar';

  @override
  String get statsToday => 'Bugün';

  @override
  String get statsMonth => 'Bu Ay';

  @override
  String get statsYear => 'Bu Yıl';

  @override
  String get statsTotal => 'Toplam';

  @override
  String get noRecentQsos => 'Henüz QSO yok';

  @override
  String get syncNow => 'Şimdi Senkronize Et';

  @override
  String pendingSync(int count) {
    return '$count QSO senkronize edilmeyi bekliyor';
  }

  @override
  String get offlineBanner => 'Çevrimdışı — QSOlar yerel olarak kaydedildi';

  @override
  String get activeStation => 'Aktif istasyon';

  @override
  String get logbookTitle => 'Logbook';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterAllModes => 'Tüm Modlar';

  @override
  String get searchHint => 'Çağrı işareti ara...';

  @override
  String get noQsos => 'QSO bulunamadı';

  @override
  String get qsoDetailTitle => 'QSO Detayı';

  @override
  String get qsoNotFound => 'QSO bulunamadı';

  @override
  String get signal => 'Sinyal';

  @override
  String get rstSent => 'RST Gönderilen';

  @override
  String get rstReceived => 'RST Alınan';

  @override
  String get txPower => 'TX Gücü';

  @override
  String get counterStation => 'Karşı İstasyon';

  @override
  String get country => 'Ülke';

  @override
  String get continent => 'Kıta';

  @override
  String get dxcc => 'DXCC';

  @override
  String get cqZone => 'CQ Bölgesi';

  @override
  String get ituZone => 'ITU Bölgesi';

  @override
  String get gridSquare => 'Grid Kare';

  @override
  String get propMode => 'Yayılım';

  @override
  String get distance => 'Mesafe';

  @override
  String get qslStatus => 'QSL Durumu';

  @override
  String get paperQsl => 'Kağıt';

  @override
  String get lotwQsl => 'LoTW';

  @override
  String get eqslQsl => 'eQSL';

  @override
  String get qrzQsl => 'QRZ.com';

  @override
  String get clublog => 'Club Log';

  @override
  String get hrdlog => 'HRDLog';

  @override
  String get qslSent => 'Gönderildi';

  @override
  String get qslReceived => 'Alındı';

  @override
  String get qslMethod => 'Yöntem';

  @override
  String get awards => 'Ödül Referansları';

  @override
  String get iota => 'IOTA';

  @override
  String get sota => 'SOTA';

  @override
  String get wwff => 'WWFF';

  @override
  String get pota => 'POTA';

  @override
  String get myStation => 'Kendi İstasyonum';

  @override
  String get myCallsign => 'Çağrı İşaretim';

  @override
  String get contest => 'Yarışma';

  @override
  String get serialSent => 'Gönderilen Seri';

  @override
  String get serialReceived => 'Alınan Seri';

  @override
  String get solarConditions => 'Uzay Havası';

  @override
  String get aIndex => 'A-Endeksi';

  @override
  String get kIndex => 'K-Endeksi';

  @override
  String get sfi => 'SFI';

  @override
  String get notesSection => 'Notlar';

  @override
  String get rawAdif => 'Ham ADIF';

  @override
  String get showAll => 'Tümünü Göster';

  @override
  String get showLess => 'Daha Az Göster';

  @override
  String get qrzProfile => 'QRZ Profili';

  @override
  String get addQsoTitle => 'QSO Ekle';

  @override
  String get liveQso => 'Anlık QSO';

  @override
  String get historicalQso => 'Geçmiş QSO';

  @override
  String get callsignField => 'Çağrı İşareti *';

  @override
  String get lookupSearch => 'QRZ Sorgula';

  @override
  String get liveDateTimeLabel => 'Tarih/Saat (UTC) — Anlık';

  @override
  String get dateTimeLabel => 'Tarih/Saat (UTC)';

  @override
  String get bandField => 'Bant *';

  @override
  String get modeField => 'Mod *';

  @override
  String get frequencyField => 'Frekans (MHz)';

  @override
  String get rstSentField => 'RST Gönderilen *';

  @override
  String get rstRcvdField => 'RST Alınan *';

  @override
  String get nameField => 'Ad';

  @override
  String get qthField => 'QTH';

  @override
  String get gridField => 'Grid Kare';

  @override
  String get commentField => 'Yorum';

  @override
  String get stationProfileField => 'İstasyon Profili';

  @override
  String get saveQsoBtn => 'QSO Kaydet';

  @override
  String qsoSaved(String callsign) {
    return '✓  $callsign kaydedildi';
  }

  @override
  String qsoSavedLocal(String callsign) {
    return '✓  $callsign yerel olarak kaydedildi';
  }

  @override
  String get noActiveStation => 'Aktif istasyon seçilmedi';

  @override
  String get lookupTitle => 'Çağrı Sorgula';

  @override
  String get lookupHint => 'Çağrı işareti girin...';

  @override
  String get lookupBtn => 'Sorgula';

  @override
  String get recentSearches => 'Son Sorgular';

  @override
  String get clearHistory => 'Geçmişi Temizle';

  @override
  String get makeQso => 'QSO Yap';

  @override
  String get notFound => 'Bulunamadı';

  @override
  String get stationsTitle => 'İstasyonlar';

  @override
  String stationActivated(String callsign) {
    return '$callsign aktif istasyon olarak seçildi';
  }

  @override
  String get stationWebInfo =>
      'İstasyon ekleme ve düzenleme işlemleri için Wavelog web arayüzünü kullanın.';

  @override
  String get noStations => 'Henüz istasyon yok';

  @override
  String get noStationsHint =>
      'Wavelog web arayüzü üzerinden istasyon ekleyin.';

  @override
  String get addStationOnWeb => 'Wavelog\'da İstasyon Ekle';

  @override
  String get adifTitle => 'ADIF İçe / Dışa Aktar';

  @override
  String get importTab => 'İçe Aktar';

  @override
  String get exportTab => 'Dışa Aktar';

  @override
  String get selectAdifFile => 'ADIF Dosyası Seç';

  @override
  String get selectFileBtn => 'Dosya Seç (.adi / .adif)';

  @override
  String get stationRequired => 'İstasyon Profili *';

  @override
  String importing(int done, int total) {
    return 'İçe aktarılıyor... $done/$total';
  }

  @override
  String get importBtn => 'İçe Aktar';

  @override
  String get exportFilters => 'Dışa Aktarma Filtreleri';

  @override
  String get stationFilter => 'İstasyon';

  @override
  String get allStations => 'Tüm İstasyonlar';

  @override
  String get startDate => 'Başlangıç';

  @override
  String get endDate => 'Bitiş';

  @override
  String get notSelected => 'Seçilmedi';

  @override
  String get clearDates => 'Tarihleri Temizle';

  @override
  String get exporting => 'Dışa aktarılıyor...';

  @override
  String get exportAndShare => 'Dışa Aktar ve Paylaş';

  @override
  String get copyPath => 'Yolu Kopyala';

  @override
  String get reshare => 'Tekrar Paylaş';

  @override
  String get pathCopied => 'Dosya yolu kopyalandı';

  @override
  String qsoExported(int count) {
    return '$count QSO dışa aktarıldı';
  }

  @override
  String get noStationForExport => 'Dışa aktarım için istasyon bulunamadı';

  @override
  String qsoImported(int imported, int total) {
    return '$imported / $total QSO aktarıldı';
  }

  @override
  String get selectSaveLocation => 'Kayıt konumunu seçin';

  @override
  String get copySuffix => '(Kopya)';

  @override
  String get errNetwork => 'Bağlantı yok — ağınızı kontrol edin';

  @override
  String get errTimeout => 'Bağlantı zaman aşımına uğradı';

  @override
  String get errUnauthorized => 'Geçersiz API anahtarı';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get connectionSection => 'Bağlantı';

  @override
  String get sessionSection => 'Oturum';

  @override
  String get loggedIn => 'Giriş yapıldı';

  @override
  String get logoutBtn => 'Çıkış Yap';

  @override
  String get logoutTitle => 'Çıkış Yap';

  @override
  String get logoutConfirm => 'Oturumu kapatmak istediğinizden emin misiniz?';

  @override
  String get switchAccountBtn => 'Hesap Değiştir';

  @override
  String get activeStationSection => 'Aktif İstasyon';

  @override
  String get selectStationBtn => 'İstasyon Seç';

  @override
  String get addStationWeb => 'Web\'de İstasyon Ekle';

  @override
  String get defaultsSection => 'Varsayılanlar';

  @override
  String get defaultBand => 'Varsayılan Bant';

  @override
  String get defaultMode => 'Varsayılan Mod';

  @override
  String get appSection => 'Uygulama';

  @override
  String get darkTheme => 'Koyu Tema';

  @override
  String get darkThemeHint => 'Saha kullanımı için önerilen';

  @override
  String get offlineMode => 'Offline Mod';

  @override
  String get offlineModeHint =>
      'Tüm QSOları önce yerel kaydet, sonra senkronize et';

  @override
  String get languageLabel => 'Dil';

  @override
  String get infoSection => 'Bilgi';

  @override
  String get aboutAppBtn => 'Uygulama Hakkında';

  @override
  String get aboutAppHint => 'Versiyon, geliştirici, lisans';

  @override
  String get dataSection => 'Veri';

  @override
  String get clearCacheBtn => 'QSO Önbelleğini Temizle';

  @override
  String get clearCacheHint => 'Yerel QSO önbelleğini siler';

  @override
  String get clearCacheTitle => 'Önbelleği Temizle';

  @override
  String get clearCacheConfirm =>
      'Yerel QSO önbelleği silinecek. Bu işlem geri alınamaz.';

  @override
  String get clearCacheAction => 'Temizle';

  @override
  String get cacheCleared => 'Önbellek temizlendi';

  @override
  String get langSystem => 'Sistem Varsayılanı';

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langPolish => 'Polski';

  @override
  String get aboutTitle => 'Uygulama Hakkında';

  @override
  String get appDescription => 'Wavelog için açık kaynak Android uygulaması';

  @override
  String versionLabel(String version, String build) {
    return 'Versiyon $version  (Build $build)';
  }

  @override
  String get mobileDeveloperSection => 'Mobil Uygulama Geliştirici';

  @override
  String get wavelogProjectSection => 'Wavelog Projesi';

  @override
  String get wavelogDescription => 'Web tabanlı amatör telsiz log sistemi';

  @override
  String get coreDevelopers => 'Çekirdek Geliştiriciler';

  @override
  String get mitLicense => 'MIT Lisansı';

  @override
  String get mitDescription =>
      'Bu uygulama ve Wavelog projesi MIT lisansı kapsamında dağıtılmaktadır. Açık kaynak olup herhangi bir garanti verilmemektedir.';

  @override
  String get licenseSection => 'Lisans';

  @override
  String get errorNoConnection => 'Bağlantı yok';

  @override
  String get errorUnauthorized => 'Yetkisiz — API anahtarını kontrol edin';

  @override
  String get errorServer => 'Sunucu hatası';

  @override
  String get patchRequiredTitle => 'Sunucu Patch\'i Gerekli';

  @override
  String get patchRequiredMessage =>
      'Düzenleme ve silme özellikleri için sunucunuza Wavelog Mobile API patch\'inin kurulu olması gerekiyor.\n\nKurulum talimatları için sp9aqg.pl/install.html adresini ziyaret edin.';

  @override
  String get patchRequiredBanner =>
      'Düzenleme ve silme özellikleri için sunucunuza Wavelog Mobile API patch\'inin kurulu olması gerekiyor.';

  @override
  String get patchViewGuide => 'Kurulum Kılavuzu';

  @override
  String get setupGuideTitle => 'Kurulum Rehberi';

  @override
  String get setupGuideIntro =>
      'QSO kaydetmeye başlamadan önce uygulamayı Wavelog sunucunuza bağlayın. Aşağıdaki adımları izleyin.';

  @override
  String get setupGuideStep1Title => '1. Sunucu Adresi';

  @override
  String get setupGuideStep1Body =>
      'Wavelog\'u tarayıcınızda açarken kullandığınız adresi yazın, örn: https://sizin-domaininiz.com — sonunda eğik çizgi (/) olmadan.';

  @override
  String get setupGuideStep2Title => '2. Sunucu Patch\'i (önce bunu yapın)';

  @override
  String get setupGuideStep2Body =>
      'API anahtarı oluşturmadan önce sunucunuza Wavelog Mobile API patch\'ini kurun. Talimatlar için aşağıya dokunun.';

  @override
  String get setupGuideStep3Title => '3. API Anahtarı';

  @override
  String get setupGuideStep3Body =>
      'Patch kurulduktan sonra Wavelog\'da Ayarlar → API Anahtarları bölümüne gidin ve \"Create a mobile app key\" butonuna tıklayın. Oluşan anahtarı API Anahtarı alanına yapıştırın.';

  @override
  String get setupGuideStep4Title => '4. Çağrı İşareti ve Görünen Ad';

  @override
  String get setupGuideStep4Body =>
      'Çağrı İşareti: kendi amatör telsiz çağrı işaretiniz, istasyonunuzu eşleştirmek için kullanılır. Görünen Ad: bu cihazdaki girişi tanımak için istediğiniz herhangi bir etiket.';

  @override
  String get setupGuideContinueBtn => 'Kuruluma Başla';

  @override
  String get appSubtitle => 'Amatör Telsiz Log Uygulaması';

  @override
  String get switchToLightTheme => 'Açık temaya geç';

  @override
  String get switchToDarkTheme => 'Koyu temaya geç';

  @override
  String get deleteQsoTitle => 'QSO Sil';

  @override
  String deleteQsoConfirm(String callsign, String date) {
    return '$callsign ile $date tarihli QSO kalıcı olarak silinsin mi?';
  }

  @override
  String get editTooltip => 'Düzenle';

  @override
  String get shareAdifTooltip => 'ADIF Paylaş';

  @override
  String get localNotSynced => 'Yerel kayıt — henüz senkronize edilmedi';

  @override
  String get satellite => 'Uydu';

  @override
  String get satelliteMode => 'Uydu Modu';

  @override
  String get antenna => 'Anten';

  @override
  String get nameLabel => 'Ad';

  @override
  String get stateProvince => 'Eyalet/İl';

  @override
  String get county => 'İlçe';

  @override
  String get city => 'Şehir';

  @override
  String get continentAF => 'Afrika';

  @override
  String get continentAN => 'Antarktika';

  @override
  String get continentAS => 'Asya';

  @override
  String get continentEU => 'Avrupa';

  @override
  String get continentNA => 'Kuzey Amerika';

  @override
  String get continentOC => 'Okyanusya';

  @override
  String get continentSA => 'Güney Amerika';

  @override
  String get qrzProfileLoading => 'QRZ profili yükleniyor...';

  @override
  String viewOnQrz(String callsign) {
    return 'QRZ.com\'da Görüntüle  ($callsign)';
  }

  @override
  String get qslMethods => 'QSL Yöntemleri';

  @override
  String get bureau => 'Büro';

  @override
  String qslManagerPrefix(String manager) {
    return 'Yönetici: $manager';
  }

  @override
  String get callsignCopied => 'Çağrı işareti kopyalandı';

  @override
  String get uploadedStatus => 'Yüklendi';

  @override
  String get notUploadedStatus => 'Yüklenmedi';

  @override
  String get matchedStatus => 'Eşleşti';

  @override
  String get toDeleteStatus => 'Silinecek';

  @override
  String get yes => 'Evet';

  @override
  String get requested => 'İstendi';

  @override
  String get no => 'Hayır';

  @override
  String get invalid => 'Geçersiz';

  @override
  String get viaDirect => 'Direkt';

  @override
  String get viaElectronic => 'Elektronik';

  @override
  String get viaMail => 'Posta';

  @override
  String otherAdifFields(int count) {
    return 'Diğer ADIF Alanları ($count)';
  }

  @override
  String get editQsoTitle => 'QSO Düzenle';

  @override
  String get qsoUpdated => 'QSO güncellendi';

  @override
  String get qsoUpdatedLocal => 'QSO yerel olarak güncellendi';

  @override
  String get counterStationHint =>
      'Çağrı işareti girilince QRZ\nbilgileri ve önceki QSO\'lar\nburada görünür.';

  @override
  String previousQsosCount(int count) {
    return 'Önceki QSO\'lar ($count)';
  }

  @override
  String morePreviousQsos(int count) {
    return '+$count daha...';
  }

  @override
  String previousQsosWithCallsign(String callsign) {
    return '$callsign ile önceki QSO\'lar';
  }

  @override
  String totalQsos(int count) {
    return '$count toplam';
  }

  @override
  String get workedBefore => 'Daha önce çalışıldı';

  @override
  String get lastQsoLabel => 'Son QSO';

  @override
  String get themeLabel => 'Tema';

  @override
  String get darkThemeActive => 'Koyu tema etkin';

  @override
  String get lightThemeActive => 'Açık tema etkin';

  @override
  String get lightThemeLabel => 'Açık';

  @override
  String get darkThemeLabel => 'Koyu';

  @override
  String get commentNotes => 'Yorum / Notlar';

  @override
  String get commentLabel => 'Yorum';

  @override
  String get exchangeReceived => 'Alınan Exchange';

  @override
  String get exchangeSent => 'Gönderilen Exchange';

  @override
  String get contestIdLabel => 'Yarışma';

  @override
  String get sigLabel => 'SIG';

  @override
  String get stationSetup => 'İstasyon Kurulumu';

  @override
  String get logbooks => 'Logbook\'lar';

  @override
  String get locations => 'Konumlar';

  @override
  String get newLogbook => 'Yeni Logbook';

  @override
  String get logbookName => 'Logbook Adı';

  @override
  String get renameLogbook => 'Yeniden Adlandır';

  @override
  String get deleteLogbook => 'Logbook\'u Sil';

  @override
  String get setActiveLogbook => 'Aktif Yap';

  @override
  String get activeLogbook => 'Aktif Logbook';

  @override
  String get editStation => 'Düzenle';

  @override
  String get cloneStation => 'Klonla';

  @override
  String get deleteStation => 'Sil';

  @override
  String get deleteStationConfirm => 'İstasyonu sil';

  @override
  String get deleteStationWarning =>
      'Bu istasyona ait tüm QSO\'lar kalıcı olarak silinecek. Devam edilsin mi?';

  @override
  String get stationDeleted => 'İstasyon silindi';

  @override
  String get stationUpdated => 'İstasyon güncellendi';

  @override
  String get stationCloned => 'İstasyon kopyalandı';

  @override
  String get linkLocation => 'Konum Bağla';

  @override
  String get unlinkLocation => 'Bağlantıyı Kopar';

  @override
  String get linkedLocations => 'Bağlı Konumlar';

  @override
  String get newStationName => 'Yeni istasyon adı';

  @override
  String get deleteLogbookConfirm => 'Logbook\'u sil';

  @override
  String get deleteLogbookWarning =>
      'Bu logbook silinecek. Bağlı konumlar korunur. Devam edilsin mi?';

  @override
  String get logbookDeleted => 'Logbook silindi';

  @override
  String get hrdlogCode => 'HRDLog Kodu';

  @override
  String get webAdifApiKey => 'WebADIF API Anahtarı';

  @override
  String get webAdifApiUrl => 'WebADIF API URL';

  @override
  String get basicInfo => 'Temel Bilgiler';

  @override
  String get locationSectionTitle => 'Konum';

  @override
  String get awardReferences => 'Ödül Referansları';

  @override
  String get integrationsSectionTitle => 'Entegrasyonlar';

  @override
  String get stationSettingsSection => 'İstasyon Ayarları';

  @override
  String get editStationTitle => 'İstasyonu Düzenle';

  @override
  String get newStationTitle => 'Yeni İstasyon';

  @override
  String get saveChangesBtn => 'Değişiklikleri Kaydet';

  @override
  String get createStationBtn => 'İstasyon Oluştur';

  @override
  String get stationCreated => 'İstasyon oluşturuldu';

  @override
  String get stationCreateFailed =>
      'İşlem başarısız. Aynı profil adı zaten mevcut olabilir.';

  @override
  String get stationProfileNameLabel => 'İstasyon Profil Adı *';

  @override
  String get stationProfileNameHint => 'Ana İstasyon';

  @override
  String get cityQth => 'Şehir / QTH';

  @override
  String get powerWatts => 'Güç (W)';

  @override
  String get dxccCountry => 'DXCC / Ülke';

  @override
  String get selectLabel => 'Seçiniz...';

  @override
  String get dxccSearch => 'DXCC / Ülke Ara';

  @override
  String get deletedDxcc => 'Silinmiş DXCC';

  @override
  String get eqslQthNicknameLabel => 'eQSL QTH Takma Adı';

  @override
  String get eqslDefaultMsgLabel => 'eQSL Varsayılan Mesaj';

  @override
  String get pending => 'Beklemede';

  @override
  String get uploadDisabled => 'Devre Dışı';

  @override
  String get uploadEnabled => 'Etkin';

  @override
  String get uploadRealtime => 'Gerçek Zamanlı';

  @override
  String get qrzApiKeyLabel => 'QRZ.com Logbook API Anahtarı';

  @override
  String get qrzUploadLabel => 'QRZ.com Yükleme';

  @override
  String get clublogIgnoreTitle => 'Clublog\'u Yoksay';

  @override
  String get clublogIgnoreSubtitle =>
      'Bu istasyonu Clublog yüklemesinden hariç tut';

  @override
  String get clublogRealtimeTitle => 'Clublog Gerçek Zamanlı';

  @override
  String get clublogRealtimeSubtitle => 'QSOları Clublog\'a anlık ilet';

  @override
  String get hrdlogUsernameLabel => 'HRDLog.net Kullanıcı Adı';

  @override
  String get hrdlogApiKeyLabel => 'HRDLog.net API Anahtarı';

  @override
  String get hrdlogUploadLabel => 'HRDLog.net Yükleme';

  @override
  String get qo100ApiKeyLabel => 'QO-100 DX Club API Anahtarı';

  @override
  String get qo100RealtimeTitle => 'QO-100 DX Club Gerçek Zamanlı';

  @override
  String get qo100RealtimeSubtitle => 'QSOları QO-100 DX Club\'a anlık ilet';

  @override
  String get oqrsSectionTitle => 'OQRS (Çevrimiçi QSL)';

  @override
  String get oqrsEnabledTitle => 'OQRS Etkin';

  @override
  String get oqrsEnabledSubtitle => 'Çevrimiçi QSL talep sistemini etkinleştir';

  @override
  String get oqrsTextLabel => 'OQRS Açıklama Metni';

  @override
  String get oqrsEmailLabel => 'OQRS E-Posta';

  @override
  String get setAsActiveStationTitle => 'Aktif İstasyon Olarak Ayarla';

  @override
  String get setAsActiveStationSubtitle =>
      'Bu istasyonu Wavelog\'ta aktif olarak işaretle';

  @override
  String get linkToActiveLogbookTitle => 'Aktif Logbook\'a Bağla';

  @override
  String get linkToActiveLogbookSubtitle =>
      'Oluşturulunca aktif logbook\'a otomatik bağla';

  @override
  String get active => 'Aktif';

  @override
  String get loadDetailsFailed => 'Detaylar yüklenemedi';

  @override
  String get cannotDeleteActiveStation => 'Aktif istasyon silinemez.';

  @override
  String get navStats => 'İstatistik';

  @override
  String get statisticsTitle => 'İstatistikler';

  @override
  String get uniqueCallsigns => 'Benzersiz Çağrı';

  @override
  String get currentStreak => 'Güncel Seri';

  @override
  String streakDays(int count) {
    return '$count gün';
  }

  @override
  String get bandDistribution => 'Bant Dağılımı';

  @override
  String get modeDistribution => 'Mod Dağılımı';

  @override
  String get perStation => 'İstasyon Başına';

  @override
  String get basedOnCache =>
      'Bant / mod / istasyon istatistikleri önbelleğe alınan QSO\'lara dayanmaktadır.';

  @override
  String get statsTab => 'İstatistik';

  @override
  String get propagationTab => 'Propagasyon';

  @override
  String get bandConditions => 'Bant Koşulları';

  @override
  String get dayTime => 'Gündüz';

  @override
  String get nightTime => 'Gece';

  @override
  String get conditionGood => 'İyi';

  @override
  String get conditionFair => 'Orta';

  @override
  String get conditionPoor => 'Zayıf';

  @override
  String lastUpdated(String time) {
    return 'Güncellendi: $time';
  }

  @override
  String get noSolarData => 'Güneş verileri yüklenemedi';

  @override
  String get potaStats => 'POTA İstatistikleri';

  @override
  String get potaTotalQsos => 'POTA QSO';

  @override
  String get potaActivatedParks => 'Aktive Edilen Parklar';

  @override
  String get potaAllParks => 'Tüm Parklar';

  @override
  String get potaActivatedBadge => 'Aktive';

  @override
  String get potaAttemptBadge => 'Deneme';

  @override
  String get potaNoStation => 'POTA istasyon profili yapılandırılmamış';

  @override
  String get potaNoQsos => 'Önbellekte POTA QSO\'su yok';

  @override
  String get navSpot => 'Spot';

  @override
  String get spotTitle => 'Spot';

  @override
  String get spotAdd => 'Spot Ekle';

  @override
  String get spotSend => 'Spot Gönder';

  @override
  String get spotSent => 'Spot gönderildi!';

  @override
  String get spotNoResults => 'Spot bulunamadı';

  @override
  String get spotLoadError => 'Spotlar yüklenemedi';

  @override
  String get spotActivator => 'Aktivatör Çağrısı';

  @override
  String get spotSpotter => 'Spotter Çağrısı';

  @override
  String get spotFrequency => 'Frekans (kHz)';

  @override
  String get spotReference => 'Park Referansı';

  @override
  String get spotComments => 'Yorum';

  @override
  String get spotCommentsHint => 'QRZ, CQ POTA...';

  @override
  String get spotInvalidRef => 'Geçersiz format (örn. PL-0001)';

  @override
  String get sortNewest => 'Yeniden eskiye';

  @override
  String get sortOldest => 'Eskiden yeniye';

  @override
  String get filterBand => 'Band';

  @override
  String get filterMode => 'Mod';

  @override
  String get filterCountry => 'Ülke';

  @override
  String get filterAssociation => 'Dernek';

  @override
  String get spotAddComingSoon => 'Spot Ekle — Çok Yakında';

  @override
  String get filterClear => 'Filtreleri temizle';

  @override
  String get mode => 'Mod';

  @override
  String get required => 'Zorunlu alan';

  @override
  String get invalidNumber => 'Geçersiz sayı';

  @override
  String get potaAutoSpot => 'Otomatik Spot';

  @override
  String get potaAutoSpotHint =>
      'POTA veya SOTA istasyonuna QSO girildiğinde otomatik self-spot atar (her biri için 30 dk cooldown)';

  @override
  String autoSpotSent(String ref) {
    return 'Otomatik spot gönderildi: $ref';
  }

  @override
  String get autoSpotWillFire => 'QSO kaydedilince spot atılacak';

  @override
  String autoSpotCooldown(int min) {
    return 'Spot atıldı · Sonraki: $min dk';
  }

  @override
  String get autoSpotCooldownSoon => 'Spot atıldı · Sonraki spot yakında';

  @override
  String autoSpotKeyChanged(String fields) {
    return '$fields değişti · Yeni spot atılacak';
  }

  @override
  String get autoSpotFieldFreq => 'Frekans';

  @override
  String get autoSpotFieldMode => 'Mod';

  @override
  String get autoSpotFieldRef => 'Park';

  @override
  String get logbookSummaryTitle => 'Son QSO\'lar';

  @override
  String todayQsoCount(int count) {
    return 'Bugün: $count QSO';
  }

  @override
  String get colDateTime => 'Tarih/Saat';

  @override
  String get colRstSent => 'RST(G)';

  @override
  String get colRstRcvd => 'RST(A)';

  @override
  String get submodeLabel => 'Alt mod';

  @override
  String selectedCount(int count) {
    return '$count seçildi';
  }

  @override
  String get selectAll => 'Tümünü Seç';

  @override
  String get exportSelected => 'Dışa Aktar';

  @override
  String get deleteSelected => 'Sil';

  @override
  String deleteSelectedConfirm(int count) {
    return '$count QSO silinsin mi?';
  }

  @override
  String get mapTitle => 'Harita';

  @override
  String get mapNoData => 'Grid karesi olan QSO bulunamadı';

  @override
  String mapStationCount(int count) {
    return '$count istasyon';
  }

  @override
  String get dxccProgress => 'DXCC İlerleme';

  @override
  String get workedCountries => 'Çalışılan Ülkeler';

  @override
  String get dxccWorked => 'Çalışılan';

  @override
  String dxccUniqueEntities(int count) {
    return '$count farklı varlık';
  }

  @override
  String get dxccConfirmed => 'Onaylanan (LoTW / eQSL / QSL)';

  @override
  String get dxccRemaining => 'Geriye Kalan';

  @override
  String get dxccLegendConfirmed => 'Onaylı';

  @override
  String get dxccLegendPending => 'Beklemede';

  @override
  String get dxccLegendNotWorked => 'Çalışılmadı';

  @override
  String get spotSummitNotFound => 'Zirve bulunamadı';

  @override
  String get spotParkNotFound => 'Park bulunamadı';

  @override
  String get qsoTypeTitle => 'QSO Kaydet';

  @override
  String get normalQso => 'Normal QSO';

  @override
  String get normalQsoDesc => 'Standart QSO girişi';

  @override
  String get contestQso => 'Yarışma QSO\'su';

  @override
  String get contestQsoDesc => 'Exchange ile hızlı yarışma kaydı';

  @override
  String get contestLog => 'Yarışma Logu';

  @override
  String get contestSetup => 'Yarışma Kurulumu';

  @override
  String get contestNameHint => 'ör. CQ-WW-CW';

  @override
  String get ourExchange => 'Bizim Exchange';

  @override
  String get serialStart => 'Başlangıç Seri No';

  @override
  String get showExchangeFields => 'Exchange alanları';

  @override
  String get startContest => 'Kayda Başla';

  @override
  String get endContest => 'Oturumu Kapat';

  @override
  String get endContestConfirm =>
      'Yarışma oturumu kapatılsın mı? (Seri numarası ve ayarlar sıfırlanır.)';

  @override
  String get serialSentLabel => 'Gönd. #';

  @override
  String get serialRcvdLabel => 'Alın. #';

  @override
  String get exchangeSentLabel => 'Gönd. Exch';

  @override
  String get exchangeRcvdLabel => 'Alın. Exch';

  @override
  String get gridSentLabel => 'Grid G';

  @override
  String get gridRcvdLabel => 'Grid A';

  @override
  String get logQso => 'QSO Kaydet';

  @override
  String get qsoLogged => 'QSO kaydedildi';

  @override
  String get contestRecentQsos => 'Son QSO\'lar';

  @override
  String get contestSessions => 'Yarışma Oturumları';

  @override
  String get newSession => 'Yeni Oturum';

  @override
  String get noContestSessions => 'Henüz yarışma oturumu yok';

  @override
  String get noContestSessionsHint =>
      'Web arayüzünden veya + butonuyla yeni oturum oluşturun.';

  @override
  String get contestSessionActive => 'Aktif';

  @override
  String get contestSessionEnded => 'Tamamlandı';

  @override
  String qsoCount(int count) {
    return '$count QSO';
  }

  @override
  String contestSessionDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get createContestSession => 'Yarışma Oturumu Oluştur';

  @override
  String get sessionName => 'Oturum Adı (opsiyonel)';

  @override
  String get sessionNameHint => 'ör. Ev İstasyonu — CW';

  @override
  String get selectContest => 'Yarışma Seç *';

  @override
  String get searchContest => 'Yarışma ara...';

  @override
  String get serverContests => 'Sunucudan';

  @override
  String get builtinContests => 'Yaygın Yarışmalar';

  @override
  String get startDateTime => 'Başlangıç Tarihi/Saati *';

  @override
  String get endDateTime => 'Bitiş Tarihi/Saati *';

  @override
  String get durationShortcut4h => '+4s';

  @override
  String get durationShortcut12h => '+12s';

  @override
  String get durationShortcut24h => '+24s';

  @override
  String get durationShortcut48h => '+48s';

  @override
  String get exchangeType => 'Exchange Türü';

  @override
  String get exchangeTypeSerial => 'Seri Numarası';

  @override
  String get exchangeTypeExchange => 'Metin Exchange';

  @override
  String get exchangeTypeBoth => 'Seri + Metin Exchange';

  @override
  String get createSession => 'Oturum Oluştur';

  @override
  String get sessionCreated => 'Yarışma oturumu oluşturuldu';

  @override
  String get sessionUpdated => 'Yarışma oturumu güncellendi';

  @override
  String get editContestSession => 'Yarışma Oturumunu Düzenle';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get deleteSession => 'Oturumu Sil';

  @override
  String get deleteSessionConfirm =>
      'Bu yarışma oturumu silinsin mi? Oturumda kaydedilen QSO\'lar logbook\'ta kalır.';

  @override
  String get openSession => 'Kayıt İçin Aç';

  @override
  String get patchRequiredContest =>
      'Yarışma oturumu yönetimi güncellenmiş Wavelog Mobile patch gerektirir.';

  @override
  String get contestCalendarTitle => 'Yarışma Takvimi';

  @override
  String get contestCalendarNoContests => 'Yarışma bulunamadı.';

  @override
  String get contestCalendarToday => 'Bugün';

  @override
  String get contestCalendarThisWeek => 'Bu Hafta';

  @override
  String get contestCalendarUpcoming => 'Yaklaşan';

  @override
  String get contestCalendarRecentlyPast => 'Yakın Geçmiş';

  @override
  String get contestCalendarLoadError => 'Yarışma takvimi yüklenemedi';

  @override
  String get contestCalendarRefresh => 'Yenile';

  @override
  String get contestCalendarRetry => 'Tekrar Dene';

  @override
  String get upcomingContestsTitle => 'Yaklaşan Yarışmalar';

  @override
  String get viewAll => 'Tümünü Gör';

  @override
  String get noUpcomingContests => 'Yaklaşan yarışma bulunamadı.';

  @override
  String get contestTodayBadge => 'BUGÜN';

  @override
  String get navStyleLabel => 'Navigasyon Stili';

  @override
  String get navStyleModern => 'Modern — FAB + çekmece';

  @override
  String get navStyleClassic => 'Klasik — 6 sekme';

  @override
  String get drawerMap => 'Harita';

  @override
  String get drawerContestCalendar => 'Yarışma Takvimi';

  @override
  String get drawerContestSessions => 'Yarışma Oturumları';

  @override
  String get drawerAdif => 'ADIF';

  @override
  String get drawerMenu => 'Menü';
}
