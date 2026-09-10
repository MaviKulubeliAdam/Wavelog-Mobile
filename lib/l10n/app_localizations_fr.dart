// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Wavelog Mobile';

  @override
  String get splashConnecting => 'CONNEXION';

  @override
  String get navHome => 'Accueil';

  @override
  String get navLogbook => 'Carnet';

  @override
  String get navLookup => 'Recherche';

  @override
  String get navStation => 'Station';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get continueBtn => 'Continuer';

  @override
  String get close => 'Fermer';

  @override
  String get retry => 'Réessayer';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get change => 'Modifier';

  @override
  String get goWeb => 'Ouvrir →';

  @override
  String get editOnWeb => 'Modifier sur le Web';

  @override
  String get openInBrowser => 'Ouvrir dans le navigateur';

  @override
  String get serverSetupTitle => 'Configuration du serveur';

  @override
  String get serverSetupSubtitle => 'Configurer votre serveur Wavelog';

  @override
  String get serverUrlLabel => 'URL du serveur Wavelog';

  @override
  String get serverUrlHint => 'https://log.exemple.com';

  @override
  String get testConnection => 'Tester la connexion';

  @override
  String get testingConnection => 'Test en cours...';

  @override
  String get connectionSuccess => 'Connexion réussie !';

  @override
  String get connectionFailed => 'Échec de la connexion';

  @override
  String get apiKeyCopied => 'Clé API copiée';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get serverBtn => 'Serveur';

  @override
  String get addAccountBtn => 'Ajouter un compte';

  @override
  String get signInBtn => 'Se connecter';

  @override
  String get deleteProfile => 'Supprimer';

  @override
  String get deleteProfileTitle => 'Supprimer le compte';

  @override
  String deleteProfileConfirm(String name) {
    return 'Retirer $name de cet appareil ?';
  }

  @override
  String get displayName => 'Nom d\'affichage';

  @override
  String get callsign => 'Indicatif';

  @override
  String get apiKeyLabel => 'Clé API';

  @override
  String get validating => 'Validation...';

  @override
  String get profileSaved => 'Compte enregistré';

  @override
  String get loginFailed => 'Échec de la connexion';

  @override
  String get noStationFound => 'Aucune station trouvée — indicatif utilisé';

  @override
  String get homeTitle => 'Accueil';

  @override
  String get addQso => 'Ajouter QSO';

  @override
  String get recentQsos => 'QSO récents';

  @override
  String get statsToday => 'Aujourd\'hui';

  @override
  String get statsMonth => 'Mois';

  @override
  String get statsYear => 'Année';

  @override
  String get statsTotal => 'Total';

  @override
  String get noRecentQsos => 'Aucun QSO';

  @override
  String get syncNow => 'Synchroniser';

  @override
  String pendingSync(int count) {
    return '$count QSO(s) en attente de sync';
  }

  @override
  String get offlineBanner => 'Hors ligne — QSOs sauvegardés localement';

  @override
  String get activeStation => 'Station active';

  @override
  String get logbookTitle => 'Carnet de log';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterAllModes => 'Tous les modes';

  @override
  String get searchHint => 'Rechercher un indicatif...';

  @override
  String get noQsos => 'Aucun QSO trouvé';

  @override
  String get qsoDetailTitle => 'Détail QSO';

  @override
  String get qsoNotFound => 'QSO introuvable';

  @override
  String get signal => 'Signal';

  @override
  String get rstSent => 'RST Émis';

  @override
  String get rstReceived => 'RST Reçu';

  @override
  String get txPower => 'Puissance TX';

  @override
  String get counterStation => 'Station correspondante';

  @override
  String get country => 'Pays';

  @override
  String get continent => 'Continent';

  @override
  String get dxcc => 'DXCC';

  @override
  String get cqZone => 'Zone CQ';

  @override
  String get ituZone => 'Zone ITU';

  @override
  String get gridSquare => 'Locator';

  @override
  String get propMode => 'Propagation';

  @override
  String get distance => 'Distance';

  @override
  String get qslStatus => 'Statut QSL';

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
  String get qslSent => 'Émis';

  @override
  String get qslRcvd => 'Reçu';

  @override
  String get qslReceived => 'Reçu';

  @override
  String get qslMethod => 'Méthode';

  @override
  String get awards => 'Références diplômes';

  @override
  String get iota => 'IOTA';

  @override
  String get sota => 'SOTA';

  @override
  String get wwff => 'WWFF';

  @override
  String get pota => 'POTA';

  @override
  String get myStation => 'Ma station';

  @override
  String get myCallsign => 'Mon indicatif';

  @override
  String get contest => 'Concours';

  @override
  String get serialSent => 'Numéro émis';

  @override
  String get serialReceived => 'Numéro reçu';

  @override
  String get solarConditions => 'Conditions solaires';

  @override
  String get aIndex => 'Indice A';

  @override
  String get kIndex => 'Indice K';

  @override
  String get sfi => 'SFI';

  @override
  String get notesSection => 'Notes';

  @override
  String get rawAdif => 'ADIF brut';

  @override
  String get showAll => 'Tout afficher';

  @override
  String get showLess => 'Réduire';

  @override
  String get qrzProfile => 'Profil QRZ';

  @override
  String get addQsoTitle => 'Ajouter QSO';

  @override
  String get liveQso => 'QSO en direct';

  @override
  String get historicalQso => 'QSO historique';

  @override
  String get callsignField => 'Indicatif *';

  @override
  String get lookupSearch => 'Recherche QRZ';

  @override
  String get liveDateTimeLabel => 'Date/Heure (UTC) — En direct';

  @override
  String get dateTimeLabel => 'Date/Heure (UTC)';

  @override
  String get bandField => 'Bande *';

  @override
  String get modeField => 'Mode *';

  @override
  String get frequencyField => 'Fréquence (MHz)';

  @override
  String get rstSentField => 'RST Émis *';

  @override
  String get rstRcvdField => 'RST Reçu *';

  @override
  String get nameField => 'Nom';

  @override
  String get qthField => 'QTH';

  @override
  String get gridField => 'Locator';

  @override
  String get commentField => 'Commentaire';

  @override
  String get stationProfileField => 'Profil de station';

  @override
  String get saveQsoBtn => 'Enregistrer QSO';

  @override
  String qsoSaved(String callsign) {
    return '✓  $callsign enregistré';
  }

  @override
  String qsoSavedLocal(String callsign) {
    return '✓  $callsign enregistré localement';
  }

  @override
  String get noActiveStation => 'Aucune station active sélectionnée';

  @override
  String get lookupTitle => 'Recherche d\'indicatif';

  @override
  String get lookupHint => 'Entrer un indicatif...';

  @override
  String get lookupBtn => 'Rechercher';

  @override
  String get recentSearches => 'Recherches récentes';

  @override
  String get clearHistory => 'Effacer l\'historique';

  @override
  String get makeQso => 'Enregistrer QSO';

  @override
  String get notFound => 'Introuvable';

  @override
  String get stationsTitle => 'Stations';

  @override
  String stationActivated(String callsign) {
    return '$callsign définie comme station active';
  }

  @override
  String get stationWebInfo =>
      'Ajoutez et modifiez les stations via l\'interface web Wavelog.';

  @override
  String get noStations => 'Aucune station';

  @override
  String get noStationsHint =>
      'Ajoutez une station via l\'interface web Wavelog.';

  @override
  String get addStationOnWeb => 'Ajouter une station sur Wavelog';

  @override
  String get adifTitle => 'Import / Export ADIF';

  @override
  String get importTab => 'Import';

  @override
  String get exportTab => 'Export';

  @override
  String get selectAdifFile => 'Sélectionner un fichier ADIF';

  @override
  String get selectFileBtn => 'Choisir un fichier (.adi / .adif)';

  @override
  String get stationRequired => 'Profil de station *';

  @override
  String importing(int done, int total) {
    return 'Import... $done/$total';
  }

  @override
  String get importBtn => 'Importer';

  @override
  String get fileReadError =>
      'Impossible de lire le fichier, veuillez réessayer';

  @override
  String get invalidFileExtension =>
      'Veuillez sélectionner un fichier .adi ou .adif';

  @override
  String get exportFilters => 'Filtres d\'export';

  @override
  String get stationFilter => 'Station';

  @override
  String get allStations => 'Toutes les stations';

  @override
  String get startDate => 'Début';

  @override
  String get endDate => 'Fin';

  @override
  String get notSelected => 'Non sélectionné';

  @override
  String get clearDates => 'Effacer les dates';

  @override
  String get exporting => 'Export en cours...';

  @override
  String get exportAndShare => 'Exporter et partager';

  @override
  String get copyPath => 'Copier le chemin';

  @override
  String get reshare => 'Partager à nouveau';

  @override
  String get pathCopied => 'Chemin copié';

  @override
  String qsoExported(int count) {
    return '$count QSO(s) exporté(s)';
  }

  @override
  String get noStationForExport => 'Aucune station trouvée pour l\'export';

  @override
  String qsoImported(int imported, int total) {
    return '$imported / $total QSO(s) importé(s)';
  }

  @override
  String get selectSaveLocation => 'Choisir l\'emplacement';

  @override
  String get copySuffix => '(Copie)';

  @override
  String get errNetwork => 'Pas de connexion — vérifiez votre réseau';

  @override
  String get errTimeout => 'Délai de connexion dépassé';

  @override
  String get errUnauthorized => 'Clé API invalide';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get connectionSection => 'Connexion';

  @override
  String get sessionSection => 'Session';

  @override
  String get loggedIn => 'Connecté';

  @override
  String get logoutBtn => 'Déconnexion';

  @override
  String get logoutTitle => 'Déconnexion';

  @override
  String get logoutConfirm => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get switchAccountBtn => 'Changer de compte';

  @override
  String get activeStationSection => 'Station active';

  @override
  String get selectStationBtn => 'Sélectionner une station';

  @override
  String get addStationWeb => 'Ajouter une station sur le Web';

  @override
  String get defaultsSection => 'Valeurs par défaut';

  @override
  String get defaultBand => 'Bande par défaut';

  @override
  String get defaultMode => 'Mode par défaut';

  @override
  String get appSection => 'Application';

  @override
  String get darkTheme => 'Thème sombre';

  @override
  String get darkThemeHint => 'Recommandé pour une utilisation terrain';

  @override
  String get offlineMode => 'Mode hors ligne';

  @override
  String get offlineModeHint =>
      'Sauvegarder les QSOs localement, synchroniser plus tard';

  @override
  String get allowInsecureSsl => 'Autoriser les certificats SSL non vérifiés';

  @override
  String get allowInsecureSslHint =>
      'Faire confiance aux certificats auto-signés ou de CA privée (pour serveurs auto-hébergés). Déconseillé sur les réseaux publics.';

  @override
  String get languageLabel => 'Langue';

  @override
  String get infoSection => 'Informations';

  @override
  String get aboutAppBtn => 'À propos';

  @override
  String get aboutAppHint => 'Version, développeur, licence';

  @override
  String get dataSection => 'Données';

  @override
  String get clearCacheBtn => 'Vider le cache QSO';

  @override
  String get clearCacheHint => 'Supprime le cache QSO local';

  @override
  String get clearCacheTitle => 'Vider le cache';

  @override
  String get clearCacheConfirm =>
      'Le cache QSO local sera supprimé. Cette action est irréversible.';

  @override
  String get clearCacheAction => 'Vider';

  @override
  String get cacheCleared => 'Cache vidé';

  @override
  String get langSystem => 'Langue du système';

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
  String get langRussian => 'Russe';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get appDescription => 'Application Android open source pour Wavelog';

  @override
  String versionLabel(String version, String build) {
    return 'Version $version  (Build $build)';
  }

  @override
  String get mobileDeveloperSection => 'Développeur de l\'application';

  @override
  String get wavelogProjectSection => 'Projet Wavelog';

  @override
  String get wavelogDescription =>
      'Système de log radioamateur basé sur le Web';

  @override
  String get coreDevelopers => 'Développeurs principaux';

  @override
  String get mitLicense => 'Licence MIT';

  @override
  String get mitDescription =>
      'Cette application et le projet Wavelog sont distribués sous la licence MIT. Open source, sans garantie.';

  @override
  String get licenseSection => 'Licence';

  @override
  String get errorNoConnection => 'Pas de connexion';

  @override
  String get errorUnauthorized => 'Non autorisé — vérifiez votre clé API';

  @override
  String get errorServer => 'Erreur serveur';

  @override
  String get patchRequiredTitle => 'Patch serveur requis';

  @override
  String get patchRequiredMessage =>
      'Les fonctions d\'édition et suppression nécessitent le patch API Wavelog Mobile sur votre serveur.\n\nVisitez sp9aqg.pl/install.html pour les instructions.';

  @override
  String get patchRequiredBanner =>
      'Les fonctions d\'édition et suppression nécessitent le patch API Wavelog Mobile.';

  @override
  String get patchViewGuide => 'Voir le guide';

  @override
  String get setupGuideTitle => 'Guide de configuration';

  @override
  String get setupGuideIntro =>
      'Avant de pouvoir enregistrer des QSOs, connectez l\'application à votre serveur Wavelog.';

  @override
  String get setupGuidePatchWarning =>
      'Cette application nécessite le patch Wavelog Mobile sur votre serveur.';

  @override
  String get setupGuidePatchStepTitle => 'Installer le patch serveur';

  @override
  String get setupGuidePatchStepBody =>
      'L\'application utilise l\'API v2 de Wavelog, qui nécessite un petit patch sur votre serveur.';

  @override
  String get setupGuidePatchBtn => 'Guide d\'installation';

  @override
  String get setupGuideStep1Title => '1. Adresse du serveur';

  @override
  String get setupGuideStep1Body =>
      'Entrez l\'adresse que vous utilisez pour ouvrir Wavelog dans votre navigateur, ex. https://votredomaine.com';

  @override
  String get setupGuideStep2Title => '2. Token API v2';

  @override
  String get setupGuideStep2Body =>
      'Dans Wavelog, allez dans Paramètres → API → Tokens API (v2) → Nouveau token. Sélectionnez le preset \"Wavelog Mobile\" et confirmez. Copiez le token généré (commence par wl2_).';

  @override
  String get setupGuideStep3Title => '3. Indicatif & Nom d\'affichage';

  @override
  String get setupGuideStep3Body =>
      'Indicatif : votre propre indicatif radioamateur. Nom d\'affichage : un libellé pour reconnaître ce compte sur votre appareil.';

  @override
  String get setupGuideContinueBtn => 'Démarrer la configuration';

  @override
  String get migrationTokenHint => 'wl2_…';

  @override
  String get migrationTokenLabel => 'Token API v2';

  @override
  String get migrationValidateBtn => 'Valider et continuer';

  @override
  String get migrationValidating => 'Validation…';

  @override
  String get migrationTokenEmpty => 'Veuillez coller votre token wl2_.';

  @override
  String get migrationTokenInvalid =>
      'Token invalide — veuillez vérifier et réessayer.';

  @override
  String get patchNotInstalledTitle => 'Patch non détecté';

  @override
  String get patchNotInstalledBody =>
      'Le patch Wavelog Mobile ne semble pas installé sur votre serveur.\n\nUn token API v2 (wl2_…) ne fonctionnera pas sans le patch.';

  @override
  String get patchInstallFirst => 'Installer le patch';

  @override
  String get appSubtitle => 'Application de log radioamateur';

  @override
  String get switchToLightTheme => 'Passer au thème clair';

  @override
  String get switchToDarkTheme => 'Passer au thème sombre';

  @override
  String get deleteQsoTitle => 'Supprimer QSO';

  @override
  String deleteQsoConfirm(String callsign, String date) {
    return 'Supprimer définitivement le QSO avec $callsign le $date ?';
  }

  @override
  String get editTooltip => 'Modifier';

  @override
  String get shareAdifTooltip => 'Partager ADIF';

  @override
  String get localNotSynced => 'Enregistrement local — non synchronisé';

  @override
  String get satellite => 'Satellite';

  @override
  String get satelliteMode => 'Mode satellite';

  @override
  String get antenna => 'Antenne';

  @override
  String get nameLabel => 'Nom';

  @override
  String get stateProvince => 'État/Province';

  @override
  String get county => 'Département';

  @override
  String get city => 'Ville';

  @override
  String get continentAF => 'Afrique';

  @override
  String get continentAN => 'Antarctique';

  @override
  String get continentAS => 'Asie';

  @override
  String get continentEU => 'Europe';

  @override
  String get continentNA => 'Amérique du Nord';

  @override
  String get continentOC => 'Océanie';

  @override
  String get continentSA => 'Amérique du Sud';

  @override
  String get qrzProfileLoading => 'Chargement du profil QRZ...';

  @override
  String viewOnQrz(String callsign) {
    return 'Voir sur QRZ.com  ($callsign)';
  }

  @override
  String get qslMethods => 'Méthodes QSL';

  @override
  String get bureau => 'Bureau';

  @override
  String qslManagerPrefix(String manager) {
    return 'Gérant : $manager';
  }

  @override
  String get callsignCopied => 'Indicatif copié';

  @override
  String get uploadedStatus => 'Téléversé';

  @override
  String get notUploadedStatus => 'Non téléversé';

  @override
  String get matchedStatus => 'Correspondance';

  @override
  String get toDeleteStatus => 'À supprimer';

  @override
  String get yes => 'Oui';

  @override
  String get requested => 'Demandé';

  @override
  String get no => 'Non';

  @override
  String get invalid => 'Invalide';

  @override
  String get viaDirect => 'Direct';

  @override
  String get viaElectronic => 'Électronique';

  @override
  String get viaMail => 'Courrier';

  @override
  String otherAdifFields(int count) {
    return 'Autres champs ADIF ($count)';
  }

  @override
  String get editQsoTitle => 'Modifier QSO';

  @override
  String get qsoUpdated => 'QSO mis à jour';

  @override
  String get qsoUpdatedLocal => 'QSO mis à jour localement';

  @override
  String get counterStationHint =>
      'Entrez un indicatif pour voir\nles infos QRZ et les QSOs\nprécédents ici.';

  @override
  String previousQsosCount(int count) {
    return 'QSOs précédents ($count)';
  }

  @override
  String morePreviousQsos(int count) {
    return '+$count de plus...';
  }

  @override
  String previousQsosWithCallsign(String callsign) {
    return 'QSOs précédents avec $callsign';
  }

  @override
  String totalQsos(int count) {
    return '$count au total';
  }

  @override
  String get workedBefore => 'Déjà contacté';

  @override
  String get lastQsoLabel => 'Dernier QSO';

  @override
  String get themeLabel => 'Thème';

  @override
  String get darkThemeActive => 'Thème sombre actif';

  @override
  String get lightThemeActive => 'Thème clair actif';

  @override
  String get lightThemeLabel => 'Clair';

  @override
  String get darkThemeLabel => 'Sombre';

  @override
  String get commentNotes => 'Commentaire / Notes';

  @override
  String get commentLabel => 'Commentaire';

  @override
  String get exchangeReceived => 'Échange reçu';

  @override
  String get exchangeSent => 'Échange émis';

  @override
  String get contestIdLabel => 'Concours';

  @override
  String get sigLabel => 'SIG';

  @override
  String get stationSetup => 'Configuration station';

  @override
  String get logbooks => 'Carnets de log';

  @override
  String get locations => 'Emplacements';

  @override
  String get newLogbook => 'Nouveau carnet';

  @override
  String get logbookName => 'Nom du carnet';

  @override
  String get renameLogbook => 'Renommer';

  @override
  String get deleteLogbook => 'Supprimer le carnet';

  @override
  String get setActiveLogbook => 'Définir actif';

  @override
  String get activeLogbook => 'Carnet actif';

  @override
  String get editStation => 'Modifier';

  @override
  String get cloneStation => 'Cloner';

  @override
  String get deleteStation => 'Supprimer';

  @override
  String get deleteStationConfirm => 'Supprimer la station';

  @override
  String get deleteStationWarning =>
      'Tous les QSOs de cette station seront supprimés définitivement. Continuer ?';

  @override
  String get stationDeleted => 'Station supprimée';

  @override
  String get stationUpdated => 'Station mise à jour';

  @override
  String get stationCloned => 'Station clonée';

  @override
  String get linkLocation => 'Lier un emplacement';

  @override
  String get unlinkLocation => 'Délier';

  @override
  String get linkedLocations => 'Emplacements liés';

  @override
  String get newStationName => 'Nom de la nouvelle station';

  @override
  String get deleteLogbookConfirm => 'Supprimer le carnet';

  @override
  String get deleteLogbookWarning =>
      'Ce carnet sera supprimé. Les emplacements liés sont conservés. Continuer ?';

  @override
  String get logbookDeleted => 'Carnet supprimé';

  @override
  String get hrdlogCode => 'Code HRDLog';

  @override
  String get webAdifApiKey => 'Clé API WebADIF';

  @override
  String get webAdifApiUrl => 'URL API WebADIF';

  @override
  String get basicInfo => 'Informations de base';

  @override
  String get locationSectionTitle => 'Localisation';

  @override
  String get awardReferences => 'Références diplômes';

  @override
  String get integrationsSectionTitle => 'Intégrations';

  @override
  String get stationSettingsSection => 'Paramètres station';

  @override
  String get editStationTitle => 'Modifier la station';

  @override
  String get newStationTitle => 'Nouvelle station';

  @override
  String get saveChangesBtn => 'Enregistrer les modifications';

  @override
  String get createStationBtn => 'Créer la station';

  @override
  String get stationCreated => 'Station créée';

  @override
  String get stationCreateFailed =>
      'Échec. Un profil avec ce nom existe peut-être déjà.';

  @override
  String get stationProfileNameLabel => 'Nom du profil de station *';

  @override
  String get stationProfileNameHint => 'Station principale';

  @override
  String get cityQth => 'Ville / QTH';

  @override
  String get powerWatts => 'Puissance (W)';

  @override
  String get dxccCountry => 'DXCC / Pays';

  @override
  String get selectLabel => 'Sélectionner...';

  @override
  String get dxccSearch => 'Rechercher DXCC / Pays';

  @override
  String get deletedDxcc => 'DXCC supprimé';

  @override
  String get eqslQthNicknameLabel => 'Surnom QTH eQSL';

  @override
  String get eqslDefaultMsgLabel => 'Message par défaut eQSL';

  @override
  String get pending => 'En attente';

  @override
  String get uploadDisabled => 'Désactivé';

  @override
  String get uploadEnabled => 'Activé';

  @override
  String get uploadRealtime => 'Temps réel';

  @override
  String get qrzApiKeyLabel => 'Clé API QRZ.com Logbook';

  @override
  String get qrzUploadLabel => 'Téléversement QRZ.com';

  @override
  String get clublogIgnoreTitle => 'Ignorer Clublog';

  @override
  String get clublogIgnoreSubtitle =>
      'Exclure cette station des téléversements Clublog';

  @override
  String get clublogRealtimeTitle => 'Clublog temps réel';

  @override
  String get clublogRealtimeSubtitle =>
      'Téléverser les QSOs vers Clublog en temps réel';

  @override
  String get hrdlogUsernameLabel => 'Nom d\'utilisateur HRDLog.net';

  @override
  String get hrdlogApiKeyLabel => 'Clé API HRDLog.net';

  @override
  String get hrdlogUploadLabel => 'Téléversement HRDLog.net';

  @override
  String get qo100ApiKeyLabel => 'Clé API QO-100 DX Club';

  @override
  String get qo100RealtimeTitle => 'QO-100 DX Club temps réel';

  @override
  String get qo100RealtimeSubtitle =>
      'Téléverser les QSOs vers QO-100 DX Club en temps réel';

  @override
  String get oqrsSectionTitle => 'OQRS (QSL en ligne)';

  @override
  String get oqrsEnabledTitle => 'OQRS activé';

  @override
  String get oqrsEnabledSubtitle =>
      'Activer le système de demande QSL en ligne';

  @override
  String get oqrsTextLabel => 'Texte de description OQRS';

  @override
  String get oqrsEmailLabel => 'Email OQRS';

  @override
  String get setAsActiveStationTitle => 'Définir comme station active';

  @override
  String get setAsActiveStationSubtitle =>
      'Marquer cette station comme active dans Wavelog';

  @override
  String get linkToActiveLogbookTitle => 'Lier au carnet actif';

  @override
  String get linkToActiveLogbookSubtitle =>
      'Lier automatiquement au carnet actif à la création';

  @override
  String get active => 'Actif';

  @override
  String get loadDetailsFailed => 'Échec du chargement des détails';

  @override
  String get cannotDeleteActiveStation =>
      'Impossible de supprimer la station active.';

  @override
  String get navStats => 'Stats';

  @override
  String get statisticsTitle => 'Statistiques';

  @override
  String get uniqueCallsigns => 'Indicatifs uniques';

  @override
  String get currentStreak => 'Série en cours';

  @override
  String streakDays(int count) {
    return '$count jour(s)';
  }

  @override
  String get bandDistribution => 'Répartition par bande';

  @override
  String get modeDistribution => 'Répartition par mode';

  @override
  String get perStation => 'Par station';

  @override
  String get basedOnCache =>
      'Les stats bande/mode/station sont basées sur les QSOs en cache.';

  @override
  String get statsTab => 'Statistiques';

  @override
  String get propagationTab => 'Propagation';

  @override
  String get bandConditions => 'Conditions de bande';

  @override
  String get dayTime => 'Jour';

  @override
  String get nightTime => 'Nuit';

  @override
  String get conditionGood => 'Bonne';

  @override
  String get conditionFair => 'Moyenne';

  @override
  String get conditionPoor => 'Mauvaise';

  @override
  String lastUpdated(String time) {
    return 'Mis à jour : $time';
  }

  @override
  String get noSolarData => 'Impossible de charger les données solaires';

  @override
  String get potaStats => 'Statistiques POTA';

  @override
  String get potaTotalQsos => 'QSOs POTA';

  @override
  String get potaActivatedParks => 'Parcs activés';

  @override
  String get potaAllParks => 'Tous les parcs';

  @override
  String get potaActivatedBadge => 'Activé';

  @override
  String get potaAttemptBadge => 'Tentative';

  @override
  String get potaNoStation => 'Aucun profil de station POTA configuré';

  @override
  String get potaNoQsos => 'Aucun QSO POTA en cache';

  @override
  String get navSpot => 'Spot';

  @override
  String get spotTitle => 'Spot';

  @override
  String get spotAdd => 'Ajouter un spot';

  @override
  String get spotSend => 'Envoyer le spot';

  @override
  String get spotSent => 'Spot envoyé !';

  @override
  String get spotNoResults => 'Aucun spot trouvé';

  @override
  String get spotLoadError => 'Impossible de charger les spots';

  @override
  String get spotActivator => 'Indicatif activateur';

  @override
  String get spotSpotter => 'Indicatif spotter';

  @override
  String get spotFrequency => 'Fréquence (kHz)';

  @override
  String get spotReference => 'Référence parc';

  @override
  String get spotComments => 'Commentaires';

  @override
  String get spotCommentsHint => 'QRZ, CQ POTA...';

  @override
  String get spotInvalidRef => 'Format invalide (ex. PL-0001)';

  @override
  String get sortNewest => 'Plus récent d\'abord';

  @override
  String get sortOldest => 'Plus ancien d\'abord';

  @override
  String get filterBand => 'Bande';

  @override
  String get filterMode => 'Mode';

  @override
  String get filterCountry => 'Pays';

  @override
  String get filterAssociation => 'Association';

  @override
  String get spotAddComingSoon => 'Ajouter un spot — Bientôt disponible';

  @override
  String get filterClear => 'Effacer les filtres';

  @override
  String get mode => 'Mode';

  @override
  String get required => 'Requis';

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String get potaAutoSpot => 'Auto-Spot';

  @override
  String get potaAutoSpotHint =>
      'S\'auto-spotter automatiquement lors d\'un QSO à une station POTA ou SOTA (délai de 30 min)';

  @override
  String autoSpotSent(String ref) {
    return 'Auto-spot envoyé : $ref';
  }

  @override
  String get autoSpotWillFire => 'Le QSO déclenchera un spot';

  @override
  String autoSpotCooldown(int min) {
    return 'Spot envoyé · Prochain dans $min min';
  }

  @override
  String get autoSpotCooldownSoon => 'Spot envoyé · Prochain spot bientôt';

  @override
  String autoSpotKeyChanged(String fields) {
    return '$fields modifié(s) · Nouveau spot à venir';
  }

  @override
  String get autoSpotFieldFreq => 'Fréquence';

  @override
  String get autoSpotFieldMode => 'Mode';

  @override
  String get autoSpotFieldRef => 'Parc';

  @override
  String get logbookSummaryTitle => 'QSO récents';

  @override
  String todayQsoCount(int count) {
    return 'Aujourd\'hui : $count QSO';
  }

  @override
  String get colDateTime => 'Date/Heure';

  @override
  String get colRstSent => 'RST(E)';

  @override
  String get colRstRcvd => 'RST(R)';

  @override
  String get submodeLabel => 'Sous-mode';

  @override
  String selectedCount(int count) {
    return '$count sélectionné(s)';
  }

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get exportSelected => 'Exporter';

  @override
  String get deleteSelected => 'Supprimer';

  @override
  String deleteSelectedConfirm(int count) {
    return 'Supprimer $count QSOs ?';
  }

  @override
  String get mapTitle => 'Carte';

  @override
  String get mapNoData => 'Aucun QSO avec locator trouvé';

  @override
  String mapStationCount(int count) {
    return '$count stations';
  }

  @override
  String get dxccProgress => 'Progression DXCC';

  @override
  String get workedCountries => 'Pays contactés';

  @override
  String get dxccWorked => 'Contactés';

  @override
  String dxccUniqueEntities(int count) {
    return '$count entités uniques';
  }

  @override
  String get dxccConfirmed => 'Confirmés (LoTW / eQSL / QSL)';

  @override
  String get dxccRemaining => 'Restants';

  @override
  String get dxccLegendConfirmed => 'Confirmé';

  @override
  String get dxccLegendPending => 'En attente';

  @override
  String get dxccLegendNotWorked => 'Non contacté';

  @override
  String get spotSummitNotFound => 'Sommet introuvable';

  @override
  String get spotParkNotFound => 'Parc introuvable';

  @override
  String get qsoTypeTitle => 'Enregistrer un QSO';

  @override
  String get normalQso => 'QSO normal';

  @override
  String get normalQsoDesc => 'Saisie de contact standard';

  @override
  String get contestQso => 'QSO concours';

  @override
  String get contestQsoDesc => 'Log concours rapide avec échange';

  @override
  String get contestLog => 'Log concours';

  @override
  String get contestSetup => 'Configuration concours';

  @override
  String get contestNameHint => 'ex. CQ-WW-CW';

  @override
  String get ourExchange => 'Notre échange';

  @override
  String get serialStart => 'Numéro de série de départ';

  @override
  String get showExchangeFields => 'Champs d\'échange';

  @override
  String get startContest => 'Démarrer le log';

  @override
  String get endContest => 'Terminer la session';

  @override
  String get endContestConfirm =>
      'Terminer la session de concours ? (Le compteur série et les paramètres seront réinitialisés.)';

  @override
  String get serialSentLabel => 'Snt #';

  @override
  String get serialRcvdLabel => 'Rcvd #';

  @override
  String get exchangeSentLabel => 'Éch. Émis';

  @override
  String get exchangeRcvdLabel => 'Éch. Reçu';

  @override
  String get gridSentLabel => 'Grid E';

  @override
  String get gridRcvdLabel => 'Grid R';

  @override
  String get logQso => 'Logger QSO';

  @override
  String get qsoLogged => 'QSO enregistré';

  @override
  String get contestRecentQsos => 'Récents';

  @override
  String get contestSessions => 'Sessions de concours';

  @override
  String get newSession => 'Nouvelle session';

  @override
  String get noContestSessions => 'Aucune session de concours';

  @override
  String get noContestSessionsHint =>
      'Créez une session sur le web ou appuyez sur + pour en démarrer une.';

  @override
  String get contestSessionActive => 'Active';

  @override
  String get contestSessionEnded => 'Terminée';

  @override
  String qsoCount(int count) {
    return '$count QSOs';
  }

  @override
  String contestSessionDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get createContestSession => 'Créer une session de concours';

  @override
  String get sessionName => 'Nom de la session (facultatif)';

  @override
  String get sessionNameHint => 'ex. Station principale — CW';

  @override
  String get selectContest => 'Sélectionner un concours *';

  @override
  String get searchContest => 'Rechercher des concours...';

  @override
  String get serverContests => 'Du serveur';

  @override
  String get builtinContests => 'Concours courants';

  @override
  String get startDateTime => 'Date/Heure de début *';

  @override
  String get endDateTime => 'Date/Heure de fin *';

  @override
  String get durationShortcut4h => '+4h';

  @override
  String get durationShortcut12h => '+12h';

  @override
  String get durationShortcut24h => '+24h';

  @override
  String get durationShortcut48h => '+48h';

  @override
  String get exchangeType => 'Type d\'échange';

  @override
  String get exchangeTypeSerial => 'Numéro de série';

  @override
  String get exchangeTypeExchange => 'Échange texte';

  @override
  String get exchangeTypeBoth => 'Série + Échange texte';

  @override
  String get createSession => 'Créer la session';

  @override
  String get sessionCreated => 'Session de concours créée';

  @override
  String get sessionUpdated => 'Session de concours mise à jour';

  @override
  String get editContestSession => 'Modifier la session de concours';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get deleteSession => 'Supprimer la session';

  @override
  String get deleteSessionConfirm =>
      'Supprimer cette session de concours ? Les QSOs enregistrés resteront dans le carnet.';

  @override
  String get openSession => 'Ouvrir pour le log';

  @override
  String get patchRequiredContest =>
      'La gestion des sessions de concours nécessite le patch Wavelog Mobile mis à jour.';

  @override
  String get contestCalendarTitle => 'Calendrier des concours';

  @override
  String get contestCalendarNoContests => 'Aucun concours trouvé.';

  @override
  String get contestCalendarToday => 'Aujourd\'hui';

  @override
  String get contestCalendarThisWeek => 'Cette semaine';

  @override
  String get contestCalendarUpcoming => 'À venir';

  @override
  String get contestCalendarRecentlyPast => 'Récemment passés';

  @override
  String get contestCalendarLoadError =>
      'Impossible de charger le calendrier des concours';

  @override
  String get contestCalendarRefresh => 'Actualiser';

  @override
  String get contestCalendarRetry => 'Réessayer';

  @override
  String get upcomingContestsTitle => 'Concours à venir';

  @override
  String get viewAll => 'Voir tout';

  @override
  String get noUpcomingContests => 'Aucun concours à venir.';

  @override
  String get contestTodayBadge => 'AUJOURD\'HUI';

  @override
  String get navStyleLabel => 'Style de navigation';

  @override
  String get navStyleModern => 'Moderne — FAB + tiroir';

  @override
  String get navStyleClassic => 'Classique — barre 6 onglets';

  @override
  String get drawerMap => 'Carte';

  @override
  String get drawerContestCalendar => 'Calendrier concours';

  @override
  String get drawerContestSessions => 'Sessions concours';

  @override
  String get drawerAdif => 'ADIF';

  @override
  String get drawerMenu => 'Menu';

  @override
  String get antennaCompassTitle => 'Direction antenne';

  @override
  String get targetGrid => 'Locator cible';

  @override
  String get calculate => 'Calculer';

  @override
  String get shortPath => 'Chemin court';

  @override
  String get longPath => 'Chemin long';

  @override
  String get azimuth => 'Azimut';

  @override
  String get myHeading => 'Cap';

  @override
  String get invalidGrid => 'Locator invalide';

  @override
  String get gpsLocating => 'Localisation GPS… veuillez patienter';

  @override
  String get gpsUnavailable => 'Localisation GPS indisponible';

  @override
  String get drawerAntenna => 'Direction antenne';

  @override
  String get achievementsTitle => 'Succès';

  @override
  String get achievementsEmpty =>
      'Enregistrez votre premier QSO pour gagner des badges !';

  @override
  String get shareAchievement => 'Partager';

  @override
  String get achievementUnlocked => 'Succès débloqué !';

  @override
  String progressLabel(int done, int target) {
    return '$done / $target';
  }

  @override
  String get drawerAchievements => 'Succès';

  @override
  String get drawerCommunity => 'Communauté';

  @override
  String get communityTitle => 'Communauté';

  @override
  String get communityNoActivations =>
      'Aucune activation planifiée pour l\'instant';

  @override
  String get communityBeFirst => 'Soyez le premier à en annoncer une !';

  @override
  String get communityAnnounce => 'Annoncer une activation';

  @override
  String get communityFollow => 'Suivre';

  @override
  String get communityUnfollow => 'Ne plus suivre';

  @override
  String communityFollowers(int count) {
    return '$count abonnés';
  }

  @override
  String get communityTypeGeneral => 'Général';

  @override
  String get communityCallsign => 'Indicatif';

  @override
  String get communityReference => 'Référence';

  @override
  String get communitySotaRef => 'Référence SOTA (TA/AN-001)';

  @override
  String get communityPotaRef => 'Référence POTA (TA-0001)';

  @override
  String get communityScheduledTime => 'Heure prévue';

  @override
  String get communityNote => 'Note (optionnelle)';

  @override
  String get communityNoteHint => 'Brève info sur l\'activation...';

  @override
  String get communityAnnounceButton => 'Annoncer';

  @override
  String get communityAnnounced => 'Activation annoncée !';

  @override
  String get communityRateLimit =>
      'Vous venez d\'annoncer. Veuillez patienter quelques minutes.';

  @override
  String get communityCallsignRequired => 'Indicatif requis';

  @override
  String get communityReferenceRequired => 'Référence requise';

  @override
  String get communityBandRequired => 'Sélectionnez au moins une bande';

  @override
  String get gifPreparing => 'Préparation de la vidéo...';

  @override
  String gifCapturing(int percent) {
    return 'Capture des images... $percent%';
  }

  @override
  String get gifEncoding => 'Encodage de la vidéo...';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get noCompassSensor => 'Pas de capteur boussole';

  @override
  String get fillFromGps => 'Remplir via GPS';

  @override
  String get locationPermissionDenied => 'Permission de localisation refusée';

  @override
  String gpsError(String error) {
    return 'Erreur GPS : $error';
  }

  @override
  String get errParse => 'Échec de l\'analyse de la réponse serveur';

  @override
  String get errLocalStorage => 'Erreur de stockage local';

  @override
  String get errServer => 'Erreur serveur';

  @override
  String get wpxPrefix => 'Préfixe WPX';

  @override
  String get nowBtn => 'Maintenant';

  @override
  String get contestOtherCustom => 'Autre / Personnalisé';

  @override
  String get sigInfo => 'Info SIG';

  @override
  String get migrationTitle => 'API v2 requis';

  @override
  String get migrationBody =>
      'Wavelog Mobile utilise désormais le nouveau système API de Wavelog. Votre ancienne clé API n\'est plus valide — suivez les étapes ci-dessous pour migrer en quelques minutes.';

  @override
  String get migrationStep1Title => 'Installer le patch serveur';

  @override
  String get migrationStep1Body =>
      'Un petit fichier de mise à jour doit être installé sur votre serveur Wavelog. Appuyez sur le bouton Guide d\'installation pour suivre les instructions.';

  @override
  String get migrationInstallGuideBtn => 'Guide d\'installation';

  @override
  String get migrationStep2Title => 'Créer un nouveau token API';

  @override
  String get migrationStep2Body =>
      'Dans l\'interface web Wavelog :\n  1. Ouvrez le menu paramètres en haut à droite\n  2. Allez dans \"API\" → \"Tokens API\"\n  3. Cliquez sur \"Nouveau token\"\n  4. Sélectionnez le preset \"Wavelog Mobile\"\n  5. Confirmez et copiez le code affiché\n  (Le token commence par \"wl2_\")';

  @override
  String get migrationStep3Title => 'Mettre à jour votre profil';

  @override
  String get migrationStep3Body =>
      'Appuyez sur le bouton ci-dessous. Votre adresse serveur sera conservée — collez simplement le nouveau token dans le champ.';

  @override
  String get migrationUpdateTokenBtn => 'Mettre à jour le token';

  @override
  String get migrationHelpBtn => 'Aide & Guide d\'installation';

  @override
  String get celebTitle => 'Wavelog v3.2.0';

  @override
  String get celebSubtitle => 'Plus besoin du patch serveur !';

  @override
  String get celebBody =>
      'Toutes les fonctionnalités passent désormais par l\'API v2 officielle de Wavelog. Vous pouvez supprimer l\'ancien patch de votre serveur.\n\nCette application nécessite désormais Wavelog v3.2.0 ou ultérieur.';

  @override
  String get celebCreateToken => 'Créer un token API';

  @override
  String get celebSkip => 'Ignorer';

  @override
  String get celebScopesTitle => 'Portées du token API v2';

  @override
  String get celebScopesBody =>
      'Lors de la création d\'un nouveau token dans Wavelog sous Profil → Tokens API → Nouveau token, sélectionnez les portées suivantes :';

  @override
  String get celebDone => 'Compris';

  @override
  String get scopeQsoRead => 'Lire les QSOs';

  @override
  String get scopeQsoWrite => 'Ajouter / modifier des QSOs';

  @override
  String get scopeQsoDelete => 'Supprimer des QSOs';

  @override
  String get scopeStationRead => 'Lire les profils de station';

  @override
  String get scopeStationWrite => 'Créer / modifier des stations';

  @override
  String get scopeStationDelete => 'Supprimer des stations';

  @override
  String get scopeLogbookRead => 'Lire les carnets de log';

  @override
  String get scopeLogbookWrite => 'Créer / modifier des carnets';

  @override
  String get scopeLogbookDelete => 'Supprimer des carnets';

  @override
  String get scopeContestRead => 'Lire les sessions de concours';

  @override
  String get scopeContestWrite => 'Créer / modifier des sessions de concours';

  @override
  String get scopeContestDelete => 'Supprimer des sessions de concours';

  @override
  String get scopeCatalogRead => 'Liste DXCC, subdivisions et concours';

  @override
  String get scopeLookupRead => 'Recherche d\'indicatif';

  @override
  String get scopeStatisticsRead => 'Lire les statistiques';

  @override
  String get scopeConfirmationRead =>
      'Lire les confirmations LoTW / eQSL / QRZ.com';

  @override
  String get scopeTestStation => 'Station';

  @override
  String get scopeTestLogbook => 'Journal';

  @override
  String get scopeTestQso => 'QSO';

  @override
  String get scopeTestContest => 'Concours';

  @override
  String get scopeTestConfirmation => 'Confirmation';

  @override
  String get scopeTestStatistics => 'Statistiques';

  @override
  String get scopeTestLookup => 'Recherche';

  @override
  String get apiScopeGuideBtn => 'Guide des portées API';

  @override
  String get apiScopeGuideTitle => 'Guide des portées de jeton API';

  @override
  String get apiScopeGuideIntro =>
      'Lors de la création d\'un nouveau jeton API dans Wavelog (Paramètres → Jetons API), sélectionnez toutes les portées ci-dessous pour activer toutes les fonctionnalités de l\'application.';

  @override
  String get apiTokenNoticeTitle => 'Créer un nouveau jeton API';

  @override
  String get apiTokenNoticeBody =>
      'L\'API Wavelog v2 nécessite un nouveau jeton avec des portées spécifiques. Rendez-vous dans Wavelog → Paramètres → Jetons API et créez un nouveau jeton avec toutes les portées requises. Appuyez sur le bouton Guide des portées ci-dessous pour la liste complète.';

  @override
  String get apiTokenNoticeDontShow => 'Ne plus afficher';

  @override
  String get apiTokenNoticeIgnore => 'Ignorer';

  @override
  String get apiTokenNoticeScopeGuide => 'Guide des portées API';
}
