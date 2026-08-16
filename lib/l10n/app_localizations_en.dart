// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wavelog Mobile';

  @override
  String get splashConnecting => 'CONNECTING';

  @override
  String get navHome => 'Home';

  @override
  String get navLogbook => 'Logbook';

  @override
  String get navLookup => 'Lookup';

  @override
  String get navStation => 'Station';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get refresh => 'Refresh';

  @override
  String get continueBtn => 'Continue';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get change => 'Change';

  @override
  String get goWeb => 'Go →';

  @override
  String get editOnWeb => 'Edit on Web';

  @override
  String get openInBrowser => 'Open in Browser';

  @override
  String get serverSetupTitle => 'Server Setup';

  @override
  String get serverSetupSubtitle => 'Configure your Wavelog server';

  @override
  String get serverUrlLabel => 'Wavelog Server URL';

  @override
  String get serverUrlHint => 'https://log.example.com';

  @override
  String get testConnection => 'Test Connection';

  @override
  String get testingConnection => 'Testing...';

  @override
  String get connectionSuccess => 'Connection successful!';

  @override
  String get connectionFailed => 'Connection failed';

  @override
  String get apiKeyCopied => 'API key copied';

  @override
  String get loginTitle => 'Login';

  @override
  String get serverBtn => 'Server';

  @override
  String get addAccountBtn => 'Add Account';

  @override
  String get signInBtn => 'Sign In';

  @override
  String get deleteProfile => 'Delete';

  @override
  String get deleteProfileTitle => 'Delete Account';

  @override
  String deleteProfileConfirm(String name) {
    return 'Remove $name from this device?';
  }

  @override
  String get displayName => 'Display Name';

  @override
  String get callsign => 'Callsign';

  @override
  String get apiKeyLabel => 'API Key';

  @override
  String get validating => 'Validating...';

  @override
  String get profileSaved => 'Account saved';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get noStationFound => 'No matching station found — using callsign';

  @override
  String get homeTitle => 'Home';

  @override
  String get addQso => 'Add QSO';

  @override
  String get recentQsos => 'Recent QSOs';

  @override
  String get statsToday => 'Today';

  @override
  String get statsMonth => 'Month';

  @override
  String get statsYear => 'Year';

  @override
  String get statsTotal => 'Total';

  @override
  String get noRecentQsos => 'No QSOs yet';

  @override
  String get syncNow => 'Sync Now';

  @override
  String pendingSync(int count) {
    return '$count QSO(s) pending sync';
  }

  @override
  String get offlineBanner => 'Offline — QSOs saved locally';

  @override
  String get activeStation => 'Active station';

  @override
  String get logbookTitle => 'Logbook';

  @override
  String get filterAll => 'All';

  @override
  String get filterAllModes => 'All Modes';

  @override
  String get searchHint => 'Search callsign...';

  @override
  String get noQsos => 'No QSOs found';

  @override
  String get qsoDetailTitle => 'QSO Detail';

  @override
  String get qsoNotFound => 'QSO not found';

  @override
  String get signal => 'Signal';

  @override
  String get rstSent => 'RST Sent';

  @override
  String get rstReceived => 'RST Received';

  @override
  String get txPower => 'TX Power';

  @override
  String get counterStation => 'Counter Station';

  @override
  String get country => 'Country';

  @override
  String get continent => 'Continent';

  @override
  String get dxcc => 'DXCC';

  @override
  String get cqZone => 'CQ Zone';

  @override
  String get ituZone => 'ITU Zone';

  @override
  String get gridSquare => 'Grid Square';

  @override
  String get propMode => 'Propagation';

  @override
  String get distance => 'Distance';

  @override
  String get qslStatus => 'QSL Status';

  @override
  String get paperQsl => 'Paper';

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
  String get qslSent => 'Sent';

  @override
  String get qslRcvd => 'Rcvd';

  @override
  String get qslReceived => 'Received';

  @override
  String get qslMethod => 'Method';

  @override
  String get awards => 'Award References';

  @override
  String get iota => 'IOTA';

  @override
  String get sota => 'SOTA';

  @override
  String get wwff => 'WWFF';

  @override
  String get pota => 'POTA';

  @override
  String get myStation => 'My Station';

  @override
  String get myCallsign => 'My Callsign';

  @override
  String get contest => 'Contest';

  @override
  String get serialSent => 'Serial Sent';

  @override
  String get serialReceived => 'Serial Received';

  @override
  String get solarConditions => 'Solar Conditions';

  @override
  String get aIndex => 'A-Index';

  @override
  String get kIndex => 'K-Index';

  @override
  String get sfi => 'SFI';

  @override
  String get notesSection => 'Notes';

  @override
  String get rawAdif => 'Raw ADIF';

  @override
  String get showAll => 'Show All';

  @override
  String get showLess => 'Show Less';

  @override
  String get qrzProfile => 'QRZ Profile';

  @override
  String get addQsoTitle => 'Add QSO';

  @override
  String get liveQso => 'Live QSO';

  @override
  String get historicalQso => 'Historical QSO';

  @override
  String get callsignField => 'Callsign *';

  @override
  String get lookupSearch => 'QRZ Lookup';

  @override
  String get liveDateTimeLabel => 'Date/Time (UTC) — Live';

  @override
  String get dateTimeLabel => 'Date/Time (UTC)';

  @override
  String get bandField => 'Band *';

  @override
  String get modeField => 'Mode *';

  @override
  String get frequencyField => 'Frequency (MHz)';

  @override
  String get rstSentField => 'RST Sent *';

  @override
  String get rstRcvdField => 'RST Received *';

  @override
  String get nameField => 'Name';

  @override
  String get qthField => 'QTH';

  @override
  String get gridField => 'Grid Square';

  @override
  String get commentField => 'Comment';

  @override
  String get stationProfileField => 'Station Profile';

  @override
  String get saveQsoBtn => 'Save QSO';

  @override
  String qsoSaved(String callsign) {
    return '✓  $callsign saved';
  }

  @override
  String qsoSavedLocal(String callsign) {
    return '✓  $callsign saved locally';
  }

  @override
  String get noActiveStation => 'No active station selected';

  @override
  String get lookupTitle => 'Callsign Lookup';

  @override
  String get lookupHint => 'Enter callsign...';

  @override
  String get lookupBtn => 'Search';

  @override
  String get recentSearches => 'Recent Searches';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get makeQso => 'Log QSO';

  @override
  String get notFound => 'Not found';

  @override
  String get stationsTitle => 'Stations';

  @override
  String stationActivated(String callsign) {
    return '$callsign set as active station';
  }

  @override
  String get stationWebInfo =>
      'Add and edit stations using the Wavelog web interface.';

  @override
  String get noStations => 'No stations yet';

  @override
  String get noStationsHint => 'Add a station via the Wavelog web interface.';

  @override
  String get addStationOnWeb => 'Add Station on Wavelog';

  @override
  String get adifTitle => 'ADIF Import / Export';

  @override
  String get importTab => 'Import';

  @override
  String get exportTab => 'Export';

  @override
  String get selectAdifFile => 'Select ADIF File';

  @override
  String get selectFileBtn => 'Choose File (.adi / .adif)';

  @override
  String get stationRequired => 'Station Profile *';

  @override
  String importing(int done, int total) {
    return 'Importing... $done/$total';
  }

  @override
  String get importBtn => 'Import';

  @override
  String get fileReadError => 'Could not read file content, please try again';

  @override
  String get invalidFileExtension =>
      'Please select a file with .adi or .adif extension';

  @override
  String get exportFilters => 'Export Filters';

  @override
  String get stationFilter => 'Station';

  @override
  String get allStations => 'All Stations';

  @override
  String get startDate => 'Start';

  @override
  String get endDate => 'End';

  @override
  String get notSelected => 'Not selected';

  @override
  String get clearDates => 'Clear Dates';

  @override
  String get exporting => 'Exporting...';

  @override
  String get exportAndShare => 'Export and Share';

  @override
  String get copyPath => 'Copy Path';

  @override
  String get reshare => 'Share Again';

  @override
  String get pathCopied => 'File path copied';

  @override
  String qsoExported(int count) {
    return '$count QSO(s) exported';
  }

  @override
  String get noStationForExport => 'No station found for export';

  @override
  String qsoImported(int imported, int total) {
    return '$imported / $total QSO(s) imported';
  }

  @override
  String get selectSaveLocation => 'Choose save location';

  @override
  String get copySuffix => '(Copy)';

  @override
  String get errNetwork => 'No connection — check your network';

  @override
  String get errTimeout => 'Connection timed out';

  @override
  String get errUnauthorized => 'Invalid API key';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get connectionSection => 'Connection';

  @override
  String get sessionSection => 'Session';

  @override
  String get loggedIn => 'Logged in';

  @override
  String get logoutBtn => 'Logout';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get switchAccountBtn => 'Switch Account';

  @override
  String get activeStationSection => 'Active Station';

  @override
  String get selectStationBtn => 'Select Station';

  @override
  String get addStationWeb => 'Add Station on Web';

  @override
  String get defaultsSection => 'Defaults';

  @override
  String get defaultBand => 'Default Band';

  @override
  String get defaultMode => 'Default Mode';

  @override
  String get appSection => 'App';

  @override
  String get darkTheme => 'Dark Theme';

  @override
  String get darkThemeHint => 'Recommended for field use';

  @override
  String get offlineMode => 'Offline Mode';

  @override
  String get offlineModeHint => 'Save QSOs locally first, sync later';

  @override
  String get languageLabel => 'Language';

  @override
  String get infoSection => 'Info';

  @override
  String get aboutAppBtn => 'About';

  @override
  String get aboutAppHint => 'Version, developer, license';

  @override
  String get dataSection => 'Data';

  @override
  String get clearCacheBtn => 'Clear QSO Cache';

  @override
  String get clearCacheHint => 'Deletes local QSO cache';

  @override
  String get clearCacheTitle => 'Clear Cache';

  @override
  String get clearCacheConfirm =>
      'Local QSO cache will be deleted. This cannot be undone.';

  @override
  String get clearCacheAction => 'Clear';

  @override
  String get cacheCleared => 'Cache cleared';

  @override
  String get langSystem => 'System Default';

  @override
  String get langEnglish => 'English';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langPolish => 'Polski';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get aboutTitle => 'About';

  @override
  String get appDescription => 'Open source Android app for Wavelog';

  @override
  String versionLabel(String version, String build) {
    return 'Version $version  (Build $build)';
  }

  @override
  String get mobileDeveloperSection => 'Mobile App Developer';

  @override
  String get wavelogProjectSection => 'Wavelog Project';

  @override
  String get wavelogDescription => 'Web-based amateur radio logging system';

  @override
  String get coreDevelopers => 'Core Developers';

  @override
  String get mitLicense => 'MIT License';

  @override
  String get mitDescription =>
      'This app and the Wavelog project are distributed under the MIT License. Open source, no warranty provided.';

  @override
  String get licenseSection => 'License';

  @override
  String get errorNoConnection => 'No connection';

  @override
  String get errorUnauthorized => 'Unauthorized — check your API key';

  @override
  String get errorServer => 'Server error';

  @override
  String get patchRequiredTitle => 'Server Patch Required';

  @override
  String get patchRequiredMessage =>
      'Edit and delete features require the Wavelog Mobile API patch to be installed on your server.\n\nVisit sp9aqg.pl/install.html for installation instructions.';

  @override
  String get patchRequiredBanner =>
      'Edit and delete features require the Wavelog Mobile API patch to be installed on your server.';

  @override
  String get patchViewGuide => 'View Guide';

  @override
  String get setupGuideTitle => 'Setup Guide';

  @override
  String get setupGuideIntro =>
      'Before you can log QSOs, connect the app to your Wavelog server. Follow the steps below.';

  @override
  String get setupGuidePatchWarning =>
      'This app requires the Wavelog Mobile patch to be installed on your server. Even if you generate an API v2 token without it, the app will not work correctly.';

  @override
  String get setupGuidePatchStepTitle => 'Install Server Patch';

  @override
  String get setupGuidePatchStepBody =>
      'The app uses Wavelog\'s API v2, which requires a small patch on your server. If you haven\'t installed it yet, open the Installation Guide and follow the steps for your setup (Classic or Docker).';

  @override
  String get setupGuidePatchBtn => 'Installation Guide';

  @override
  String get setupGuideStep1Title => '1. Server Address';

  @override
  String get setupGuideStep1Body =>
      'Enter the same address you use to open Wavelog in your browser, e.g. https://yourdomain.com — without a trailing slash.';

  @override
  String get setupGuideStep2Title => '2. API v2 Token';

  @override
  String get setupGuideStep2Body =>
      'In Wavelog, go to Settings → API → API Tokens (v2) → New Token. Select the \"Wavelog Mobile\" preset and confirm. Copy the generated token (starts with wl2_) and paste it into the app.';

  @override
  String get setupGuideStep3Title => '3. Callsign & Display Name';

  @override
  String get setupGuideStep3Body =>
      'Callsign: your own amateur radio callsign, used to match your station. Display Name: any label to recognize this login on your device.';

  @override
  String get setupGuideContinueBtn => 'Start Setup';

  @override
  String get migrationTokenHint => 'wl2_…';

  @override
  String get migrationTokenLabel => 'API v2 Token';

  @override
  String get migrationValidateBtn => 'Validate & Continue';

  @override
  String get migrationValidating => 'Validating…';

  @override
  String get migrationTokenEmpty => 'Please paste your wl2_ token.';

  @override
  String get migrationTokenInvalid =>
      'Token is invalid — please check and try again.';

  @override
  String get patchNotInstalledTitle => 'Patch Not Detected';

  @override
  String get patchNotInstalledBody =>
      'The Wavelog Mobile patch does not appear to be installed on your server.\n\nAn API v2 token (wl2_…) will not work without the patch. Please complete Step 1 first.';

  @override
  String get patchInstallFirst => 'Install Patch';

  @override
  String get appSubtitle => 'Amateur Radio Log Application';

  @override
  String get switchToLightTheme => 'Switch to light theme';

  @override
  String get switchToDarkTheme => 'Switch to dark theme';

  @override
  String get deleteQsoTitle => 'Delete QSO';

  @override
  String deleteQsoConfirm(String callsign, String date) {
    return 'Permanently delete QSO with $callsign on $date?';
  }

  @override
  String get editTooltip => 'Edit';

  @override
  String get shareAdifTooltip => 'Share ADIF';

  @override
  String get localNotSynced => 'Local record — not yet synchronized';

  @override
  String get satellite => 'Satellite';

  @override
  String get satelliteMode => 'Satellite Mode';

  @override
  String get antenna => 'Antenna';

  @override
  String get nameLabel => 'Name';

  @override
  String get stateProvince => 'State/Province';

  @override
  String get county => 'County';

  @override
  String get city => 'City';

  @override
  String get continentAF => 'Africa';

  @override
  String get continentAN => 'Antarctica';

  @override
  String get continentAS => 'Asia';

  @override
  String get continentEU => 'Europe';

  @override
  String get continentNA => 'North America';

  @override
  String get continentOC => 'Oceania';

  @override
  String get continentSA => 'South America';

  @override
  String get qrzProfileLoading => 'Loading QRZ profile...';

  @override
  String viewOnQrz(String callsign) {
    return 'View on QRZ.com  ($callsign)';
  }

  @override
  String get qslMethods => 'QSL Methods';

  @override
  String get bureau => 'Bureau';

  @override
  String qslManagerPrefix(String manager) {
    return 'Manager: $manager';
  }

  @override
  String get callsignCopied => 'Callsign copied';

  @override
  String get uploadedStatus => 'Uploaded';

  @override
  String get notUploadedStatus => 'Not uploaded';

  @override
  String get matchedStatus => 'Matched';

  @override
  String get toDeleteStatus => 'To delete';

  @override
  String get yes => 'Yes';

  @override
  String get requested => 'Requested';

  @override
  String get no => 'No';

  @override
  String get invalid => 'Invalid';

  @override
  String get viaDirect => 'Direct';

  @override
  String get viaElectronic => 'Electronic';

  @override
  String get viaMail => 'Mail';

  @override
  String otherAdifFields(int count) {
    return 'Other ADIF Fields ($count)';
  }

  @override
  String get editQsoTitle => 'Edit QSO';

  @override
  String get qsoUpdated => 'QSO updated';

  @override
  String get qsoUpdatedLocal => 'QSO updated locally';

  @override
  String get counterStationHint =>
      'Enter callsign to see QRZ\ninfo and previous QSOs\nhere.';

  @override
  String previousQsosCount(int count) {
    return 'Previous QSOs ($count)';
  }

  @override
  String morePreviousQsos(int count) {
    return '+$count more...';
  }

  @override
  String previousQsosWithCallsign(String callsign) {
    return 'Previous QSOs with $callsign';
  }

  @override
  String totalQsos(int count) {
    return '$count total';
  }

  @override
  String get workedBefore => 'Worked before';

  @override
  String get lastQsoLabel => 'Last QSO';

  @override
  String get themeLabel => 'Theme';

  @override
  String get darkThemeActive => 'Dark theme active';

  @override
  String get lightThemeActive => 'Light theme active';

  @override
  String get lightThemeLabel => 'Light';

  @override
  String get darkThemeLabel => 'Dark';

  @override
  String get commentNotes => 'Comment / Notes';

  @override
  String get commentLabel => 'Comment';

  @override
  String get exchangeReceived => 'Received Exchange';

  @override
  String get exchangeSent => 'Sent Exchange';

  @override
  String get contestIdLabel => 'Contest';

  @override
  String get sigLabel => 'SIG';

  @override
  String get stationSetup => 'Station Setup';

  @override
  String get logbooks => 'Logbooks';

  @override
  String get locations => 'Locations';

  @override
  String get newLogbook => 'New Logbook';

  @override
  String get logbookName => 'Logbook Name';

  @override
  String get renameLogbook => 'Rename';

  @override
  String get deleteLogbook => 'Delete Logbook';

  @override
  String get setActiveLogbook => 'Set Active';

  @override
  String get activeLogbook => 'Active Logbook';

  @override
  String get editStation => 'Edit';

  @override
  String get cloneStation => 'Clone';

  @override
  String get deleteStation => 'Delete';

  @override
  String get deleteStationConfirm => 'Delete station';

  @override
  String get deleteStationWarning =>
      'All QSOs of this station will be permanently deleted. Continue?';

  @override
  String get stationDeleted => 'Station deleted';

  @override
  String get stationUpdated => 'Station updated';

  @override
  String get stationCloned => 'Station cloned';

  @override
  String get linkLocation => 'Link Location';

  @override
  String get unlinkLocation => 'Unlink';

  @override
  String get linkedLocations => 'Linked Locations';

  @override
  String get newStationName => 'New station name';

  @override
  String get deleteLogbookConfirm => 'Delete logbook';

  @override
  String get deleteLogbookWarning =>
      'This logbook will be deleted. Linked locations are preserved. Continue?';

  @override
  String get logbookDeleted => 'Logbook deleted';

  @override
  String get hrdlogCode => 'HRDLog Code';

  @override
  String get webAdifApiKey => 'WebADIF API Key';

  @override
  String get webAdifApiUrl => 'WebADIF API URL';

  @override
  String get basicInfo => 'Basic Info';

  @override
  String get locationSectionTitle => 'Location';

  @override
  String get awardReferences => 'Award References';

  @override
  String get integrationsSectionTitle => 'Integrations';

  @override
  String get stationSettingsSection => 'Station Settings';

  @override
  String get editStationTitle => 'Edit Station';

  @override
  String get newStationTitle => 'New Station';

  @override
  String get saveChangesBtn => 'Save Changes';

  @override
  String get createStationBtn => 'Create Station';

  @override
  String get stationCreated => 'Station created';

  @override
  String get stationCreateFailed =>
      'Failed. A profile with that name may already exist.';

  @override
  String get stationProfileNameLabel => 'Station Profile Name *';

  @override
  String get stationProfileNameHint => 'Home Station';

  @override
  String get cityQth => 'City / QTH';

  @override
  String get powerWatts => 'Power (W)';

  @override
  String get dxccCountry => 'DXCC / Country';

  @override
  String get selectLabel => 'Select...';

  @override
  String get dxccSearch => 'Search DXCC / Country';

  @override
  String get deletedDxcc => 'Deleted DXCC';

  @override
  String get eqslQthNicknameLabel => 'eQSL QTH Nickname';

  @override
  String get eqslDefaultMsgLabel => 'eQSL Default Message';

  @override
  String get pending => 'Pending';

  @override
  String get uploadDisabled => 'Disabled';

  @override
  String get uploadEnabled => 'Enabled';

  @override
  String get uploadRealtime => 'Realtime';

  @override
  String get qrzApiKeyLabel => 'QRZ.com Logbook API Key';

  @override
  String get qrzUploadLabel => 'QRZ.com Upload';

  @override
  String get clublogIgnoreTitle => 'Ignore Clublog';

  @override
  String get clublogIgnoreSubtitle =>
      'Exclude this station from Clublog uploads';

  @override
  String get clublogRealtimeTitle => 'Clublog Realtime';

  @override
  String get clublogRealtimeSubtitle => 'Upload QSOs to Clublog in real time';

  @override
  String get hrdlogUsernameLabel => 'HRDLog.net Username';

  @override
  String get hrdlogApiKeyLabel => 'HRDLog.net API Key';

  @override
  String get hrdlogUploadLabel => 'HRDLog.net Upload';

  @override
  String get qo100ApiKeyLabel => 'QO-100 DX Club API Key';

  @override
  String get qo100RealtimeTitle => 'QO-100 DX Club Realtime';

  @override
  String get qo100RealtimeSubtitle =>
      'Upload QSOs to QO-100 DX Club in real time';

  @override
  String get oqrsSectionTitle => 'OQRS (Online QSL)';

  @override
  String get oqrsEnabledTitle => 'OQRS Enabled';

  @override
  String get oqrsEnabledSubtitle => 'Enable the online QSL request system';

  @override
  String get oqrsTextLabel => 'OQRS Description Text';

  @override
  String get oqrsEmailLabel => 'OQRS Email';

  @override
  String get setAsActiveStationTitle => 'Set as Active Station';

  @override
  String get setAsActiveStationSubtitle =>
      'Mark this station as active in Wavelog';

  @override
  String get linkToActiveLogbookTitle => 'Link to Active Logbook';

  @override
  String get linkToActiveLogbookSubtitle =>
      'Automatically link to the active logbook on creation';

  @override
  String get active => 'Active';

  @override
  String get loadDetailsFailed => 'Failed to load details';

  @override
  String get cannotDeleteActiveStation => 'Cannot delete the active station.';

  @override
  String get navStats => 'Stats';

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get uniqueCallsigns => 'Unique Calls';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String streakDays(int count) {
    return '$count day(s)';
  }

  @override
  String get bandDistribution => 'Band Distribution';

  @override
  String get modeDistribution => 'Mode Distribution';

  @override
  String get perStation => 'Per Station';

  @override
  String get basedOnCache =>
      'Band / mode / station stats are based on cached QSOs.';

  @override
  String get statsTab => 'Statistics';

  @override
  String get propagationTab => 'Propagation';

  @override
  String get bandConditions => 'Band Conditions';

  @override
  String get dayTime => 'Day';

  @override
  String get nightTime => 'Night';

  @override
  String get conditionGood => 'Good';

  @override
  String get conditionFair => 'Fair';

  @override
  String get conditionPoor => 'Poor';

  @override
  String lastUpdated(String time) {
    return 'Updated: $time';
  }

  @override
  String get noSolarData => 'Could not load solar data';

  @override
  String get potaStats => 'POTA Statistics';

  @override
  String get potaTotalQsos => 'POTA QSOs';

  @override
  String get potaActivatedParks => 'Activated Parks';

  @override
  String get potaAllParks => 'All Parks';

  @override
  String get potaActivatedBadge => 'Activated';

  @override
  String get potaAttemptBadge => 'Attempt';

  @override
  String get potaNoStation => 'No POTA station profile configured';

  @override
  String get potaNoQsos => 'No POTA QSOs in cache';

  @override
  String get navSpot => 'Spot';

  @override
  String get spotTitle => 'Spot';

  @override
  String get spotAdd => 'Add Spot';

  @override
  String get spotSend => 'Send Spot';

  @override
  String get spotSent => 'Spot sent!';

  @override
  String get spotNoResults => 'No spots found';

  @override
  String get spotLoadError => 'Could not load spots';

  @override
  String get spotActivator => 'Activator Callsign';

  @override
  String get spotSpotter => 'Spotter Callsign';

  @override
  String get spotFrequency => 'Frequency (kHz)';

  @override
  String get spotReference => 'Park Reference';

  @override
  String get spotComments => 'Comments';

  @override
  String get spotCommentsHint => 'QRZ, CQ POTA...';

  @override
  String get spotInvalidRef => 'Invalid format (e.g. PL-0001)';

  @override
  String get sortNewest => 'Newest first';

  @override
  String get sortOldest => 'Oldest first';

  @override
  String get filterBand => 'Band';

  @override
  String get filterMode => 'Mode';

  @override
  String get filterCountry => 'Country';

  @override
  String get filterAssociation => 'Association';

  @override
  String get spotAddComingSoon => 'Add Spot — Coming Soon';

  @override
  String get filterClear => 'Clear filters';

  @override
  String get mode => 'Mode';

  @override
  String get required => 'Required';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get potaAutoSpot => 'Auto-Spot';

  @override
  String get potaAutoSpotHint =>
      'Automatically self-spot when logging a QSO at a POTA or SOTA station (30 min cooldown each)';

  @override
  String autoSpotSent(String ref) {
    return 'Auto-spot sent: $ref';
  }

  @override
  String get autoSpotWillFire => 'QSO will trigger a spot';

  @override
  String autoSpotCooldown(int min) {
    return 'Spot sent · Next in $min min';
  }

  @override
  String get autoSpotCooldownSoon => 'Spot sent · Next spot soon';

  @override
  String autoSpotKeyChanged(String fields) {
    return '$fields changed · New spot will fire';
  }

  @override
  String get autoSpotFieldFreq => 'Frequency';

  @override
  String get autoSpotFieldMode => 'Mode';

  @override
  String get autoSpotFieldRef => 'Park';

  @override
  String get logbookSummaryTitle => 'Recent QSOs';

  @override
  String todayQsoCount(int count) {
    return 'Today: $count QSO';
  }

  @override
  String get colDateTime => 'Date/Time';

  @override
  String get colRstSent => 'RST(S)';

  @override
  String get colRstRcvd => 'RST(R)';

  @override
  String get submodeLabel => 'Submode';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get selectAll => 'Select All';

  @override
  String get exportSelected => 'Export';

  @override
  String get deleteSelected => 'Delete';

  @override
  String deleteSelectedConfirm(int count) {
    return 'Delete $count QSOs?';
  }

  @override
  String get mapTitle => 'Map';

  @override
  String get mapNoData => 'No QSOs with grid square found';

  @override
  String mapStationCount(int count) {
    return '$count stations';
  }

  @override
  String get dxccProgress => 'DXCC Progress';

  @override
  String get workedCountries => 'Worked Countries';

  @override
  String get dxccWorked => 'Worked';

  @override
  String dxccUniqueEntities(int count) {
    return '$count unique entities';
  }

  @override
  String get dxccConfirmed => 'Confirmed (LoTW / eQSL / QSL)';

  @override
  String get dxccRemaining => 'Remaining';

  @override
  String get dxccLegendConfirmed => 'Confirmed';

  @override
  String get dxccLegendPending => 'Pending';

  @override
  String get dxccLegendNotWorked => 'Not worked';

  @override
  String get spotSummitNotFound => 'Summit not found';

  @override
  String get spotParkNotFound => 'Park not found';

  @override
  String get qsoTypeTitle => 'Log a QSO';

  @override
  String get normalQso => 'Normal QSO';

  @override
  String get normalQsoDesc => 'Standard contact entry';

  @override
  String get contestQso => 'Contest QSO';

  @override
  String get contestQsoDesc => 'Fast contest logging with exchange';

  @override
  String get contestLog => 'Contest Log';

  @override
  String get contestSetup => 'Contest Setup';

  @override
  String get contestNameHint => 'e.g. CQ-WW-CW';

  @override
  String get ourExchange => 'Our Exchange';

  @override
  String get serialStart => 'Starting Serial #';

  @override
  String get showExchangeFields => 'Exchange fields';

  @override
  String get startContest => 'Start Logging';

  @override
  String get endContest => 'End Session';

  @override
  String get endContestConfirm =>
      'End contest session? (Serial counter and settings will be reset.)';

  @override
  String get serialSentLabel => 'Snt #';

  @override
  String get serialRcvdLabel => 'Rcvd #';

  @override
  String get exchangeSentLabel => 'Snt Exch';

  @override
  String get exchangeRcvdLabel => 'Rcvd Exch';

  @override
  String get gridSentLabel => 'Grid S';

  @override
  String get gridRcvdLabel => 'Grid R';

  @override
  String get logQso => 'Log QSO';

  @override
  String get qsoLogged => 'QSO logged';

  @override
  String get contestRecentQsos => 'Recent';

  @override
  String get contestSessions => 'Contest Sessions';

  @override
  String get newSession => 'New Session';

  @override
  String get noContestSessions => 'No contest sessions yet';

  @override
  String get noContestSessionsHint =>
      'Create a session on the web or tap + to start one here.';

  @override
  String get contestSessionActive => 'Active';

  @override
  String get contestSessionEnded => 'Ended';

  @override
  String qsoCount(int count) {
    return '$count QSOs';
  }

  @override
  String contestSessionDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get createContestSession => 'Create Contest Session';

  @override
  String get sessionName => 'Session Name (optional)';

  @override
  String get sessionNameHint => 'e.g. Home Station — CW';

  @override
  String get selectContest => 'Select Contest *';

  @override
  String get searchContest => 'Search contests...';

  @override
  String get serverContests => 'From Server';

  @override
  String get builtinContests => 'Common Contests';

  @override
  String get startDateTime => 'Start Date/Time *';

  @override
  String get endDateTime => 'End Date/Time *';

  @override
  String get durationShortcut4h => '+4h';

  @override
  String get durationShortcut12h => '+12h';

  @override
  String get durationShortcut24h => '+24h';

  @override
  String get durationShortcut48h => '+48h';

  @override
  String get exchangeType => 'Exchange Type';

  @override
  String get exchangeTypeSerial => 'Serial Number';

  @override
  String get exchangeTypeExchange => 'Text Exchange';

  @override
  String get exchangeTypeBoth => 'Serial + Text Exchange';

  @override
  String get createSession => 'Create Session';

  @override
  String get sessionCreated => 'Contest session created';

  @override
  String get sessionUpdated => 'Contest session updated';

  @override
  String get editContestSession => 'Edit Contest Session';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get deleteSession => 'Delete Session';

  @override
  String get deleteSessionConfirm =>
      'Delete this contest session? QSOs logged in this session will remain in the logbook.';

  @override
  String get openSession => 'Open for Logging';

  @override
  String get patchRequiredContest =>
      'Contest session management requires the updated Wavelog Mobile patch.';

  @override
  String get contestCalendarTitle => 'Contest Calendar';

  @override
  String get contestCalendarNoContests => 'No contests found.';

  @override
  String get contestCalendarToday => 'Today';

  @override
  String get contestCalendarThisWeek => 'This Week';

  @override
  String get contestCalendarUpcoming => 'Upcoming';

  @override
  String get contestCalendarRecentlyPast => 'Recently Past';

  @override
  String get contestCalendarLoadError => 'Could not load contest calendar';

  @override
  String get contestCalendarRefresh => 'Refresh';

  @override
  String get contestCalendarRetry => 'Retry';

  @override
  String get upcomingContestsTitle => 'Upcoming Contests';

  @override
  String get viewAll => 'View all';

  @override
  String get noUpcomingContests => 'No upcoming contests found.';

  @override
  String get contestTodayBadge => 'TODAY';

  @override
  String get navStyleLabel => 'Navigation Style';

  @override
  String get navStyleModern => 'Modern — FAB + drawer';

  @override
  String get navStyleClassic => 'Classic — 6-tab bar';

  @override
  String get drawerMap => 'Map';

  @override
  String get drawerContestCalendar => 'Contest Calendar';

  @override
  String get drawerContestSessions => 'Contest Sessions';

  @override
  String get drawerAdif => 'ADIF';

  @override
  String get drawerMenu => 'Menu';

  @override
  String get antennaCompassTitle => 'Antenna Direction';

  @override
  String get targetGrid => 'Target Grid Square';

  @override
  String get calculate => 'Calculate';

  @override
  String get shortPath => 'Short Path';

  @override
  String get longPath => 'Long Path';

  @override
  String get azimuth => 'Azimuth';

  @override
  String get myHeading => 'Heading';

  @override
  String get invalidGrid => 'Invalid grid square';

  @override
  String get gpsLocating => 'GPS locating… please wait';

  @override
  String get gpsUnavailable => 'GPS location unavailable';

  @override
  String get drawerAntenna => 'Antenna Direction';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get achievementsEmpty => 'Log your first QSO to start earning badges!';

  @override
  String get shareAchievement => 'Share';

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String progressLabel(int done, int target) {
    return '$done / $target';
  }

  @override
  String get drawerAchievements => 'Achievements';

  @override
  String get gifPreparing => 'Preparing video...';

  @override
  String gifCapturing(int percent) {
    return 'Capturing frames... $percent%';
  }

  @override
  String get gifEncoding => 'Encoding video...';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get noCompassSensor => 'No compass sensor';

  @override
  String get fillFromGps => 'Fill from GPS';

  @override
  String get locationPermissionDenied => 'Location permission denied';

  @override
  String gpsError(String error) {
    return 'GPS error: $error';
  }

  @override
  String get errParse => 'Failed to parse server response';

  @override
  String get errLocalStorage => 'Local storage error';

  @override
  String get errServer => 'Server error';

  @override
  String get wpxPrefix => 'WPX Prefix';

  @override
  String get nowBtn => 'Now';

  @override
  String get contestOtherCustom => 'Other / Custom';

  @override
  String get sigInfo => 'SIG Info';

  @override
  String get migrationTitle => 'API v2 Required';

  @override
  String get migrationBody =>
      'Wavelog Mobile now uses Wavelog\'s new API system. Your old API key is no longer valid — follow the steps below to migrate in minutes.';

  @override
  String get migrationStep1Title => 'Install server patch';

  @override
  String get migrationStep1Body =>
      'A small update file needs to be installed on your Wavelog server. Tap the Installation Guide button below to follow the step-by-step instructions.';

  @override
  String get migrationInstallGuideBtn => 'Installation Guide';

  @override
  String get migrationStep2Title => 'Create a new API token';

  @override
  String get migrationStep2Body =>
      'In the Wavelog web interface:\n  1. Open the settings menu in the top right\n  2. Go to \"API\" → \"API Tokens\"\n  3. Click \"New Token\"\n  4. Select the \"Wavelog Mobile\" preset\n  5. Confirm and copy the code shown\n  (Token starts with \"wl2_\")';

  @override
  String get migrationStep3Title => 'Update your profile';

  @override
  String get migrationStep3Body =>
      'Tap the button below. Your server address will be kept — just paste the new token you copied into the field.';

  @override
  String get migrationUpdateTokenBtn => 'Update Token';

  @override
  String get migrationHelpBtn => 'Help & Installation Guide';
}
