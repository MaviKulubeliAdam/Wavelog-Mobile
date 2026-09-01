import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
    Locale('pl'),
    Locale('de')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Wavelog Mobile'**
  String get appTitle;

  /// No description provided for @splashConnecting.
  ///
  /// In en, this message translates to:
  /// **'CONNECTING'**
  String get splashConnecting;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLogbook.
  ///
  /// In en, this message translates to:
  /// **'Logbook'**
  String get navLogbook;

  /// No description provided for @navLookup.
  ///
  /// In en, this message translates to:
  /// **'Lookup'**
  String get navLookup;

  /// No description provided for @navStation.
  ///
  /// In en, this message translates to:
  /// **'Station'**
  String get navStation;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @goWeb.
  ///
  /// In en, this message translates to:
  /// **'Go →'**
  String get goWeb;

  /// No description provided for @editOnWeb.
  ///
  /// In en, this message translates to:
  /// **'Edit on Web'**
  String get editOnWeb;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get openInBrowser;

  /// No description provided for @serverSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Server Setup'**
  String get serverSetupTitle;

  /// No description provided for @serverSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure your Wavelog server'**
  String get serverSetupSubtitle;

  /// No description provided for @serverUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Wavelog Server URL'**
  String get serverUrlLabel;

  /// No description provided for @serverUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://log.example.com'**
  String get serverUrlHint;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get testConnection;

  /// No description provided for @testingConnection.
  ///
  /// In en, this message translates to:
  /// **'Testing...'**
  String get testingConnection;

  /// No description provided for @connectionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Connection successful!'**
  String get connectionSuccess;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailed;

  /// No description provided for @apiKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'API key copied'**
  String get apiKeyCopied;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @serverBtn.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get serverBtn;

  /// No description provided for @addAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccountBtn;

  /// No description provided for @signInBtn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInBtn;

  /// No description provided for @deleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteProfile;

  /// No description provided for @deleteProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteProfileTitle;

  /// No description provided for @deleteProfileConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from this device?'**
  String deleteProfileConfirm(String name);

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @callsign.
  ///
  /// In en, this message translates to:
  /// **'Callsign'**
  String get callsign;

  /// No description provided for @apiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKeyLabel;

  /// No description provided for @validating.
  ///
  /// In en, this message translates to:
  /// **'Validating...'**
  String get validating;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Account saved'**
  String get profileSaved;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @noStationFound.
  ///
  /// In en, this message translates to:
  /// **'No matching station found — using callsign'**
  String get noStationFound;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @addQso.
  ///
  /// In en, this message translates to:
  /// **'Add QSO'**
  String get addQso;

  /// No description provided for @recentQsos.
  ///
  /// In en, this message translates to:
  /// **'Recent QSOs'**
  String get recentQsos;

  /// No description provided for @statsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statsToday;

  /// No description provided for @statsMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get statsMonth;

  /// No description provided for @statsYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get statsYear;

  /// No description provided for @statsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get statsTotal;

  /// No description provided for @noRecentQsos.
  ///
  /// In en, this message translates to:
  /// **'No QSOs yet'**
  String get noRecentQsos;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @pendingSync.
  ///
  /// In en, this message translates to:
  /// **'{count} QSO(s) pending sync'**
  String pendingSync(int count);

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'Offline — QSOs saved locally'**
  String get offlineBanner;

  /// No description provided for @activeStation.
  ///
  /// In en, this message translates to:
  /// **'Active station'**
  String get activeStation;

  /// No description provided for @logbookTitle.
  ///
  /// In en, this message translates to:
  /// **'Logbook'**
  String get logbookTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterAllModes.
  ///
  /// In en, this message translates to:
  /// **'All Modes'**
  String get filterAllModes;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search callsign...'**
  String get searchHint;

  /// No description provided for @noQsos.
  ///
  /// In en, this message translates to:
  /// **'No QSOs found'**
  String get noQsos;

  /// No description provided for @qsoDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'QSO Detail'**
  String get qsoDetailTitle;

  /// No description provided for @qsoNotFound.
  ///
  /// In en, this message translates to:
  /// **'QSO not found'**
  String get qsoNotFound;

  /// No description provided for @signal.
  ///
  /// In en, this message translates to:
  /// **'Signal'**
  String get signal;

  /// No description provided for @rstSent.
  ///
  /// In en, this message translates to:
  /// **'RST Sent'**
  String get rstSent;

  /// No description provided for @rstReceived.
  ///
  /// In en, this message translates to:
  /// **'RST Received'**
  String get rstReceived;

  /// No description provided for @txPower.
  ///
  /// In en, this message translates to:
  /// **'TX Power'**
  String get txPower;

  /// No description provided for @counterStation.
  ///
  /// In en, this message translates to:
  /// **'Counter Station'**
  String get counterStation;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @continent.
  ///
  /// In en, this message translates to:
  /// **'Continent'**
  String get continent;

  /// No description provided for @dxcc.
  ///
  /// In en, this message translates to:
  /// **'DXCC'**
  String get dxcc;

  /// No description provided for @cqZone.
  ///
  /// In en, this message translates to:
  /// **'CQ Zone'**
  String get cqZone;

  /// No description provided for @ituZone.
  ///
  /// In en, this message translates to:
  /// **'ITU Zone'**
  String get ituZone;

  /// No description provided for @gridSquare.
  ///
  /// In en, this message translates to:
  /// **'Grid Square'**
  String get gridSquare;

  /// No description provided for @propMode.
  ///
  /// In en, this message translates to:
  /// **'Propagation'**
  String get propMode;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @qslStatus.
  ///
  /// In en, this message translates to:
  /// **'QSL Status'**
  String get qslStatus;

  /// No description provided for @paperQsl.
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get paperQsl;

  /// No description provided for @lotwQsl.
  ///
  /// In en, this message translates to:
  /// **'LoTW'**
  String get lotwQsl;

  /// No description provided for @eqslQsl.
  ///
  /// In en, this message translates to:
  /// **'eQSL'**
  String get eqslQsl;

  /// No description provided for @qrzQsl.
  ///
  /// In en, this message translates to:
  /// **'QRZ.com'**
  String get qrzQsl;

  /// No description provided for @clublog.
  ///
  /// In en, this message translates to:
  /// **'Club Log'**
  String get clublog;

  /// No description provided for @hrdlog.
  ///
  /// In en, this message translates to:
  /// **'HRDLog'**
  String get hrdlog;

  /// No description provided for @qslSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get qslSent;

  /// No description provided for @qslRcvd.
  ///
  /// In en, this message translates to:
  /// **'Rcvd'**
  String get qslRcvd;

  /// No description provided for @qslReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get qslReceived;

  /// No description provided for @qslMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get qslMethod;

  /// No description provided for @awards.
  ///
  /// In en, this message translates to:
  /// **'Award References'**
  String get awards;

  /// No description provided for @iota.
  ///
  /// In en, this message translates to:
  /// **'IOTA'**
  String get iota;

  /// No description provided for @sota.
  ///
  /// In en, this message translates to:
  /// **'SOTA'**
  String get sota;

  /// No description provided for @wwff.
  ///
  /// In en, this message translates to:
  /// **'WWFF'**
  String get wwff;

  /// No description provided for @pota.
  ///
  /// In en, this message translates to:
  /// **'POTA'**
  String get pota;

  /// No description provided for @myStation.
  ///
  /// In en, this message translates to:
  /// **'My Station'**
  String get myStation;

  /// No description provided for @myCallsign.
  ///
  /// In en, this message translates to:
  /// **'My Callsign'**
  String get myCallsign;

  /// No description provided for @contest.
  ///
  /// In en, this message translates to:
  /// **'Contest'**
  String get contest;

  /// No description provided for @serialSent.
  ///
  /// In en, this message translates to:
  /// **'Serial Sent'**
  String get serialSent;

  /// No description provided for @serialReceived.
  ///
  /// In en, this message translates to:
  /// **'Serial Received'**
  String get serialReceived;

  /// No description provided for @solarConditions.
  ///
  /// In en, this message translates to:
  /// **'Solar Conditions'**
  String get solarConditions;

  /// No description provided for @aIndex.
  ///
  /// In en, this message translates to:
  /// **'A-Index'**
  String get aIndex;

  /// No description provided for @kIndex.
  ///
  /// In en, this message translates to:
  /// **'K-Index'**
  String get kIndex;

  /// No description provided for @sfi.
  ///
  /// In en, this message translates to:
  /// **'SFI'**
  String get sfi;

  /// No description provided for @notesSection.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesSection;

  /// No description provided for @rawAdif.
  ///
  /// In en, this message translates to:
  /// **'Raw ADIF'**
  String get rawAdif;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @qrzProfile.
  ///
  /// In en, this message translates to:
  /// **'QRZ Profile'**
  String get qrzProfile;

  /// No description provided for @addQsoTitle.
  ///
  /// In en, this message translates to:
  /// **'Add QSO'**
  String get addQsoTitle;

  /// No description provided for @liveQso.
  ///
  /// In en, this message translates to:
  /// **'Live QSO'**
  String get liveQso;

  /// No description provided for @historicalQso.
  ///
  /// In en, this message translates to:
  /// **'Historical QSO'**
  String get historicalQso;

  /// No description provided for @callsignField.
  ///
  /// In en, this message translates to:
  /// **'Callsign *'**
  String get callsignField;

  /// No description provided for @lookupSearch.
  ///
  /// In en, this message translates to:
  /// **'QRZ Lookup'**
  String get lookupSearch;

  /// No description provided for @liveDateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date/Time (UTC) — Live'**
  String get liveDateTimeLabel;

  /// No description provided for @dateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date/Time (UTC)'**
  String get dateTimeLabel;

  /// No description provided for @bandField.
  ///
  /// In en, this message translates to:
  /// **'Band *'**
  String get bandField;

  /// No description provided for @modeField.
  ///
  /// In en, this message translates to:
  /// **'Mode *'**
  String get modeField;

  /// No description provided for @frequencyField.
  ///
  /// In en, this message translates to:
  /// **'Frequency (MHz)'**
  String get frequencyField;

  /// No description provided for @rstSentField.
  ///
  /// In en, this message translates to:
  /// **'RST Sent *'**
  String get rstSentField;

  /// No description provided for @rstRcvdField.
  ///
  /// In en, this message translates to:
  /// **'RST Received *'**
  String get rstRcvdField;

  /// No description provided for @nameField.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameField;

  /// No description provided for @qthField.
  ///
  /// In en, this message translates to:
  /// **'QTH'**
  String get qthField;

  /// No description provided for @gridField.
  ///
  /// In en, this message translates to:
  /// **'Grid Square'**
  String get gridField;

  /// No description provided for @commentField.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commentField;

  /// No description provided for @stationProfileField.
  ///
  /// In en, this message translates to:
  /// **'Station Profile'**
  String get stationProfileField;

  /// No description provided for @saveQsoBtn.
  ///
  /// In en, this message translates to:
  /// **'Save QSO'**
  String get saveQsoBtn;

  /// No description provided for @qsoSaved.
  ///
  /// In en, this message translates to:
  /// **'✓  {callsign} saved'**
  String qsoSaved(String callsign);

  /// No description provided for @qsoSavedLocal.
  ///
  /// In en, this message translates to:
  /// **'✓  {callsign} saved locally'**
  String qsoSavedLocal(String callsign);

  /// No description provided for @noActiveStation.
  ///
  /// In en, this message translates to:
  /// **'No active station selected'**
  String get noActiveStation;

  /// No description provided for @lookupTitle.
  ///
  /// In en, this message translates to:
  /// **'Callsign Lookup'**
  String get lookupTitle;

  /// No description provided for @lookupHint.
  ///
  /// In en, this message translates to:
  /// **'Enter callsign...'**
  String get lookupHint;

  /// No description provided for @lookupBtn.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get lookupBtn;

  /// No description provided for @recentSearches.
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get recentSearches;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @makeQso.
  ///
  /// In en, this message translates to:
  /// **'Log QSO'**
  String get makeQso;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @stationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stations'**
  String get stationsTitle;

  /// No description provided for @stationActivated.
  ///
  /// In en, this message translates to:
  /// **'{callsign} set as active station'**
  String stationActivated(String callsign);

  /// No description provided for @stationWebInfo.
  ///
  /// In en, this message translates to:
  /// **'Add and edit stations using the Wavelog web interface.'**
  String get stationWebInfo;

  /// No description provided for @noStations.
  ///
  /// In en, this message translates to:
  /// **'No stations yet'**
  String get noStations;

  /// No description provided for @noStationsHint.
  ///
  /// In en, this message translates to:
  /// **'Add a station via the Wavelog web interface.'**
  String get noStationsHint;

  /// No description provided for @addStationOnWeb.
  ///
  /// In en, this message translates to:
  /// **'Add Station on Wavelog'**
  String get addStationOnWeb;

  /// No description provided for @adifTitle.
  ///
  /// In en, this message translates to:
  /// **'ADIF Import / Export'**
  String get adifTitle;

  /// No description provided for @importTab.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importTab;

  /// No description provided for @exportTab.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportTab;

  /// No description provided for @selectAdifFile.
  ///
  /// In en, this message translates to:
  /// **'Select ADIF File'**
  String get selectAdifFile;

  /// No description provided for @selectFileBtn.
  ///
  /// In en, this message translates to:
  /// **'Choose File (.adi / .adif)'**
  String get selectFileBtn;

  /// No description provided for @stationRequired.
  ///
  /// In en, this message translates to:
  /// **'Station Profile *'**
  String get stationRequired;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing... {done}/{total}'**
  String importing(int done, int total);

  /// No description provided for @importBtn.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importBtn;

  /// No description provided for @fileReadError.
  ///
  /// In en, this message translates to:
  /// **'Could not read file content, please try again'**
  String get fileReadError;

  /// No description provided for @invalidFileExtension.
  ///
  /// In en, this message translates to:
  /// **'Please select a file with .adi or .adif extension'**
  String get invalidFileExtension;

  /// No description provided for @exportFilters.
  ///
  /// In en, this message translates to:
  /// **'Export Filters'**
  String get exportFilters;

  /// No description provided for @stationFilter.
  ///
  /// In en, this message translates to:
  /// **'Station'**
  String get stationFilter;

  /// No description provided for @allStations.
  ///
  /// In en, this message translates to:
  /// **'All Stations'**
  String get allStations;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endDate;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @clearDates.
  ///
  /// In en, this message translates to:
  /// **'Clear Dates'**
  String get clearDates;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// No description provided for @exportAndShare.
  ///
  /// In en, this message translates to:
  /// **'Export and Share'**
  String get exportAndShare;

  /// No description provided for @copyPath.
  ///
  /// In en, this message translates to:
  /// **'Copy Path'**
  String get copyPath;

  /// No description provided for @reshare.
  ///
  /// In en, this message translates to:
  /// **'Share Again'**
  String get reshare;

  /// No description provided for @pathCopied.
  ///
  /// In en, this message translates to:
  /// **'File path copied'**
  String get pathCopied;

  /// No description provided for @qsoExported.
  ///
  /// In en, this message translates to:
  /// **'{count} QSO(s) exported'**
  String qsoExported(int count);

  /// No description provided for @noStationForExport.
  ///
  /// In en, this message translates to:
  /// **'No station found for export'**
  String get noStationForExport;

  /// No description provided for @qsoImported.
  ///
  /// In en, this message translates to:
  /// **'{imported} / {total} QSO(s) imported'**
  String qsoImported(int imported, int total);

  /// No description provided for @selectSaveLocation.
  ///
  /// In en, this message translates to:
  /// **'Choose save location'**
  String get selectSaveLocation;

  /// No description provided for @copySuffix.
  ///
  /// In en, this message translates to:
  /// **'(Copy)'**
  String get copySuffix;

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection — check your network'**
  String get errNetwork;

  /// No description provided for @errTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out'**
  String get errTimeout;

  /// No description provided for @errUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Invalid API key'**
  String get errUnauthorized;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @connectionSection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connectionSection;

  /// No description provided for @sessionSection.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get sessionSection;

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loggedIn;

  /// No description provided for @logoutBtn.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutBtn;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @switchAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Switch Account'**
  String get switchAccountBtn;

  /// No description provided for @activeStationSection.
  ///
  /// In en, this message translates to:
  /// **'Active Station'**
  String get activeStationSection;

  /// No description provided for @selectStationBtn.
  ///
  /// In en, this message translates to:
  /// **'Select Station'**
  String get selectStationBtn;

  /// No description provided for @addStationWeb.
  ///
  /// In en, this message translates to:
  /// **'Add Station on Web'**
  String get addStationWeb;

  /// No description provided for @defaultsSection.
  ///
  /// In en, this message translates to:
  /// **'Defaults'**
  String get defaultsSection;

  /// No description provided for @defaultBand.
  ///
  /// In en, this message translates to:
  /// **'Default Band'**
  String get defaultBand;

  /// No description provided for @defaultMode.
  ///
  /// In en, this message translates to:
  /// **'Default Mode'**
  String get defaultMode;

  /// No description provided for @appSection.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get appSection;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @darkThemeHint.
  ///
  /// In en, this message translates to:
  /// **'Recommended for field use'**
  String get darkThemeHint;

  /// No description provided for @offlineMode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// No description provided for @offlineModeHint.
  ///
  /// In en, this message translates to:
  /// **'Save QSOs locally first, sync later'**
  String get offlineModeHint;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @infoSection.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoSection;

  /// No description provided for @aboutAppBtn.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutAppBtn;

  /// No description provided for @aboutAppHint.
  ///
  /// In en, this message translates to:
  /// **'Version, developer, license'**
  String get aboutAppHint;

  /// No description provided for @dataSection.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dataSection;

  /// No description provided for @clearCacheBtn.
  ///
  /// In en, this message translates to:
  /// **'Clear QSO Cache'**
  String get clearCacheBtn;

  /// No description provided for @clearCacheHint.
  ///
  /// In en, this message translates to:
  /// **'Deletes local QSO cache'**
  String get clearCacheHint;

  /// No description provided for @clearCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCacheTitle;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'Local QSO cache will be deleted. This cannot be undone.'**
  String get clearCacheConfirm;

  /// No description provided for @clearCacheAction.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearCacheAction;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get cacheCleared;

  /// No description provided for @langSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get langSystem;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get langTurkish;

  /// No description provided for @langPolish.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get langPolish;

  /// No description provided for @langGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get langGerman;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Open source Android app for Wavelog'**
  String get appDescription;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}  (Build {build})'**
  String versionLabel(String version, String build);

  /// No description provided for @mobileDeveloperSection.
  ///
  /// In en, this message translates to:
  /// **'Mobile App Developer'**
  String get mobileDeveloperSection;

  /// No description provided for @wavelogProjectSection.
  ///
  /// In en, this message translates to:
  /// **'Wavelog Project'**
  String get wavelogProjectSection;

  /// No description provided for @wavelogDescription.
  ///
  /// In en, this message translates to:
  /// **'Web-based amateur radio logging system'**
  String get wavelogDescription;

  /// No description provided for @coreDevelopers.
  ///
  /// In en, this message translates to:
  /// **'Core Developers'**
  String get coreDevelopers;

  /// No description provided for @mitLicense.
  ///
  /// In en, this message translates to:
  /// **'MIT License'**
  String get mitLicense;

  /// No description provided for @mitDescription.
  ///
  /// In en, this message translates to:
  /// **'This app and the Wavelog project are distributed under the MIT License. Open source, no warranty provided.'**
  String get mitDescription;

  /// No description provided for @licenseSection.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get licenseSection;

  /// No description provided for @errorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No connection'**
  String get errorNoConnection;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized — check your API key'**
  String get errorUnauthorized;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get errorServer;

  /// No description provided for @patchRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Server Patch Required'**
  String get patchRequiredTitle;

  /// No description provided for @patchRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Edit and delete features require the Wavelog Mobile API patch to be installed on your server.\n\nVisit sp9aqg.pl/install.html for installation instructions.'**
  String get patchRequiredMessage;

  /// No description provided for @patchRequiredBanner.
  ///
  /// In en, this message translates to:
  /// **'Edit and delete features require the Wavelog Mobile API patch to be installed on your server.'**
  String get patchRequiredBanner;

  /// No description provided for @patchViewGuide.
  ///
  /// In en, this message translates to:
  /// **'View Guide'**
  String get patchViewGuide;

  /// No description provided for @setupGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup Guide'**
  String get setupGuideTitle;

  /// No description provided for @setupGuideIntro.
  ///
  /// In en, this message translates to:
  /// **'Before you can log QSOs, connect the app to your Wavelog server. Follow the steps below.'**
  String get setupGuideIntro;

  /// No description provided for @setupGuidePatchWarning.
  ///
  /// In en, this message translates to:
  /// **'This app requires the Wavelog Mobile patch to be installed on your server. Even if you generate an API v2 token without it, the app will not work correctly.'**
  String get setupGuidePatchWarning;

  /// No description provided for @setupGuidePatchStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Install Server Patch'**
  String get setupGuidePatchStepTitle;

  /// No description provided for @setupGuidePatchStepBody.
  ///
  /// In en, this message translates to:
  /// **'The app uses Wavelog\'s API v2, which requires a small patch on your server. If you haven\'t installed it yet, open the Installation Guide and follow the steps for your setup (Classic or Docker).'**
  String get setupGuidePatchStepBody;

  /// No description provided for @setupGuidePatchBtn.
  ///
  /// In en, this message translates to:
  /// **'Installation Guide'**
  String get setupGuidePatchBtn;

  /// No description provided for @setupGuideStep1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Server Address'**
  String get setupGuideStep1Title;

  /// No description provided for @setupGuideStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Enter the same address you use to open Wavelog in your browser, e.g. https://yourdomain.com — without a trailing slash.'**
  String get setupGuideStep1Body;

  /// No description provided for @setupGuideStep2Title.
  ///
  /// In en, this message translates to:
  /// **'2. API v2 Token'**
  String get setupGuideStep2Title;

  /// No description provided for @setupGuideStep2Body.
  ///
  /// In en, this message translates to:
  /// **'In Wavelog, go to Settings → API → API Tokens (v2) → New Token. Select the \"Wavelog Mobile\" preset and confirm. Copy the generated token (starts with wl2_) and paste it into the app.'**
  String get setupGuideStep2Body;

  /// No description provided for @setupGuideStep3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Callsign & Display Name'**
  String get setupGuideStep3Title;

  /// No description provided for @setupGuideStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Callsign: your own amateur radio callsign, used to match your station. Display Name: any label to recognize this login on your device.'**
  String get setupGuideStep3Body;

  /// No description provided for @setupGuideContinueBtn.
  ///
  /// In en, this message translates to:
  /// **'Start Setup'**
  String get setupGuideContinueBtn;

  /// No description provided for @migrationTokenHint.
  ///
  /// In en, this message translates to:
  /// **'wl2_…'**
  String get migrationTokenHint;

  /// No description provided for @migrationTokenLabel.
  ///
  /// In en, this message translates to:
  /// **'API v2 Token'**
  String get migrationTokenLabel;

  /// No description provided for @migrationValidateBtn.
  ///
  /// In en, this message translates to:
  /// **'Validate & Continue'**
  String get migrationValidateBtn;

  /// No description provided for @migrationValidating.
  ///
  /// In en, this message translates to:
  /// **'Validating…'**
  String get migrationValidating;

  /// No description provided for @migrationTokenEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please paste your wl2_ token.'**
  String get migrationTokenEmpty;

  /// No description provided for @migrationTokenInvalid.
  ///
  /// In en, this message translates to:
  /// **'Token is invalid — please check and try again.'**
  String get migrationTokenInvalid;

  /// No description provided for @patchNotInstalledTitle.
  ///
  /// In en, this message translates to:
  /// **'Patch Not Detected'**
  String get patchNotInstalledTitle;

  /// No description provided for @patchNotInstalledBody.
  ///
  /// In en, this message translates to:
  /// **'The Wavelog Mobile patch does not appear to be installed on your server.\n\nAn API v2 token (wl2_…) will not work without the patch. Please complete Step 1 first.'**
  String get patchNotInstalledBody;

  /// No description provided for @patchInstallFirst.
  ///
  /// In en, this message translates to:
  /// **'Install Patch'**
  String get patchInstallFirst;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Amateur Radio Log Application'**
  String get appSubtitle;

  /// No description provided for @switchToLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Switch to light theme'**
  String get switchToLightTheme;

  /// No description provided for @switchToDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get switchToDarkTheme;

  /// No description provided for @deleteQsoTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete QSO'**
  String get deleteQsoTitle;

  /// No description provided for @deleteQsoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete QSO with {callsign} on {date}?'**
  String deleteQsoConfirm(String callsign, String date);

  /// No description provided for @editTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editTooltip;

  /// No description provided for @shareAdifTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share ADIF'**
  String get shareAdifTooltip;

  /// No description provided for @localNotSynced.
  ///
  /// In en, this message translates to:
  /// **'Local record — not yet synchronized'**
  String get localNotSynced;

  /// No description provided for @satellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get satellite;

  /// No description provided for @satelliteMode.
  ///
  /// In en, this message translates to:
  /// **'Satellite Mode'**
  String get satelliteMode;

  /// No description provided for @antenna.
  ///
  /// In en, this message translates to:
  /// **'Antenna'**
  String get antenna;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @stateProvince.
  ///
  /// In en, this message translates to:
  /// **'State/Province'**
  String get stateProvince;

  /// No description provided for @county.
  ///
  /// In en, this message translates to:
  /// **'County'**
  String get county;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @continentAF.
  ///
  /// In en, this message translates to:
  /// **'Africa'**
  String get continentAF;

  /// No description provided for @continentAN.
  ///
  /// In en, this message translates to:
  /// **'Antarctica'**
  String get continentAN;

  /// No description provided for @continentAS.
  ///
  /// In en, this message translates to:
  /// **'Asia'**
  String get continentAS;

  /// No description provided for @continentEU.
  ///
  /// In en, this message translates to:
  /// **'Europe'**
  String get continentEU;

  /// No description provided for @continentNA.
  ///
  /// In en, this message translates to:
  /// **'North America'**
  String get continentNA;

  /// No description provided for @continentOC.
  ///
  /// In en, this message translates to:
  /// **'Oceania'**
  String get continentOC;

  /// No description provided for @continentSA.
  ///
  /// In en, this message translates to:
  /// **'South America'**
  String get continentSA;

  /// No description provided for @qrzProfileLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading QRZ profile...'**
  String get qrzProfileLoading;

  /// No description provided for @viewOnQrz.
  ///
  /// In en, this message translates to:
  /// **'View on QRZ.com  ({callsign})'**
  String viewOnQrz(String callsign);

  /// No description provided for @qslMethods.
  ///
  /// In en, this message translates to:
  /// **'QSL Methods'**
  String get qslMethods;

  /// No description provided for @bureau.
  ///
  /// In en, this message translates to:
  /// **'Bureau'**
  String get bureau;

  /// No description provided for @qslManagerPrefix.
  ///
  /// In en, this message translates to:
  /// **'Manager: {manager}'**
  String qslManagerPrefix(String manager);

  /// No description provided for @callsignCopied.
  ///
  /// In en, this message translates to:
  /// **'Callsign copied'**
  String get callsignCopied;

  /// No description provided for @uploadedStatus.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploadedStatus;

  /// No description provided for @notUploadedStatus.
  ///
  /// In en, this message translates to:
  /// **'Not uploaded'**
  String get notUploadedStatus;

  /// No description provided for @matchedStatus.
  ///
  /// In en, this message translates to:
  /// **'Matched'**
  String get matchedStatus;

  /// No description provided for @toDeleteStatus.
  ///
  /// In en, this message translates to:
  /// **'To delete'**
  String get toDeleteStatus;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @requested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requested;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @viaDirect.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get viaDirect;

  /// No description provided for @viaElectronic.
  ///
  /// In en, this message translates to:
  /// **'Electronic'**
  String get viaElectronic;

  /// No description provided for @viaMail.
  ///
  /// In en, this message translates to:
  /// **'Mail'**
  String get viaMail;

  /// No description provided for @otherAdifFields.
  ///
  /// In en, this message translates to:
  /// **'Other ADIF Fields ({count})'**
  String otherAdifFields(int count);

  /// No description provided for @editQsoTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit QSO'**
  String get editQsoTitle;

  /// No description provided for @qsoUpdated.
  ///
  /// In en, this message translates to:
  /// **'QSO updated'**
  String get qsoUpdated;

  /// No description provided for @qsoUpdatedLocal.
  ///
  /// In en, this message translates to:
  /// **'QSO updated locally'**
  String get qsoUpdatedLocal;

  /// No description provided for @counterStationHint.
  ///
  /// In en, this message translates to:
  /// **'Enter callsign to see QRZ\ninfo and previous QSOs\nhere.'**
  String get counterStationHint;

  /// No description provided for @previousQsosCount.
  ///
  /// In en, this message translates to:
  /// **'Previous QSOs ({count})'**
  String previousQsosCount(int count);

  /// No description provided for @morePreviousQsos.
  ///
  /// In en, this message translates to:
  /// **'+{count} more...'**
  String morePreviousQsos(int count);

  /// No description provided for @previousQsosWithCallsign.
  ///
  /// In en, this message translates to:
  /// **'Previous QSOs with {callsign}'**
  String previousQsosWithCallsign(String callsign);

  /// No description provided for @totalQsos.
  ///
  /// In en, this message translates to:
  /// **'{count} total'**
  String totalQsos(int count);

  /// No description provided for @workedBefore.
  ///
  /// In en, this message translates to:
  /// **'Worked before'**
  String get workedBefore;

  /// No description provided for @lastQsoLabel.
  ///
  /// In en, this message translates to:
  /// **'Last QSO'**
  String get lastQsoLabel;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @darkThemeActive.
  ///
  /// In en, this message translates to:
  /// **'Dark theme active'**
  String get darkThemeActive;

  /// No description provided for @lightThemeActive.
  ///
  /// In en, this message translates to:
  /// **'Light theme active'**
  String get lightThemeActive;

  /// No description provided for @lightThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightThemeLabel;

  /// No description provided for @darkThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkThemeLabel;

  /// No description provided for @commentNotes.
  ///
  /// In en, this message translates to:
  /// **'Comment / Notes'**
  String get commentNotes;

  /// No description provided for @commentLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commentLabel;

  /// No description provided for @exchangeReceived.
  ///
  /// In en, this message translates to:
  /// **'Received Exchange'**
  String get exchangeReceived;

  /// No description provided for @exchangeSent.
  ///
  /// In en, this message translates to:
  /// **'Sent Exchange'**
  String get exchangeSent;

  /// No description provided for @contestIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Contest'**
  String get contestIdLabel;

  /// No description provided for @sigLabel.
  ///
  /// In en, this message translates to:
  /// **'SIG'**
  String get sigLabel;

  /// No description provided for @stationSetup.
  ///
  /// In en, this message translates to:
  /// **'Station Setup'**
  String get stationSetup;

  /// No description provided for @logbooks.
  ///
  /// In en, this message translates to:
  /// **'Logbooks'**
  String get logbooks;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @newLogbook.
  ///
  /// In en, this message translates to:
  /// **'New Logbook'**
  String get newLogbook;

  /// No description provided for @logbookName.
  ///
  /// In en, this message translates to:
  /// **'Logbook Name'**
  String get logbookName;

  /// No description provided for @renameLogbook.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameLogbook;

  /// No description provided for @deleteLogbook.
  ///
  /// In en, this message translates to:
  /// **'Delete Logbook'**
  String get deleteLogbook;

  /// No description provided for @setActiveLogbook.
  ///
  /// In en, this message translates to:
  /// **'Set Active'**
  String get setActiveLogbook;

  /// No description provided for @activeLogbook.
  ///
  /// In en, this message translates to:
  /// **'Active Logbook'**
  String get activeLogbook;

  /// No description provided for @editStation.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editStation;

  /// No description provided for @cloneStation.
  ///
  /// In en, this message translates to:
  /// **'Clone'**
  String get cloneStation;

  /// No description provided for @deleteStation.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteStation;

  /// No description provided for @deleteStationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete station'**
  String get deleteStationConfirm;

  /// No description provided for @deleteStationWarning.
  ///
  /// In en, this message translates to:
  /// **'All QSOs of this station will be permanently deleted. Continue?'**
  String get deleteStationWarning;

  /// No description provided for @stationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Station deleted'**
  String get stationDeleted;

  /// No description provided for @stationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Station updated'**
  String get stationUpdated;

  /// No description provided for @stationCloned.
  ///
  /// In en, this message translates to:
  /// **'Station cloned'**
  String get stationCloned;

  /// No description provided for @linkLocation.
  ///
  /// In en, this message translates to:
  /// **'Link Location'**
  String get linkLocation;

  /// No description provided for @unlinkLocation.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get unlinkLocation;

  /// No description provided for @linkedLocations.
  ///
  /// In en, this message translates to:
  /// **'Linked Locations'**
  String get linkedLocations;

  /// No description provided for @newStationName.
  ///
  /// In en, this message translates to:
  /// **'New station name'**
  String get newStationName;

  /// No description provided for @deleteLogbookConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete logbook'**
  String get deleteLogbookConfirm;

  /// No description provided for @deleteLogbookWarning.
  ///
  /// In en, this message translates to:
  /// **'This logbook will be deleted. Linked locations are preserved. Continue?'**
  String get deleteLogbookWarning;

  /// No description provided for @logbookDeleted.
  ///
  /// In en, this message translates to:
  /// **'Logbook deleted'**
  String get logbookDeleted;

  /// No description provided for @hrdlogCode.
  ///
  /// In en, this message translates to:
  /// **'HRDLog Code'**
  String get hrdlogCode;

  /// No description provided for @webAdifApiKey.
  ///
  /// In en, this message translates to:
  /// **'WebADIF API Key'**
  String get webAdifApiKey;

  /// No description provided for @webAdifApiUrl.
  ///
  /// In en, this message translates to:
  /// **'WebADIF API URL'**
  String get webAdifApiUrl;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// No description provided for @locationSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationSectionTitle;

  /// No description provided for @awardReferences.
  ///
  /// In en, this message translates to:
  /// **'Award References'**
  String get awardReferences;

  /// No description provided for @integrationsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get integrationsSectionTitle;

  /// No description provided for @stationSettingsSection.
  ///
  /// In en, this message translates to:
  /// **'Station Settings'**
  String get stationSettingsSection;

  /// No description provided for @editStationTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Station'**
  String get editStationTitle;

  /// No description provided for @newStationTitle.
  ///
  /// In en, this message translates to:
  /// **'New Station'**
  String get newStationTitle;

  /// No description provided for @saveChangesBtn.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesBtn;

  /// No description provided for @createStationBtn.
  ///
  /// In en, this message translates to:
  /// **'Create Station'**
  String get createStationBtn;

  /// No description provided for @stationCreated.
  ///
  /// In en, this message translates to:
  /// **'Station created'**
  String get stationCreated;

  /// No description provided for @stationCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed. A profile with that name may already exist.'**
  String get stationCreateFailed;

  /// No description provided for @stationProfileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Station Profile Name *'**
  String get stationProfileNameLabel;

  /// No description provided for @stationProfileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Home Station'**
  String get stationProfileNameHint;

  /// No description provided for @cityQth.
  ///
  /// In en, this message translates to:
  /// **'City / QTH'**
  String get cityQth;

  /// No description provided for @powerWatts.
  ///
  /// In en, this message translates to:
  /// **'Power (W)'**
  String get powerWatts;

  /// No description provided for @dxccCountry.
  ///
  /// In en, this message translates to:
  /// **'DXCC / Country'**
  String get dxccCountry;

  /// No description provided for @selectLabel.
  ///
  /// In en, this message translates to:
  /// **'Select...'**
  String get selectLabel;

  /// No description provided for @dxccSearch.
  ///
  /// In en, this message translates to:
  /// **'Search DXCC / Country'**
  String get dxccSearch;

  /// No description provided for @deletedDxcc.
  ///
  /// In en, this message translates to:
  /// **'Deleted DXCC'**
  String get deletedDxcc;

  /// No description provided for @eqslQthNicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'eQSL QTH Nickname'**
  String get eqslQthNicknameLabel;

  /// No description provided for @eqslDefaultMsgLabel.
  ///
  /// In en, this message translates to:
  /// **'eQSL Default Message'**
  String get eqslDefaultMsgLabel;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @uploadDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get uploadDisabled;

  /// No description provided for @uploadEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get uploadEnabled;

  /// No description provided for @uploadRealtime.
  ///
  /// In en, this message translates to:
  /// **'Realtime'**
  String get uploadRealtime;

  /// No description provided for @qrzApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'QRZ.com Logbook API Key'**
  String get qrzApiKeyLabel;

  /// No description provided for @qrzUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'QRZ.com Upload'**
  String get qrzUploadLabel;

  /// No description provided for @clublogIgnoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Ignore Clublog'**
  String get clublogIgnoreTitle;

  /// No description provided for @clublogIgnoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exclude this station from Clublog uploads'**
  String get clublogIgnoreSubtitle;

  /// No description provided for @clublogRealtimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Clublog Realtime'**
  String get clublogRealtimeTitle;

  /// No description provided for @clublogRealtimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload QSOs to Clublog in real time'**
  String get clublogRealtimeSubtitle;

  /// No description provided for @hrdlogUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'HRDLog.net Username'**
  String get hrdlogUsernameLabel;

  /// No description provided for @hrdlogApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'HRDLog.net API Key'**
  String get hrdlogApiKeyLabel;

  /// No description provided for @hrdlogUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'HRDLog.net Upload'**
  String get hrdlogUploadLabel;

  /// No description provided for @qo100ApiKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'QO-100 DX Club API Key'**
  String get qo100ApiKeyLabel;

  /// No description provided for @qo100RealtimeTitle.
  ///
  /// In en, this message translates to:
  /// **'QO-100 DX Club Realtime'**
  String get qo100RealtimeTitle;

  /// No description provided for @qo100RealtimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload QSOs to QO-100 DX Club in real time'**
  String get qo100RealtimeSubtitle;

  /// No description provided for @oqrsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'OQRS (Online QSL)'**
  String get oqrsSectionTitle;

  /// No description provided for @oqrsEnabledTitle.
  ///
  /// In en, this message translates to:
  /// **'OQRS Enabled'**
  String get oqrsEnabledTitle;

  /// No description provided for @oqrsEnabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable the online QSL request system'**
  String get oqrsEnabledSubtitle;

  /// No description provided for @oqrsTextLabel.
  ///
  /// In en, this message translates to:
  /// **'OQRS Description Text'**
  String get oqrsTextLabel;

  /// No description provided for @oqrsEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'OQRS Email'**
  String get oqrsEmailLabel;

  /// No description provided for @setAsActiveStationTitle.
  ///
  /// In en, this message translates to:
  /// **'Set as Active Station'**
  String get setAsActiveStationTitle;

  /// No description provided for @setAsActiveStationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mark this station as active in Wavelog'**
  String get setAsActiveStationSubtitle;

  /// No description provided for @linkToActiveLogbookTitle.
  ///
  /// In en, this message translates to:
  /// **'Link to Active Logbook'**
  String get linkToActiveLogbookTitle;

  /// No description provided for @linkToActiveLogbookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically link to the active logbook on creation'**
  String get linkToActiveLogbookSubtitle;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @loadDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load details'**
  String get loadDetailsFailed;

  /// No description provided for @cannotDeleteActiveStation.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the active station.'**
  String get cannotDeleteActiveStation;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @uniqueCallsigns.
  ///
  /// In en, this message translates to:
  /// **'Unique Calls'**
  String get uniqueCallsigns;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} day(s)'**
  String streakDays(int count);

  /// No description provided for @bandDistribution.
  ///
  /// In en, this message translates to:
  /// **'Band Distribution'**
  String get bandDistribution;

  /// No description provided for @modeDistribution.
  ///
  /// In en, this message translates to:
  /// **'Mode Distribution'**
  String get modeDistribution;

  /// No description provided for @perStation.
  ///
  /// In en, this message translates to:
  /// **'Per Station'**
  String get perStation;

  /// No description provided for @basedOnCache.
  ///
  /// In en, this message translates to:
  /// **'Band / mode / station stats are based on cached QSOs.'**
  String get basedOnCache;

  /// No description provided for @statsTab.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statsTab;

  /// No description provided for @propagationTab.
  ///
  /// In en, this message translates to:
  /// **'Propagation'**
  String get propagationTab;

  /// No description provided for @bandConditions.
  ///
  /// In en, this message translates to:
  /// **'Band Conditions'**
  String get bandConditions;

  /// No description provided for @dayTime.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayTime;

  /// No description provided for @nightTime.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get nightTime;

  /// No description provided for @conditionGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get conditionGood;

  /// No description provided for @conditionFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get conditionFair;

  /// No description provided for @conditionPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get conditionPoor;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated: {time}'**
  String lastUpdated(String time);

  /// No description provided for @noSolarData.
  ///
  /// In en, this message translates to:
  /// **'Could not load solar data'**
  String get noSolarData;

  /// No description provided for @potaStats.
  ///
  /// In en, this message translates to:
  /// **'POTA Statistics'**
  String get potaStats;

  /// No description provided for @potaTotalQsos.
  ///
  /// In en, this message translates to:
  /// **'POTA QSOs'**
  String get potaTotalQsos;

  /// No description provided for @potaActivatedParks.
  ///
  /// In en, this message translates to:
  /// **'Activated Parks'**
  String get potaActivatedParks;

  /// No description provided for @potaAllParks.
  ///
  /// In en, this message translates to:
  /// **'All Parks'**
  String get potaAllParks;

  /// No description provided for @potaActivatedBadge.
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get potaActivatedBadge;

  /// No description provided for @potaAttemptBadge.
  ///
  /// In en, this message translates to:
  /// **'Attempt'**
  String get potaAttemptBadge;

  /// No description provided for @potaNoStation.
  ///
  /// In en, this message translates to:
  /// **'No POTA station profile configured'**
  String get potaNoStation;

  /// No description provided for @potaNoQsos.
  ///
  /// In en, this message translates to:
  /// **'No POTA QSOs in cache'**
  String get potaNoQsos;

  /// No description provided for @navSpot.
  ///
  /// In en, this message translates to:
  /// **'Spot'**
  String get navSpot;

  /// No description provided for @spotTitle.
  ///
  /// In en, this message translates to:
  /// **'Spot'**
  String get spotTitle;

  /// No description provided for @spotAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Spot'**
  String get spotAdd;

  /// No description provided for @spotSend.
  ///
  /// In en, this message translates to:
  /// **'Send Spot'**
  String get spotSend;

  /// No description provided for @spotSent.
  ///
  /// In en, this message translates to:
  /// **'Spot sent!'**
  String get spotSent;

  /// No description provided for @spotNoResults.
  ///
  /// In en, this message translates to:
  /// **'No spots found'**
  String get spotNoResults;

  /// No description provided for @spotLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load spots'**
  String get spotLoadError;

  /// No description provided for @spotActivator.
  ///
  /// In en, this message translates to:
  /// **'Activator Callsign'**
  String get spotActivator;

  /// No description provided for @spotSpotter.
  ///
  /// In en, this message translates to:
  /// **'Spotter Callsign'**
  String get spotSpotter;

  /// No description provided for @spotFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency (kHz)'**
  String get spotFrequency;

  /// No description provided for @spotReference.
  ///
  /// In en, this message translates to:
  /// **'Park Reference'**
  String get spotReference;

  /// No description provided for @spotComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get spotComments;

  /// No description provided for @spotCommentsHint.
  ///
  /// In en, this message translates to:
  /// **'QRZ, CQ POTA...'**
  String get spotCommentsHint;

  /// No description provided for @spotInvalidRef.
  ///
  /// In en, this message translates to:
  /// **'Invalid format (e.g. PL-0001)'**
  String get spotInvalidRef;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortOldest;

  /// No description provided for @filterBand.
  ///
  /// In en, this message translates to:
  /// **'Band'**
  String get filterBand;

  /// No description provided for @filterMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get filterMode;

  /// No description provided for @filterCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get filterCountry;

  /// No description provided for @filterAssociation.
  ///
  /// In en, this message translates to:
  /// **'Association'**
  String get filterAssociation;

  /// No description provided for @spotAddComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Add Spot — Coming Soon'**
  String get spotAddComingSoon;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get filterClear;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @potaAutoSpot.
  ///
  /// In en, this message translates to:
  /// **'Auto-Spot'**
  String get potaAutoSpot;

  /// No description provided for @potaAutoSpotHint.
  ///
  /// In en, this message translates to:
  /// **'Automatically self-spot when logging a QSO at a POTA or SOTA station (30 min cooldown each)'**
  String get potaAutoSpotHint;

  /// No description provided for @autoSpotSent.
  ///
  /// In en, this message translates to:
  /// **'Auto-spot sent: {ref}'**
  String autoSpotSent(String ref);

  /// No description provided for @autoSpotWillFire.
  ///
  /// In en, this message translates to:
  /// **'QSO will trigger a spot'**
  String get autoSpotWillFire;

  /// No description provided for @autoSpotCooldown.
  ///
  /// In en, this message translates to:
  /// **'Spot sent · Next in {min} min'**
  String autoSpotCooldown(int min);

  /// No description provided for @autoSpotCooldownSoon.
  ///
  /// In en, this message translates to:
  /// **'Spot sent · Next spot soon'**
  String get autoSpotCooldownSoon;

  /// No description provided for @autoSpotKeyChanged.
  ///
  /// In en, this message translates to:
  /// **'{fields} changed · New spot will fire'**
  String autoSpotKeyChanged(String fields);

  /// No description provided for @autoSpotFieldFreq.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get autoSpotFieldFreq;

  /// No description provided for @autoSpotFieldMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get autoSpotFieldMode;

  /// No description provided for @autoSpotFieldRef.
  ///
  /// In en, this message translates to:
  /// **'Park'**
  String get autoSpotFieldRef;

  /// No description provided for @logbookSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent QSOs'**
  String get logbookSummaryTitle;

  /// No description provided for @todayQsoCount.
  ///
  /// In en, this message translates to:
  /// **'Today: {count} QSO'**
  String todayQsoCount(int count);

  /// No description provided for @colDateTime.
  ///
  /// In en, this message translates to:
  /// **'Date/Time'**
  String get colDateTime;

  /// No description provided for @colRstSent.
  ///
  /// In en, this message translates to:
  /// **'RST(S)'**
  String get colRstSent;

  /// No description provided for @colRstRcvd.
  ///
  /// In en, this message translates to:
  /// **'RST(R)'**
  String get colRstRcvd;

  /// No description provided for @submodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Submode'**
  String get submodeLabel;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @exportSelected.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportSelected;

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteSelected;

  /// No description provided for @deleteSelectedConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} QSOs?'**
  String deleteSelectedConfirm(int count);

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapTitle;

  /// No description provided for @mapNoData.
  ///
  /// In en, this message translates to:
  /// **'No QSOs with grid square found'**
  String get mapNoData;

  /// No description provided for @mapStationCount.
  ///
  /// In en, this message translates to:
  /// **'{count} stations'**
  String mapStationCount(int count);

  /// No description provided for @dxccProgress.
  ///
  /// In en, this message translates to:
  /// **'DXCC Progress'**
  String get dxccProgress;

  /// No description provided for @workedCountries.
  ///
  /// In en, this message translates to:
  /// **'Worked Countries'**
  String get workedCountries;

  /// No description provided for @dxccWorked.
  ///
  /// In en, this message translates to:
  /// **'Worked'**
  String get dxccWorked;

  /// No description provided for @dxccUniqueEntities.
  ///
  /// In en, this message translates to:
  /// **'{count} unique entities'**
  String dxccUniqueEntities(int count);

  /// No description provided for @dxccConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed (LoTW / eQSL / QSL)'**
  String get dxccConfirmed;

  /// No description provided for @dxccRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get dxccRemaining;

  /// No description provided for @dxccLegendConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get dxccLegendConfirmed;

  /// No description provided for @dxccLegendPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get dxccLegendPending;

  /// No description provided for @dxccLegendNotWorked.
  ///
  /// In en, this message translates to:
  /// **'Not worked'**
  String get dxccLegendNotWorked;

  /// No description provided for @spotSummitNotFound.
  ///
  /// In en, this message translates to:
  /// **'Summit not found'**
  String get spotSummitNotFound;

  /// No description provided for @spotParkNotFound.
  ///
  /// In en, this message translates to:
  /// **'Park not found'**
  String get spotParkNotFound;

  /// No description provided for @qsoTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Log a QSO'**
  String get qsoTypeTitle;

  /// No description provided for @normalQso.
  ///
  /// In en, this message translates to:
  /// **'Normal QSO'**
  String get normalQso;

  /// No description provided for @normalQsoDesc.
  ///
  /// In en, this message translates to:
  /// **'Standard contact entry'**
  String get normalQsoDesc;

  /// No description provided for @contestQso.
  ///
  /// In en, this message translates to:
  /// **'Contest QSO'**
  String get contestQso;

  /// No description provided for @contestQsoDesc.
  ///
  /// In en, this message translates to:
  /// **'Fast contest logging with exchange'**
  String get contestQsoDesc;

  /// No description provided for @contestLog.
  ///
  /// In en, this message translates to:
  /// **'Contest Log'**
  String get contestLog;

  /// No description provided for @contestSetup.
  ///
  /// In en, this message translates to:
  /// **'Contest Setup'**
  String get contestSetup;

  /// No description provided for @contestNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. CQ-WW-CW'**
  String get contestNameHint;

  /// No description provided for @ourExchange.
  ///
  /// In en, this message translates to:
  /// **'Our Exchange'**
  String get ourExchange;

  /// No description provided for @serialStart.
  ///
  /// In en, this message translates to:
  /// **'Starting Serial #'**
  String get serialStart;

  /// No description provided for @showExchangeFields.
  ///
  /// In en, this message translates to:
  /// **'Exchange fields'**
  String get showExchangeFields;

  /// No description provided for @startContest.
  ///
  /// In en, this message translates to:
  /// **'Start Logging'**
  String get startContest;

  /// No description provided for @endContest.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get endContest;

  /// No description provided for @endContestConfirm.
  ///
  /// In en, this message translates to:
  /// **'End contest session? (Serial counter and settings will be reset.)'**
  String get endContestConfirm;

  /// No description provided for @serialSentLabel.
  ///
  /// In en, this message translates to:
  /// **'Snt #'**
  String get serialSentLabel;

  /// No description provided for @serialRcvdLabel.
  ///
  /// In en, this message translates to:
  /// **'Rcvd #'**
  String get serialRcvdLabel;

  /// No description provided for @exchangeSentLabel.
  ///
  /// In en, this message translates to:
  /// **'Snt Exch'**
  String get exchangeSentLabel;

  /// No description provided for @exchangeRcvdLabel.
  ///
  /// In en, this message translates to:
  /// **'Rcvd Exch'**
  String get exchangeRcvdLabel;

  /// No description provided for @gridSentLabel.
  ///
  /// In en, this message translates to:
  /// **'Grid S'**
  String get gridSentLabel;

  /// No description provided for @gridRcvdLabel.
  ///
  /// In en, this message translates to:
  /// **'Grid R'**
  String get gridRcvdLabel;

  /// No description provided for @logQso.
  ///
  /// In en, this message translates to:
  /// **'Log QSO'**
  String get logQso;

  /// No description provided for @qsoLogged.
  ///
  /// In en, this message translates to:
  /// **'QSO logged'**
  String get qsoLogged;

  /// No description provided for @contestRecentQsos.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get contestRecentQsos;

  /// No description provided for @contestSessions.
  ///
  /// In en, this message translates to:
  /// **'Contest Sessions'**
  String get contestSessions;

  /// No description provided for @newSession.
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get newSession;

  /// No description provided for @noContestSessions.
  ///
  /// In en, this message translates to:
  /// **'No contest sessions yet'**
  String get noContestSessions;

  /// No description provided for @noContestSessionsHint.
  ///
  /// In en, this message translates to:
  /// **'Create a session on the web or tap + to start one here.'**
  String get noContestSessionsHint;

  /// No description provided for @contestSessionActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get contestSessionActive;

  /// No description provided for @contestSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get contestSessionEnded;

  /// No description provided for @qsoCount.
  ///
  /// In en, this message translates to:
  /// **'{count} QSOs'**
  String qsoCount(int count);

  /// No description provided for @contestSessionDates.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String contestSessionDates(String start, String end);

  /// No description provided for @createContestSession.
  ///
  /// In en, this message translates to:
  /// **'Create Contest Session'**
  String get createContestSession;

  /// No description provided for @sessionName.
  ///
  /// In en, this message translates to:
  /// **'Session Name (optional)'**
  String get sessionName;

  /// No description provided for @sessionNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home Station — CW'**
  String get sessionNameHint;

  /// No description provided for @selectContest.
  ///
  /// In en, this message translates to:
  /// **'Select Contest *'**
  String get selectContest;

  /// No description provided for @searchContest.
  ///
  /// In en, this message translates to:
  /// **'Search contests...'**
  String get searchContest;

  /// No description provided for @serverContests.
  ///
  /// In en, this message translates to:
  /// **'From Server'**
  String get serverContests;

  /// No description provided for @builtinContests.
  ///
  /// In en, this message translates to:
  /// **'Common Contests'**
  String get builtinContests;

  /// No description provided for @startDateTime.
  ///
  /// In en, this message translates to:
  /// **'Start Date/Time *'**
  String get startDateTime;

  /// No description provided for @endDateTime.
  ///
  /// In en, this message translates to:
  /// **'End Date/Time *'**
  String get endDateTime;

  /// No description provided for @durationShortcut4h.
  ///
  /// In en, this message translates to:
  /// **'+4h'**
  String get durationShortcut4h;

  /// No description provided for @durationShortcut12h.
  ///
  /// In en, this message translates to:
  /// **'+12h'**
  String get durationShortcut12h;

  /// No description provided for @durationShortcut24h.
  ///
  /// In en, this message translates to:
  /// **'+24h'**
  String get durationShortcut24h;

  /// No description provided for @durationShortcut48h.
  ///
  /// In en, this message translates to:
  /// **'+48h'**
  String get durationShortcut48h;

  /// No description provided for @exchangeType.
  ///
  /// In en, this message translates to:
  /// **'Exchange Type'**
  String get exchangeType;

  /// No description provided for @exchangeTypeSerial.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get exchangeTypeSerial;

  /// No description provided for @exchangeTypeExchange.
  ///
  /// In en, this message translates to:
  /// **'Text Exchange'**
  String get exchangeTypeExchange;

  /// No description provided for @exchangeTypeBoth.
  ///
  /// In en, this message translates to:
  /// **'Serial + Text Exchange'**
  String get exchangeTypeBoth;

  /// No description provided for @createSession.
  ///
  /// In en, this message translates to:
  /// **'Create Session'**
  String get createSession;

  /// No description provided for @sessionCreated.
  ///
  /// In en, this message translates to:
  /// **'Contest session created'**
  String get sessionCreated;

  /// No description provided for @sessionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Contest session updated'**
  String get sessionUpdated;

  /// No description provided for @editContestSession.
  ///
  /// In en, this message translates to:
  /// **'Edit Contest Session'**
  String get editContestSession;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @deleteSession.
  ///
  /// In en, this message translates to:
  /// **'Delete Session'**
  String get deleteSession;

  /// No description provided for @deleteSessionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this contest session? QSOs logged in this session will remain in the logbook.'**
  String get deleteSessionConfirm;

  /// No description provided for @openSession.
  ///
  /// In en, this message translates to:
  /// **'Open for Logging'**
  String get openSession;

  /// No description provided for @patchRequiredContest.
  ///
  /// In en, this message translates to:
  /// **'Contest session management requires the updated Wavelog Mobile patch.'**
  String get patchRequiredContest;

  /// No description provided for @contestCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Contest Calendar'**
  String get contestCalendarTitle;

  /// No description provided for @contestCalendarNoContests.
  ///
  /// In en, this message translates to:
  /// **'No contests found.'**
  String get contestCalendarNoContests;

  /// No description provided for @contestCalendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get contestCalendarToday;

  /// No description provided for @contestCalendarThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get contestCalendarThisWeek;

  /// No description provided for @contestCalendarUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get contestCalendarUpcoming;

  /// No description provided for @contestCalendarRecentlyPast.
  ///
  /// In en, this message translates to:
  /// **'Recently Past'**
  String get contestCalendarRecentlyPast;

  /// No description provided for @contestCalendarLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load contest calendar'**
  String get contestCalendarLoadError;

  /// No description provided for @contestCalendarRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get contestCalendarRefresh;

  /// No description provided for @contestCalendarRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get contestCalendarRetry;

  /// No description provided for @upcomingContestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Contests'**
  String get upcomingContestsTitle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @noUpcomingContests.
  ///
  /// In en, this message translates to:
  /// **'No upcoming contests found.'**
  String get noUpcomingContests;

  /// No description provided for @contestTodayBadge.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get contestTodayBadge;

  /// No description provided for @navStyleLabel.
  ///
  /// In en, this message translates to:
  /// **'Navigation Style'**
  String get navStyleLabel;

  /// No description provided for @navStyleModern.
  ///
  /// In en, this message translates to:
  /// **'Modern — FAB + drawer'**
  String get navStyleModern;

  /// No description provided for @navStyleClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic — 6-tab bar'**
  String get navStyleClassic;

  /// No description provided for @drawerMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get drawerMap;

  /// No description provided for @drawerContestCalendar.
  ///
  /// In en, this message translates to:
  /// **'Contest Calendar'**
  String get drawerContestCalendar;

  /// No description provided for @drawerContestSessions.
  ///
  /// In en, this message translates to:
  /// **'Contest Sessions'**
  String get drawerContestSessions;

  /// No description provided for @drawerAdif.
  ///
  /// In en, this message translates to:
  /// **'ADIF'**
  String get drawerAdif;

  /// No description provided for @drawerMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get drawerMenu;

  /// No description provided for @antennaCompassTitle.
  ///
  /// In en, this message translates to:
  /// **'Antenna Direction'**
  String get antennaCompassTitle;

  /// No description provided for @targetGrid.
  ///
  /// In en, this message translates to:
  /// **'Target Grid Square'**
  String get targetGrid;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @shortPath.
  ///
  /// In en, this message translates to:
  /// **'Short Path'**
  String get shortPath;

  /// No description provided for @longPath.
  ///
  /// In en, this message translates to:
  /// **'Long Path'**
  String get longPath;

  /// No description provided for @azimuth.
  ///
  /// In en, this message translates to:
  /// **'Azimuth'**
  String get azimuth;

  /// No description provided for @myHeading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get myHeading;

  /// No description provided for @invalidGrid.
  ///
  /// In en, this message translates to:
  /// **'Invalid grid square'**
  String get invalidGrid;

  /// No description provided for @gpsLocating.
  ///
  /// In en, this message translates to:
  /// **'GPS locating… please wait'**
  String get gpsLocating;

  /// No description provided for @gpsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'GPS location unavailable'**
  String get gpsUnavailable;

  /// No description provided for @drawerAntenna.
  ///
  /// In en, this message translates to:
  /// **'Antenna Direction'**
  String get drawerAntenna;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log your first QSO to start earning badges!'**
  String get achievementsEmpty;

  /// No description provided for @shareAchievement.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareAchievement;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked!'**
  String get achievementUnlocked;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'{done} / {target}'**
  String progressLabel(int done, int target);

  /// No description provided for @drawerAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get drawerAchievements;

  /// No description provided for @gifPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing video...'**
  String get gifPreparing;

  /// No description provided for @gifCapturing.
  ///
  /// In en, this message translates to:
  /// **'Capturing frames... {percent}%'**
  String gifCapturing(int percent);

  /// No description provided for @gifEncoding.
  ///
  /// In en, this message translates to:
  /// **'Encoding video...'**
  String get gifEncoding;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @noCompassSensor.
  ///
  /// In en, this message translates to:
  /// **'No compass sensor'**
  String get noCompassSensor;

  /// No description provided for @fillFromGps.
  ///
  /// In en, this message translates to:
  /// **'Fill from GPS'**
  String get fillFromGps;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @gpsError.
  ///
  /// In en, this message translates to:
  /// **'GPS error: {error}'**
  String gpsError(String error);

  /// No description provided for @errParse.
  ///
  /// In en, this message translates to:
  /// **'Failed to parse server response'**
  String get errParse;

  /// No description provided for @errLocalStorage.
  ///
  /// In en, this message translates to:
  /// **'Local storage error'**
  String get errLocalStorage;

  /// No description provided for @errServer.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get errServer;

  /// No description provided for @wpxPrefix.
  ///
  /// In en, this message translates to:
  /// **'WPX Prefix'**
  String get wpxPrefix;

  /// No description provided for @nowBtn.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get nowBtn;

  /// No description provided for @contestOtherCustom.
  ///
  /// In en, this message translates to:
  /// **'Other / Custom'**
  String get contestOtherCustom;

  /// No description provided for @sigInfo.
  ///
  /// In en, this message translates to:
  /// **'SIG Info'**
  String get sigInfo;

  /// No description provided for @migrationTitle.
  ///
  /// In en, this message translates to:
  /// **'API v2 Required'**
  String get migrationTitle;

  /// No description provided for @migrationBody.
  ///
  /// In en, this message translates to:
  /// **'Wavelog Mobile now uses Wavelog\'s new API system. Your old API key is no longer valid — follow the steps below to migrate in minutes.'**
  String get migrationBody;

  /// No description provided for @migrationStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Install server patch'**
  String get migrationStep1Title;

  /// No description provided for @migrationStep1Body.
  ///
  /// In en, this message translates to:
  /// **'A small update file needs to be installed on your Wavelog server. Tap the Installation Guide button below to follow the step-by-step instructions.'**
  String get migrationStep1Body;

  /// No description provided for @migrationInstallGuideBtn.
  ///
  /// In en, this message translates to:
  /// **'Installation Guide'**
  String get migrationInstallGuideBtn;

  /// No description provided for @migrationStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Create a new API token'**
  String get migrationStep2Title;

  /// No description provided for @migrationStep2Body.
  ///
  /// In en, this message translates to:
  /// **'In the Wavelog web interface:\n  1. Open the settings menu in the top right\n  2. Go to \"API\" → \"API Tokens\"\n  3. Click \"New Token\"\n  4. Select the \"Wavelog Mobile\" preset\n  5. Confirm and copy the code shown\n  (Token starts with \"wl2_\")'**
  String get migrationStep2Body;

  /// No description provided for @migrationStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Update your profile'**
  String get migrationStep3Title;

  /// No description provided for @migrationStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below. Your server address will be kept — just paste the new token you copied into the field.'**
  String get migrationStep3Body;

  /// No description provided for @migrationUpdateTokenBtn.
  ///
  /// In en, this message translates to:
  /// **'Update Token'**
  String get migrationUpdateTokenBtn;

  /// No description provided for @migrationHelpBtn.
  ///
  /// In en, this message translates to:
  /// **'Help & Installation Guide'**
  String get migrationHelpBtn;

  /// No description provided for @celebTitle.
  ///
  /// In en, this message translates to:
  /// **'Wavelog v3.2.0'**
  String get celebTitle;

  /// No description provided for @celebSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Server Patch No Longer Needed!'**
  String get celebSubtitle;

  /// No description provided for @celebBody.
  ///
  /// In en, this message translates to:
  /// **'All features now work directly via Wavelog\'s official API v2. You can remove the old patch you uploaded to your server.\n\nThis app now requires Wavelog v3.2.0 or later.'**
  String get celebBody;

  /// No description provided for @celebCreateToken.
  ///
  /// In en, this message translates to:
  /// **'Create API Token'**
  String get celebCreateToken;

  /// No description provided for @celebSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get celebSkip;

  /// No description provided for @celebScopesTitle.
  ///
  /// In en, this message translates to:
  /// **'API v2 Token Scopes'**
  String get celebScopesTitle;

  /// No description provided for @celebScopesBody.
  ///
  /// In en, this message translates to:
  /// **'When creating a new token in the Wavelog interface under Profile → API Tokens → New Token, select the following scopes:'**
  String get celebScopesBody;

  /// No description provided for @celebDone.
  ///
  /// In en, this message translates to:
  /// **'Got It'**
  String get celebDone;

  /// No description provided for @scopeQsoRead.
  ///
  /// In en, this message translates to:
  /// **'Read QSO records'**
  String get scopeQsoRead;

  /// No description provided for @scopeQsoWrite.
  ///
  /// In en, this message translates to:
  /// **'Add / update / delete QSOs'**
  String get scopeQsoWrite;

  /// No description provided for @scopeStationRead.
  ///
  /// In en, this message translates to:
  /// **'Read station profiles'**
  String get scopeStationRead;

  /// No description provided for @scopeStationWrite.
  ///
  /// In en, this message translates to:
  /// **'Create / update / delete stations'**
  String get scopeStationWrite;

  /// No description provided for @scopeLogbookRead.
  ///
  /// In en, this message translates to:
  /// **'Read logbooks'**
  String get scopeLogbookRead;

  /// No description provided for @scopeLogbookWrite.
  ///
  /// In en, this message translates to:
  /// **'Create / update / delete logbooks'**
  String get scopeLogbookWrite;

  /// No description provided for @scopeContestRead.
  ///
  /// In en, this message translates to:
  /// **'Read contest sessions'**
  String get scopeContestRead;

  /// No description provided for @scopeContestWrite.
  ///
  /// In en, this message translates to:
  /// **'Create / update contest sessions'**
  String get scopeContestWrite;

  /// No description provided for @scopeCatalogRead.
  ///
  /// In en, this message translates to:
  /// **'DXCC, subdivisions and contest list'**
  String get scopeCatalogRead;

  /// No description provided for @scopeLookupRead.
  ///
  /// In en, this message translates to:
  /// **'Callsign lookup'**
  String get scopeLookupRead;

  /// No description provided for @scopeStatisticsRead.
  ///
  /// In en, this message translates to:
  /// **'Read statistics'**
  String get scopeStatisticsRead;

  /// No description provided for @scopeConfirmationRead.
  ///
  /// In en, this message translates to:
  /// **'Read LoTW / eQSL / QRZ.com confirmations'**
  String get scopeConfirmationRead;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'pl', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
