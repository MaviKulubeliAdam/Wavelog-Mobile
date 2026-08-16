// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Wavelog Mobile';

  @override
  String get splashConnecting => 'VERBINDEN';

  @override
  String get navHome => 'Startseite';

  @override
  String get navLogbook => 'Logbuch';

  @override
  String get navLookup => 'Suche';

  @override
  String get navStation => 'Station';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get continueBtn => 'Weiter';

  @override
  String get close => 'Schließen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get change => 'Ändern';

  @override
  String get goWeb => 'Öffnen →';

  @override
  String get editOnWeb => 'Im Web bearbeiten';

  @override
  String get openInBrowser => 'Im Browser öffnen';

  @override
  String get serverSetupTitle => 'Server-Einrichtung';

  @override
  String get serverSetupSubtitle => 'Wavelog-Server konfigurieren';

  @override
  String get serverUrlLabel => 'Wavelog-Server-URL';

  @override
  String get serverUrlHint => 'https://log.example.com';

  @override
  String get testConnection => 'Verbindung testen';

  @override
  String get testingConnection => 'Teste...';

  @override
  String get connectionSuccess => 'Verbindung erfolgreich!';

  @override
  String get connectionFailed => 'Verbindung fehlgeschlagen';

  @override
  String get apiKeyCopied => 'API-Schlüssel kopiert';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get serverBtn => 'Server';

  @override
  String get addAccountBtn => 'Konto hinzufügen';

  @override
  String get signInBtn => 'Anmelden';

  @override
  String get deleteProfile => 'Löschen';

  @override
  String get deleteProfileTitle => 'Konto löschen';

  @override
  String deleteProfileConfirm(String name) {
    return '$name von diesem Gerät entfernen?';
  }

  @override
  String get displayName => 'Anzeigename';

  @override
  String get callsign => 'Rufzeichen';

  @override
  String get apiKeyLabel => 'API-Schlüssel';

  @override
  String get validating => 'Prüfen...';

  @override
  String get profileSaved => 'Konto gespeichert';

  @override
  String get loginFailed => 'Anmeldung fehlgeschlagen';

  @override
  String get noStationFound =>
      'Keine passende Station gefunden — Rufzeichen wird verwendet';

  @override
  String get homeTitle => 'Startseite';

  @override
  String get addQso => 'QSO hinzufügen';

  @override
  String get recentQsos => 'Letzte QSOs';

  @override
  String get statsToday => 'Heute';

  @override
  String get statsMonth => 'Monat';

  @override
  String get statsYear => 'Jahr';

  @override
  String get statsTotal => 'Gesamt';

  @override
  String get noRecentQsos => 'Noch keine QSOs';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String pendingSync(int count) {
    return '$count QSO(s) ausstehend';
  }

  @override
  String get offlineBanner => 'Offline — QSOs lokal gespeichert';

  @override
  String get activeStation => 'Aktive Station';

  @override
  String get logbookTitle => 'Logbuch';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterAllModes => 'Alle Betriebsarten';

  @override
  String get searchHint => 'Rufzeichen suchen...';

  @override
  String get noQsos => 'Keine QSOs gefunden';

  @override
  String get qsoDetailTitle => 'QSO-Details';

  @override
  String get qsoNotFound => 'QSO nicht gefunden';

  @override
  String get signal => 'Signal';

  @override
  String get rstSent => 'RST Gesandt';

  @override
  String get rstReceived => 'RST Empfangen';

  @override
  String get txPower => 'TX-Leistung';

  @override
  String get counterStation => 'Gegenstation';

  @override
  String get country => 'Land';

  @override
  String get continent => 'Kontinent';

  @override
  String get dxcc => 'DXCC';

  @override
  String get cqZone => 'CQ-Zone';

  @override
  String get ituZone => 'ITU-Zone';

  @override
  String get gridSquare => 'Locator';

  @override
  String get propMode => 'Ausbreitung';

  @override
  String get distance => 'Entfernung';

  @override
  String get qslStatus => 'QSL-Status';

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
  String get qslSent => 'Gesandt';

  @override
  String get qslRcvd => 'Empf.';

  @override
  String get qslReceived => 'Empfangen';

  @override
  String get qslMethod => 'Methode';

  @override
  String get awards => 'Award-Referenzen';

  @override
  String get iota => 'IOTA';

  @override
  String get sota => 'SOTA';

  @override
  String get wwff => 'WWFF';

  @override
  String get pota => 'POTA';

  @override
  String get myStation => 'Meine Station';

  @override
  String get myCallsign => 'Mein Rufzeichen';

  @override
  String get contest => 'Contest';

  @override
  String get serialSent => 'Seriennummer Gesandt';

  @override
  String get serialReceived => 'Seriennummer Empfangen';

  @override
  String get solarConditions => 'Solarbedingungen';

  @override
  String get aIndex => 'A-Index';

  @override
  String get kIndex => 'K-Index';

  @override
  String get sfi => 'SFI';

  @override
  String get notesSection => 'Notizen';

  @override
  String get rawAdif => 'ADIF-Rohformat';

  @override
  String get showAll => 'Alle anzeigen';

  @override
  String get showLess => 'Weniger anzeigen';

  @override
  String get qrzProfile => 'QRZ-Profil';

  @override
  String get addQsoTitle => 'QSO hinzufügen';

  @override
  String get liveQso => 'Live-QSO';

  @override
  String get historicalQso => 'Historisches QSO';

  @override
  String get callsignField => 'Rufzeichen *';

  @override
  String get lookupSearch => 'QRZ-Suche';

  @override
  String get liveDateTimeLabel => 'Datum/Uhrzeit (UTC) — Live';

  @override
  String get dateTimeLabel => 'Datum/Uhrzeit (UTC)';

  @override
  String get bandField => 'Band *';

  @override
  String get modeField => 'Betriebsart *';

  @override
  String get frequencyField => 'Frequenz (MHz)';

  @override
  String get rstSentField => 'RST Gesandt *';

  @override
  String get rstRcvdField => 'RST Empfangen *';

  @override
  String get nameField => 'Name';

  @override
  String get qthField => 'QTH';

  @override
  String get gridField => 'Locator';

  @override
  String get commentField => 'Kommentar';

  @override
  String get stationProfileField => 'Stationsprofil';

  @override
  String get saveQsoBtn => 'QSO speichern';

  @override
  String qsoSaved(String callsign) {
    return '✓  $callsign gespeichert';
  }

  @override
  String qsoSavedLocal(String callsign) {
    return '✓  $callsign lokal gespeichert';
  }

  @override
  String get noActiveStation => 'Keine aktive Station ausgewählt';

  @override
  String get lookupTitle => 'Rufzeichensuche';

  @override
  String get lookupHint => 'Rufzeichen eingeben...';

  @override
  String get lookupBtn => 'Suchen';

  @override
  String get recentSearches => 'Letzte Suchen';

  @override
  String get clearHistory => 'Verlauf löschen';

  @override
  String get makeQso => 'QSO loggen';

  @override
  String get notFound => 'Nicht gefunden';

  @override
  String get stationsTitle => 'Stationen';

  @override
  String stationActivated(String callsign) {
    return '$callsign als aktive Station gesetzt';
  }

  @override
  String get stationWebInfo =>
      'Stationen über die Wavelog-Weboberfläche hinzufügen und bearbeiten.';

  @override
  String get noStations => 'Noch keine Stationen';

  @override
  String get noStationsHint =>
      'Eine Station über die Wavelog-Weboberfläche hinzufügen.';

  @override
  String get addStationOnWeb => 'Station in Wavelog hinzufügen';

  @override
  String get adifTitle => 'ADIF Import / Export';

  @override
  String get importTab => 'Import';

  @override
  String get exportTab => 'Export';

  @override
  String get selectAdifFile => 'ADIF-Datei auswählen';

  @override
  String get selectFileBtn => 'Datei auswählen (.adi / .adif)';

  @override
  String get stationRequired => 'Stationsprofil *';

  @override
  String importing(int done, int total) {
    return 'Importiere... $done/$total';
  }

  @override
  String get importBtn => 'Importieren';

  @override
  String get fileReadError =>
      'Dateiinhalt konnte nicht gelesen werden, bitte erneut versuchen';

  @override
  String get invalidFileExtension =>
      'Bitte eine Datei mit der Endung .adi oder .adif auswählen';

  @override
  String get exportFilters => 'Export-Filter';

  @override
  String get stationFilter => 'Station';

  @override
  String get allStations => 'Alle Stationen';

  @override
  String get startDate => 'Start';

  @override
  String get endDate => 'Ende';

  @override
  String get notSelected => 'Nicht ausgewählt';

  @override
  String get clearDates => 'Datumsangaben löschen';

  @override
  String get exporting => 'Exportiere...';

  @override
  String get exportAndShare => 'Exportieren und Teilen';

  @override
  String get copyPath => 'Pfad kopieren';

  @override
  String get reshare => 'Erneut teilen';

  @override
  String get pathCopied => 'Dateipfad kopiert';

  @override
  String qsoExported(int count) {
    return '$count QSO(s) exportiert';
  }

  @override
  String get noStationForExport => 'Keine Station für den Export gefunden';

  @override
  String qsoImported(int imported, int total) {
    return '$imported / $total QSO(s) importiert';
  }

  @override
  String get selectSaveLocation => 'Speicherort auswählen';

  @override
  String get copySuffix => '(Kopie)';

  @override
  String get errNetwork => 'Keine Verbindung — Netzwerk prüfen';

  @override
  String get errTimeout => 'Verbindung abgelaufen';

  @override
  String get errUnauthorized => 'Ungültiger API-Schlüssel';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get connectionSection => 'Verbindung';

  @override
  String get sessionSection => 'Sitzung';

  @override
  String get loggedIn => 'Angemeldet';

  @override
  String get logoutBtn => 'Abmelden';

  @override
  String get logoutTitle => 'Abmelden';

  @override
  String get logoutConfirm => 'Wirklich abmelden?';

  @override
  String get switchAccountBtn => 'Konto wechseln';

  @override
  String get activeStationSection => 'Aktive Station';

  @override
  String get selectStationBtn => 'Station auswählen';

  @override
  String get addStationWeb => 'Station im Web hinzufügen';

  @override
  String get defaultsSection => 'Standards';

  @override
  String get defaultBand => 'Standardband';

  @override
  String get defaultMode => 'Standardbetriebsart';

  @override
  String get appSection => 'App';

  @override
  String get darkTheme => 'Dunkles Design';

  @override
  String get darkThemeHint => 'Empfohlen für den Feldeinsatz';

  @override
  String get offlineMode => 'Offline-Modus';

  @override
  String get offlineModeHint =>
      'QSOs zuerst lokal speichern, später synchronisieren';

  @override
  String get languageLabel => 'Sprache';

  @override
  String get infoSection => 'Info';

  @override
  String get aboutAppBtn => 'Über';

  @override
  String get aboutAppHint => 'Version, Entwickler, Lizenz';

  @override
  String get dataSection => 'Daten';

  @override
  String get clearCacheBtn => 'QSO-Cache löschen';

  @override
  String get clearCacheHint => 'Löscht den lokalen QSO-Cache';

  @override
  String get clearCacheTitle => 'Cache löschen';

  @override
  String get clearCacheConfirm =>
      'Lokaler QSO-Cache wird gelöscht. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get clearCacheAction => 'Löschen';

  @override
  String get cacheCleared => 'Cache gelöscht';

  @override
  String get langSystem => 'Systemstandard';

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langPolish => 'Polski';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get aboutTitle => 'Über';

  @override
  String get appDescription => 'Open-Source-Android-App für Wavelog';

  @override
  String versionLabel(String version, String build) {
    return 'Version $version  (Build $build)';
  }

  @override
  String get mobileDeveloperSection => 'Mobile-App-Entwickler';

  @override
  String get wavelogProjectSection => 'Wavelog-Projekt';

  @override
  String get wavelogDescription => 'Webbasiertes Amateurfunklogbuchsystem';

  @override
  String get coreDevelopers => 'Kernentwickler';

  @override
  String get mitLicense => 'MIT-Lizenz';

  @override
  String get mitDescription =>
      'Diese App und das Wavelog-Projekt werden unter der MIT-Lizenz vertrieben. Open Source, ohne Garantie.';

  @override
  String get licenseSection => 'Lizenz';

  @override
  String get errorNoConnection => 'Keine Verbindung';

  @override
  String get errorUnauthorized => 'Nicht autorisiert — API-Schlüssel prüfen';

  @override
  String get errorServer => 'Serverfehler';

  @override
  String get patchRequiredTitle => 'Server-Patch erforderlich';

  @override
  String get patchRequiredMessage =>
      'Bearbeitungs- und Löschfunktionen erfordern den Wavelog Mobile API-Patch auf Ihrem Server.\n\nInstallationsanweisungen finden Sie unter sp9aqg.pl/install.html.';

  @override
  String get patchRequiredBanner =>
      'Bearbeitungs- und Löschfunktionen erfordern den Wavelog Mobile API-Patch auf Ihrem Server.';

  @override
  String get patchViewGuide => 'Anleitung anzeigen';

  @override
  String get setupGuideTitle => 'Einrichtungsanleitung';

  @override
  String get setupGuideIntro =>
      'Bevor Sie QSOs loggen können, verbinden Sie die App mit Ihrem Wavelog-Server. Folgen Sie den Schritten unten.';

  @override
  String get setupGuidePatchWarning =>
      'Diese App erfordert den Wavelog Mobile-Patch auf Ihrem Server. Auch wenn Sie ohne ihn einen API v2-Token erstellen, wird die App nicht korrekt funktionieren.';

  @override
  String get setupGuidePatchStepTitle => 'Server-Patch installieren';

  @override
  String get setupGuidePatchStepBody =>
      'Die App verwendet Wavelogs API v2, die einen kleinen Patch auf Ihrem Server erfordert. Falls noch nicht installiert, öffnen Sie die Installationsanleitung und folgen Sie den Schritten für Ihre Einrichtung (Klassisch oder Docker).';

  @override
  String get setupGuidePatchBtn => 'Installationsanleitung';

  @override
  String get setupGuideStep1Title => '1. Server-Adresse';

  @override
  String get setupGuideStep1Body =>
      'Geben Sie die gleiche Adresse ein, die Sie zum Öffnen von Wavelog im Browser verwenden, z. B. https://ihredomain.de — ohne abschließenden Schrägstrich.';

  @override
  String get setupGuideStep2Title => '2. API v2-Token';

  @override
  String get setupGuideStep2Body =>
      'Gehen Sie in Wavelog zu Einstellungen → API → API-Token (v2) → Neuer Token. Wählen Sie das Preset \"Wavelog Mobile\" und bestätigen Sie. Kopieren Sie den generierten Token (beginnt mit wl2_) und fügen Sie ihn in die App ein.';

  @override
  String get setupGuideStep3Title => '3. Rufzeichen & Anzeigename';

  @override
  String get setupGuideStep3Body =>
      'Rufzeichen: Ihr eigenes Amateurfunkrufzeichen, das zum Abgleich mit Ihrer Station verwendet wird. Anzeigename: Eine beliebige Bezeichnung, um diese Anmeldung auf Ihrem Gerät zu erkennen.';

  @override
  String get setupGuideContinueBtn => 'Einrichtung starten';

  @override
  String get migrationTokenHint => 'wl2_…';

  @override
  String get migrationTokenLabel => 'API v2-Token';

  @override
  String get migrationValidateBtn => 'Überprüfen & Fortfahren';

  @override
  String get migrationValidating => 'Überprüfen…';

  @override
  String get migrationTokenEmpty => 'Bitte wl2_-Token einfügen.';

  @override
  String get migrationTokenInvalid =>
      'Token ungültig — bitte prüfen und erneut versuchen.';

  @override
  String get patchNotInstalledTitle => 'Patch nicht erkannt';

  @override
  String get patchNotInstalledBody =>
      'Der Wavelog Mobile-Patch scheint nicht auf Ihrem Server installiert zu sein.\n\nEin API v2-Token (wl2_…) funktioniert ohne den Patch nicht. Bitte führen Sie zuerst Schritt 1 aus.';

  @override
  String get patchInstallFirst => 'Patch installieren';

  @override
  String get appSubtitle => 'Amateurfunk-Logbuch-Anwendung';

  @override
  String get switchToLightTheme => 'Zum hellen Design wechseln';

  @override
  String get switchToDarkTheme => 'Zum dunklen Design wechseln';

  @override
  String get deleteQsoTitle => 'QSO löschen';

  @override
  String deleteQsoConfirm(String callsign, String date) {
    return 'QSO mit $callsign am $date dauerhaft löschen?';
  }

  @override
  String get editTooltip => 'Bearbeiten';

  @override
  String get shareAdifTooltip => 'ADIF teilen';

  @override
  String get localNotSynced => 'Lokaler Eintrag — noch nicht synchronisiert';

  @override
  String get satellite => 'Satellit';

  @override
  String get satelliteMode => 'Satellitenbetrieb';

  @override
  String get antenna => 'Antenne';

  @override
  String get nameLabel => 'Name';

  @override
  String get stateProvince => 'Bundesland/Provinz';

  @override
  String get county => 'Landkreis';

  @override
  String get city => 'Stadt';

  @override
  String get continentAF => 'Afrika';

  @override
  String get continentAN => 'Antarktis';

  @override
  String get continentAS => 'Asien';

  @override
  String get continentEU => 'Europa';

  @override
  String get continentNA => 'Nordamerika';

  @override
  String get continentOC => 'Ozeanien';

  @override
  String get continentSA => 'Südamerika';

  @override
  String get qrzProfileLoading => 'QRZ-Profil laden...';

  @override
  String viewOnQrz(String callsign) {
    return 'Auf QRZ.com anzeigen  ($callsign)';
  }

  @override
  String get qslMethods => 'QSL-Methoden';

  @override
  String get bureau => 'Büro';

  @override
  String qslManagerPrefix(String manager) {
    return 'Manager: $manager';
  }

  @override
  String get callsignCopied => 'Rufzeichen kopiert';

  @override
  String get uploadedStatus => 'Hochgeladen';

  @override
  String get notUploadedStatus => 'Nicht hochgeladen';

  @override
  String get matchedStatus => 'Abgeglichen';

  @override
  String get toDeleteStatus => 'Zum Löschen';

  @override
  String get yes => 'Ja';

  @override
  String get requested => 'Angefordert';

  @override
  String get no => 'Nein';

  @override
  String get invalid => 'Ungültig';

  @override
  String get viaDirect => 'Direkt';

  @override
  String get viaElectronic => 'Elektronisch';

  @override
  String get viaMail => 'Post';

  @override
  String otherAdifFields(int count) {
    return 'Weitere ADIF-Felder ($count)';
  }

  @override
  String get editQsoTitle => 'QSO bearbeiten';

  @override
  String get qsoUpdated => 'QSO aktualisiert';

  @override
  String get qsoUpdatedLocal => 'QSO lokal aktualisiert';

  @override
  String get counterStationHint =>
      'Rufzeichen eingeben, um QRZ-Info\nund frühere QSOs\nhier zu sehen.';

  @override
  String previousQsosCount(int count) {
    return 'Frühere QSOs ($count)';
  }

  @override
  String morePreviousQsos(int count) {
    return '+$count weitere...';
  }

  @override
  String previousQsosWithCallsign(String callsign) {
    return 'Frühere QSOs mit $callsign';
  }

  @override
  String totalQsos(int count) {
    return '$count gesamt';
  }

  @override
  String get workedBefore => 'Früher gearbeitet';

  @override
  String get lastQsoLabel => 'Letztes QSO';

  @override
  String get themeLabel => 'Design';

  @override
  String get darkThemeActive => 'Dunkles Design aktiv';

  @override
  String get lightThemeActive => 'Helles Design aktiv';

  @override
  String get lightThemeLabel => 'Hell';

  @override
  String get darkThemeLabel => 'Dunkel';

  @override
  String get commentNotes => 'Kommentar / Notizen';

  @override
  String get commentLabel => 'Kommentar';

  @override
  String get exchangeReceived => 'Empfangene Exchange';

  @override
  String get exchangeSent => 'Gesendete Exchange';

  @override
  String get contestIdLabel => 'Contest';

  @override
  String get sigLabel => 'SIG';

  @override
  String get stationSetup => 'Stationseinrichtung';

  @override
  String get logbooks => 'Logbücher';

  @override
  String get locations => 'Standorte';

  @override
  String get newLogbook => 'Neues Logbuch';

  @override
  String get logbookName => 'Logbuchname';

  @override
  String get renameLogbook => 'Umbenennen';

  @override
  String get deleteLogbook => 'Logbuch löschen';

  @override
  String get setActiveLogbook => 'Aktiv setzen';

  @override
  String get activeLogbook => 'Aktives Logbuch';

  @override
  String get editStation => 'Bearbeiten';

  @override
  String get cloneStation => 'Klonen';

  @override
  String get deleteStation => 'Löschen';

  @override
  String get deleteStationConfirm => 'Station löschen';

  @override
  String get deleteStationWarning =>
      'Alle QSOs dieser Station werden dauerhaft gelöscht. Fortfahren?';

  @override
  String get stationDeleted => 'Station gelöscht';

  @override
  String get stationUpdated => 'Station aktualisiert';

  @override
  String get stationCloned => 'Station geklont';

  @override
  String get linkLocation => 'Standort verknüpfen';

  @override
  String get unlinkLocation => 'Verknüpfung aufheben';

  @override
  String get linkedLocations => 'Verknüpfte Standorte';

  @override
  String get newStationName => 'Neuer Stationsname';

  @override
  String get deleteLogbookConfirm => 'Logbuch löschen';

  @override
  String get deleteLogbookWarning =>
      'Dieses Logbuch wird gelöscht. Verknüpfte Standorte bleiben erhalten. Fortfahren?';

  @override
  String get logbookDeleted => 'Logbuch gelöscht';

  @override
  String get hrdlogCode => 'HRDLog-Code';

  @override
  String get webAdifApiKey => 'WebADIF-API-Schlüssel';

  @override
  String get webAdifApiUrl => 'WebADIF-API-URL';

  @override
  String get basicInfo => 'Grundlegende Info';

  @override
  String get locationSectionTitle => 'Standort';

  @override
  String get awardReferences => 'Award-Referenzen';

  @override
  String get integrationsSectionTitle => 'Integrationen';

  @override
  String get stationSettingsSection => 'Stationseinstellungen';

  @override
  String get editStationTitle => 'Station bearbeiten';

  @override
  String get newStationTitle => 'Neue Station';

  @override
  String get saveChangesBtn => 'Änderungen speichern';

  @override
  String get createStationBtn => 'Station erstellen';

  @override
  String get stationCreated => 'Station erstellt';

  @override
  String get stationCreateFailed =>
      'Fehlgeschlagen. Möglicherweise existiert bereits ein Profil mit diesem Namen.';

  @override
  String get stationProfileNameLabel => 'Stationsprofilname *';

  @override
  String get stationProfileNameHint => 'Heimstation';

  @override
  String get cityQth => 'Stadt / QTH';

  @override
  String get powerWatts => 'Leistung (W)';

  @override
  String get dxccCountry => 'DXCC / Land';

  @override
  String get selectLabel => 'Auswählen...';

  @override
  String get dxccSearch => 'DXCC / Land suchen';

  @override
  String get deletedDxcc => 'Gelöschtes DXCC';

  @override
  String get eqslQthNicknameLabel => 'eQSL QTH-Spitzname';

  @override
  String get eqslDefaultMsgLabel => 'eQSL-Standardnachricht';

  @override
  String get pending => 'Ausstehend';

  @override
  String get uploadDisabled => 'Deaktiviert';

  @override
  String get uploadEnabled => 'Aktiviert';

  @override
  String get uploadRealtime => 'Echtzeit';

  @override
  String get qrzApiKeyLabel => 'QRZ.com Logbuch-API-Schlüssel';

  @override
  String get qrzUploadLabel => 'QRZ.com-Upload';

  @override
  String get clublogIgnoreTitle => 'Clublog ignorieren';

  @override
  String get clublogIgnoreSubtitle =>
      'Diese Station von Clublog-Uploads ausschließen';

  @override
  String get clublogRealtimeTitle => 'Clublog Echtzeit';

  @override
  String get clublogRealtimeSubtitle => 'QSOs in Echtzeit zu Clublog hochladen';

  @override
  String get hrdlogUsernameLabel => 'HRDLog.net-Benutzername';

  @override
  String get hrdlogApiKeyLabel => 'HRDLog.net-API-Schlüssel';

  @override
  String get hrdlogUploadLabel => 'HRDLog.net-Upload';

  @override
  String get qo100ApiKeyLabel => 'QO-100 DX Club API-Schlüssel';

  @override
  String get qo100RealtimeTitle => 'QO-100 DX Club Echtzeit';

  @override
  String get qo100RealtimeSubtitle =>
      'QSOs in Echtzeit zu QO-100 DX Club hochladen';

  @override
  String get oqrsSectionTitle => 'OQRS (Online QSL)';

  @override
  String get oqrsEnabledTitle => 'OQRS aktiviert';

  @override
  String get oqrsEnabledSubtitle => 'Online-QSL-Anforderungssystem aktivieren';

  @override
  String get oqrsTextLabel => 'OQRS-Beschreibungstext';

  @override
  String get oqrsEmailLabel => 'OQRS-E-Mail';

  @override
  String get setAsActiveStationTitle => 'Als aktive Station festlegen';

  @override
  String get setAsActiveStationSubtitle =>
      'Diese Station in Wavelog als aktiv markieren';

  @override
  String get linkToActiveLogbookTitle => 'Mit aktivem Logbuch verknüpfen';

  @override
  String get linkToActiveLogbookSubtitle =>
      'Bei Erstellung automatisch mit dem aktiven Logbuch verknüpfen';

  @override
  String get active => 'Aktiv';

  @override
  String get loadDetailsFailed => 'Details konnten nicht geladen werden';

  @override
  String get cannotDeleteActiveStation =>
      'Die aktive Station kann nicht gelöscht werden.';

  @override
  String get navStats => 'Statistik';

  @override
  String get statisticsTitle => 'Statistiken';

  @override
  String get uniqueCallsigns => 'Eindeutige Rufzeichen';

  @override
  String get currentStreak => 'Aktuelle Serie';

  @override
  String streakDays(int count) {
    return '$count Tag(e)';
  }

  @override
  String get bandDistribution => 'Bandverteilung';

  @override
  String get modeDistribution => 'Betriebsartenverteilung';

  @override
  String get perStation => 'Pro Station';

  @override
  String get basedOnCache =>
      'Band-/Betriebsarten-/Stationsstatistiken basieren auf gecachten QSOs.';

  @override
  String get statsTab => 'Statistiken';

  @override
  String get propagationTab => 'Ausbreitung';

  @override
  String get bandConditions => 'Bandbedingungen';

  @override
  String get dayTime => 'Tag';

  @override
  String get nightTime => 'Nacht';

  @override
  String get conditionGood => 'Gut';

  @override
  String get conditionFair => 'Mäßig';

  @override
  String get conditionPoor => 'Schlecht';

  @override
  String lastUpdated(String time) {
    return 'Aktualisiert: $time';
  }

  @override
  String get noSolarData => 'Solardaten konnten nicht geladen werden';

  @override
  String get potaStats => 'POTA-Statistiken';

  @override
  String get potaTotalQsos => 'POTA-QSOs';

  @override
  String get potaActivatedParks => 'Aktivierte Parks';

  @override
  String get potaAllParks => 'Alle Parks';

  @override
  String get potaActivatedBadge => 'Aktiviert';

  @override
  String get potaAttemptBadge => 'Versuch';

  @override
  String get potaNoStation => 'Kein POTA-Stationsprofil konfiguriert';

  @override
  String get potaNoQsos => 'Keine POTA-QSOs im Cache';

  @override
  String get navSpot => 'Spot';

  @override
  String get spotTitle => 'Spot';

  @override
  String get spotAdd => 'Spot hinzufügen';

  @override
  String get spotSend => 'Spot senden';

  @override
  String get spotSent => 'Spot gesendet!';

  @override
  String get spotNoResults => 'Keine Spots gefunden';

  @override
  String get spotLoadError => 'Spots konnten nicht geladen werden';

  @override
  String get spotActivator => 'Aktivator-Rufzeichen';

  @override
  String get spotSpotter => 'Spotter-Rufzeichen';

  @override
  String get spotFrequency => 'Frequenz (kHz)';

  @override
  String get spotReference => 'Park-Referenz';

  @override
  String get spotComments => 'Kommentare';

  @override
  String get spotCommentsHint => 'QRZ, CQ POTA...';

  @override
  String get spotInvalidRef => 'Ungültiges Format (z. B. PL-0001)';

  @override
  String get sortNewest => 'Neueste zuerst';

  @override
  String get sortOldest => 'Älteste zuerst';

  @override
  String get filterBand => 'Band';

  @override
  String get filterMode => 'Betriebsart';

  @override
  String get filterCountry => 'Land';

  @override
  String get filterAssociation => 'Verband';

  @override
  String get spotAddComingSoon => 'Spot hinzufügen — Demnächst';

  @override
  String get filterClear => 'Filter löschen';

  @override
  String get mode => 'Betriebsart';

  @override
  String get required => 'Erforderlich';

  @override
  String get invalidNumber => 'Ungültige Zahl';

  @override
  String get potaAutoSpot => 'Auto-Spot';

  @override
  String get potaAutoSpotHint =>
      'Automatisch selbst-spotten beim Loggen eines QSOs an einer POTA- oder SOTA-Station (30 min Abkühlung)';

  @override
  String autoSpotSent(String ref) {
    return 'Auto-Spot gesendet: $ref';
  }

  @override
  String get autoSpotWillFire => 'QSO wird einen Spot auslösen';

  @override
  String autoSpotCooldown(int min) {
    return 'Spot gesendet · Nächster in $min min';
  }

  @override
  String get autoSpotCooldownSoon => 'Spot gesendet · Nächster Spot bald';

  @override
  String autoSpotKeyChanged(String fields) {
    return '$fields geändert · Neuer Spot wird gesendet';
  }

  @override
  String get autoSpotFieldFreq => 'Frequenz';

  @override
  String get autoSpotFieldMode => 'Betriebsart';

  @override
  String get autoSpotFieldRef => 'Park';

  @override
  String get logbookSummaryTitle => 'Letzte QSOs';

  @override
  String todayQsoCount(int count) {
    return 'Heute: $count QSO';
  }

  @override
  String get colDateTime => 'Datum/Zeit';

  @override
  String get colRstSent => 'RST(S)';

  @override
  String get colRstRcvd => 'RST(E)';

  @override
  String get submodeLabel => 'Unterart';

  @override
  String selectedCount(int count) {
    return '$count ausgewählt';
  }

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get exportSelected => 'Exportieren';

  @override
  String get deleteSelected => 'Löschen';

  @override
  String deleteSelectedConfirm(int count) {
    return '$count QSOs löschen?';
  }

  @override
  String get mapTitle => 'Karte';

  @override
  String get mapNoData => 'Keine QSOs mit Locator gefunden';

  @override
  String mapStationCount(int count) {
    return '$count Stationen';
  }

  @override
  String get dxccProgress => 'DXCC-Fortschritt';

  @override
  String get workedCountries => 'Gearbeitete Länder';

  @override
  String get dxccWorked => 'Gearbeitet';

  @override
  String dxccUniqueEntities(int count) {
    return '$count einmalige Entitäten';
  }

  @override
  String get dxccConfirmed => 'Bestätigt (LoTW / eQSL / QSL)';

  @override
  String get dxccRemaining => 'Verbleibend';

  @override
  String get dxccLegendConfirmed => 'Bestätigt';

  @override
  String get dxccLegendPending => 'Ausstehend';

  @override
  String get dxccLegendNotWorked => 'Nicht gearbeitet';

  @override
  String get spotSummitNotFound => 'Gipfel nicht gefunden';

  @override
  String get spotParkNotFound => 'Park nicht gefunden';

  @override
  String get qsoTypeTitle => 'QSO loggen';

  @override
  String get normalQso => 'Normales QSO';

  @override
  String get normalQsoDesc => 'Standardeintrag';

  @override
  String get contestQso => 'Contest-QSO';

  @override
  String get contestQsoDesc => 'Schnelles Contest-Loggen mit Exchange';

  @override
  String get contestLog => 'Contest-Log';

  @override
  String get contestSetup => 'Contest-Einstellungen';

  @override
  String get contestNameHint => 'z. B. CQ-WW-CW';

  @override
  String get ourExchange => 'Unser Exchange';

  @override
  String get serialStart => 'Startnummer #';

  @override
  String get showExchangeFields => 'Exchange-Felder';

  @override
  String get startContest => 'Loggen starten';

  @override
  String get endContest => 'Sitzung beenden';

  @override
  String get endContestConfirm =>
      'Contest-Sitzung beenden? (Seriennummernzähler und Einstellungen werden zurückgesetzt.)';

  @override
  String get serialSentLabel => 'Gsd. Nr.';

  @override
  String get serialRcvdLabel => 'Empf. Nr.';

  @override
  String get exchangeSentLabel => 'Gsd. Exch.';

  @override
  String get exchangeRcvdLabel => 'Empf. Exch.';

  @override
  String get gridSentLabel => 'Grid G.';

  @override
  String get gridRcvdLabel => 'Grid E.';

  @override
  String get logQso => 'QSO loggen';

  @override
  String get qsoLogged => 'QSO geloggt';

  @override
  String get contestRecentQsos => 'Letzte';

  @override
  String get contestSessions => 'Contest-Sitzungen';

  @override
  String get newSession => 'Neue Sitzung';

  @override
  String get noContestSessions => 'Noch keine Contest-Sitzungen';

  @override
  String get noContestSessionsHint =>
      'Erstellen Sie eine Sitzung im Web oder tippen Sie auf +, um eine hier zu starten.';

  @override
  String get contestSessionActive => 'Aktiv';

  @override
  String get contestSessionEnded => 'Beendet';

  @override
  String qsoCount(int count) {
    return '$count QSOs';
  }

  @override
  String contestSessionDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get createContestSession => 'Contest-Sitzung erstellen';

  @override
  String get sessionName => 'Sitzungsname (optional)';

  @override
  String get sessionNameHint => 'z. B. Heimstation — CW';

  @override
  String get selectContest => 'Contest auswählen *';

  @override
  String get searchContest => 'Contests suchen...';

  @override
  String get serverContests => 'Vom Server';

  @override
  String get builtinContests => 'Häufige Contests';

  @override
  String get startDateTime => 'Startdatum/-uhrzeit *';

  @override
  String get endDateTime => 'Enddatum/-uhrzeit *';

  @override
  String get durationShortcut4h => '+4h';

  @override
  String get durationShortcut12h => '+12h';

  @override
  String get durationShortcut24h => '+24h';

  @override
  String get durationShortcut48h => '+48h';

  @override
  String get exchangeType => 'Exchange-Typ';

  @override
  String get exchangeTypeSerial => 'Seriennummer';

  @override
  String get exchangeTypeExchange => 'Text-Exchange';

  @override
  String get exchangeTypeBoth => 'Seriennummer + Text-Exchange';

  @override
  String get createSession => 'Sitzung erstellen';

  @override
  String get sessionCreated => 'Contest-Sitzung erstellt';

  @override
  String get sessionUpdated => 'Contest-Sitzung aktualisiert';

  @override
  String get editContestSession => 'Contest-Sitzung bearbeiten';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get deleteSession => 'Sitzung löschen';

  @override
  String get deleteSessionConfirm =>
      'Diese Contest-Sitzung löschen? Die in dieser Sitzung geloggten QSOs bleiben im Logbuch erhalten.';

  @override
  String get openSession => 'Zum Loggen öffnen';

  @override
  String get patchRequiredContest =>
      'Die Contest-Sitzungsverwaltung erfordert den aktualisierten Wavelog Mobile-Patch.';

  @override
  String get contestCalendarTitle => 'Contest-Kalender';

  @override
  String get contestCalendarNoContests => 'Keine Contests gefunden.';

  @override
  String get contestCalendarToday => 'Heute';

  @override
  String get contestCalendarThisWeek => 'Diese Woche';

  @override
  String get contestCalendarUpcoming => 'Bevorstehend';

  @override
  String get contestCalendarRecentlyPast => 'Kürzlich vergangen';

  @override
  String get contestCalendarLoadError =>
      'Contest-Kalender konnte nicht geladen werden';

  @override
  String get contestCalendarRefresh => 'Aktualisieren';

  @override
  String get contestCalendarRetry => 'Erneut versuchen';

  @override
  String get upcomingContestsTitle => 'Bevorstehende Contests';

  @override
  String get viewAll => 'Alle anzeigen';

  @override
  String get noUpcomingContests => 'Keine bevorstehenden Contests gefunden.';

  @override
  String get contestTodayBadge => 'HEUTE';

  @override
  String get navStyleLabel => 'Navigationsstil';

  @override
  String get navStyleModern => 'Modern — FAB + Schublade';

  @override
  String get navStyleClassic => 'Klassisch — 6-Tab-Leiste';

  @override
  String get drawerMap => 'Karte';

  @override
  String get drawerContestCalendar => 'Contest-Kalender';

  @override
  String get drawerContestSessions => 'Contest-Sitzungen';

  @override
  String get drawerAdif => 'ADIF';

  @override
  String get drawerMenu => 'Menü';

  @override
  String get antennaCompassTitle => 'Antennenrichtung';

  @override
  String get targetGrid => 'Ziel-Locator';

  @override
  String get calculate => 'Berechnen';

  @override
  String get shortPath => 'Kurzweg';

  @override
  String get longPath => 'Langweg';

  @override
  String get azimuth => 'Azimut';

  @override
  String get myHeading => 'Richtung';

  @override
  String get invalidGrid => 'Ungültiger Locator';

  @override
  String get gpsLocating => 'GPS-Ortung… bitte warten';

  @override
  String get gpsUnavailable => 'GPS-Standort nicht verfügbar';

  @override
  String get drawerAntenna => 'Antennenrichtung';

  @override
  String get achievementsTitle => 'Erfolge';

  @override
  String get achievementsEmpty =>
      'Loggen Sie Ihr erstes QSO, um Abzeichen zu verdienen!';

  @override
  String get shareAchievement => 'Teilen';

  @override
  String get achievementUnlocked => 'Erfolg freigeschaltet!';

  @override
  String progressLabel(int done, int target) {
    return '$done / $target';
  }

  @override
  String get drawerAchievements => 'Erfolge';

  @override
  String get gifPreparing => 'Video vorbereiten...';

  @override
  String gifCapturing(int percent) {
    return 'Frames erfassen... $percent%';
  }

  @override
  String get gifEncoding => 'Video kodieren...';

  @override
  String get comingSoon => 'Demnächst';

  @override
  String get noCompassSensor => 'Kein Kompasssensor';

  @override
  String get fillFromGps => 'Von GPS ausfüllen';

  @override
  String get locationPermissionDenied => 'Standortberechtigung verweigert';

  @override
  String gpsError(String error) {
    return 'GPS-Fehler: $error';
  }

  @override
  String get errParse => 'Serverantwort konnte nicht verarbeitet werden';

  @override
  String get errLocalStorage => 'Lokaler Speicherfehler';

  @override
  String get errServer => 'Serverfehler';

  @override
  String get wpxPrefix => 'WPX-Präfix';

  @override
  String get nowBtn => 'Jetzt';

  @override
  String get contestOtherCustom => 'Andere / Eigene';

  @override
  String get sigInfo => 'SIG-Info';

  @override
  String get migrationTitle => 'API v2 erforderlich';

  @override
  String get migrationBody =>
      'Wavelog Mobile verwendet jetzt Wavelogs neues API-System. Ihr alter API-Schlüssel ist nicht mehr gültig — folgen Sie den Schritten unten, um in wenigen Minuten zu migrieren.';

  @override
  String get migrationStep1Title => 'Server-Patch installieren';

  @override
  String get migrationStep1Body =>
      'Eine kleine Aktualisierungsdatei muss auf Ihrem Wavelog-Server installiert werden. Tippen Sie auf die Schaltfläche Installationsanleitung unten, um die Schritt-für-Schritt-Anweisungen zu sehen.';

  @override
  String get migrationInstallGuideBtn => 'Installationsanleitung';

  @override
  String get migrationStep2Title => 'Neuen API-Token erstellen';

  @override
  String get migrationStep2Body =>
      'In der Wavelog-Weboberfläche:\n  1. Einstellungsmenü oben rechts öffnen\n  2. Zu \"API\" → \"API-Token\" gehen\n  3. \"Neuer Token\" klicken\n  4. Preset \"Wavelog Mobile\" auswählen\n  5. Bestätigen und den angezeigten Code kopieren\n  (Token beginnt mit \"wl2_\")';

  @override
  String get migrationStep3Title => 'Profil aktualisieren';

  @override
  String get migrationStep3Body =>
      'Tippen Sie auf die Schaltfläche unten. Ihre Server-Adresse wird beibehalten — fügen Sie einfach den kopierten neuen Token in das Feld ein.';

  @override
  String get migrationUpdateTokenBtn => 'Token aktualisieren';

  @override
  String get migrationHelpBtn => 'Hilfe & Installationsanleitung';
}
