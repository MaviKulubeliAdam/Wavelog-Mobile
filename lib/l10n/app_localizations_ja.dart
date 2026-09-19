// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Wavelog Mobile';

  @override
  String get splashConnecting => '接続中';

  @override
  String get navHome => 'ホーム';

  @override
  String get navLogbook => 'ログブック';

  @override
  String get navLookup => '検索';

  @override
  String get navStation => '局';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get refresh => '更新';

  @override
  String get continueBtn => '続ける';

  @override
  String get close => '閉じる';

  @override
  String get retry => '再試行';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get success => '成功';

  @override
  String get change => '変更';

  @override
  String get goWeb => '開く →';

  @override
  String get editOnWeb => 'Web で編集';

  @override
  String get openInBrowser => 'ブラウザで開く';

  @override
  String get serverSetupTitle => 'サーバー設定';

  @override
  String get serverSetupSubtitle => 'Wavelog サーバーを設定する';

  @override
  String get serverUrlLabel => 'Wavelog サーバー URL';

  @override
  String get serverUrlHint => 'https://log.example.com';

  @override
  String get testConnection => '接続テスト';

  @override
  String get testingConnection => 'テスト中...';

  @override
  String get sslIssueTitle => 'SSL証明書の問題';

  @override
  String get sslIssueBody =>
      'このサーバーのSSL証明書を検証できませんでした。自己署名または期限切れの可能性があります。検証をスキップして続行しますか?(信頼できるサーバーにのみ推奨されます)';

  @override
  String get sslIssueAllow => '検証せずに続行';

  @override
  String get scopeTestSectionTitle => '権限テスト';

  @override
  String get scopeTestRunning => '権限をテスト中…';

  @override
  String get scopeTestAllPassed => '必要な権限はすべて揃っています';

  @override
  String get scopeTestSomeFailed => '一部の権限が不足しています';

  @override
  String get scopeTestAddHint => 'APIトークン作成時にこの権限も選択してください';

  @override
  String get connectionSuccess => '接続成功！';

  @override
  String get connectionFailed => '接続失敗';

  @override
  String get apiKeyCopied => 'APIキーをコピーしました';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get serverBtn => 'サーバー';

  @override
  String get addAccountBtn => 'アカウント追加';

  @override
  String get signInBtn => 'サインイン';

  @override
  String get deleteProfile => '削除';

  @override
  String get deleteProfileTitle => 'アカウント削除';

  @override
  String deleteProfileConfirm(String name) {
    return '$name をこの端末から削除しますか？';
  }

  @override
  String get displayName => '表示名';

  @override
  String get callsign => 'コールサイン';

  @override
  String get apiKeyLabel => 'APIキー';

  @override
  String get validating => '検証中...';

  @override
  String get profileSaved => 'アカウントを保存しました';

  @override
  String get loginFailed => 'ログイン失敗';

  @override
  String get noStationFound => '一致する局が見つかりません — コールサインを使用します';

  @override
  String get homeTitle => 'ホーム';

  @override
  String get addQso => 'QSO 追加';

  @override
  String get recentQsos => '最近の QSO';

  @override
  String get statsToday => '今日';

  @override
  String get statsMonth => '今月';

  @override
  String get statsYear => '今年';

  @override
  String get statsTotal => '合計';

  @override
  String get noRecentQsos => 'QSOがありません';

  @override
  String get syncNow => '今すぐ同期';

  @override
  String pendingSync(int count) {
    return '$count 件の QSO が同期待ち';
  }

  @override
  String get offlineBanner => 'オフライン — QSO はローカルに保存されました';

  @override
  String get activeStation => 'アクティブ局';

  @override
  String get logbookTitle => 'ログブック';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterAllModes => '全モード';

  @override
  String get searchHint => 'コールサインで検索...';

  @override
  String get noQsos => 'QSOが見つかりません';

  @override
  String get qsoDetailTitle => 'QSO 詳細';

  @override
  String get qsoNotFound => 'QSOが見つかりません';

  @override
  String get signal => 'シグナル';

  @override
  String get rstSent => '送信 RST';

  @override
  String get rstReceived => '受信 RST';

  @override
  String get txPower => '送信出力';

  @override
  String get counterStation => '相手局';

  @override
  String get country => '国';

  @override
  String get continent => '大陸';

  @override
  String get dxcc => 'DXCC';

  @override
  String get cqZone => 'CQ ゾーン';

  @override
  String get ituZone => 'ITU ゾーン';

  @override
  String get gridSquare => 'グリッドスクエア';

  @override
  String get propMode => '伝播';

  @override
  String get distance => '距離';

  @override
  String get qslStatus => 'QSL 状態';

  @override
  String get paperQsl => '紙';

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
  String get qslSent => '送信済み';

  @override
  String get qslRcvd => '受信済み';

  @override
  String get qslReceived => '受信';

  @override
  String get qslMethod => '方法';

  @override
  String get awards => 'アワード参照';

  @override
  String get iota => 'IOTA';

  @override
  String get sota => 'SOTA';

  @override
  String get wwff => 'WWFF';

  @override
  String get pota => 'POTA';

  @override
  String get myStation => '自局';

  @override
  String get myCallsign => '自局コールサイン';

  @override
  String get contest => 'コンテスト';

  @override
  String get serialSent => '送信シリアル';

  @override
  String get serialReceived => '受信シリアル';

  @override
  String get solarConditions => '太陽状態';

  @override
  String get aIndex => 'A 指数';

  @override
  String get kIndex => 'K 指数';

  @override
  String get sfi => 'SFI';

  @override
  String get notesSection => 'メモ';

  @override
  String get rawAdif => '生 ADIF';

  @override
  String get showAll => 'すべて表示';

  @override
  String get showLess => '折りたたむ';

  @override
  String get qrzProfile => 'QRZ プロフィール';

  @override
  String get addQsoTitle => 'QSO 追加';

  @override
  String get liveQso => 'リアルタイム QSO';

  @override
  String get historicalQso => '過去の QSO';

  @override
  String get callsignField => 'コールサイン *';

  @override
  String get lookupSearch => 'QRZ 検索';

  @override
  String get liveDateTimeLabel => '日時 (UTC) — リアルタイム';

  @override
  String get dateTimeLabel => '日時 (UTC)';

  @override
  String get bandField => 'バンド *';

  @override
  String get modeField => 'モード *';

  @override
  String get frequencyField => '周波数 (MHz)';

  @override
  String get rstSentField => '送信 RST *';

  @override
  String get rstRcvdField => '受信 RST *';

  @override
  String get nameField => '氏名';

  @override
  String get qthField => 'QTH';

  @override
  String get gridField => 'グリッドスクエア';

  @override
  String get commentField => 'コメント';

  @override
  String get stationProfileField => '局プロファイル';

  @override
  String get saveQsoBtn => 'QSO 保存';

  @override
  String qsoSaved(String callsign) {
    return '✓  $callsign を保存しました';
  }

  @override
  String qsoSavedLocal(String callsign) {
    return '✓  $callsign をローカルに保存しました';
  }

  @override
  String get noActiveStation => 'アクティブ局が選択されていません';

  @override
  String get lookupTitle => 'コールサイン検索';

  @override
  String get lookupHint => 'コールサインを入力...';

  @override
  String get lookupBtn => '検索';

  @override
  String get recentSearches => '最近の検索';

  @override
  String get clearHistory => '履歴を消去';

  @override
  String get makeQso => 'QSO を記録';

  @override
  String get notFound => '見つかりません';

  @override
  String get stationsTitle => '局';

  @override
  String stationActivated(String callsign) {
    return '$callsign をアクティブ局に設定しました';
  }

  @override
  String get stationWebInfo => 'Wavelog Web インターフェースで局を追加・編集してください。';

  @override
  String get noStations => '局がありません';

  @override
  String get noStationsHint => 'Wavelog Web インターフェースから局を追加してください。';

  @override
  String get addStationOnWeb => 'Wavelog で局を追加';

  @override
  String get adifTitle => 'ADIF インポート / エクスポート';

  @override
  String get importTab => 'インポート';

  @override
  String get exportTab => 'エクスポート';

  @override
  String get selectAdifFile => 'ADIF ファイルを選択';

  @override
  String get selectFileBtn => 'ファイルを選択 (.adi / .adif)';

  @override
  String get stationRequired => '局プロファイル *';

  @override
  String importing(int done, int total) {
    return 'インポート中... $done/$total';
  }

  @override
  String get importBtn => 'インポート';

  @override
  String get fileReadError => 'ファイルを読み込めませんでした。再試行してください';

  @override
  String get invalidFileExtension => '.adi または .adif ファイルを選択してください';

  @override
  String get exportFilters => 'エクスポートフィルター';

  @override
  String get stationFilter => '局';

  @override
  String get allStations => 'すべての局';

  @override
  String get startDate => '開始';

  @override
  String get endDate => '終了';

  @override
  String get notSelected => '未選択';

  @override
  String get clearDates => '日付をクリア';

  @override
  String get exporting => 'エクスポート中...';

  @override
  String get exportAndShare => 'エクスポートして共有';

  @override
  String get copyPath => 'パスをコピー';

  @override
  String get reshare => '再共有';

  @override
  String get pathCopied => 'ファイルパスをコピーしました';

  @override
  String qsoExported(int count) {
    return '$count 件の QSO をエクスポートしました';
  }

  @override
  String get noStationForExport => 'エクスポート対象の局が見つかりません';

  @override
  String qsoImported(int imported, int total) {
    return '$imported / $total 件の QSO をインポートしました';
  }

  @override
  String get selectSaveLocation => '保存先を選択';

  @override
  String get copySuffix => '(コピー)';

  @override
  String get errNetwork => '接続なし — ネットワークを確認してください';

  @override
  String get errTimeout => '接続タイムアウト';

  @override
  String get errUnauthorized => '無効な APIキー';

  @override
  String get settingsTitle => '設定';

  @override
  String get connectionSection => '接続';

  @override
  String get sessionSection => 'セッション';

  @override
  String get loggedIn => 'ログイン中';

  @override
  String get logoutBtn => 'ログアウト';

  @override
  String get logoutTitle => 'ログアウト';

  @override
  String get logoutConfirm => '本当にログアウトしますか？';

  @override
  String get switchAccountBtn => 'アカウント切替';

  @override
  String get activeStationSection => 'アクティブ局';

  @override
  String get selectStationBtn => '局を選択';

  @override
  String get addStationWeb => 'Web で局を追加';

  @override
  String get defaultsSection => 'デフォルト';

  @override
  String get defaultBand => 'デフォルトバンド';

  @override
  String get defaultMode => 'デフォルトモード';

  @override
  String get appSection => 'アプリ';

  @override
  String get darkTheme => 'ダークテーマ';

  @override
  String get darkThemeHint => 'フィールド使用に推奨';

  @override
  String get offlineMode => 'オフラインモード';

  @override
  String get offlineModeHint => 'QSO をローカルに保存し、後で同期';

  @override
  String get allowInsecureSsl => '未検証のSSL証明書を許可';

  @override
  String get allowInsecureSslHint =>
      '自己署名証明書またはプライベートCAを信頼します（自己ホスト型サーバー向け）。公共ネットワークでは非推奨。';

  @override
  String get languageLabel => '言語';

  @override
  String get infoSection => '情報';

  @override
  String get aboutAppBtn => 'アバウト';

  @override
  String get aboutAppHint => 'バージョン、開発者、ライセンス';

  @override
  String get dataSection => 'データ';

  @override
  String get clearCacheBtn => 'QSO キャッシュを消去';

  @override
  String get clearCacheHint => 'ローカル QSO キャッシュを削除します';

  @override
  String get clearCacheTitle => 'キャッシュ消去';

  @override
  String get clearCacheConfirm => 'ローカル QSO キャッシュが削除されます。元に戻せません。';

  @override
  String get clearCacheAction => '消去';

  @override
  String get cacheCleared => 'キャッシュを消去しました';

  @override
  String get langSystem => 'システムデフォルト';

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
  String get langRussian => 'ロシア語';

  @override
  String get aboutTitle => 'アバウト';

  @override
  String get appDescription => 'Wavelog 用オープンソース Android アプリ';

  @override
  String versionLabel(String version, String build) {
    return 'バージョン $version  (ビルド $build)';
  }

  @override
  String get mobileDeveloperSection => 'モバイルアプリ開発者';

  @override
  String get wavelogProjectSection => 'Wavelog プロジェクト';

  @override
  String get wavelogDescription => 'Web ベースのアマチュア無線ログシステム';

  @override
  String get coreDevelopers => 'コア開発者';

  @override
  String get mitLicense => 'MIT ライセンス';

  @override
  String get mitDescription =>
      'このアプリおよび Wavelog プロジェクトは MIT ライセンスの下で配布されています。オープンソース、無保証。';

  @override
  String get licenseSection => 'ライセンス';

  @override
  String get errorNoConnection => '接続なし';

  @override
  String get errorUnauthorized => '認証失敗 — APIキーを確認してください';

  @override
  String get errorServer => 'サーバーエラー';

  @override
  String get patchRequiredTitle => 'サーバーパッチが必要';

  @override
  String get patchRequiredMessage =>
      '編集・削除機能には Wavelog Mobile API パッチのインストールが必要です。\n\nインストール手順は sp9aqg.pl/install.html をご覧ください。';

  @override
  String get patchRequiredBanner =>
      '編集・削除機能には Wavelog Mobile API パッチのインストールが必要です。';

  @override
  String get patchViewGuide => 'ガイドを見る';

  @override
  String get setupGuideTitle => 'セットアップガイド';

  @override
  String get setupGuideIntro =>
      'QSO を記録する前に、アプリを Wavelog サーバーに接続してください。以下の手順に従ってください。';

  @override
  String get setupGuideStep1Title => '1. サーバーアドレス';

  @override
  String get setupGuideStep1Body =>
      'ブラウザで Wavelog を開く際と同じアドレスを入力してください（例: https://yourdomain.com）。末尾のスラッシュは不要です。';

  @override
  String get setupGuideStep2Title => '2. API v2 トークン';

  @override
  String get setupGuideStep2Body =>
      'Wavelog で、設定 → API → API トークン (v2) → 新しいトークン を開き、アプリに必要なスコープを選択します（トークンを貼り付けた後、アプリが自動で確認します）。生成されたトークン（wl2_ で始まる）をコピーしてアプリに貼り付けます。';

  @override
  String get setupGuideStep3Title => '3. コールサインと表示名';

  @override
  String get setupGuideStep3Body =>
      'コールサイン：自局のアマチュア無線コールサイン。表示名：端末でこのログインを識別するラベル。';

  @override
  String get setupGuideContinueBtn => 'セットアップ開始';

  @override
  String get migrationTokenHint => 'wl2_…';

  @override
  String get migrationTokenLabel => 'API v2 トークン';

  @override
  String get migrationValidateBtn => '検証して続ける';

  @override
  String get migrationValidating => '検証中…';

  @override
  String get migrationTokenEmpty => 'wl2_ トークンを貼り付けてください。';

  @override
  String get migrationTokenInvalid => '無効なトークンです — 確認して再試行してください。';

  @override
  String get patchNotInstalledTitle => 'パッチが検出されません';

  @override
  String get patchNotInstalledBody =>
      'サーバーに Wavelog Mobile パッチがインストールされていないようです。\n\nパッチなしでは API v2 トークン (wl2_…) は機能しません。先にステップ 1 を完了してください。';

  @override
  String get patchInstallFirst => 'パッチをインストール';

  @override
  String get appSubtitle => 'アマチュア無線ログアプリ';

  @override
  String get switchToLightTheme => 'ライトテーマに切替';

  @override
  String get switchToDarkTheme => 'ダークテーマに切替';

  @override
  String get deleteQsoTitle => 'QSO 削除';

  @override
  String deleteQsoConfirm(String callsign, String date) {
    return '$date の $callsign との QSO を完全に削除しますか？';
  }

  @override
  String get editTooltip => '編集';

  @override
  String get shareAdifTooltip => 'ADIF を共有';

  @override
  String get localNotSynced => 'ローカルレコード — 未同期';

  @override
  String get satellite => '衛星';

  @override
  String get satelliteMode => '衛星モード';

  @override
  String get antenna => 'アンテナ';

  @override
  String get nameLabel => '氏名';

  @override
  String get stateProvince => '州/省';

  @override
  String get county => '郡';

  @override
  String get city => '市区町村';

  @override
  String get continentAF => 'アフリカ';

  @override
  String get continentAN => '南極';

  @override
  String get continentAS => 'アジア';

  @override
  String get continentEU => 'ヨーロッパ';

  @override
  String get continentNA => '北米';

  @override
  String get continentOC => 'オセアニア';

  @override
  String get continentSA => '南米';

  @override
  String get qrzProfileLoading => 'QRZ プロフィールを読み込み中...';

  @override
  String viewOnQrz(String callsign) {
    return 'QRZ.com で見る ($callsign)';
  }

  @override
  String get qslMethods => 'QSL 方法';

  @override
  String get bureau => 'ビューロー';

  @override
  String qslManagerPrefix(String manager) {
    return 'マネージャー: $manager';
  }

  @override
  String get callsignCopied => 'コールサインをコピーしました';

  @override
  String get uploadedStatus => 'アップロード済み';

  @override
  String get notUploadedStatus => '未アップロード';

  @override
  String get matchedStatus => 'マッチ済み';

  @override
  String get toDeleteStatus => '削除予定';

  @override
  String get yes => 'はい';

  @override
  String get requested => '要求済み';

  @override
  String get no => 'いいえ';

  @override
  String get invalid => '無効';

  @override
  String get viaDirect => 'ダイレクト';

  @override
  String get viaElectronic => '電子';

  @override
  String get viaMail => '郵便';

  @override
  String otherAdifFields(int count) {
    return 'その他の ADIF フィールド ($count)';
  }

  @override
  String get editQsoTitle => 'QSO 編集';

  @override
  String get qsoUpdated => 'QSO を更新しました';

  @override
  String get qsoUpdatedLocal => 'QSO をローカルで更新しました';

  @override
  String get counterStationHint => 'コールサインを入力すると\nQRZ 情報と過去の QSO が\nここに表示されます。';

  @override
  String previousQsosCount(int count) {
    return '過去の QSO ($count)';
  }

  @override
  String morePreviousQsos(int count) {
    return '+$count 件以上...';
  }

  @override
  String previousQsosWithCallsign(String callsign) {
    return '$callsign との過去の QSO';
  }

  @override
  String totalQsos(int count) {
    return '合計 $count 件';
  }

  @override
  String get workedBefore => '過去に交信済み';

  @override
  String get lastQsoLabel => '最後の QSO';

  @override
  String get themeLabel => 'テーマ';

  @override
  String get darkThemeActive => 'ダークテーマ使用中';

  @override
  String get lightThemeActive => 'ライトテーマ使用中';

  @override
  String get lightThemeLabel => 'ライト';

  @override
  String get darkThemeLabel => 'ダーク';

  @override
  String get commentNotes => 'コメント / メモ';

  @override
  String get commentLabel => 'コメント';

  @override
  String get exchangeReceived => '受信エクスチェンジ';

  @override
  String get exchangeSent => '送信エクスチェンジ';

  @override
  String get contestIdLabel => 'コンテスト';

  @override
  String get sigLabel => 'SIG';

  @override
  String get stationSetup => '局設定';

  @override
  String get logbooks => 'ログブック';

  @override
  String get locations => '場所';

  @override
  String get newLogbook => '新しいログブック';

  @override
  String get logbookName => 'ログブック名';

  @override
  String get renameLogbook => '名前変更';

  @override
  String get deleteLogbook => 'ログブック削除';

  @override
  String get setActiveLogbook => 'アクティブに設定';

  @override
  String get activeLogbook => 'アクティブログブック';

  @override
  String get editStation => '編集';

  @override
  String get cloneStation => '複製';

  @override
  String get deleteStation => '削除';

  @override
  String get deleteStationConfirm => '局を削除';

  @override
  String get deleteStationWarning => 'この局のすべての QSO が完全に削除されます。続けますか？';

  @override
  String get stationDeleted => '局を削除しました';

  @override
  String get stationUpdated => '局を更新しました';

  @override
  String get stationCloned => '局を複製しました';

  @override
  String get linkLocation => '場所をリンク';

  @override
  String get unlinkLocation => 'リンク解除';

  @override
  String get linkedLocations => 'リンクされた場所';

  @override
  String get newStationName => '新しい局名';

  @override
  String get deleteLogbookConfirm => 'ログブック削除';

  @override
  String get deleteLogbookWarning => 'このログブックが削除されます。リンクされた場所は保持されます。続けますか？';

  @override
  String get logbookDeleted => 'ログブックを削除しました';

  @override
  String get hrdlogCode => 'HRDLog コード';

  @override
  String get webAdifApiKey => 'WebADIF APIキー';

  @override
  String get webAdifApiUrl => 'WebADIF API URL';

  @override
  String get basicInfo => '基本情報';

  @override
  String get locationSectionTitle => '場所';

  @override
  String get awardReferences => 'アワード参照';

  @override
  String get integrationsSectionTitle => '連携';

  @override
  String get stationSettingsSection => '局設定';

  @override
  String get editStationTitle => '局を編集';

  @override
  String get newStationTitle => '新しい局';

  @override
  String get saveChangesBtn => '変更を保存';

  @override
  String get createStationBtn => '局を作成';

  @override
  String get stationCreated => '局を作成しました';

  @override
  String get stationCreateFailed => '失敗しました。同じ名前のプロファイルが既に存在する可能性があります。';

  @override
  String get stationProfileNameLabel => '局プロファイル名 *';

  @override
  String get stationProfileNameHint => 'ホーム局';

  @override
  String get cityQth => '市区町村 / QTH';

  @override
  String get powerWatts => '出力 (W)';

  @override
  String get dxccCountry => 'DXCC / 国';

  @override
  String get selectLabel => '選択...';

  @override
  String get dxccSearch => 'DXCC / 国を検索';

  @override
  String get deletedDxcc => '削除済み DXCC';

  @override
  String get eqslQthNicknameLabel => 'eQSL QTH ニックネーム';

  @override
  String get eqslDefaultMsgLabel => 'eQSL デフォルトメッセージ';

  @override
  String get pending => '保留中';

  @override
  String get uploadDisabled => '無効';

  @override
  String get uploadEnabled => '有効';

  @override
  String get uploadRealtime => 'リアルタイム';

  @override
  String get qrzApiKeyLabel => 'QRZ.com ログブック APIキー';

  @override
  String get qrzUploadLabel => 'QRZ.com アップロード';

  @override
  String get clublogIgnoreTitle => 'Clublog を無視';

  @override
  String get clublogIgnoreSubtitle => 'この局を Clublog アップロードから除外';

  @override
  String get clublogRealtimeTitle => 'Clublog リアルタイム';

  @override
  String get clublogRealtimeSubtitle => 'QSO をリアルタイムで Clublog にアップロード';

  @override
  String get hrdlogUsernameLabel => 'HRDLog.net ユーザー名';

  @override
  String get hrdlogApiKeyLabel => 'HRDLog.net APIキー';

  @override
  String get hrdlogUploadLabel => 'HRDLog.net アップロード';

  @override
  String get qo100ApiKeyLabel => 'QO-100 DX Club APIキー';

  @override
  String get qo100RealtimeTitle => 'QO-100 DX Club リアルタイム';

  @override
  String get qo100RealtimeSubtitle => 'QSO をリアルタイムで QO-100 DX Club にアップロード';

  @override
  String get oqrsSectionTitle => 'OQRS（オンライン QSL）';

  @override
  String get oqrsEnabledTitle => 'OQRS 有効';

  @override
  String get oqrsEnabledSubtitle => 'オンライン QSL リクエストシステムを有効にする';

  @override
  String get oqrsTextLabel => 'OQRS 説明テキスト';

  @override
  String get oqrsEmailLabel => 'OQRS メール';

  @override
  String get setAsActiveStationTitle => 'アクティブ局に設定';

  @override
  String get setAsActiveStationSubtitle => 'Wavelog でこの局をアクティブとしてマーク';

  @override
  String get linkToActiveLogbookTitle => 'アクティブログブックにリンク';

  @override
  String get linkToActiveLogbookSubtitle => '作成時にアクティブログブックに自動的にリンク';

  @override
  String get active => 'アクティブ';

  @override
  String get loadDetailsFailed => '詳細の読み込みに失敗しました';

  @override
  String get cannotDeleteActiveStation => 'アクティブ局は削除できません。';

  @override
  String get navStats => '統計';

  @override
  String get statisticsTitle => '統計';

  @override
  String get uniqueCallsigns => 'ユニークコール';

  @override
  String get currentStreak => '連続記録';

  @override
  String streakDays(int count) {
    return '$count 日';
  }

  @override
  String get bandDistribution => 'バンド分布';

  @override
  String get modeDistribution => 'モード分布';

  @override
  String get perStation => '局別';

  @override
  String get basedOnCache => 'バンド / モード / 局統計はキャッシュされた QSO に基づいています。';

  @override
  String get statsTab => '統計';

  @override
  String get propagationTab => '伝播';

  @override
  String get bandConditions => 'バンド状況';

  @override
  String get dayTime => '昼';

  @override
  String get nightTime => '夜';

  @override
  String get conditionGood => '良好';

  @override
  String get conditionFair => '普通';

  @override
  String get conditionPoor => '不良';

  @override
  String lastUpdated(String time) {
    return '更新: $time';
  }

  @override
  String get noSolarData => '太陽データを読み込めませんでした';

  @override
  String get potaStats => 'POTA 統計';

  @override
  String get potaTotalQsos => 'POTA QSO';

  @override
  String get potaActivatedParks => '運用済み公園';

  @override
  String get potaAllParks => '全公園';

  @override
  String get potaActivatedBadge => '運用済み';

  @override
  String get potaAttemptBadge => '試行';

  @override
  String get potaNoStation => 'POTA 局プロファイルが設定されていません';

  @override
  String get potaNoQsos => 'キャッシュに POTA QSO がありません';

  @override
  String get navSpot => 'スポット';

  @override
  String get spotTitle => 'スポット';

  @override
  String get spotAdd => 'スポット追加';

  @override
  String get spotSend => 'スポット送信';

  @override
  String get spotSent => 'スポット送信完了！';

  @override
  String get spotNoResults => 'スポットが見つかりません';

  @override
  String get spotLoadError => 'スポットを読み込めませんでした';

  @override
  String get spotActivator => '運用局コールサイン';

  @override
  String get spotSpotter => 'スポッター コールサイン';

  @override
  String get spotFrequency => '周波数 (kHz)';

  @override
  String get spotReference => '公園リファレンス';

  @override
  String get spotComments => 'コメント';

  @override
  String get spotCommentsHint => 'QRZ、CQ POTA...';

  @override
  String get spotInvalidRef => '無効な形式（例: PL-0001）';

  @override
  String get sortNewest => '新しい順';

  @override
  String get sortOldest => '古い順';

  @override
  String get filterBand => 'バンド';

  @override
  String get filterMode => 'モード';

  @override
  String get filterCountry => '国';

  @override
  String get filterAssociation => '協会';

  @override
  String get spotAddComingSoon => 'スポット追加 — 近日公開';

  @override
  String get filterClear => 'フィルターをクリア';

  @override
  String get mode => 'モード';

  @override
  String get required => '必須';

  @override
  String get invalidNumber => '無効な数値';

  @override
  String get potaAutoSpot => '自動スポット';

  @override
  String get potaAutoSpotHint =>
      'POTA または SOTA 局で QSO を記録する際に自動でセルフスポット（各 30 分のクールダウン）';

  @override
  String get spotRefreshLabel => 'スポット更新間隔';

  @override
  String get spotRefreshHint => 'この間隔でスポットリストを自動的に更新します';

  @override
  String autoSpotSent(String ref) {
    return '自動スポット送信: $ref';
  }

  @override
  String get autoSpotWillFire => 'QSO でスポットがトリガーされます';

  @override
  String autoSpotCooldown(int min) {
    return 'スポット送信済み · 次は $min 分後';
  }

  @override
  String get autoSpotCooldownSoon => 'スポット送信済み · 次のスポットはまもなく';

  @override
  String autoSpotKeyChanged(String fields) {
    return '$fields が変更されました · 新しいスポットが送信されます';
  }

  @override
  String get autoSpotFieldFreq => '周波数';

  @override
  String get autoSpotFieldMode => 'モード';

  @override
  String get autoSpotFieldRef => '公園';

  @override
  String get logbookSummaryTitle => '最近の QSO';

  @override
  String todayQsoCount(int count) {
    return '今日: $count QSO';
  }

  @override
  String get colDateTime => '日時';

  @override
  String get colRstSent => 'RST(S)';

  @override
  String get colRstRcvd => 'RST(R)';

  @override
  String get submodeLabel => 'サブモード';

  @override
  String selectedCount(int count) {
    return '$count 件選択';
  }

  @override
  String get selectAll => 'すべて選択';

  @override
  String get exportSelected => 'エクスポート';

  @override
  String get deleteSelected => '削除';

  @override
  String deleteSelectedConfirm(int count) {
    return '$count 件の QSO を削除しますか？';
  }

  @override
  String get mapTitle => 'マップ';

  @override
  String get mapNoData => 'グリッドスクエアのある QSO が見つかりません';

  @override
  String mapStationCount(int count) {
    return '$count 局';
  }

  @override
  String get dxccProgress => 'DXCC 進捗';

  @override
  String get workedCountries => '交信済み国';

  @override
  String get dxccWorked => '交信済み';

  @override
  String dxccUniqueEntities(int count) {
    return '$count ユニークエンティティ';
  }

  @override
  String get dxccConfirmed => '確認済み (LoTW / eQSL / QSL)';

  @override
  String get dxccRemaining => '残り';

  @override
  String get dxccLegendConfirmed => '確認済み';

  @override
  String get dxccLegendPending => '保留中';

  @override
  String get dxccLegendNotWorked => '未交信';

  @override
  String get spotSummitNotFound => '山頂が見つかりません';

  @override
  String get spotParkNotFound => '公園が見つかりません';

  @override
  String get qsoTypeTitle => 'QSO を記録';

  @override
  String get normalQso => '通常 QSO';

  @override
  String get normalQsoDesc => '標準的な交信エントリー';

  @override
  String get contestQso => 'コンテスト QSO';

  @override
  String get contestQsoDesc => 'エクスチェンジを含む高速コンテスト記録';

  @override
  String get contestLog => 'コンテストログ';

  @override
  String get contestSetup => 'コンテスト設定';

  @override
  String get contestNameHint => '例: CQ-WW-CW';

  @override
  String get ourExchange => '自局エクスチェンジ';

  @override
  String get serialStart => '開始シリアル #';

  @override
  String get showExchangeFields => 'エクスチェンジフィールド';

  @override
  String get startContest => '記録開始';

  @override
  String get endContest => 'セッション終了';

  @override
  String get endContestConfirm => 'コンテストセッションを終了しますか？（シリアルカウンターと設定がリセットされます。）';

  @override
  String get serialSentLabel => '送信 #';

  @override
  String get serialRcvdLabel => '受信 #';

  @override
  String get exchangeSentLabel => '送信 Exch';

  @override
  String get exchangeRcvdLabel => '受信 Exch';

  @override
  String get gridSentLabel => 'グリッド S';

  @override
  String get gridRcvdLabel => 'グリッド R';

  @override
  String get logQso => 'QSO 記録';

  @override
  String get qsoLogged => 'QSO を記録しました';

  @override
  String get contestRecentQsos => '最近';

  @override
  String get contestSessions => 'コンテストセッション';

  @override
  String get newSession => '新しいセッション';

  @override
  String get noContestSessions => 'コンテストセッションがありません';

  @override
  String get noContestSessionsHint => 'Web でセッションを作成するか、+ をタップして開始してください。';

  @override
  String get contestSessionActive => 'アクティブ';

  @override
  String get contestSessionEnded => '終了';

  @override
  String qsoCount(int count) {
    return '$count QSO';
  }

  @override
  String contestSessionDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get createContestSession => 'コンテストセッションを作成';

  @override
  String get sessionName => 'セッション名（任意）';

  @override
  String get sessionNameHint => '例: ホーム局 — CW';

  @override
  String get selectContest => 'コンテストを選択 *';

  @override
  String get searchContest => 'コンテストを検索...';

  @override
  String get serverContests => 'サーバーから';

  @override
  String get builtinContests => '一般的なコンテスト';

  @override
  String get startDateTime => '開始日時 *';

  @override
  String get endDateTime => '終了日時 *';

  @override
  String get durationShortcut4h => '+4h';

  @override
  String get durationShortcut12h => '+12h';

  @override
  String get durationShortcut24h => '+24h';

  @override
  String get durationShortcut48h => '+48h';

  @override
  String get exchangeType => 'エクスチェンジタイプ';

  @override
  String get exchangeTypeSerial => 'シリアル番号';

  @override
  String get exchangeTypeExchange => 'テキストエクスチェンジ';

  @override
  String get exchangeTypeBoth => 'シリアル + テキストエクスチェンジ';

  @override
  String get createSession => 'セッションを作成';

  @override
  String get sessionCreated => 'コンテストセッションを作成しました';

  @override
  String get sessionUpdated => 'コンテストセッションを更新しました';

  @override
  String get editContestSession => 'コンテストセッションを編集';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get deleteSession => 'セッションを削除';

  @override
  String get deleteSessionConfirm =>
      'このコンテストセッションを削除しますか？このセッションで記録した QSO はログブックに残ります。';

  @override
  String get openSession => '記録用に開く';

  @override
  String get patchRequiredContest =>
      'コンテストセッション管理には更新された Wavelog Mobile パッチが必要です。';

  @override
  String get contestCalendarTitle => 'コンテストカレンダー';

  @override
  String get contestCalendarNoContests => 'コンテストが見つかりません。';

  @override
  String get contestCalendarToday => '今日';

  @override
  String get contestCalendarThisWeek => '今週';

  @override
  String get contestCalendarUpcoming => '今後';

  @override
  String get contestCalendarRecentlyPast => '最近終了';

  @override
  String get contestCalendarLoadError => 'コンテストカレンダーを読み込めませんでした';

  @override
  String get contestCalendarRefresh => '更新';

  @override
  String get contestCalendarRetry => '再試行';

  @override
  String get upcomingContestsTitle => '今後のコンテスト';

  @override
  String get viewAll => 'すべて表示';

  @override
  String get noUpcomingContests => '今後のコンテストは見つかりません。';

  @override
  String get contestTodayBadge => '今日';

  @override
  String get navStyleLabel => 'ナビゲーションスタイル';

  @override
  String get navStyleModern => 'モダン — FAB + ドロワー';

  @override
  String get navStyleClassic => 'クラシック — 6 タブバー';

  @override
  String get drawerMap => 'マップ';

  @override
  String get drawerContestCalendar => 'コンテストカレンダー';

  @override
  String get drawerContestSessions => 'コンテストセッション';

  @override
  String get drawerAdif => 'ADIF';

  @override
  String get drawerMenu => 'メニュー';

  @override
  String get antennaCompassTitle => 'アンテナ方向';

  @override
  String get targetGrid => 'ターゲットグリッドスクエア';

  @override
  String get calculate => '計算';

  @override
  String get shortPath => 'ショートパス';

  @override
  String get longPath => 'ロングパス';

  @override
  String get azimuth => '方位角';

  @override
  String get myHeading => '方位';

  @override
  String get invalidGrid => '無効なグリッドスクエア';

  @override
  String get gpsLocating => 'GPS 測位中… しばらくお待ちください';

  @override
  String get gpsUnavailable => 'GPS 位置情報が利用できません';

  @override
  String get drawerAntenna => 'アンテナ方向';

  @override
  String get achievementsTitle => '実績';

  @override
  String get achievementsEmpty => '最初の QSO を記録してバッジを獲得しましょう！';

  @override
  String get shareAchievement => '共有';

  @override
  String get achievementUnlocked => '実績解除！';

  @override
  String progressLabel(int done, int target) {
    return '$done / $target';
  }

  @override
  String get drawerAchievements => '実績';

  @override
  String get drawerCommunity => 'コミュニティ';

  @override
  String get communityTitle => 'コミュニティ';

  @override
  String get communityNoActivations => '予定されたアクティベーションはありません';

  @override
  String get communityBeFirst => '最初に告知してみましょう！';

  @override
  String get communityAnnounce => 'アクティベーションを告知';

  @override
  String get communityFollow => 'フォロー';

  @override
  String get communityUnfollow => 'フォロー解除';

  @override
  String communityFollowers(int count) {
    return '$count フォロワー';
  }

  @override
  String get communityTypeGeneral => '一般';

  @override
  String get communityCallsign => 'コールサイン';

  @override
  String get communityReference => 'リファレンス';

  @override
  String get communitySotaRef => 'SOTAリファレンス (TA/AN-001)';

  @override
  String get communityPotaRef => 'POTAリファレンス (TA-0001)';

  @override
  String get communityScheduledTime => '予定時刻';

  @override
  String get communityNote => 'メモ（任意）';

  @override
  String get communityNoteHint => 'アクティベーションの簡単な説明...';

  @override
  String get communityAnnounceButton => '告知する';

  @override
  String get communityAnnounced => 'アクティベーションを告知しました！';

  @override
  String get communityRateLimit => '直前に告知しました。しばらく待ってください。';

  @override
  String get communityCallsignRequired => 'コールサインは必須です';

  @override
  String get communityReferenceRequired => 'リファレンスは必須です';

  @override
  String get communityBandRequired => '少なくとも1つのバンドを選択してください';

  @override
  String get communityActivations => 'アクティベーション';

  @override
  String get communityChat => 'チャット';

  @override
  String get communityEditActivation => 'アクティベーションを編集';

  @override
  String get communityDeleteActivation => 'アクティベーションを削除';

  @override
  String get communityDeleteActivationConfirm =>
      'このアクティベーションを削除しますか？この操作は元に戻せません。';

  @override
  String get communityUpdated => 'アクティベーションを更新しました';

  @override
  String get chatRooms => 'チャットルーム';

  @override
  String get chatGeneral => '一般';

  @override
  String get chatGeneralSubtitle => '共通言語: 英語';

  @override
  String get chatMessageHint => 'メッセージを入力…';

  @override
  String get chatSend => '送信';

  @override
  String get chatEdit => '編集';

  @override
  String get chatDelete => '削除';

  @override
  String get chatDeleteConfirm => 'このメッセージを削除しますか？';

  @override
  String get chatEdited => '編集済み';

  @override
  String get chatNoStation => 'チャットするにはアクティブな局を設定してください';

  @override
  String get chatToday => '今日';

  @override
  String get chatYesterday => '昨日';

  @override
  String get chatFollow => 'フォロー';

  @override
  String get chatUnfollow => 'フォロー解除';

  @override
  String get chatFollowing => 'フォロー中';

  @override
  String get chatAddReaction => 'リアクションを追加';

  @override
  String get gifPreparing => '動画を準備中...';

  @override
  String gifCapturing(int percent) {
    return 'フレームをキャプチャ中... $percent%';
  }

  @override
  String get gifEncoding => '動画をエンコード中...';

  @override
  String get comingSoon => '近日公開';

  @override
  String get noCompassSensor => 'コンパスセンサーなし';

  @override
  String get fillFromGps => 'GPS から入力';

  @override
  String get locationPermissionDenied => '位置情報の権限が拒否されました';

  @override
  String gpsError(String error) {
    return 'GPS エラー: $error';
  }

  @override
  String get errParse => 'サーバーレスポンスの解析に失敗しました';

  @override
  String get errLocalStorage => 'ローカルストレージエラー';

  @override
  String get errServer => 'サーバーエラー';

  @override
  String get wpxPrefix => 'WPX プレフィックス';

  @override
  String get nowBtn => '今すぐ';

  @override
  String get contestOtherCustom => 'その他 / カスタム';

  @override
  String get sigInfo => 'SIG 情報';

  @override
  String get migrationTitle => 'API v2 が必要です';

  @override
  String get migrationBody =>
      'Wavelog Mobile は Wavelog の新しい API システムを使用するようになりました。古い APIキーは無効です — 以下の手順に従って数分で移行してください。';

  @override
  String get migrationStep1Title => 'サーバーパッチをインストール';

  @override
  String get migrationStep1Body =>
      'Wavelog サーバーに小さな更新ファイルをインストールする必要があります。下のインストールガイドボタンをタップして手順に従ってください。';

  @override
  String get migrationInstallGuideBtn => 'インストールガイド';

  @override
  String get migrationStep2Title => '新しい API トークンを作成';

  @override
  String get migrationStep2Body =>
      'Wavelog Web インターフェースで:\n  1. 右上の設定メニューを開く\n  2. 「API」→「API トークン」に移動\n  3. 「新しいトークン」をクリック\n  4. 「Wavelog Mobile」プリセットを選択\n  5. 確認して表示されたコードをコピー\n  （トークンは「wl2_」で始まります）';

  @override
  String get migrationStep3Title => 'プロファイルを更新';

  @override
  String get migrationStep3Body =>
      '下のボタンをタップしてください。サーバーアドレスはそのまま保持されます — コピーした新しいトークンをフィールドに貼り付けるだけです。';

  @override
  String get migrationUpdateTokenBtn => 'トークンを更新';

  @override
  String get migrationHelpBtn => 'ヘルプ & インストールガイド';

  @override
  String get celebTitle => 'Wavelog v3.2.0';

  @override
  String get celebSubtitle => 'サーバーパッチは不要になりました！';

  @override
  String get celebBody =>
      'すべての機能が Wavelog の公式 API v2 を通じて直接動作するようになりました。サーバーにアップロードした古いパッチを削除できます。\n\nこのアプリは Wavelog v3.2.0 以降が必要です。';

  @override
  String get celebCreateToken => 'API トークンを作成';

  @override
  String get celebSkip => 'スキップ';

  @override
  String get celebScopesTitle => 'API v2 トークンスコープ';

  @override
  String get celebScopesBody =>
      'Wavelog の プロファイル → API トークン → 新しいトークン で新しいトークンを作成する際、以下のスコープを選択してください：';

  @override
  String get celebDone => '了解しました';

  @override
  String get scopeQsoRead => 'QSO レコードの読み取り';

  @override
  String get scopeQsoWrite => 'QSO の追加 / 更新';

  @override
  String get scopeQsoDelete => 'QSO の削除';

  @override
  String get scopeStationRead => '局プロファイルの読み取り';

  @override
  String get scopeStationWrite => '局の作成 / 更新';

  @override
  String get scopeStationDelete => '局の削除';

  @override
  String get scopeLogbookRead => 'ログブックの読み取り';

  @override
  String get scopeLogbookWrite => 'ログブックの作成 / 更新';

  @override
  String get scopeLogbookDelete => 'ログブックの削除';

  @override
  String get scopeContestRead => 'コンテストセッションの読み取り';

  @override
  String get scopeContestWrite => 'コンテストセッションの作成 / 更新';

  @override
  String get scopeContestDelete => 'コンテストセッションの削除';

  @override
  String get scopeCatalogRead => 'DXCC、地域区分、コンテストリスト';

  @override
  String get scopeLookupRead => 'コールサイン検索';

  @override
  String get scopeStatisticsRead => '統計の読み取り';

  @override
  String get scopeConfirmationRead => 'LoTW / eQSL / QRZ.com 確認の読み取り';

  @override
  String get scopeTestStation => '局';

  @override
  String get scopeTestLogbook => 'ログブック';

  @override
  String get scopeTestQso => 'QSO';

  @override
  String get scopeTestContest => 'コンテスト';

  @override
  String get scopeTestConfirmation => '確認';

  @override
  String get scopeTestStatistics => '統計';

  @override
  String get scopeTestLookup => '照会';

  @override
  String get apiScopeGuideBtn => 'APIスコープガイド';

  @override
  String get apiScopeGuideTitle => 'APIトークンスコープガイド';

  @override
  String get apiScopeGuideIntro =>
      'WavelogでAPIトークンを新規作成する際（設定 → APIトークン）、アプリの全機能を有効にするために以下のすべてのスコープを選択してください。';

  @override
  String get apiTokenNoticeTitle => '新しいAPIトークンを作成';

  @override
  String get apiTokenNoticeBody =>
      'Wavelog v2 APIは特定のスコープを持つ新しいトークンが必要です。Wavelog → 設定 → APIトークンに移動して、必要なすべてのスコープで新しいトークンを作成してください。完全なリストは下のAPIスコープガイドボタンをタップしてください。';

  @override
  String get apiTokenNoticeDontShow => '今後表示しない';

  @override
  String get apiTokenNoticeIgnore => '無視';

  @override
  String get apiTokenNoticeScopeGuide => 'APIスコープガイド';

  @override
  String get communitySignInTitle => 'コールサインを認証';

  @override
  String get communitySignInSubtitle =>
      'Googleアカウントをコールサインに紐付けるためにGoogleでサインインしてください。';

  @override
  String get communitySignInButton => 'Googleでサインイン';

  @override
  String get communitySignInNoStation => 'コミュニティ機能を使用する前に、設定でアクティブな局を選択してください。';

  @override
  String get communityCallsignTaken => 'このコールサインはすでに別のGoogleアカウントに紐付けられています。';

  @override
  String get communitySignOut => 'サインアウトしてアカウントを切り替える';
}
