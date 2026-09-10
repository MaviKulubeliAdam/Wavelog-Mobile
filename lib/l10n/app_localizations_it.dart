// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Wavelog Mobile';

  @override
  String get splashConnecting => 'CONNESSIONE';

  @override
  String get navHome => 'Home';

  @override
  String get navLogbook => 'Diario';

  @override
  String get navLookup => 'Ricerca';

  @override
  String get navStation => 'Stazione';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get continueBtn => 'Continua';

  @override
  String get close => 'Chiudi';

  @override
  String get retry => 'Riprova';

  @override
  String get loading => 'Caricamento...';

  @override
  String get error => 'Errore';

  @override
  String get success => 'Successo';

  @override
  String get change => 'Modifica';

  @override
  String get goWeb => 'Apri →';

  @override
  String get editOnWeb => 'Modifica sul Web';

  @override
  String get openInBrowser => 'Apri nel browser';

  @override
  String get serverSetupTitle => 'Configurazione server';

  @override
  String get serverSetupSubtitle => 'Configura il tuo server Wavelog';

  @override
  String get serverUrlLabel => 'URL server Wavelog';

  @override
  String get serverUrlHint => 'https://log.esempio.com';

  @override
  String get testConnection => 'Testa connessione';

  @override
  String get testingConnection => 'Test in corso...';

  @override
  String get connectionSuccess => 'Connessione riuscita!';

  @override
  String get connectionFailed => 'Connessione non riuscita';

  @override
  String get apiKeyCopied => 'Chiave API copiata';

  @override
  String get loginTitle => 'Accesso';

  @override
  String get serverBtn => 'Server';

  @override
  String get addAccountBtn => 'Aggiungi account';

  @override
  String get signInBtn => 'Accedi';

  @override
  String get deleteProfile => 'Elimina';

  @override
  String get deleteProfileTitle => 'Elimina account';

  @override
  String deleteProfileConfirm(String name) {
    return 'Rimuovere $name da questo dispositivo?';
  }

  @override
  String get displayName => 'Nome visualizzato';

  @override
  String get callsign => 'Nominativo';

  @override
  String get apiKeyLabel => 'Chiave API';

  @override
  String get validating => 'Validazione...';

  @override
  String get profileSaved => 'Account salvato';

  @override
  String get loginFailed => 'Accesso non riuscito';

  @override
  String get noStationFound => 'Nessuna stazione trovata — uso del nominativo';

  @override
  String get homeTitle => 'Home';

  @override
  String get addQso => 'Aggiungi QSO';

  @override
  String get recentQsos => 'QSO recenti';

  @override
  String get statsToday => 'Oggi';

  @override
  String get statsMonth => 'Mese';

  @override
  String get statsYear => 'Anno';

  @override
  String get statsTotal => 'Totale';

  @override
  String get noRecentQsos => 'Nessun QSO';

  @override
  String get syncNow => 'Sincronizza ora';

  @override
  String pendingSync(int count) {
    return '$count QSO in attesa di sync';
  }

  @override
  String get offlineBanner => 'Offline — QSO salvati localmente';

  @override
  String get activeStation => 'Stazione attiva';

  @override
  String get logbookTitle => 'Diario di stazione';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterAllModes => 'Tutti i modi';

  @override
  String get searchHint => 'Cerca nominativo...';

  @override
  String get noQsos => 'Nessun QSO trovato';

  @override
  String get qsoDetailTitle => 'Dettaglio QSO';

  @override
  String get qsoNotFound => 'QSO non trovato';

  @override
  String get signal => 'Segnale';

  @override
  String get rstSent => 'RST Inviato';

  @override
  String get rstReceived => 'RST Ricevuto';

  @override
  String get txPower => 'Potenza TX';

  @override
  String get counterStation => 'Stazione corrispondente';

  @override
  String get country => 'Paese';

  @override
  String get continent => 'Continente';

  @override
  String get dxcc => 'DXCC';

  @override
  String get cqZone => 'Zona CQ';

  @override
  String get ituZone => 'Zona ITU';

  @override
  String get gridSquare => 'Locatore';

  @override
  String get propMode => 'Propagazione';

  @override
  String get distance => 'Distanza';

  @override
  String get qslStatus => 'Stato QSL';

  @override
  String get paperQsl => 'Cartolina';

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
  String get qslSent => 'Inviato';

  @override
  String get qslRcvd => 'Ricevuto';

  @override
  String get qslReceived => 'Ricevuto';

  @override
  String get qslMethod => 'Metodo';

  @override
  String get awards => 'Riferimenti diplomi';

  @override
  String get iota => 'IOTA';

  @override
  String get sota => 'SOTA';

  @override
  String get wwff => 'WWFF';

  @override
  String get pota => 'POTA';

  @override
  String get myStation => 'La mia stazione';

  @override
  String get myCallsign => 'Il mio nominativo';

  @override
  String get contest => 'Contest';

  @override
  String get serialSent => 'Numero inviato';

  @override
  String get serialReceived => 'Numero ricevuto';

  @override
  String get solarConditions => 'Condizioni solari';

  @override
  String get aIndex => 'Indice A';

  @override
  String get kIndex => 'Indice K';

  @override
  String get sfi => 'SFI';

  @override
  String get notesSection => 'Note';

  @override
  String get rawAdif => 'ADIF grezzo';

  @override
  String get showAll => 'Mostra tutto';

  @override
  String get showLess => 'Mostra meno';

  @override
  String get qrzProfile => 'Profilo QRZ';

  @override
  String get addQsoTitle => 'Aggiungi QSO';

  @override
  String get liveQso => 'QSO in diretta';

  @override
  String get historicalQso => 'QSO storico';

  @override
  String get callsignField => 'Nominativo *';

  @override
  String get lookupSearch => 'Ricerca QRZ';

  @override
  String get liveDateTimeLabel => 'Data/Ora (UTC) — In diretta';

  @override
  String get dateTimeLabel => 'Data/Ora (UTC)';

  @override
  String get bandField => 'Banda *';

  @override
  String get modeField => 'Modo *';

  @override
  String get frequencyField => 'Frequenza (MHz)';

  @override
  String get rstSentField => 'RST Inviato *';

  @override
  String get rstRcvdField => 'RST Ricevuto *';

  @override
  String get nameField => 'Nome';

  @override
  String get qthField => 'QTH';

  @override
  String get gridField => 'Locatore';

  @override
  String get commentField => 'Commento';

  @override
  String get stationProfileField => 'Profilo stazione';

  @override
  String get saveQsoBtn => 'Salva QSO';

  @override
  String qsoSaved(String callsign) {
    return '✓  $callsign salvato';
  }

  @override
  String qsoSavedLocal(String callsign) {
    return '✓  $callsign salvato localmente';
  }

  @override
  String get noActiveStation => 'Nessuna stazione attiva selezionata';

  @override
  String get lookupTitle => 'Ricerca nominativo';

  @override
  String get lookupHint => 'Inserisci nominativo...';

  @override
  String get lookupBtn => 'Cerca';

  @override
  String get recentSearches => 'Ricerche recenti';

  @override
  String get clearHistory => 'Cancella cronologia';

  @override
  String get makeQso => 'Registra QSO';

  @override
  String get notFound => 'Non trovato';

  @override
  String get stationsTitle => 'Stazioni';

  @override
  String stationActivated(String callsign) {
    return '$callsign impostata come stazione attiva';
  }

  @override
  String get stationWebInfo =>
      'Aggiungi e modifica le stazioni tramite l\'interfaccia web Wavelog.';

  @override
  String get noStations => 'Nessuna stazione';

  @override
  String get noStationsHint =>
      'Aggiungi una stazione tramite l\'interfaccia web Wavelog.';

  @override
  String get addStationOnWeb => 'Aggiungi stazione su Wavelog';

  @override
  String get adifTitle => 'Import / Export ADIF';

  @override
  String get importTab => 'Import';

  @override
  String get exportTab => 'Export';

  @override
  String get selectAdifFile => 'Seleziona file ADIF';

  @override
  String get selectFileBtn => 'Scegli file (.adi / .adif)';

  @override
  String get stationRequired => 'Profilo stazione *';

  @override
  String importing(int done, int total) {
    return 'Import... $done/$total';
  }

  @override
  String get importBtn => 'Importa';

  @override
  String get fileReadError => 'Impossibile leggere il file, riprova';

  @override
  String get invalidFileExtension =>
      'Seleziona un file con estensione .adi o .adif';

  @override
  String get exportFilters => 'Filtri export';

  @override
  String get stationFilter => 'Stazione';

  @override
  String get allStations => 'Tutte le stazioni';

  @override
  String get startDate => 'Inizio';

  @override
  String get endDate => 'Fine';

  @override
  String get notSelected => 'Non selezionato';

  @override
  String get clearDates => 'Cancella date';

  @override
  String get exporting => 'Export in corso...';

  @override
  String get exportAndShare => 'Esporta e condividi';

  @override
  String get copyPath => 'Copia percorso';

  @override
  String get reshare => 'Condividi di nuovo';

  @override
  String get pathCopied => 'Percorso copiato';

  @override
  String qsoExported(int count) {
    return '$count QSO esportati';
  }

  @override
  String get noStationForExport => 'Nessuna stazione trovata per l\'export';

  @override
  String qsoImported(int imported, int total) {
    return '$imported / $total QSO importati';
  }

  @override
  String get selectSaveLocation => 'Scegli posizione di salvataggio';

  @override
  String get copySuffix => '(Copia)';

  @override
  String get errNetwork => 'Nessuna connessione — controlla la rete';

  @override
  String get errTimeout => 'Connessione scaduta';

  @override
  String get errUnauthorized => 'Chiave API non valida';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get connectionSection => 'Connessione';

  @override
  String get sessionSection => 'Sessione';

  @override
  String get loggedIn => 'Connesso';

  @override
  String get logoutBtn => 'Disconnetti';

  @override
  String get logoutTitle => 'Disconnessione';

  @override
  String get logoutConfirm => 'Sei sicuro di voler disconnetterti?';

  @override
  String get switchAccountBtn => 'Cambia account';

  @override
  String get activeStationSection => 'Stazione attiva';

  @override
  String get selectStationBtn => 'Seleziona stazione';

  @override
  String get addStationWeb => 'Aggiungi stazione sul Web';

  @override
  String get defaultsSection => 'Valori predefiniti';

  @override
  String get defaultBand => 'Banda predefinita';

  @override
  String get defaultMode => 'Modo predefinito';

  @override
  String get appSection => 'App';

  @override
  String get darkTheme => 'Tema scuro';

  @override
  String get darkThemeHint => 'Consigliato per uso sul campo';

  @override
  String get offlineMode => 'Modalità offline';

  @override
  String get offlineModeHint =>
      'Salva i QSO localmente, sincronizza in seguito';

  @override
  String get allowInsecureSsl => 'Consenti certificati SSL non verificati';

  @override
  String get allowInsecureSslHint =>
      'Considera attendibili i certificati auto-firmati o di CA privata (per server self-hosted). Non consigliato su reti pubbliche.';

  @override
  String get languageLabel => 'Lingua';

  @override
  String get infoSection => 'Informazioni';

  @override
  String get aboutAppBtn => 'Informazioni';

  @override
  String get aboutAppHint => 'Versione, sviluppatore, licenza';

  @override
  String get dataSection => 'Dati';

  @override
  String get clearCacheBtn => 'Svuota cache QSO';

  @override
  String get clearCacheHint => 'Elimina la cache QSO locale';

  @override
  String get clearCacheTitle => 'Svuota cache';

  @override
  String get clearCacheConfirm =>
      'La cache QSO locale verrà eliminata. Questa operazione non può essere annullata.';

  @override
  String get clearCacheAction => 'Svuota';

  @override
  String get cacheCleared => 'Cache svuotata';

  @override
  String get langSystem => 'Lingua di sistema';

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langPolish => 'Polski';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langFrench => 'Français';

  @override
  String get langItalian => 'Italiano';

  @override
  String get langJapanese => '日本語';

  @override
  String get langKorean => '한국어';

  @override
  String get langRussian => 'Russo';

  @override
  String get aboutTitle => 'Informazioni';

  @override
  String get appDescription => 'App Android open source per Wavelog';

  @override
  String versionLabel(String version, String build) {
    return 'Versione $version  (Build $build)';
  }

  @override
  String get mobileDeveloperSection => 'Sviluppatore app mobile';

  @override
  String get wavelogProjectSection => 'Progetto Wavelog';

  @override
  String get wavelogDescription =>
      'Sistema di log radioamatoriale basato sul Web';

  @override
  String get coreDevelopers => 'Sviluppatori principali';

  @override
  String get mitLicense => 'Licenza MIT';

  @override
  String get mitDescription =>
      'Questa app e il progetto Wavelog sono distribuiti sotto licenza MIT. Open source, nessuna garanzia.';

  @override
  String get licenseSection => 'Licenza';

  @override
  String get errorNoConnection => 'Nessuna connessione';

  @override
  String get errorUnauthorized => 'Non autorizzato — controlla la chiave API';

  @override
  String get errorServer => 'Errore server';

  @override
  String get patchRequiredTitle => 'Patch server richiesta';

  @override
  String get patchRequiredMessage =>
      'Le funzioni di modifica ed eliminazione richiedono il patch API Wavelog Mobile sul tuo server.\n\nVisita sp9aqg.pl/install.html per le istruzioni.';

  @override
  String get patchRequiredBanner =>
      'Le funzioni di modifica ed eliminazione richiedono il patch API Wavelog Mobile.';

  @override
  String get patchViewGuide => 'Vedi guida';

  @override
  String get setupGuideTitle => 'Guida configurazione';

  @override
  String get setupGuideIntro =>
      'Prima di poter registrare QSO, connetti l\'app al tuo server Wavelog.';

  @override
  String get setupGuidePatchWarning =>
      'Questa app richiede il patch Wavelog Mobile sul tuo server.';

  @override
  String get setupGuidePatchStepTitle => 'Installa patch server';

  @override
  String get setupGuidePatchStepBody =>
      'L\'app utilizza l\'API v2 di Wavelog, che richiede un piccolo patch sul tuo server.';

  @override
  String get setupGuidePatchBtn => 'Guida installazione';

  @override
  String get setupGuideStep1Title => '1. Indirizzo server';

  @override
  String get setupGuideStep1Body =>
      'Inserisci lo stesso indirizzo che usi per aprire Wavelog nel browser, es. https://tuodominio.com';

  @override
  String get setupGuideStep2Title => '2. Token API v2';

  @override
  String get setupGuideStep2Body =>
      'In Wavelog, vai in Impostazioni → API → Token API (v2) → Nuovo token. Seleziona il preset \"Wavelog Mobile\" e conferma. Copia il token generato (inizia con wl2_).';

  @override
  String get setupGuideStep3Title => '3. Nominativo e Nome visualizzato';

  @override
  String get setupGuideStep3Body =>
      'Nominativo: il tuo nominativo radioamatoriale. Nome visualizzato: un\'etichetta per riconoscere questo accesso sul dispositivo.';

  @override
  String get setupGuideContinueBtn => 'Avvia configurazione';

  @override
  String get migrationTokenHint => 'wl2_…';

  @override
  String get migrationTokenLabel => 'Token API v2';

  @override
  String get migrationValidateBtn => 'Valida e continua';

  @override
  String get migrationValidating => 'Validazione…';

  @override
  String get migrationTokenEmpty => 'Incolla il tuo token wl2_.';

  @override
  String get migrationTokenInvalid => 'Token non valido — controlla e riprova.';

  @override
  String get patchNotInstalledTitle => 'Patch non rilevata';

  @override
  String get patchNotInstalledBody =>
      'Il patch Wavelog Mobile non sembra installato sul tuo server.\n\nUn token API v2 (wl2_…) non funzionerà senza il patch.';

  @override
  String get patchInstallFirst => 'Installa patch';

  @override
  String get appSubtitle => 'Applicazione di log radioamatoriale';

  @override
  String get switchToLightTheme => 'Passa al tema chiaro';

  @override
  String get switchToDarkTheme => 'Passa al tema scuro';

  @override
  String get deleteQsoTitle => 'Elimina QSO';

  @override
  String deleteQsoConfirm(String callsign, String date) {
    return 'Eliminare definitivamente il QSO con $callsign del $date?';
  }

  @override
  String get editTooltip => 'Modifica';

  @override
  String get shareAdifTooltip => 'Condividi ADIF';

  @override
  String get localNotSynced => 'Record locale — non ancora sincronizzato';

  @override
  String get satellite => 'Satellite';

  @override
  String get satelliteMode => 'Modo satellite';

  @override
  String get antenna => 'Antenna';

  @override
  String get nameLabel => 'Nome';

  @override
  String get stateProvince => 'Stato/Provincia';

  @override
  String get county => 'Contea';

  @override
  String get city => 'Città';

  @override
  String get continentAF => 'Africa';

  @override
  String get continentAN => 'Antartide';

  @override
  String get continentAS => 'Asia';

  @override
  String get continentEU => 'Europa';

  @override
  String get continentNA => 'America del Nord';

  @override
  String get continentOC => 'Oceania';

  @override
  String get continentSA => 'America del Sud';

  @override
  String get qrzProfileLoading => 'Caricamento profilo QRZ...';

  @override
  String viewOnQrz(String callsign) {
    return 'Vedi su QRZ.com  ($callsign)';
  }

  @override
  String get qslMethods => 'Metodi QSL';

  @override
  String get bureau => 'Bureau';

  @override
  String qslManagerPrefix(String manager) {
    return 'Manager: $manager';
  }

  @override
  String get callsignCopied => 'Nominativo copiato';

  @override
  String get uploadedStatus => 'Caricato';

  @override
  String get notUploadedStatus => 'Non caricato';

  @override
  String get matchedStatus => 'Abbinato';

  @override
  String get toDeleteStatus => 'Da eliminare';

  @override
  String get yes => 'Sì';

  @override
  String get requested => 'Richiesto';

  @override
  String get no => 'No';

  @override
  String get invalid => 'Non valido';

  @override
  String get viaDirect => 'Diretto';

  @override
  String get viaElectronic => 'Elettronico';

  @override
  String get viaMail => 'Posta';

  @override
  String otherAdifFields(int count) {
    return 'Altri campi ADIF ($count)';
  }

  @override
  String get editQsoTitle => 'Modifica QSO';

  @override
  String get qsoUpdated => 'QSO aggiornato';

  @override
  String get qsoUpdatedLocal => 'QSO aggiornato localmente';

  @override
  String get counterStationHint =>
      'Inserisci un nominativo per vedere\nle info QRZ e i QSO\nprecedenti qui.';

  @override
  String previousQsosCount(int count) {
    return 'QSO precedenti ($count)';
  }

  @override
  String morePreviousQsos(int count) {
    return '+$count altri...';
  }

  @override
  String previousQsosWithCallsign(String callsign) {
    return 'QSO precedenti con $callsign';
  }

  @override
  String totalQsos(int count) {
    return '$count in totale';
  }

  @override
  String get workedBefore => 'Già contattato';

  @override
  String get lastQsoLabel => 'Ultimo QSO';

  @override
  String get themeLabel => 'Tema';

  @override
  String get darkThemeActive => 'Tema scuro attivo';

  @override
  String get lightThemeActive => 'Tema chiaro attivo';

  @override
  String get lightThemeLabel => 'Chiaro';

  @override
  String get darkThemeLabel => 'Scuro';

  @override
  String get commentNotes => 'Commento / Note';

  @override
  String get commentLabel => 'Commento';

  @override
  String get exchangeReceived => 'Scambio ricevuto';

  @override
  String get exchangeSent => 'Scambio inviato';

  @override
  String get contestIdLabel => 'Contest';

  @override
  String get sigLabel => 'SIG';

  @override
  String get stationSetup => 'Configurazione stazione';

  @override
  String get logbooks => 'Diari di stazione';

  @override
  String get locations => 'Posizioni';

  @override
  String get newLogbook => 'Nuovo diario';

  @override
  String get logbookName => 'Nome diario';

  @override
  String get renameLogbook => 'Rinomina';

  @override
  String get deleteLogbook => 'Elimina diario';

  @override
  String get setActiveLogbook => 'Imposta attivo';

  @override
  String get activeLogbook => 'Diario attivo';

  @override
  String get editStation => 'Modifica';

  @override
  String get cloneStation => 'Clona';

  @override
  String get deleteStation => 'Elimina';

  @override
  String get deleteStationConfirm => 'Elimina stazione';

  @override
  String get deleteStationWarning =>
      'Tutti i QSO di questa stazione saranno eliminati definitivamente. Continuare?';

  @override
  String get stationDeleted => 'Stazione eliminata';

  @override
  String get stationUpdated => 'Stazione aggiornata';

  @override
  String get stationCloned => 'Stazione clonata';

  @override
  String get linkLocation => 'Collega posizione';

  @override
  String get unlinkLocation => 'Scollega';

  @override
  String get linkedLocations => 'Posizioni collegate';

  @override
  String get newStationName => 'Nome nuova stazione';

  @override
  String get deleteLogbookConfirm => 'Elimina diario';

  @override
  String get deleteLogbookWarning =>
      'Questo diario verrà eliminato. Le posizioni collegate sono conservate. Continuare?';

  @override
  String get logbookDeleted => 'Diario eliminato';

  @override
  String get hrdlogCode => 'Codice HRDLog';

  @override
  String get webAdifApiKey => 'Chiave API WebADIF';

  @override
  String get webAdifApiUrl => 'URL API WebADIF';

  @override
  String get basicInfo => 'Informazioni di base';

  @override
  String get locationSectionTitle => 'Posizione';

  @override
  String get awardReferences => 'Riferimenti diplomi';

  @override
  String get integrationsSectionTitle => 'Integrazioni';

  @override
  String get stationSettingsSection => 'Impostazioni stazione';

  @override
  String get editStationTitle => 'Modifica stazione';

  @override
  String get newStationTitle => 'Nuova stazione';

  @override
  String get saveChangesBtn => 'Salva modifiche';

  @override
  String get createStationBtn => 'Crea stazione';

  @override
  String get stationCreated => 'Stazione creata';

  @override
  String get stationCreateFailed =>
      'Errore. Potrebbe esistere già un profilo con questo nome.';

  @override
  String get stationProfileNameLabel => 'Nome profilo stazione *';

  @override
  String get stationProfileNameHint => 'Stazione principale';

  @override
  String get cityQth => 'Città / QTH';

  @override
  String get powerWatts => 'Potenza (W)';

  @override
  String get dxccCountry => 'DXCC / Paese';

  @override
  String get selectLabel => 'Seleziona...';

  @override
  String get dxccSearch => 'Cerca DXCC / Paese';

  @override
  String get deletedDxcc => 'DXCC eliminato';

  @override
  String get eqslQthNicknameLabel => 'Soprannome QTH eQSL';

  @override
  String get eqslDefaultMsgLabel => 'Messaggio predefinito eQSL';

  @override
  String get pending => 'In attesa';

  @override
  String get uploadDisabled => 'Disabilitato';

  @override
  String get uploadEnabled => 'Abilitato';

  @override
  String get uploadRealtime => 'Tempo reale';

  @override
  String get qrzApiKeyLabel => 'Chiave API QRZ.com Logbook';

  @override
  String get qrzUploadLabel => 'Caricamento QRZ.com';

  @override
  String get clublogIgnoreTitle => 'Ignora Clublog';

  @override
  String get clublogIgnoreSubtitle =>
      'Escludi questa stazione dai caricamenti Clublog';

  @override
  String get clublogRealtimeTitle => 'Clublog tempo reale';

  @override
  String get clublogRealtimeSubtitle =>
      'Carica i QSO su Clublog in tempo reale';

  @override
  String get hrdlogUsernameLabel => 'Nome utente HRDLog.net';

  @override
  String get hrdlogApiKeyLabel => 'Chiave API HRDLog.net';

  @override
  String get hrdlogUploadLabel => 'Caricamento HRDLog.net';

  @override
  String get qo100ApiKeyLabel => 'Chiave API QO-100 DX Club';

  @override
  String get qo100RealtimeTitle => 'QO-100 DX Club tempo reale';

  @override
  String get qo100RealtimeSubtitle =>
      'Carica i QSO su QO-100 DX Club in tempo reale';

  @override
  String get oqrsSectionTitle => 'OQRS (QSL online)';

  @override
  String get oqrsEnabledTitle => 'OQRS abilitato';

  @override
  String get oqrsEnabledSubtitle =>
      'Abilita il sistema di richiesta QSL online';

  @override
  String get oqrsTextLabel => 'Testo descrizione OQRS';

  @override
  String get oqrsEmailLabel => 'Email OQRS';

  @override
  String get setAsActiveStationTitle => 'Imposta come stazione attiva';

  @override
  String get setAsActiveStationSubtitle =>
      'Segna questa stazione come attiva in Wavelog';

  @override
  String get linkToActiveLogbookTitle => 'Collega al diario attivo';

  @override
  String get linkToActiveLogbookSubtitle =>
      'Collega automaticamente al diario attivo alla creazione';

  @override
  String get active => 'Attivo';

  @override
  String get loadDetailsFailed => 'Caricamento dettagli non riuscito';

  @override
  String get cannotDeleteActiveStation =>
      'Impossibile eliminare la stazione attiva.';

  @override
  String get navStats => 'Stats';

  @override
  String get statisticsTitle => 'Statistiche';

  @override
  String get uniqueCallsigns => 'Nominativi unici';

  @override
  String get currentStreak => 'Serie corrente';

  @override
  String streakDays(int count) {
    return '$count giorno/i';
  }

  @override
  String get bandDistribution => 'Distribuzione per banda';

  @override
  String get modeDistribution => 'Distribuzione per modo';

  @override
  String get perStation => 'Per stazione';

  @override
  String get basedOnCache =>
      'Le statistiche banda/modo/stazione si basano sui QSO in cache.';

  @override
  String get statsTab => 'Statistiche';

  @override
  String get propagationTab => 'Propagazione';

  @override
  String get bandConditions => 'Condizioni di banda';

  @override
  String get dayTime => 'Giorno';

  @override
  String get nightTime => 'Notte';

  @override
  String get conditionGood => 'Buone';

  @override
  String get conditionFair => 'Discrete';

  @override
  String get conditionPoor => 'Scarse';

  @override
  String lastUpdated(String time) {
    return 'Aggiornato: $time';
  }

  @override
  String get noSolarData => 'Impossibile caricare i dati solari';

  @override
  String get potaStats => 'Statistiche POTA';

  @override
  String get potaTotalQsos => 'QSO POTA';

  @override
  String get potaActivatedParks => 'Parchi attivati';

  @override
  String get potaAllParks => 'Tutti i parchi';

  @override
  String get potaActivatedBadge => 'Attivato';

  @override
  String get potaAttemptBadge => 'Tentativo';

  @override
  String get potaNoStation => 'Nessun profilo stazione POTA configurato';

  @override
  String get potaNoQsos => 'Nessun QSO POTA in cache';

  @override
  String get navSpot => 'Spot';

  @override
  String get spotTitle => 'Spot';

  @override
  String get spotAdd => 'Aggiungi spot';

  @override
  String get spotSend => 'Invia spot';

  @override
  String get spotSent => 'Spot inviato!';

  @override
  String get spotNoResults => 'Nessuno spot trovato';

  @override
  String get spotLoadError => 'Impossibile caricare gli spot';

  @override
  String get spotActivator => 'Nominativo attivatore';

  @override
  String get spotSpotter => 'Nominativo spotter';

  @override
  String get spotFrequency => 'Frequenza (kHz)';

  @override
  String get spotReference => 'Riferimento parco';

  @override
  String get spotComments => 'Commenti';

  @override
  String get spotCommentsHint => 'QRZ, CQ POTA...';

  @override
  String get spotInvalidRef => 'Formato non valido (es. PL-0001)';

  @override
  String get sortNewest => 'Più recente prima';

  @override
  String get sortOldest => 'Più vecchio prima';

  @override
  String get filterBand => 'Banda';

  @override
  String get filterMode => 'Modo';

  @override
  String get filterCountry => 'Paese';

  @override
  String get filterAssociation => 'Associazione';

  @override
  String get spotAddComingSoon => 'Aggiungi spot — Prossimamente';

  @override
  String get filterClear => 'Cancella filtri';

  @override
  String get mode => 'Modo';

  @override
  String get required => 'Obbligatorio';

  @override
  String get invalidNumber => 'Numero non valido';

  @override
  String get potaAutoSpot => 'Auto-Spot';

  @override
  String get potaAutoSpotHint =>
      'Auto-spotting automatico durante un QSO a una stazione POTA o SOTA (cooldown 30 min)';

  @override
  String autoSpotSent(String ref) {
    return 'Auto-spot inviato: $ref';
  }

  @override
  String get autoSpotWillFire => 'Il QSO attiverà uno spot';

  @override
  String autoSpotCooldown(int min) {
    return 'Spot inviato · Prossimo tra $min min';
  }

  @override
  String get autoSpotCooldownSoon => 'Spot inviato · Prossimo spot a breve';

  @override
  String autoSpotKeyChanged(String fields) {
    return '$fields modificato/i · Nuovo spot in arrivo';
  }

  @override
  String get autoSpotFieldFreq => 'Frequenza';

  @override
  String get autoSpotFieldMode => 'Modo';

  @override
  String get autoSpotFieldRef => 'Parco';

  @override
  String get logbookSummaryTitle => 'QSO recenti';

  @override
  String todayQsoCount(int count) {
    return 'Oggi: $count QSO';
  }

  @override
  String get colDateTime => 'Data/Ora';

  @override
  String get colRstSent => 'RST(I)';

  @override
  String get colRstRcvd => 'RST(R)';

  @override
  String get submodeLabel => 'Sottomodo';

  @override
  String selectedCount(int count) {
    return '$count selezionato/i';
  }

  @override
  String get selectAll => 'Seleziona tutto';

  @override
  String get exportSelected => 'Esporta';

  @override
  String get deleteSelected => 'Elimina';

  @override
  String deleteSelectedConfirm(int count) {
    return 'Eliminare $count QSO?';
  }

  @override
  String get mapTitle => 'Mappa';

  @override
  String get mapNoData => 'Nessun QSO con locatore trovato';

  @override
  String mapStationCount(int count) {
    return '$count stazioni';
  }

  @override
  String get dxccProgress => 'Progressi DXCC';

  @override
  String get workedCountries => 'Paesi contattati';

  @override
  String get dxccWorked => 'Contattati';

  @override
  String dxccUniqueEntities(int count) {
    return '$count entità uniche';
  }

  @override
  String get dxccConfirmed => 'Confermati (LoTW / eQSL / QSL)';

  @override
  String get dxccRemaining => 'Rimanenti';

  @override
  String get dxccLegendConfirmed => 'Confermato';

  @override
  String get dxccLegendPending => 'In attesa';

  @override
  String get dxccLegendNotWorked => 'Non contattato';

  @override
  String get spotSummitNotFound => 'Vetta non trovata';

  @override
  String get spotParkNotFound => 'Parco non trovato';

  @override
  String get qsoTypeTitle => 'Registra un QSO';

  @override
  String get normalQso => 'QSO normale';

  @override
  String get normalQsoDesc => 'Inserimento contatto standard';

  @override
  String get contestQso => 'QSO contest';

  @override
  String get contestQsoDesc => 'Log contest rapido con scambio';

  @override
  String get contestLog => 'Log contest';

  @override
  String get contestSetup => 'Configurazione contest';

  @override
  String get contestNameHint => 'es. CQ-WW-CW';

  @override
  String get ourExchange => 'Nostro scambio';

  @override
  String get serialStart => 'Numero di serie iniziale';

  @override
  String get showExchangeFields => 'Campi scambio';

  @override
  String get startContest => 'Avvia log';

  @override
  String get endContest => 'Termina sessione';

  @override
  String get endContestConfirm =>
      'Terminare la sessione contest? (Il contatore serie e le impostazioni verranno ripristinati.)';

  @override
  String get serialSentLabel => 'Snt #';

  @override
  String get serialRcvdLabel => 'Rcvd #';

  @override
  String get exchangeSentLabel => 'Sc. Inv';

  @override
  String get exchangeRcvdLabel => 'Sc. Ric';

  @override
  String get gridSentLabel => 'Grid I';

  @override
  String get gridRcvdLabel => 'Grid R';

  @override
  String get logQso => 'Registra QSO';

  @override
  String get qsoLogged => 'QSO registrato';

  @override
  String get contestRecentQsos => 'Recenti';

  @override
  String get contestSessions => 'Sessioni contest';

  @override
  String get newSession => 'Nuova sessione';

  @override
  String get noContestSessions => 'Nessuna sessione contest';

  @override
  String get noContestSessionsHint =>
      'Crea una sessione sul web o premi + per avviarne una.';

  @override
  String get contestSessionActive => 'Attiva';

  @override
  String get contestSessionEnded => 'Terminata';

  @override
  String qsoCount(int count) {
    return '$count QSO';
  }

  @override
  String contestSessionDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get createContestSession => 'Crea sessione contest';

  @override
  String get sessionName => 'Nome sessione (facoltativo)';

  @override
  String get sessionNameHint => 'es. Stazione principale — CW';

  @override
  String get selectContest => 'Seleziona contest *';

  @override
  String get searchContest => 'Cerca contest...';

  @override
  String get serverContests => 'Dal server';

  @override
  String get builtinContests => 'Contest comuni';

  @override
  String get startDateTime => 'Data/Ora inizio *';

  @override
  String get endDateTime => 'Data/Ora fine *';

  @override
  String get durationShortcut4h => '+4h';

  @override
  String get durationShortcut12h => '+12h';

  @override
  String get durationShortcut24h => '+24h';

  @override
  String get durationShortcut48h => '+48h';

  @override
  String get exchangeType => 'Tipo scambio';

  @override
  String get exchangeTypeSerial => 'Numero di serie';

  @override
  String get exchangeTypeExchange => 'Scambio testo';

  @override
  String get exchangeTypeBoth => 'Serie + Scambio testo';

  @override
  String get createSession => 'Crea sessione';

  @override
  String get sessionCreated => 'Sessione contest creata';

  @override
  String get sessionUpdated => 'Sessione contest aggiornata';

  @override
  String get editContestSession => 'Modifica sessione contest';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get deleteSession => 'Elimina sessione';

  @override
  String get deleteSessionConfirm =>
      'Eliminare questa sessione contest? I QSO registrati rimarranno nel diario.';

  @override
  String get openSession => 'Apri per il log';

  @override
  String get patchRequiredContest =>
      'La gestione delle sessioni contest richiede il patch aggiornato di Wavelog Mobile.';

  @override
  String get contestCalendarTitle => 'Calendario contest';

  @override
  String get contestCalendarNoContests => 'Nessun contest trovato.';

  @override
  String get contestCalendarToday => 'Oggi';

  @override
  String get contestCalendarThisWeek => 'Questa settimana';

  @override
  String get contestCalendarUpcoming => 'In arrivo';

  @override
  String get contestCalendarRecentlyPast => 'Recentemente terminati';

  @override
  String get contestCalendarLoadError =>
      'Impossibile caricare il calendario contest';

  @override
  String get contestCalendarRefresh => 'Aggiorna';

  @override
  String get contestCalendarRetry => 'Riprova';

  @override
  String get upcomingContestsTitle => 'Contest in arrivo';

  @override
  String get viewAll => 'Vedi tutti';

  @override
  String get noUpcomingContests => 'Nessun contest in arrivo.';

  @override
  String get contestTodayBadge => 'OGGI';

  @override
  String get navStyleLabel => 'Stile navigazione';

  @override
  String get navStyleModern => 'Moderno — FAB + cassetto';

  @override
  String get navStyleClassic => 'Classico — barra 6 schede';

  @override
  String get drawerMap => 'Mappa';

  @override
  String get drawerContestCalendar => 'Calendario contest';

  @override
  String get drawerContestSessions => 'Sessioni contest';

  @override
  String get drawerAdif => 'ADIF';

  @override
  String get drawerMenu => 'Menu';

  @override
  String get antennaCompassTitle => 'Direzione antenna';

  @override
  String get targetGrid => 'Locatore destinazione';

  @override
  String get calculate => 'Calcola';

  @override
  String get shortPath => 'Percorso breve';

  @override
  String get longPath => 'Percorso lungo';

  @override
  String get azimuth => 'Azimut';

  @override
  String get myHeading => 'Rotta';

  @override
  String get invalidGrid => 'Locatore non valido';

  @override
  String get gpsLocating => 'Localizzazione GPS… attendere';

  @override
  String get gpsUnavailable => 'Posizione GPS non disponibile';

  @override
  String get drawerAntenna => 'Direzione antenna';

  @override
  String get achievementsTitle => 'Obiettivi';

  @override
  String get achievementsEmpty =>
      'Registra il tuo primo QSO per guadagnare badge!';

  @override
  String get shareAchievement => 'Condividi';

  @override
  String get achievementUnlocked => 'Obiettivo sbloccato!';

  @override
  String progressLabel(int done, int target) {
    return '$done / $target';
  }

  @override
  String get drawerAchievements => 'Obiettivi';

  @override
  String get drawerCommunity => 'Comunità';

  @override
  String get communityTitle => 'Comunità';

  @override
  String get communityNoActivations => 'Nessuna attivazione pianificata';

  @override
  String get communityBeFirst => 'Sii il primo ad annunciarne una!';

  @override
  String get communityAnnounce => 'Annuncia attivazione';

  @override
  String get communityFollow => 'Segui';

  @override
  String get communityUnfollow => 'Smetti di seguire';

  @override
  String communityFollowers(int count) {
    return '$count iscritti';
  }

  @override
  String get communityTypeGeneral => 'Generale';

  @override
  String get communityCallsign => 'Nominativo';

  @override
  String get communityReference => 'Riferimento';

  @override
  String get communitySotaRef => 'Riferimento SOTA (TA/AN-001)';

  @override
  String get communityPotaRef => 'Riferimento POTA (TA-0001)';

  @override
  String get communityScheduledTime => 'Orario pianificato';

  @override
  String get communityNote => 'Nota (opzionale)';

  @override
  String get communityNoteHint => 'Breve info sull\'attivazione...';

  @override
  String get communityAnnounceButton => 'Annuncia';

  @override
  String get communityAnnounced => 'Attivazione annunciata!';

  @override
  String get communityRateLimit =>
      'Hai appena fatto un annuncio. Aspetta qualche minuto.';

  @override
  String get communityCallsignRequired => 'Nominativo obbligatorio';

  @override
  String get communityReferenceRequired => 'Riferimento obbligatorio';

  @override
  String get communityBandRequired => 'Seleziona almeno una banda';

  @override
  String get communityActivations => 'Attivazioni';

  @override
  String get communityChat => 'Chat';

  @override
  String get communityEditActivation => 'Modifica attivazione';

  @override
  String get communityDeleteActivation => 'Elimina attivazione';

  @override
  String get communityDeleteActivationConfirm =>
      'Eliminare questa attivazione? L\'operazione non può essere annullata.';

  @override
  String get communityUpdated => 'Attivazione aggiornata';

  @override
  String get chatRooms => 'Stanze chat';

  @override
  String get chatGeneral => 'Generale';

  @override
  String get chatGeneralSubtitle => 'Lingua comune: inglese';

  @override
  String get chatMessageHint => 'Scrivi un messaggio…';

  @override
  String get chatSend => 'Invia';

  @override
  String get chatEdit => 'Modifica';

  @override
  String get chatDelete => 'Elimina';

  @override
  String get chatDeleteConfirm => 'Eliminare questo messaggio?';

  @override
  String get chatEdited => 'modificato';

  @override
  String get chatNoStation => 'Imposta una stazione attiva per chattare';

  @override
  String get gifPreparing => 'Preparazione video...';

  @override
  String gifCapturing(int percent) {
    return 'Acquisizione frame... $percent%';
  }

  @override
  String get gifEncoding => 'Codifica video...';

  @override
  String get comingSoon => 'Prossimamente';

  @override
  String get noCompassSensor => 'Nessun sensore bussola';

  @override
  String get fillFromGps => 'Compila da GPS';

  @override
  String get locationPermissionDenied => 'Autorizzazione posizione negata';

  @override
  String gpsError(String error) {
    return 'Errore GPS: $error';
  }

  @override
  String get errParse => 'Analisi risposta server non riuscita';

  @override
  String get errLocalStorage => 'Errore di archiviazione locale';

  @override
  String get errServer => 'Errore server';

  @override
  String get wpxPrefix => 'Prefisso WPX';

  @override
  String get nowBtn => 'Adesso';

  @override
  String get contestOtherCustom => 'Altro / Personalizzato';

  @override
  String get sigInfo => 'Info SIG';

  @override
  String get migrationTitle => 'API v2 richiesta';

  @override
  String get migrationBody =>
      'Wavelog Mobile usa ora il nuovo sistema API di Wavelog. La tua vecchia chiave API non è più valida — segui i passaggi qui sotto per migrare in pochi minuti.';

  @override
  String get migrationStep1Title => 'Installa patch server';

  @override
  String get migrationStep1Body =>
      'Un piccolo file di aggiornamento deve essere installato sul tuo server Wavelog. Tocca il pulsante Guida installazione per seguire le istruzioni.';

  @override
  String get migrationInstallGuideBtn => 'Guida installazione';

  @override
  String get migrationStep2Title => 'Crea nuovo token API';

  @override
  String get migrationStep2Body =>
      'Nell\'interfaccia web Wavelog:\n  1. Apri il menu impostazioni in alto a destra\n  2. Vai su \"API\" → \"Token API\"\n  3. Clicca su \"Nuovo token\"\n  4. Seleziona il preset \"Wavelog Mobile\"\n  5. Conferma e copia il codice mostrato\n  (Il token inizia con \"wl2_\")';

  @override
  String get migrationStep3Title => 'Aggiorna il tuo profilo';

  @override
  String get migrationStep3Body =>
      'Tocca il pulsante qui sotto. Il tuo indirizzo server verrà conservato — incolla semplicemente il nuovo token nel campo.';

  @override
  String get migrationUpdateTokenBtn => 'Aggiorna token';

  @override
  String get migrationHelpBtn => 'Aiuto & Guida installazione';

  @override
  String get celebTitle => 'Wavelog v3.2.0';

  @override
  String get celebSubtitle => 'Patch server non più necessaria!';

  @override
  String get celebBody =>
      'Tutte le funzionalità ora funzionano direttamente tramite l\'API v2 ufficiale di Wavelog. Puoi rimuovere il vecchio patch dal tuo server.\n\nQuesta app richiede ora Wavelog v3.2.0 o versioni successive.';

  @override
  String get celebCreateToken => 'Crea token API';

  @override
  String get celebSkip => 'Salta';

  @override
  String get celebScopesTitle => 'Ambiti token API v2';

  @override
  String get celebScopesBody =>
      'Durante la creazione di un nuovo token in Wavelog sotto Profilo → Token API → Nuovo token, seleziona i seguenti ambiti:';

  @override
  String get celebDone => 'Capito';

  @override
  String get scopeQsoRead => 'Leggi i QSO';

  @override
  String get scopeQsoWrite => 'Aggiungi / modifica QSO';

  @override
  String get scopeQsoDelete => 'Elimina QSO';

  @override
  String get scopeStationRead => 'Leggi i profili stazione';

  @override
  String get scopeStationWrite => 'Crea / modifica stazioni';

  @override
  String get scopeStationDelete => 'Elimina stazioni';

  @override
  String get scopeLogbookRead => 'Leggi i diari di stazione';

  @override
  String get scopeLogbookWrite => 'Crea / modifica diari';

  @override
  String get scopeLogbookDelete => 'Elimina diari';

  @override
  String get scopeContestRead => 'Leggi le sessioni contest';

  @override
  String get scopeContestWrite => 'Crea / modifica sessioni contest';

  @override
  String get scopeContestDelete => 'Elimina sessioni contest';

  @override
  String get scopeCatalogRead => 'Lista DXCC, suddivisioni e contest';

  @override
  String get scopeLookupRead => 'Ricerca nominativo';

  @override
  String get scopeStatisticsRead => 'Leggi le statistiche';

  @override
  String get scopeConfirmationRead => 'Leggi conferme LoTW / eQSL / QRZ.com';

  @override
  String get scopeTestStation => 'Stazione';

  @override
  String get scopeTestLogbook => 'Diario';

  @override
  String get scopeTestQso => 'QSO';

  @override
  String get scopeTestContest => 'Gara';

  @override
  String get scopeTestConfirmation => 'Conferma';

  @override
  String get scopeTestStatistics => 'Statistiche';

  @override
  String get scopeTestLookup => 'Ricerca';

  @override
  String get apiScopeGuideBtn => 'Guida agli scope API';

  @override
  String get apiScopeGuideTitle => 'Guida agli scope del token API';

  @override
  String get apiScopeGuideIntro =>
      'Durante la creazione di un nuovo token API in Wavelog (Impostazioni → Token API), seleziona tutti gli scope sottostanti per abilitare tutte le funzionalità dell\'app.';

  @override
  String get apiTokenNoticeTitle => 'Crea un nuovo token API';

  @override
  String get apiTokenNoticeBody =>
      'L\'API Wavelog v2 richiede un nuovo token con scope specifici. Vai su Wavelog → Impostazioni → Token API e crea un nuovo token con tutti gli scope richiesti. Tocca il pulsante Guida agli scope qui sotto per l\'elenco completo.';

  @override
  String get apiTokenNoticeDontShow => 'Non mostrare più';

  @override
  String get apiTokenNoticeIgnore => 'Ignora';

  @override
  String get apiTokenNoticeScopeGuide => 'Guida agli scope API';
}
