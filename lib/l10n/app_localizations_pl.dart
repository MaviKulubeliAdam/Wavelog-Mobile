// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Wavelog Mobile';

  @override
  String get splashConnecting => 'ŁĄCZENIE';

  @override
  String get navHome => 'Strona główna';

  @override
  String get navLogbook => 'Dziennik';

  @override
  String get navLookup => 'Wyszukaj';

  @override
  String get navStation => 'Stacja';

  @override
  String get save => 'Zapisz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get refresh => 'Odśwież';

  @override
  String get continueBtn => 'Kontynuuj';

  @override
  String get close => 'Zamknij';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get error => 'Błąd';

  @override
  String get success => 'Sukces';

  @override
  String get change => 'Zmień';

  @override
  String get goWeb => 'Przejdź →';

  @override
  String get editOnWeb => 'Edytuj w sieci';

  @override
  String get openInBrowser => 'Otwórz w przeglądarce';

  @override
  String get serverSetupTitle => 'Konfiguracja serwera';

  @override
  String get serverSetupSubtitle => 'Skonfiguruj serwer Wavelog';

  @override
  String get serverUrlLabel => 'Adres serwera Wavelog';

  @override
  String get serverUrlHint => 'https://log.example.com';

  @override
  String get testConnection => 'Testuj połączenie';

  @override
  String get testingConnection => 'Testowanie...';

  @override
  String get connectionSuccess => 'Połączono pomyślnie!';

  @override
  String get connectionFailed => 'Połączenie nieudane';

  @override
  String get apiKeyCopied => 'Klucz API skopiowany';

  @override
  String get loginTitle => 'Logowanie';

  @override
  String get serverBtn => 'Serwer';

  @override
  String get addAccountBtn => 'Dodaj konto';

  @override
  String get signInBtn => 'Zaloguj';

  @override
  String get deleteProfile => 'Usuń';

  @override
  String get deleteProfileTitle => 'Usuń konto';

  @override
  String deleteProfileConfirm(String name) {
    return 'Usunąć $name z tego urządzenia?';
  }

  @override
  String get displayName => 'Nazwa wyświetlana';

  @override
  String get callsign => 'Znak wywoławczy';

  @override
  String get apiKeyLabel => 'Klucz API';

  @override
  String get validating => 'Weryfikacja...';

  @override
  String get profileSaved => 'Konto zapisano';

  @override
  String get loginFailed => 'Logowanie nieudane';

  @override
  String get noStationFound =>
      'Nie znaleziono pasującej stacji — używam znaku wywoławczego';

  @override
  String get homeTitle => 'Strona główna';

  @override
  String get addQso => 'Dodaj QSO';

  @override
  String get recentQsos => 'Ostatnie QSO';

  @override
  String get statsToday => 'Dziś';

  @override
  String get statsMonth => 'Miesiąc';

  @override
  String get statsYear => 'Rok';

  @override
  String get statsTotal => 'Łącznie';

  @override
  String get noRecentQsos => 'Brak QSO';

  @override
  String get syncNow => 'Synchronizuj';

  @override
  String pendingSync(int count) {
    return '$count QSO oczekuje na synchronizację';
  }

  @override
  String get offlineBanner => 'Offline — QSO zapisane lokalnie';

  @override
  String get activeStation => 'Aktywna stacja';

  @override
  String get logbookTitle => 'Dziennik';

  @override
  String get filterAll => 'Wszystkie';

  @override
  String get filterAllModes => 'Wszystkie tryby';

  @override
  String get searchHint => 'Szukaj znaku...';

  @override
  String get noQsos => 'Nie znaleziono QSO';

  @override
  String get qsoDetailTitle => 'Szczegóły QSO';

  @override
  String get qsoNotFound => 'Nie znaleziono QSO';

  @override
  String get signal => 'Sygnał';

  @override
  String get rstSent => 'RST wysłane';

  @override
  String get rstReceived => 'RST odebrane';

  @override
  String get txPower => 'Moc TX';

  @override
  String get counterStation => 'Stacja korespondenta';

  @override
  String get country => 'Kraj';

  @override
  String get continent => 'Kontynent';

  @override
  String get dxcc => 'DXCC';

  @override
  String get cqZone => 'Strefa CQ';

  @override
  String get ituZone => 'Strefa ITU';

  @override
  String get gridSquare => 'Locator';

  @override
  String get propMode => 'Propagacja';

  @override
  String get distance => 'Odległość';

  @override
  String get qslStatus => 'Status QSL';

  @override
  String get paperQsl => 'Papier';

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
  String get qslSent => 'Wysłano';

  @override
  String get qslReceived => 'Odebrano';

  @override
  String get qslMethod => 'Metoda';

  @override
  String get awards => 'Referencje nagród';

  @override
  String get iota => 'IOTA';

  @override
  String get sota => 'SOTA';

  @override
  String get wwff => 'WWFF';

  @override
  String get pota => 'POTA';

  @override
  String get myStation => 'Moja stacja';

  @override
  String get myCallsign => 'Mój znak';

  @override
  String get contest => 'Zawody';

  @override
  String get serialSent => 'Nr wysłany';

  @override
  String get serialReceived => 'Nr odebrany';

  @override
  String get solarConditions => 'Warunki jonosfery';

  @override
  String get aIndex => 'Indeks A';

  @override
  String get kIndex => 'Indeks K';

  @override
  String get sfi => 'SFI';

  @override
  String get notesSection => 'Notatki';

  @override
  String get rawAdif => 'Surowe ADIF';

  @override
  String get showAll => 'Pokaż wszystko';

  @override
  String get showLess => 'Pokaż mniej';

  @override
  String get qrzProfile => 'Profil QRZ';

  @override
  String get addQsoTitle => 'Dodaj QSO';

  @override
  String get liveQso => 'QSO na żywo';

  @override
  String get historicalQso => 'Historyczne QSO';

  @override
  String get callsignField => 'Znak wywoławczy *';

  @override
  String get lookupSearch => 'Szukaj QRZ';

  @override
  String get liveDateTimeLabel => 'Data/Czas (UTC) — Na żywo';

  @override
  String get dateTimeLabel => 'Data/Czas (UTC)';

  @override
  String get bandField => 'Pasmo *';

  @override
  String get modeField => 'Tryb *';

  @override
  String get frequencyField => 'Częstotliwość (MHz)';

  @override
  String get rstSentField => 'RST wysłane *';

  @override
  String get rstRcvdField => 'RST odebrane *';

  @override
  String get nameField => 'Imię';

  @override
  String get qthField => 'QTH';

  @override
  String get gridField => 'Locator';

  @override
  String get commentField => 'Komentarz';

  @override
  String get stationProfileField => 'Profil stacji';

  @override
  String get saveQsoBtn => 'Zapisz QSO';

  @override
  String qsoSaved(String callsign) {
    return '✓  $callsign zapisano';
  }

  @override
  String qsoSavedLocal(String callsign) {
    return '✓  $callsign zapisano lokalnie';
  }

  @override
  String get noActiveStation => 'Nie wybrano aktywnej stacji';

  @override
  String get lookupTitle => 'Wyszukiwanie znaku';

  @override
  String get lookupHint => 'Wpisz znak wywoławczy...';

  @override
  String get lookupBtn => 'Szukaj';

  @override
  String get recentSearches => 'Ostatnie wyszukiwania';

  @override
  String get clearHistory => 'Wyczyść historię';

  @override
  String get makeQso => 'Nawiąż QSO';

  @override
  String get notFound => 'Nie znaleziono';

  @override
  String get stationsTitle => 'Stacje';

  @override
  String stationActivated(String callsign) {
    return '$callsign ustawiono jako aktywną stację';
  }

  @override
  String get stationWebInfo =>
      'Dodawanie i edycja stacji odbywa się przez interfejs webowy Wavelog.';

  @override
  String get noStations => 'Brak stacji';

  @override
  String get noStationsHint => 'Dodaj stację przez interfejs webowy Wavelog.';

  @override
  String get addStationOnWeb => 'Dodaj stację w Wavelog';

  @override
  String get adifTitle => 'Import / Eksport ADIF';

  @override
  String get importTab => 'Import';

  @override
  String get exportTab => 'Eksport';

  @override
  String get selectAdifFile => 'Wybierz plik ADIF';

  @override
  String get selectFileBtn => 'Wybierz plik (.adi / .adif)';

  @override
  String get stationRequired => 'Profil stacji *';

  @override
  String importing(int done, int total) {
    return 'Importowanie... $done/$total';
  }

  @override
  String get importBtn => 'Importuj';

  @override
  String get exportFilters => 'Filtry eksportu';

  @override
  String get stationFilter => 'Stacja';

  @override
  String get allStations => 'Wszystkie stacje';

  @override
  String get startDate => 'Od';

  @override
  String get endDate => 'Do';

  @override
  String get notSelected => 'Nie wybrano';

  @override
  String get clearDates => 'Wyczyść daty';

  @override
  String get exporting => 'Eksportowanie...';

  @override
  String get exportAndShare => 'Eksportuj i udostępnij';

  @override
  String get copyPath => 'Kopiuj ścieżkę';

  @override
  String get reshare => 'Udostępnij ponownie';

  @override
  String get pathCopied => 'Ścieżka pliku skopiowana';

  @override
  String qsoExported(int count) {
    return 'Wyeksportowano $count QSO';
  }

  @override
  String get noStationForExport => 'Nie znaleziono stacji do eksportu';

  @override
  String qsoImported(int imported, int total) {
    return 'Zaimportowano $imported / $total QSO';
  }

  @override
  String get selectSaveLocation => 'Wybierz lokalizację zapisu';

  @override
  String get copySuffix => '(Kopia)';

  @override
  String get errNetwork => 'Brak połączenia — sprawdź sieć';

  @override
  String get errTimeout => 'Przekroczono limit czasu połączenia';

  @override
  String get errUnauthorized => 'Nieprawidłowy klucz API';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get connectionSection => 'Połączenie';

  @override
  String get sessionSection => 'Sesja';

  @override
  String get loggedIn => 'Zalogowano';

  @override
  String get logoutBtn => 'Wyloguj';

  @override
  String get logoutTitle => 'Wyloguj';

  @override
  String get logoutConfirm => 'Czy na pewno chcesz się wylogować?';

  @override
  String get switchAccountBtn => 'Zmień konto';

  @override
  String get activeStationSection => 'Aktywna stacja';

  @override
  String get selectStationBtn => 'Wybierz stację';

  @override
  String get addStationWeb => 'Dodaj stację w sieci';

  @override
  String get defaultsSection => 'Domyślne ustawienia';

  @override
  String get defaultBand => 'Domyślne pasmo';

  @override
  String get defaultMode => 'Domyślny tryb';

  @override
  String get appSection => 'Aplikacja';

  @override
  String get darkTheme => 'Ciemny motyw';

  @override
  String get darkThemeHint => 'Zalecane do pracy w terenie';

  @override
  String get offlineMode => 'Tryb offline';

  @override
  String get offlineModeHint =>
      'Najpierw zapisuj QSO lokalnie, synchronizuj później';

  @override
  String get languageLabel => 'Język';

  @override
  String get infoSection => 'Informacje';

  @override
  String get aboutAppBtn => 'O aplikacji';

  @override
  String get aboutAppHint => 'Wersja, deweloper, licencja';

  @override
  String get dataSection => 'Dane';

  @override
  String get clearCacheBtn => 'Wyczyść pamięć QSO';

  @override
  String get clearCacheHint => 'Usuwa lokalną pamięć podręczną QSO';

  @override
  String get clearCacheTitle => 'Wyczyść pamięć';

  @override
  String get clearCacheConfirm =>
      'Lokalna pamięć QSO zostanie usunięta. Operacji nie można cofnąć.';

  @override
  String get clearCacheAction => 'Wyczyść';

  @override
  String get cacheCleared => 'Pamięć wyczyszczona';

  @override
  String get langSystem => 'Domyślny systemu';

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langPolish => 'Polski';

  @override
  String get aboutTitle => 'O aplikacji';

  @override
  String get appDescription => 'Aplikacja Android open source dla Wavelog';

  @override
  String versionLabel(String version, String build) {
    return 'Wersja $version  (Build $build)';
  }

  @override
  String get mobileDeveloperSection => 'Deweloper aplikacji mobilnej';

  @override
  String get wavelogProjectSection => 'Projekt Wavelog';

  @override
  String get wavelogDescription =>
      'Webowy system logowania łączności krótkofalarskich';

  @override
  String get coreDevelopers => 'Główni deweloperzy';

  @override
  String get mitLicense => 'Licencja MIT';

  @override
  String get mitDescription =>
      'Ta aplikacja i projekt Wavelog są dystrybuowane na licencji MIT. Open source, bez żadnych gwarancji.';

  @override
  String get licenseSection => 'Licencja';

  @override
  String get errorNoConnection => 'Brak połączenia';

  @override
  String get errorUnauthorized => 'Brak autoryzacji — sprawdź klucz API';

  @override
  String get errorServer => 'Błąd serwera';

  @override
  String get patchRequiredTitle => 'Wymagana łatka serwera';

  @override
  String get patchRequiredMessage =>
      'Funkcje edycji i usuwania wymagają zainstalowania łatki Wavelog Mobile API na serwerze.\n\nOdwiedź sp9aqg.pl/install.html, aby zapoznać się z instrukcją instalacji.';

  @override
  String get patchRequiredBanner =>
      'Funkcje edycji i usuwania wymagają zainstalowania łatki Wavelog Mobile API na serwerze.';

  @override
  String get patchViewGuide => 'Przewodnik instalacji';

  @override
  String get setupGuideTitle => 'Przewodnik konfiguracji';

  @override
  String get setupGuideIntro =>
      'Zanim zaczniesz logować QSO, połącz aplikację z serwerem Wavelog. Wykonaj poniższe kroki.';

  @override
  String get setupGuideStep1Title => '1. Adres serwera';

  @override
  String get setupGuideStep1Body =>
      'Wpisz ten sam adres, którego używasz do otwierania Wavelog w przeglądarce, np. https://twojadomena.com — bez ukośnika na końcu.';

  @override
  String get setupGuideStep2Title => '2. Łatka serwera (zrób to najpierw)';

  @override
  String get setupGuideStep2Body =>
      'Przed utworzeniem klucza API zainstaluj łatkę Wavelog Mobile API na serwerze. Dotknij poniżej, aby zobaczyć instrukcję.';

  @override
  String get setupGuideStep3Title => '3. Klucz API';

  @override
  String get setupGuideStep3Body =>
      'Po zainstalowaniu łatki przejdź w Wavelog do Ustawienia → Klucze API i kliknij \"Create a mobile app key\". Wklej wygenerowany klucz w pole Klucz API.';

  @override
  String get setupGuideStep4Title => '4. Znak wywoławczy i nazwa wyświetlana';

  @override
  String get setupGuideStep4Body =>
      'Znak wywoławczy: Twój własny znak krótkofalarski, służy do dopasowania stacji. Nazwa wyświetlana: dowolna etykieta do rozpoznania tego logowania na urządzeniu.';

  @override
  String get setupGuideContinueBtn => 'Rozpocznij konfigurację';

  @override
  String get appSubtitle => 'Aplikacja do logowania krótkofalarskiego';

  @override
  String get switchToLightTheme => 'Przełącz na jasny motyw';

  @override
  String get switchToDarkTheme => 'Przełącz na ciemny motyw';

  @override
  String get deleteQsoTitle => 'Usuń QSO';

  @override
  String deleteQsoConfirm(String callsign, String date) {
    return 'Trwale usunąć QSO z $callsign z dnia $date?';
  }

  @override
  String get editTooltip => 'Edytuj';

  @override
  String get shareAdifTooltip => 'Udostępnij ADIF';

  @override
  String get localNotSynced => 'Zapis lokalny — jeszcze nie zsynchronizowany';

  @override
  String get satellite => 'Satelita';

  @override
  String get satelliteMode => 'Tryb satelitarny';

  @override
  String get antenna => 'Antena';

  @override
  String get nameLabel => 'Imię';

  @override
  String get stateProvince => 'Województwo/Stan';

  @override
  String get county => 'Powiat';

  @override
  String get city => 'Miasto';

  @override
  String get continentAF => 'Afryka';

  @override
  String get continentAN => 'Antarktyda';

  @override
  String get continentAS => 'Azja';

  @override
  String get continentEU => 'Europa';

  @override
  String get continentNA => 'Ameryka Północna';

  @override
  String get continentOC => 'Oceania';

  @override
  String get continentSA => 'Ameryka Południowa';

  @override
  String get qrzProfileLoading => 'Ładowanie profilu QRZ...';

  @override
  String viewOnQrz(String callsign) {
    return 'Wyświetl na QRZ.com  ($callsign)';
  }

  @override
  String get qslMethods => 'Metody QSL';

  @override
  String get bureau => 'Biuro';

  @override
  String qslManagerPrefix(String manager) {
    return 'Manager: $manager';
  }

  @override
  String get callsignCopied => 'Znak skopiowany';

  @override
  String get uploadedStatus => 'Przesłano';

  @override
  String get notUploadedStatus => 'Nie przesłano';

  @override
  String get matchedStatus => 'Dopasowano';

  @override
  String get toDeleteStatus => 'Do usunięcia';

  @override
  String get yes => 'Tak';

  @override
  String get requested => 'Wysłano prośbę';

  @override
  String get no => 'Nie';

  @override
  String get invalid => 'Nieprawidłowy';

  @override
  String get viaDirect => 'Bezpośrednio';

  @override
  String get viaElectronic => 'Elektronicznie';

  @override
  String get viaMail => 'Pocztą';

  @override
  String otherAdifFields(int count) {
    return 'Inne pola ADIF ($count)';
  }

  @override
  String get editQsoTitle => 'Edytuj QSO';

  @override
  String get qsoUpdated => 'QSO zaktualizowano';

  @override
  String get qsoUpdatedLocal => 'QSO zaktualizowano lokalnie';

  @override
  String get counterStationHint =>
      'Wpisz znak, aby zobaczyć\ninfo z QRZ i poprzednie\nQSO tutaj.';

  @override
  String previousQsosCount(int count) {
    return 'Poprzednie QSO ($count)';
  }

  @override
  String morePreviousQsos(int count) {
    return '+$count więcej...';
  }

  @override
  String previousQsosWithCallsign(String callsign) {
    return 'Poprzednie QSO z $callsign';
  }

  @override
  String totalQsos(int count) {
    return '$count łącznie';
  }

  @override
  String get workedBefore => 'Wcześniej w łączności';

  @override
  String get lastQsoLabel => 'Ostatnie QSO';

  @override
  String get themeLabel => 'Motyw';

  @override
  String get darkThemeActive => 'Ciemny motyw aktywny';

  @override
  String get lightThemeActive => 'Jasny motyw aktywny';

  @override
  String get lightThemeLabel => 'Jasny';

  @override
  String get darkThemeLabel => 'Ciemny';

  @override
  String get commentNotes => 'Komentarz / Notatki';

  @override
  String get commentLabel => 'Komentarz';

  @override
  String get exchangeReceived => 'Exchange odebrany';

  @override
  String get exchangeSent => 'Exchange wysłany';

  @override
  String get contestIdLabel => 'Zawody';

  @override
  String get sigLabel => 'SIG';

  @override
  String get stationSetup => 'Konfiguracja stacji';

  @override
  String get logbooks => 'Logbooki';

  @override
  String get locations => 'Lokalizacje';

  @override
  String get newLogbook => 'Nowy Logbook';

  @override
  String get logbookName => 'Nazwa logbooka';

  @override
  String get renameLogbook => 'Zmień nazwę';

  @override
  String get deleteLogbook => 'Usuń logbook';

  @override
  String get setActiveLogbook => 'Ustaw aktywny';

  @override
  String get activeLogbook => 'Aktywny logbook';

  @override
  String get editStation => 'Edytuj';

  @override
  String get cloneStation => 'Klonuj';

  @override
  String get deleteStation => 'Usuń';

  @override
  String get deleteStationConfirm => 'Usuń stację';

  @override
  String get deleteStationWarning =>
      'Wszystkie QSO tej stacji zostaną trwale usunięte. Kontynuować?';

  @override
  String get stationDeleted => 'Stacja usunięta';

  @override
  String get stationUpdated => 'Stacja zaktualizowana';

  @override
  String get stationCloned => 'Stacja sklonowana';

  @override
  String get linkLocation => 'Połącz lokalizację';

  @override
  String get unlinkLocation => 'Odłącz';

  @override
  String get linkedLocations => 'Połączone lokalizacje';

  @override
  String get newStationName => 'Nowa nazwa stacji';

  @override
  String get deleteLogbookConfirm => 'Usuń logbook';

  @override
  String get deleteLogbookWarning =>
      'Ten logbook zostanie usunięty. Połączone lokalizacje są zachowane. Kontynuować?';

  @override
  String get logbookDeleted => 'Logbook usunięty';

  @override
  String get hrdlogCode => 'Kod HRDLog';

  @override
  String get webAdifApiKey => 'Klucz API WebADIF';

  @override
  String get webAdifApiUrl => 'URL API WebADIF';

  @override
  String get basicInfo => 'Podstawowe informacje';

  @override
  String get locationSectionTitle => 'Lokalizacja';

  @override
  String get awardReferences => 'Referencje nagród';

  @override
  String get integrationsSectionTitle => 'Integracje';

  @override
  String get stationSettingsSection => 'Ustawienia stacji';

  @override
  String get editStationTitle => 'Edytuj stację';

  @override
  String get newStationTitle => 'Nowa stacja';

  @override
  String get saveChangesBtn => 'Zapisz zmiany';

  @override
  String get createStationBtn => 'Utwórz stację';

  @override
  String get stationCreated => 'Stacja utworzona';

  @override
  String get stationCreateFailed =>
      'Nie udało się. Profil o tej nazwie może już istnieć.';

  @override
  String get stationProfileNameLabel => 'Nazwa profilu stacji *';

  @override
  String get stationProfileNameHint => 'Stacja domowa';

  @override
  String get cityQth => 'Miasto / QTH';

  @override
  String get powerWatts => 'Moc (W)';

  @override
  String get dxccCountry => 'DXCC / Kraj';

  @override
  String get selectLabel => 'Wybierz...';

  @override
  String get dxccSearch => 'Szukaj DXCC / Kraj';

  @override
  String get deletedDxcc => 'Usunięty DXCC';

  @override
  String get eqslQthNicknameLabel => 'Pseudonim QTH eQSL';

  @override
  String get eqslDefaultMsgLabel => 'Domyślna wiadomość eQSL';

  @override
  String get pending => 'Oczekujące';

  @override
  String get uploadDisabled => 'Wyłączone';

  @override
  String get uploadEnabled => 'Włączone';

  @override
  String get uploadRealtime => 'Czas rzeczywisty';

  @override
  String get qrzApiKeyLabel => 'Klucz API logbooka QRZ.com';

  @override
  String get qrzUploadLabel => 'Przesyłanie QRZ.com';

  @override
  String get clublogIgnoreTitle => 'Ignoruj Clublog';

  @override
  String get clublogIgnoreSubtitle =>
      'Wyklucz tę stację z przesyłania do Clublog';

  @override
  String get clublogRealtimeTitle => 'Czas rzeczywisty Clublog';

  @override
  String get clublogRealtimeSubtitle =>
      'Przesyłaj QSO do Clublog w czasie rzeczywistym';

  @override
  String get hrdlogUsernameLabel => 'Nazwa użytkownika HRDLog.net';

  @override
  String get hrdlogApiKeyLabel => 'Klucz API HRDLog.net';

  @override
  String get hrdlogUploadLabel => 'Przesyłanie HRDLog.net';

  @override
  String get qo100ApiKeyLabel => 'Klucz API QO-100 DX Club';

  @override
  String get qo100RealtimeTitle => 'Czas rzeczywisty QO-100 DX Club';

  @override
  String get qo100RealtimeSubtitle =>
      'Przesyłaj QSO do QO-100 DX Club w czasie rzeczywistym';

  @override
  String get oqrsSectionTitle => 'OQRS (Online QSL)';

  @override
  String get oqrsEnabledTitle => 'OQRS włączone';

  @override
  String get oqrsEnabledSubtitle => 'Włącz system żądań QSL online';

  @override
  String get oqrsTextLabel => 'Tekst opisu OQRS';

  @override
  String get oqrsEmailLabel => 'E-mail OQRS';

  @override
  String get setAsActiveStationTitle => 'Ustaw jako aktywną stację';

  @override
  String get setAsActiveStationSubtitle =>
      'Oznacz tę stację jako aktywną w Wavelog';

  @override
  String get linkToActiveLogbookTitle => 'Połącz z aktywnym logbookiem';

  @override
  String get linkToActiveLogbookSubtitle =>
      'Automatycznie połącz z aktywnym logbookiem po utworzeniu';

  @override
  String get active => 'Aktywna';

  @override
  String get loadDetailsFailed => 'Nie udało się załadować szczegółów';

  @override
  String get cannotDeleteActiveStation => 'Nie można usunąć aktywnej stacji.';

  @override
  String get navStats => 'Statystyki';

  @override
  String get statisticsTitle => 'Statystyki';

  @override
  String get uniqueCallsigns => 'Unikalne Znaki';

  @override
  String get currentStreak => 'Aktualna Seria';

  @override
  String streakDays(int count) {
    return '$count dni';
  }

  @override
  String get bandDistribution => 'Rozkład Pasm';

  @override
  String get modeDistribution => 'Rozkład Trybów';

  @override
  String get perStation => 'Na Stację';

  @override
  String get basedOnCache =>
      'Statystyki pasm / trybów / stacji bazują na danych z pamięci podręcznej.';

  @override
  String get statsTab => 'Statystyki';

  @override
  String get propagationTab => 'Propagacja';

  @override
  String get bandConditions => 'Warunki Pasm';

  @override
  String get dayTime => 'Dzień';

  @override
  String get nightTime => 'Noc';

  @override
  String get conditionGood => 'Dobry';

  @override
  String get conditionFair => 'Umiarkowany';

  @override
  String get conditionPoor => 'Słaby';

  @override
  String lastUpdated(String time) {
    return 'Zaktualizowano: $time';
  }

  @override
  String get noSolarData => 'Nie można załadować danych słonecznych';

  @override
  String get potaStats => 'Statystyki POTA';

  @override
  String get potaTotalQsos => 'QSO POTA';

  @override
  String get potaActivatedParks => 'Aktywowane parki';

  @override
  String get potaAllParks => 'Wszystkie parki';

  @override
  String get potaActivatedBadge => 'Aktyw.';

  @override
  String get potaAttemptBadge => 'Próba';

  @override
  String get potaNoStation => 'Brak skonfigurowanego profilu stacji POTA';

  @override
  String get potaNoQsos => 'Brak QSO POTA w pamięci podręcznej';

  @override
  String get navSpot => 'Spot';

  @override
  String get spotTitle => 'Spot';

  @override
  String get spotAdd => 'Dodaj spot';

  @override
  String get spotSend => 'Wyślij spot';

  @override
  String get spotSent => 'Spot wysłany!';

  @override
  String get spotNoResults => 'Brak spotów';

  @override
  String get spotLoadError => 'Nie można załadować spotów';

  @override
  String get spotActivator => 'Znak aktywatora';

  @override
  String get spotSpotter => 'Znak spottera';

  @override
  String get spotFrequency => 'Częstotliwość (kHz)';

  @override
  String get spotReference => 'Referencja parku';

  @override
  String get spotComments => 'Komentarz';

  @override
  String get spotCommentsHint => 'QRZ, CQ POTA...';

  @override
  String get spotInvalidRef => 'Nieprawidłowy format (np. PL-0001)';

  @override
  String get sortNewest => 'Od najnowszych';

  @override
  String get sortOldest => 'Od najstarszych';

  @override
  String get filterBand => 'Pasmo';

  @override
  String get filterMode => 'Tryb';

  @override
  String get filterCountry => 'Kraj';

  @override
  String get filterAssociation => 'Stowarzyszenie';

  @override
  String get spotAddComingSoon => 'Dodaj spot — Wkrótce';

  @override
  String get filterClear => 'Wyczyść filtry';

  @override
  String get mode => 'Tryb';

  @override
  String get required => 'Wymagane';

  @override
  String get invalidNumber => 'Nieprawidłowa liczba';

  @override
  String get potaAutoSpot => 'Automatyczny spot';

  @override
  String get potaAutoSpotHint =>
      'Automatycznie wysyła self-spot przy logowaniu QSO na stacji POTA lub SOTA (cooldown 30 min dla każdej)';

  @override
  String autoSpotSent(String ref) {
    return 'Automatyczny spot wysłany: $ref';
  }

  @override
  String get autoSpotWillFire => 'QSO wyśle spot';

  @override
  String autoSpotCooldown(int min) {
    return 'Spot wysłany · Następny za $min min';
  }

  @override
  String get autoSpotCooldownSoon => 'Spot wysłany · Następny spot wkrótce';

  @override
  String autoSpotKeyChanged(String fields) {
    return '$fields zmienione · Nowy spot zostanie wysłany';
  }

  @override
  String get autoSpotFieldFreq => 'Częstotliwość';

  @override
  String get autoSpotFieldMode => 'Tryb';

  @override
  String get autoSpotFieldRef => 'Park';

  @override
  String get logbookSummaryTitle => 'Ostatnie QSO';

  @override
  String todayQsoCount(int count) {
    return 'Dziś: $count QSO';
  }

  @override
  String get colDateTime => 'Data/Godz.';

  @override
  String get colRstSent => 'RST(W)';

  @override
  String get colRstRcvd => 'RST(O)';

  @override
  String get submodeLabel => 'Podtryb';

  @override
  String selectedCount(int count) {
    return 'Wybrano $count';
  }

  @override
  String get selectAll => 'Zaznacz wszystko';

  @override
  String get exportSelected => 'Eksportuj';

  @override
  String get deleteSelected => 'Usuń';

  @override
  String deleteSelectedConfirm(int count) {
    return 'Usunąć $count QSO?';
  }

  @override
  String get mapTitle => 'Mapa';

  @override
  String get mapNoData => 'Nie znaleziono QSO z locatorem';

  @override
  String mapStationCount(int count) {
    return '$count stacji';
  }

  @override
  String get dxccProgress => 'Postęp DXCC';

  @override
  String get workedCountries => 'Pracowane kraje';

  @override
  String get dxccWorked => 'Pracowane';

  @override
  String dxccUniqueEntities(int count) {
    return '$count unikalnych encji';
  }

  @override
  String get dxccConfirmed => 'Potwierdzone (LoTW / eQSL / QSL)';

  @override
  String get dxccRemaining => 'Pozostałe';

  @override
  String get dxccLegendConfirmed => 'Potwierdzone';

  @override
  String get dxccLegendPending => 'Oczekujące';

  @override
  String get dxccLegendNotWorked => 'Niepracowane';

  @override
  String get spotSummitNotFound => 'Szczyt nie znaleziony';

  @override
  String get spotParkNotFound => 'Park nie znaleziony';

  @override
  String get qsoTypeTitle => 'Zapisz QSO';

  @override
  String get normalQso => 'Zwykłe QSO';

  @override
  String get normalQsoDesc => 'Standardowy wpis';

  @override
  String get contestQso => 'QSO konkursowe';

  @override
  String get contestQsoDesc => 'Szybkie logowanie z wymianą';

  @override
  String get contestLog => 'Log konkursowy';

  @override
  String get contestSetup => 'Ustawienia zawodów';

  @override
  String get contestNameHint => 'np. CQ-WW-CW';

  @override
  String get ourExchange => 'Nasza wymiana';

  @override
  String get serialStart => 'Numer startowy';

  @override
  String get showExchangeFields => 'Pola wymiany';

  @override
  String get startContest => 'Rozpocznij logowanie';

  @override
  String get endContest => 'Zakończ sesję';

  @override
  String get endContestConfirm =>
      'Zakończyć sesję konkursową? (Licznik i ustawienia zostaną zresetowane.)';

  @override
  String get serialSentLabel => 'Nr wys.';

  @override
  String get serialRcvdLabel => 'Nr odb.';

  @override
  String get exchangeSentLabel => 'Wys. wym.';

  @override
  String get exchangeRcvdLabel => 'Odb. wym.';

  @override
  String get gridSentLabel => 'Grid W';

  @override
  String get gridRcvdLabel => 'Grid O';

  @override
  String get logQso => 'Zapisz QSO';

  @override
  String get qsoLogged => 'QSO zapisane';

  @override
  String get contestRecentQsos => 'Ostatnie';

  @override
  String get contestSessions => 'Sesje konkursowe';

  @override
  String get newSession => 'Nowa sesja';

  @override
  String get noContestSessions => 'Brak sesji konkursowych';

  @override
  String get noContestSessionsHint =>
      'Utwórz sesję na stronie web lub naciśnij + tutaj.';

  @override
  String get contestSessionActive => 'Aktywna';

  @override
  String get contestSessionEnded => 'Zakończona';

  @override
  String qsoCount(int count) {
    return '$count QSO';
  }

  @override
  String contestSessionDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get createContestSession => 'Utwórz sesję konkursową';

  @override
  String get sessionName => 'Nazwa sesji (opcjonalnie)';

  @override
  String get sessionNameHint => 'np. Stacja domowa — CW';

  @override
  String get selectContest => 'Wybierz zawody *';

  @override
  String get searchContest => 'Szukaj zawodów...';

  @override
  String get serverContests => 'Z serwera';

  @override
  String get builtinContests => 'Popularne zawody';

  @override
  String get startDateTime => 'Data/godzina rozpoczęcia *';

  @override
  String get endDateTime => 'Data/godzina zakończenia *';

  @override
  String get durationShortcut4h => '+4g';

  @override
  String get durationShortcut12h => '+12g';

  @override
  String get durationShortcut24h => '+24g';

  @override
  String get durationShortcut48h => '+48g';

  @override
  String get exchangeType => 'Typ wymiany';

  @override
  String get exchangeTypeSerial => 'Numer seryjny';

  @override
  String get exchangeTypeExchange => 'Wymiana tekstowa';

  @override
  String get exchangeTypeBoth => 'Numer + wymiana tekstowa';

  @override
  String get createSession => 'Utwórz sesję';

  @override
  String get sessionCreated => 'Sesja konkursowa utworzona';

  @override
  String get sessionUpdated => 'Sesja konkursowa zaktualizowana';

  @override
  String get editContestSession => 'Edytuj sesję konkursową';

  @override
  String get saveChanges => 'Zapisz zmiany';

  @override
  String get deleteSession => 'Usuń sesję';

  @override
  String get deleteSessionConfirm =>
      'Usunąć tę sesję konkursową? QSO zalogowane w tej sesji pozostaną w dzienniku.';

  @override
  String get openSession => 'Otwórz do logowania';

  @override
  String get patchRequiredContest =>
      'Zarządzanie sesjami konkursowymi wymaga zaktualizowanej łatki Wavelog Mobile.';

  @override
  String get contestCalendarTitle => 'Kalendarz Zawodów';

  @override
  String get contestCalendarNoContests => 'Nie znaleziono zawodów.';

  @override
  String get contestCalendarToday => 'Dzisiaj';

  @override
  String get contestCalendarThisWeek => 'Ten Tydzień';

  @override
  String get contestCalendarUpcoming => 'Nadchodzące';

  @override
  String get contestCalendarRecentlyPast => 'Ostatnio zakończone';

  @override
  String get contestCalendarLoadError =>
      'Nie można załadować kalendarza zawodów';

  @override
  String get contestCalendarRefresh => 'Odśwież';

  @override
  String get contestCalendarRetry => 'Spróbuj ponownie';

  @override
  String get upcomingContestsTitle => 'Nadchodzące Zawody';

  @override
  String get viewAll => 'Zobacz wszystko';

  @override
  String get noUpcomingContests => 'Nie znaleziono nadchodzących zawodów.';

  @override
  String get contestTodayBadge => 'DZIŚ';

  @override
  String get navStyleLabel => 'Styl Nawigacji';

  @override
  String get navStyleModern => 'Nowoczesny — FAB + szuflada';

  @override
  String get navStyleClassic => 'Klasyczny — 6 zakładek';

  @override
  String get drawerMap => 'Mapa';

  @override
  String get drawerContestCalendar => 'Kalendarz Zawodów';

  @override
  String get drawerContestSessions => 'Sesje Zawodów';

  @override
  String get drawerAdif => 'ADIF';

  @override
  String get drawerMenu => 'Menu';
}
