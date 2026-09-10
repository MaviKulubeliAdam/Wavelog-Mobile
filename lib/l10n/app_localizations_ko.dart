// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Wavelog Mobile';

  @override
  String get splashConnecting => '연결 중';

  @override
  String get navHome => '홈';

  @override
  String get navLogbook => '로그북';

  @override
  String get navLookup => '검색';

  @override
  String get navStation => '스테이션';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get refresh => '새로고침';

  @override
  String get continueBtn => '계속';

  @override
  String get close => '닫기';

  @override
  String get retry => '재시도';

  @override
  String get loading => '불러오는 중...';

  @override
  String get error => '오류';

  @override
  String get success => '성공';

  @override
  String get change => '변경';

  @override
  String get goWeb => '열기 →';

  @override
  String get editOnWeb => '웹에서 편집';

  @override
  String get openInBrowser => '브라우저에서 열기';

  @override
  String get serverSetupTitle => '서버 설정';

  @override
  String get serverSetupSubtitle => 'Wavelog 서버를 설정합니다';

  @override
  String get serverUrlLabel => 'Wavelog 서버 URL';

  @override
  String get serverUrlHint => 'https://log.example.com';

  @override
  String get testConnection => '연결 테스트';

  @override
  String get testingConnection => '테스트 중...';

  @override
  String get connectionSuccess => '연결 성공!';

  @override
  String get connectionFailed => '연결 실패';

  @override
  String get apiKeyCopied => 'API 키가 복사되었습니다';

  @override
  String get loginTitle => '로그인';

  @override
  String get serverBtn => '서버';

  @override
  String get addAccountBtn => '계정 추가';

  @override
  String get signInBtn => '로그인';

  @override
  String get deleteProfile => '삭제';

  @override
  String get deleteProfileTitle => '계정 삭제';

  @override
  String deleteProfileConfirm(String name) {
    return '이 기기에서 $name을(를) 제거하시겠습니까?';
  }

  @override
  String get displayName => '표시 이름';

  @override
  String get callsign => '콜사인';

  @override
  String get apiKeyLabel => 'API 키';

  @override
  String get validating => '검증 중...';

  @override
  String get profileSaved => '계정이 저장되었습니다';

  @override
  String get loginFailed => '로그인 실패';

  @override
  String get noStationFound => '일치하는 스테이션이 없습니다 — 콜사인 사용';

  @override
  String get homeTitle => '홈';

  @override
  String get addQso => 'QSO 추가';

  @override
  String get recentQsos => '최근 QSO';

  @override
  String get statsToday => '오늘';

  @override
  String get statsMonth => '이번 달';

  @override
  String get statsYear => '올해';

  @override
  String get statsTotal => '합계';

  @override
  String get noRecentQsos => 'QSO가 없습니다';

  @override
  String get syncNow => '지금 동기화';

  @override
  String pendingSync(int count) {
    return '$count개의 QSO 동기화 대기 중';
  }

  @override
  String get offlineBanner => '오프라인 — QSO가 로컬에 저장되었습니다';

  @override
  String get activeStation => '활성 스테이션';

  @override
  String get logbookTitle => '로그북';

  @override
  String get filterAll => '전체';

  @override
  String get filterAllModes => '모든 모드';

  @override
  String get searchHint => '콜사인 검색...';

  @override
  String get noQsos => 'QSO를 찾을 수 없습니다';

  @override
  String get qsoDetailTitle => 'QSO 상세';

  @override
  String get qsoNotFound => 'QSO를 찾을 수 없습니다';

  @override
  String get signal => '신호';

  @override
  String get rstSent => '송신 RST';

  @override
  String get rstReceived => '수신 RST';

  @override
  String get txPower => '송신 출력';

  @override
  String get counterStation => '상대 스테이션';

  @override
  String get country => '국가';

  @override
  String get continent => '대륙';

  @override
  String get dxcc => 'DXCC';

  @override
  String get cqZone => 'CQ 존';

  @override
  String get ituZone => 'ITU 존';

  @override
  String get gridSquare => '그리드 스퀘어';

  @override
  String get propMode => '전파 경로';

  @override
  String get distance => '거리';

  @override
  String get qslStatus => 'QSL 상태';

  @override
  String get paperQsl => '종이';

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
  String get qslSent => '발송';

  @override
  String get qslRcvd => '수신';

  @override
  String get qslReceived => '수신됨';

  @override
  String get qslMethod => '방법';

  @override
  String get awards => '어워드 참조';

  @override
  String get iota => 'IOTA';

  @override
  String get sota => 'SOTA';

  @override
  String get wwff => 'WWFF';

  @override
  String get pota => 'POTA';

  @override
  String get myStation => '내 스테이션';

  @override
  String get myCallsign => '내 콜사인';

  @override
  String get contest => '콘테스트';

  @override
  String get serialSent => '송신 일련번호';

  @override
  String get serialReceived => '수신 일련번호';

  @override
  String get solarConditions => '태양 상태';

  @override
  String get aIndex => 'A 지수';

  @override
  String get kIndex => 'K 지수';

  @override
  String get sfi => 'SFI';

  @override
  String get notesSection => '메모';

  @override
  String get rawAdif => '원시 ADIF';

  @override
  String get showAll => '모두 보기';

  @override
  String get showLess => '접기';

  @override
  String get qrzProfile => 'QRZ 프로필';

  @override
  String get addQsoTitle => 'QSO 추가';

  @override
  String get liveQso => '실시간 QSO';

  @override
  String get historicalQso => '과거 QSO';

  @override
  String get callsignField => '콜사인 *';

  @override
  String get lookupSearch => 'QRZ 검색';

  @override
  String get liveDateTimeLabel => '날짜/시간 (UTC) — 실시간';

  @override
  String get dateTimeLabel => '날짜/시간 (UTC)';

  @override
  String get bandField => '밴드 *';

  @override
  String get modeField => '모드 *';

  @override
  String get frequencyField => '주파수 (MHz)';

  @override
  String get rstSentField => '송신 RST *';

  @override
  String get rstRcvdField => '수신 RST *';

  @override
  String get nameField => '이름';

  @override
  String get qthField => 'QTH';

  @override
  String get gridField => '그리드 스퀘어';

  @override
  String get commentField => '코멘트';

  @override
  String get stationProfileField => '스테이션 프로필';

  @override
  String get saveQsoBtn => 'QSO 저장';

  @override
  String qsoSaved(String callsign) {
    return '✓  $callsign 저장됨';
  }

  @override
  String qsoSavedLocal(String callsign) {
    return '✓  $callsign 로컬에 저장됨';
  }

  @override
  String get noActiveStation => '활성 스테이션이 선택되지 않았습니다';

  @override
  String get lookupTitle => '콜사인 검색';

  @override
  String get lookupHint => '콜사인 입력...';

  @override
  String get lookupBtn => '검색';

  @override
  String get recentSearches => '최근 검색';

  @override
  String get clearHistory => '기록 지우기';

  @override
  String get makeQso => 'QSO 기록';

  @override
  String get notFound => '찾을 수 없습니다';

  @override
  String get stationsTitle => '스테이션';

  @override
  String stationActivated(String callsign) {
    return '$callsign을(를) 활성 스테이션으로 설정했습니다';
  }

  @override
  String get stationWebInfo => 'Wavelog 웹 인터페이스에서 스테이션을 추가하고 편집하세요.';

  @override
  String get noStations => '스테이션이 없습니다';

  @override
  String get noStationsHint => 'Wavelog 웹 인터페이스에서 스테이션을 추가하세요.';

  @override
  String get addStationOnWeb => 'Wavelog에서 스테이션 추가';

  @override
  String get adifTitle => 'ADIF 가져오기 / 내보내기';

  @override
  String get importTab => '가져오기';

  @override
  String get exportTab => '내보내기';

  @override
  String get selectAdifFile => 'ADIF 파일 선택';

  @override
  String get selectFileBtn => '파일 선택 (.adi / .adif)';

  @override
  String get stationRequired => '스테이션 프로필 *';

  @override
  String importing(int done, int total) {
    return '가져오는 중... $done/$total';
  }

  @override
  String get importBtn => '가져오기';

  @override
  String get fileReadError => '파일을 읽을 수 없습니다. 다시 시도해주세요';

  @override
  String get invalidFileExtension => '.adi 또는 .adif 파일을 선택해주세요';

  @override
  String get exportFilters => '내보내기 필터';

  @override
  String get stationFilter => '스테이션';

  @override
  String get allStations => '모든 스테이션';

  @override
  String get startDate => '시작';

  @override
  String get endDate => '종료';

  @override
  String get notSelected => '선택 안 함';

  @override
  String get clearDates => '날짜 초기화';

  @override
  String get exporting => '내보내는 중...';

  @override
  String get exportAndShare => '내보내고 공유';

  @override
  String get copyPath => '경로 복사';

  @override
  String get reshare => '다시 공유';

  @override
  String get pathCopied => '파일 경로가 복사되었습니다';

  @override
  String qsoExported(int count) {
    return '$count개의 QSO를 내보냈습니다';
  }

  @override
  String get noStationForExport => '내보낼 스테이션을 찾을 수 없습니다';

  @override
  String qsoImported(int imported, int total) {
    return '$imported / $total개의 QSO를 가져왔습니다';
  }

  @override
  String get selectSaveLocation => '저장 위치 선택';

  @override
  String get copySuffix => '(복사본)';

  @override
  String get errNetwork => '연결 없음 — 네트워크를 확인하세요';

  @override
  String get errTimeout => '연결 시간 초과';

  @override
  String get errUnauthorized => '잘못된 API 키';

  @override
  String get settingsTitle => '설정';

  @override
  String get connectionSection => '연결';

  @override
  String get sessionSection => '세션';

  @override
  String get loggedIn => '로그인됨';

  @override
  String get logoutBtn => '로그아웃';

  @override
  String get logoutTitle => '로그아웃';

  @override
  String get logoutConfirm => '정말 로그아웃하시겠습니까?';

  @override
  String get switchAccountBtn => '계정 전환';

  @override
  String get activeStationSection => '활성 스테이션';

  @override
  String get selectStationBtn => '스테이션 선택';

  @override
  String get addStationWeb => '웹에서 스테이션 추가';

  @override
  String get defaultsSection => '기본값';

  @override
  String get defaultBand => '기본 밴드';

  @override
  String get defaultMode => '기본 모드';

  @override
  String get appSection => '앱';

  @override
  String get darkTheme => '다크 테마';

  @override
  String get darkThemeHint => '야외 사용에 권장';

  @override
  String get offlineMode => '오프라인 모드';

  @override
  String get offlineModeHint => 'QSO를 로컬에 먼저 저장하고 나중에 동기화';

  @override
  String get allowInsecureSsl => '미검증 SSL 인증서 허용';

  @override
  String get allowInsecureSslHint =>
      '자체 서명 또는 사설 CA 인증서를 신뢰합니다(자체 호스팅 서버용). 공공 네트워크에서는 권장하지 않습니다.';

  @override
  String get languageLabel => '언어';

  @override
  String get infoSection => '정보';

  @override
  String get aboutAppBtn => '정보';

  @override
  String get aboutAppHint => '버전, 개발자, 라이선스';

  @override
  String get dataSection => '데이터';

  @override
  String get clearCacheBtn => 'QSO 캐시 지우기';

  @override
  String get clearCacheHint => '로컬 QSO 캐시를 삭제합니다';

  @override
  String get clearCacheTitle => '캐시 지우기';

  @override
  String get clearCacheConfirm => '로컬 QSO 캐시가 삭제됩니다. 되돌릴 수 없습니다.';

  @override
  String get clearCacheAction => '지우기';

  @override
  String get cacheCleared => '캐시가 지워졌습니다';

  @override
  String get langSystem => '시스템 기본값';

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
  String get langRussian => '러시아어';

  @override
  String get aboutTitle => '정보';

  @override
  String get appDescription => 'Wavelog용 오픈소스 Android 앱';

  @override
  String versionLabel(String version, String build) {
    return '버전 $version  (빌드 $build)';
  }

  @override
  String get mobileDeveloperSection => '모바일 앱 개발자';

  @override
  String get wavelogProjectSection => 'Wavelog 프로젝트';

  @override
  String get wavelogDescription => '웹 기반 아마추어 무선 로깅 시스템';

  @override
  String get coreDevelopers => '핵심 개발자';

  @override
  String get mitLicense => 'MIT 라이선스';

  @override
  String get mitDescription =>
      '이 앱과 Wavelog 프로젝트는 MIT 라이선스 하에 배포됩니다. 오픈소스, 무보증.';

  @override
  String get licenseSection => '라이선스';

  @override
  String get errorNoConnection => '연결 없음';

  @override
  String get errorUnauthorized => '인증 실패 — API 키를 확인하세요';

  @override
  String get errorServer => '서버 오류';

  @override
  String get patchRequiredTitle => '서버 패치 필요';

  @override
  String get patchRequiredMessage =>
      '편집 및 삭제 기능을 사용하려면 서버에 Wavelog Mobile API 패치가 설치되어 있어야 합니다.\n\n설치 안내는 sp9aqg.pl/install.html을 방문하세요.';

  @override
  String get patchRequiredBanner =>
      '편집 및 삭제 기능을 사용하려면 서버에 Wavelog Mobile API 패치가 설치되어 있어야 합니다.';

  @override
  String get patchViewGuide => '가이드 보기';

  @override
  String get setupGuideTitle => '설정 가이드';

  @override
  String get setupGuideIntro =>
      'QSO를 기록하기 전에 앱을 Wavelog 서버에 연결하세요. 아래 단계를 따르세요.';

  @override
  String get setupGuidePatchWarning =>
      '이 앱은 서버에 Wavelog Mobile 패치가 설치되어 있어야 합니다.';

  @override
  String get setupGuidePatchStepTitle => '서버 패치 설치';

  @override
  String get setupGuidePatchStepBody =>
      '앱은 Wavelog의 API v2를 사용하며 서버에 작은 패치가 필요합니다. 아직 설치하지 않았다면 설치 가이드를 열고 단계에 따르세요.';

  @override
  String get setupGuidePatchBtn => '설치 가이드';

  @override
  String get setupGuideStep1Title => '1. 서버 주소';

  @override
  String get setupGuideStep1Body =>
      '브라우저에서 Wavelog를 열 때 사용하는 주소를 입력하세요. 예: https://yourdomain.com — 끝에 슬래시 없이.';

  @override
  String get setupGuideStep2Title => '2. API v2 토큰';

  @override
  String get setupGuideStep2Body =>
      'Wavelog에서 설정 → API → API 토큰 (v2) → 새 토큰으로 이동합니다. \"Wavelog Mobile\" 프리셋을 선택하고 확인합니다. 생성된 토큰(wl2_로 시작)을 복사하여 앱에 붙여넣으세요.';

  @override
  String get setupGuideStep3Title => '3. 콜사인 및 표시 이름';

  @override
  String get setupGuideStep3Body =>
      '콜사인: 내 아마추어 무선 콜사인. 표시 이름: 기기에서 이 로그인을 식별하는 이름.';

  @override
  String get setupGuideContinueBtn => '설정 시작';

  @override
  String get migrationTokenHint => 'wl2_…';

  @override
  String get migrationTokenLabel => 'API v2 토큰';

  @override
  String get migrationValidateBtn => '검증 후 계속';

  @override
  String get migrationValidating => '검증 중…';

  @override
  String get migrationTokenEmpty => 'wl2_ 토큰을 붙여넣으세요.';

  @override
  String get migrationTokenInvalid => '토큰이 잘못되었습니다 — 확인 후 다시 시도하세요.';

  @override
  String get patchNotInstalledTitle => '패치가 감지되지 않습니다';

  @override
  String get patchNotInstalledBody =>
      '서버에 Wavelog Mobile 패치가 설치되어 있지 않은 것 같습니다.\n\n패치 없이는 API v2 토큰 (wl2_…)이 작동하지 않습니다. 먼저 1단계를 완료하세요.';

  @override
  String get patchInstallFirst => '패치 설치';

  @override
  String get appSubtitle => '아마추어 무선 로그 앱';

  @override
  String get switchToLightTheme => '라이트 테마로 전환';

  @override
  String get switchToDarkTheme => '다크 테마로 전환';

  @override
  String get deleteQsoTitle => 'QSO 삭제';

  @override
  String deleteQsoConfirm(String callsign, String date) {
    return '$date에 $callsign과의 QSO를 영구적으로 삭제하시겠습니까?';
  }

  @override
  String get editTooltip => '편집';

  @override
  String get shareAdifTooltip => 'ADIF 공유';

  @override
  String get localNotSynced => '로컬 레코드 — 아직 동기화되지 않음';

  @override
  String get satellite => '위성';

  @override
  String get satelliteMode => '위성 모드';

  @override
  String get antenna => '안테나';

  @override
  String get nameLabel => '이름';

  @override
  String get stateProvince => '주/도';

  @override
  String get county => '군/구';

  @override
  String get city => '시/군';

  @override
  String get continentAF => '아프리카';

  @override
  String get continentAN => '남극';

  @override
  String get continentAS => '아시아';

  @override
  String get continentEU => '유럽';

  @override
  String get continentNA => '북미';

  @override
  String get continentOC => '오세아니아';

  @override
  String get continentSA => '남미';

  @override
  String get qrzProfileLoading => 'QRZ 프로필 불러오는 중...';

  @override
  String viewOnQrz(String callsign) {
    return 'QRZ.com에서 보기 ($callsign)';
  }

  @override
  String get qslMethods => 'QSL 방법';

  @override
  String get bureau => '뷰로';

  @override
  String qslManagerPrefix(String manager) {
    return '매니저: $manager';
  }

  @override
  String get callsignCopied => '콜사인이 복사되었습니다';

  @override
  String get uploadedStatus => '업로드됨';

  @override
  String get notUploadedStatus => '업로드 안 됨';

  @override
  String get matchedStatus => '매칭됨';

  @override
  String get toDeleteStatus => '삭제 예정';

  @override
  String get yes => '예';

  @override
  String get requested => '요청됨';

  @override
  String get no => '아니오';

  @override
  String get invalid => '잘못됨';

  @override
  String get viaDirect => '다이렉트';

  @override
  String get viaElectronic => '전자';

  @override
  String get viaMail => '우편';

  @override
  String otherAdifFields(int count) {
    return '기타 ADIF 필드 ($count)';
  }

  @override
  String get editQsoTitle => 'QSO 편집';

  @override
  String get qsoUpdated => 'QSO가 업데이트되었습니다';

  @override
  String get qsoUpdatedLocal => 'QSO가 로컬에서 업데이트되었습니다';

  @override
  String get counterStationHint => '콜사인을 입력하면\nQRZ 정보와 이전 QSO가\n여기에 표시됩니다.';

  @override
  String previousQsosCount(int count) {
    return '이전 QSO ($count)';
  }

  @override
  String morePreviousQsos(int count) {
    return '+$count개 더...';
  }

  @override
  String previousQsosWithCallsign(String callsign) {
    return '$callsign과의 이전 QSO';
  }

  @override
  String totalQsos(int count) {
    return '총 $count개';
  }

  @override
  String get workedBefore => '이전에 교신함';

  @override
  String get lastQsoLabel => '마지막 QSO';

  @override
  String get themeLabel => '테마';

  @override
  String get darkThemeActive => '다크 테마 사용 중';

  @override
  String get lightThemeActive => '라이트 테마 사용 중';

  @override
  String get lightThemeLabel => '라이트';

  @override
  String get darkThemeLabel => '다크';

  @override
  String get commentNotes => '코멘트 / 메모';

  @override
  String get commentLabel => '코멘트';

  @override
  String get exchangeReceived => '수신 익스체인지';

  @override
  String get exchangeSent => '송신 익스체인지';

  @override
  String get contestIdLabel => '콘테스트';

  @override
  String get sigLabel => 'SIG';

  @override
  String get stationSetup => '스테이션 설정';

  @override
  String get logbooks => '로그북';

  @override
  String get locations => '위치';

  @override
  String get newLogbook => '새 로그북';

  @override
  String get logbookName => '로그북 이름';

  @override
  String get renameLogbook => '이름 변경';

  @override
  String get deleteLogbook => '로그북 삭제';

  @override
  String get setActiveLogbook => '활성으로 설정';

  @override
  String get activeLogbook => '활성 로그북';

  @override
  String get editStation => '편집';

  @override
  String get cloneStation => '복제';

  @override
  String get deleteStation => '삭제';

  @override
  String get deleteStationConfirm => '스테이션 삭제';

  @override
  String get deleteStationWarning => '이 스테이션의 모든 QSO가 영구적으로 삭제됩니다. 계속하시겠습니까?';

  @override
  String get stationDeleted => '스테이션이 삭제되었습니다';

  @override
  String get stationUpdated => '스테이션이 업데이트되었습니다';

  @override
  String get stationCloned => '스테이션이 복제되었습니다';

  @override
  String get linkLocation => '위치 연결';

  @override
  String get unlinkLocation => '연결 해제';

  @override
  String get linkedLocations => '연결된 위치';

  @override
  String get newStationName => '새 스테이션 이름';

  @override
  String get deleteLogbookConfirm => '로그북 삭제';

  @override
  String get deleteLogbookWarning => '이 로그북이 삭제됩니다. 연결된 위치는 유지됩니다. 계속하시겠습니까?';

  @override
  String get logbookDeleted => '로그북이 삭제되었습니다';

  @override
  String get hrdlogCode => 'HRDLog 코드';

  @override
  String get webAdifApiKey => 'WebADIF API 키';

  @override
  String get webAdifApiUrl => 'WebADIF API URL';

  @override
  String get basicInfo => '기본 정보';

  @override
  String get locationSectionTitle => '위치';

  @override
  String get awardReferences => '어워드 참조';

  @override
  String get integrationsSectionTitle => '연동';

  @override
  String get stationSettingsSection => '스테이션 설정';

  @override
  String get editStationTitle => '스테이션 편집';

  @override
  String get newStationTitle => '새 스테이션';

  @override
  String get saveChangesBtn => '변경 저장';

  @override
  String get createStationBtn => '스테이션 만들기';

  @override
  String get stationCreated => '스테이션이 생성되었습니다';

  @override
  String get stationCreateFailed => '실패했습니다. 해당 이름의 프로필이 이미 존재할 수 있습니다.';

  @override
  String get stationProfileNameLabel => '스테이션 프로필 이름 *';

  @override
  String get stationProfileNameHint => '홈 스테이션';

  @override
  String get cityQth => '시/군 / QTH';

  @override
  String get powerWatts => '출력 (W)';

  @override
  String get dxccCountry => 'DXCC / 국가';

  @override
  String get selectLabel => '선택...';

  @override
  String get dxccSearch => 'DXCC / 국가 검색';

  @override
  String get deletedDxcc => '삭제된 DXCC';

  @override
  String get eqslQthNicknameLabel => 'eQSL QTH 닉네임';

  @override
  String get eqslDefaultMsgLabel => 'eQSL 기본 메시지';

  @override
  String get pending => '대기 중';

  @override
  String get uploadDisabled => '비활성화';

  @override
  String get uploadEnabled => '활성화';

  @override
  String get uploadRealtime => '실시간';

  @override
  String get qrzApiKeyLabel => 'QRZ.com 로그북 API 키';

  @override
  String get qrzUploadLabel => 'QRZ.com 업로드';

  @override
  String get clublogIgnoreTitle => 'Clublog 무시';

  @override
  String get clublogIgnoreSubtitle => '이 스테이션을 Clublog 업로드에서 제외';

  @override
  String get clublogRealtimeTitle => 'Clublog 실시간';

  @override
  String get clublogRealtimeSubtitle => 'QSO를 실시간으로 Clublog에 업로드';

  @override
  String get hrdlogUsernameLabel => 'HRDLog.net 사용자명';

  @override
  String get hrdlogApiKeyLabel => 'HRDLog.net API 키';

  @override
  String get hrdlogUploadLabel => 'HRDLog.net 업로드';

  @override
  String get qo100ApiKeyLabel => 'QO-100 DX Club API 키';

  @override
  String get qo100RealtimeTitle => 'QO-100 DX Club 실시간';

  @override
  String get qo100RealtimeSubtitle => 'QSO를 실시간으로 QO-100 DX Club에 업로드';

  @override
  String get oqrsSectionTitle => 'OQRS (온라인 QSL)';

  @override
  String get oqrsEnabledTitle => 'OQRS 활성화';

  @override
  String get oqrsEnabledSubtitle => '온라인 QSL 요청 시스템 활성화';

  @override
  String get oqrsTextLabel => 'OQRS 설명 텍스트';

  @override
  String get oqrsEmailLabel => 'OQRS 이메일';

  @override
  String get setAsActiveStationTitle => '활성 스테이션으로 설정';

  @override
  String get setAsActiveStationSubtitle => 'Wavelog에서 이 스테이션을 활성으로 표시';

  @override
  String get linkToActiveLogbookTitle => '활성 로그북에 연결';

  @override
  String get linkToActiveLogbookSubtitle => '생성 시 활성 로그북에 자동으로 연결';

  @override
  String get active => '활성';

  @override
  String get loadDetailsFailed => '상세 정보를 불러오지 못했습니다';

  @override
  String get cannotDeleteActiveStation => '활성 스테이션은 삭제할 수 없습니다.';

  @override
  String get navStats => '통계';

  @override
  String get statisticsTitle => '통계';

  @override
  String get uniqueCallsigns => '고유 콜사인';

  @override
  String get currentStreak => '현재 연속';

  @override
  String streakDays(int count) {
    return '$count일';
  }

  @override
  String get bandDistribution => '밴드 분포';

  @override
  String get modeDistribution => '모드 분포';

  @override
  String get perStation => '스테이션별';

  @override
  String get basedOnCache => '밴드 / 모드 / 스테이션 통계는 캐시된 QSO를 기반으로 합니다.';

  @override
  String get statsTab => '통계';

  @override
  String get propagationTab => '전파';

  @override
  String get bandConditions => '밴드 상태';

  @override
  String get dayTime => '낮';

  @override
  String get nightTime => '밤';

  @override
  String get conditionGood => '좋음';

  @override
  String get conditionFair => '보통';

  @override
  String get conditionPoor => '나쁨';

  @override
  String lastUpdated(String time) {
    return '업데이트: $time';
  }

  @override
  String get noSolarData => '태양 데이터를 불러올 수 없습니다';

  @override
  String get potaStats => 'POTA 통계';

  @override
  String get potaTotalQsos => 'POTA QSO';

  @override
  String get potaActivatedParks => '활성화된 공원';

  @override
  String get potaAllParks => '모든 공원';

  @override
  String get potaActivatedBadge => '활성화됨';

  @override
  String get potaAttemptBadge => '시도';

  @override
  String get potaNoStation => 'POTA 스테이션 프로필이 설정되지 않았습니다';

  @override
  String get potaNoQsos => '캐시에 POTA QSO가 없습니다';

  @override
  String get navSpot => '스팟';

  @override
  String get spotTitle => '스팟';

  @override
  String get spotAdd => '스팟 추가';

  @override
  String get spotSend => '스팟 전송';

  @override
  String get spotSent => '스팟 전송됨!';

  @override
  String get spotNoResults => '스팟을 찾을 수 없습니다';

  @override
  String get spotLoadError => '스팟을 불러올 수 없습니다';

  @override
  String get spotActivator => '운용국 콜사인';

  @override
  String get spotSpotter => '스포터 콜사인';

  @override
  String get spotFrequency => '주파수 (kHz)';

  @override
  String get spotReference => '공원 참조';

  @override
  String get spotComments => '코멘트';

  @override
  String get spotCommentsHint => 'QRZ, CQ POTA...';

  @override
  String get spotInvalidRef => '잘못된 형식 (예: PL-0001)';

  @override
  String get sortNewest => '최신순';

  @override
  String get sortOldest => '오래된순';

  @override
  String get filterBand => '밴드';

  @override
  String get filterMode => '모드';

  @override
  String get filterCountry => '국가';

  @override
  String get filterAssociation => '협회';

  @override
  String get spotAddComingSoon => '스팟 추가 — 곧 출시';

  @override
  String get filterClear => '필터 초기화';

  @override
  String get mode => '모드';

  @override
  String get required => '필수';

  @override
  String get invalidNumber => '잘못된 숫자';

  @override
  String get potaAutoSpot => '자동 스팟';

  @override
  String get potaAutoSpotHint =>
      'POTA 또는 SOTA 스테이션에서 QSO를 기록할 때 자동으로 셀프 스팟 (각 30분 쿨다운)';

  @override
  String autoSpotSent(String ref) {
    return '자동 스팟 전송됨: $ref';
  }

  @override
  String get autoSpotWillFire => 'QSO가 스팟을 트리거합니다';

  @override
  String autoSpotCooldown(int min) {
    return '스팟 전송됨 · $min분 후 다음';
  }

  @override
  String get autoSpotCooldownSoon => '스팟 전송됨 · 다음 스팟 곧';

  @override
  String autoSpotKeyChanged(String fields) {
    return '$fields 변경됨 · 새 스팟이 전송됩니다';
  }

  @override
  String get autoSpotFieldFreq => '주파수';

  @override
  String get autoSpotFieldMode => '모드';

  @override
  String get autoSpotFieldRef => '공원';

  @override
  String get logbookSummaryTitle => '최근 QSO';

  @override
  String todayQsoCount(int count) {
    return '오늘: $count QSO';
  }

  @override
  String get colDateTime => '날짜/시간';

  @override
  String get colRstSent => 'RST(S)';

  @override
  String get colRstRcvd => 'RST(R)';

  @override
  String get submodeLabel => '서브모드';

  @override
  String selectedCount(int count) {
    return '$count개 선택됨';
  }

  @override
  String get selectAll => '모두 선택';

  @override
  String get exportSelected => '내보내기';

  @override
  String get deleteSelected => '삭제';

  @override
  String deleteSelectedConfirm(int count) {
    return '$count개의 QSO를 삭제하시겠습니까?';
  }

  @override
  String get mapTitle => '지도';

  @override
  String get mapNoData => '그리드 스퀘어가 있는 QSO를 찾을 수 없습니다';

  @override
  String mapStationCount(int count) {
    return '$count개 스테이션';
  }

  @override
  String get dxccProgress => 'DXCC 진행률';

  @override
  String get workedCountries => '교신 국가';

  @override
  String get dxccWorked => '교신됨';

  @override
  String dxccUniqueEntities(int count) {
    return '$count개 고유 엔티티';
  }

  @override
  String get dxccConfirmed => '확인됨 (LoTW / eQSL / QSL)';

  @override
  String get dxccRemaining => '남은';

  @override
  String get dxccLegendConfirmed => '확인됨';

  @override
  String get dxccLegendPending => '대기 중';

  @override
  String get dxccLegendNotWorked => '미교신';

  @override
  String get spotSummitNotFound => '정상을 찾을 수 없습니다';

  @override
  String get spotParkNotFound => '공원을 찾을 수 없습니다';

  @override
  String get qsoTypeTitle => 'QSO 기록';

  @override
  String get normalQso => '일반 QSO';

  @override
  String get normalQsoDesc => '표준 교신 입력';

  @override
  String get contestQso => '콘테스트 QSO';

  @override
  String get contestQsoDesc => '익스체인지가 포함된 빠른 콘테스트 기록';

  @override
  String get contestLog => '콘테스트 로그';

  @override
  String get contestSetup => '콘테스트 설정';

  @override
  String get contestNameHint => '예: CQ-WW-CW';

  @override
  String get ourExchange => '자국 익스체인지';

  @override
  String get serialStart => '시작 일련번호';

  @override
  String get showExchangeFields => '익스체인지 필드';

  @override
  String get startContest => '기록 시작';

  @override
  String get endContest => '세션 종료';

  @override
  String get endContestConfirm => '콘테스트 세션을 종료하시겠습니까? (일련번호 카운터와 설정이 초기화됩니다.)';

  @override
  String get serialSentLabel => '송신 #';

  @override
  String get serialRcvdLabel => '수신 #';

  @override
  String get exchangeSentLabel => '송신 Exch';

  @override
  String get exchangeRcvdLabel => '수신 Exch';

  @override
  String get gridSentLabel => '그리드 S';

  @override
  String get gridRcvdLabel => '그리드 R';

  @override
  String get logQso => 'QSO 기록';

  @override
  String get qsoLogged => 'QSO가 기록되었습니다';

  @override
  String get contestRecentQsos => '최근';

  @override
  String get contestSessions => '콘테스트 세션';

  @override
  String get newSession => '새 세션';

  @override
  String get noContestSessions => '콘테스트 세션이 없습니다';

  @override
  String get noContestSessionsHint => '웹에서 세션을 만들거나 +를 눌러 시작하세요.';

  @override
  String get contestSessionActive => '활성';

  @override
  String get contestSessionEnded => '종료됨';

  @override
  String qsoCount(int count) {
    return '$count QSO';
  }

  @override
  String contestSessionDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get createContestSession => '콘테스트 세션 만들기';

  @override
  String get sessionName => '세션 이름 (선택)';

  @override
  String get sessionNameHint => '예: 홈 스테이션 — CW';

  @override
  String get selectContest => '콘테스트 선택 *';

  @override
  String get searchContest => '콘테스트 검색...';

  @override
  String get serverContests => '서버에서';

  @override
  String get builtinContests => '주요 콘테스트';

  @override
  String get startDateTime => '시작 날짜/시간 *';

  @override
  String get endDateTime => '종료 날짜/시간 *';

  @override
  String get durationShortcut4h => '+4h';

  @override
  String get durationShortcut12h => '+12h';

  @override
  String get durationShortcut24h => '+24h';

  @override
  String get durationShortcut48h => '+48h';

  @override
  String get exchangeType => '익스체인지 유형';

  @override
  String get exchangeTypeSerial => '일련번호';

  @override
  String get exchangeTypeExchange => '텍스트 익스체인지';

  @override
  String get exchangeTypeBoth => '일련번호 + 텍스트 익스체인지';

  @override
  String get createSession => '세션 만들기';

  @override
  String get sessionCreated => '콘테스트 세션이 생성되었습니다';

  @override
  String get sessionUpdated => '콘테스트 세션이 업데이트되었습니다';

  @override
  String get editContestSession => '콘테스트 세션 편집';

  @override
  String get saveChanges => '변경 저장';

  @override
  String get deleteSession => '세션 삭제';

  @override
  String get deleteSessionConfirm =>
      '이 콘테스트 세션을 삭제하시겠습니까? 이 세션에서 기록한 QSO는 로그북에 남습니다.';

  @override
  String get openSession => '기록을 위해 열기';

  @override
  String get patchRequiredContest =>
      '콘테스트 세션 관리에는 업데이트된 Wavelog Mobile 패치가 필요합니다.';

  @override
  String get contestCalendarTitle => '콘테스트 캘린더';

  @override
  String get contestCalendarNoContests => '콘테스트를 찾을 수 없습니다.';

  @override
  String get contestCalendarToday => '오늘';

  @override
  String get contestCalendarThisWeek => '이번 주';

  @override
  String get contestCalendarUpcoming => '예정';

  @override
  String get contestCalendarRecentlyPast => '최근 종료';

  @override
  String get contestCalendarLoadError => '콘테스트 캘린더를 불러올 수 없습니다';

  @override
  String get contestCalendarRefresh => '새로고침';

  @override
  String get contestCalendarRetry => '재시도';

  @override
  String get upcomingContestsTitle => '예정 콘테스트';

  @override
  String get viewAll => '모두 보기';

  @override
  String get noUpcomingContests => '예정된 콘테스트가 없습니다.';

  @override
  String get contestTodayBadge => '오늘';

  @override
  String get navStyleLabel => '내비게이션 스타일';

  @override
  String get navStyleModern => '모던 — FAB + 드로어';

  @override
  String get navStyleClassic => '클래식 — 6탭 바';

  @override
  String get drawerMap => '지도';

  @override
  String get drawerContestCalendar => '콘테스트 캘린더';

  @override
  String get drawerContestSessions => '콘테스트 세션';

  @override
  String get drawerAdif => 'ADIF';

  @override
  String get drawerMenu => '메뉴';

  @override
  String get antennaCompassTitle => '안테나 방향';

  @override
  String get targetGrid => '목표 그리드 스퀘어';

  @override
  String get calculate => '계산';

  @override
  String get shortPath => '단거리 경로';

  @override
  String get longPath => '장거리 경로';

  @override
  String get azimuth => '방위각';

  @override
  String get myHeading => '방향';

  @override
  String get invalidGrid => '잘못된 그리드 스퀘어';

  @override
  String get gpsLocating => 'GPS 측위 중… 잠시 기다려주세요';

  @override
  String get gpsUnavailable => 'GPS 위치를 사용할 수 없습니다';

  @override
  String get drawerAntenna => '안테나 방향';

  @override
  String get achievementsTitle => '업적';

  @override
  String get achievementsEmpty => '첫 번째 QSO를 기록하여 배지를 획득하세요!';

  @override
  String get shareAchievement => '공유';

  @override
  String get achievementUnlocked => '업적 달성!';

  @override
  String progressLabel(int done, int target) {
    return '$done / $target';
  }

  @override
  String get drawerAchievements => '업적';

  @override
  String get drawerCommunity => '커뮤니티';

  @override
  String get communityTitle => '커뮤니티';

  @override
  String get communityNoActivations => '예정된 활성화가 없습니다';

  @override
  String get communityBeFirst => '첫 번째로 발표해보세요!';

  @override
  String get communityAnnounce => '활성화 발표';

  @override
  String get communityFollow => '팔로우';

  @override
  String get communityUnfollow => '팔로우 취소';

  @override
  String communityFollowers(int count) {
    return '$count명 팔로워';
  }

  @override
  String get communityTypeGeneral => '일반';

  @override
  String get communityCallsign => '콜사인';

  @override
  String get communityReference => '참조번호';

  @override
  String get communitySotaRef => 'SOTA 참조 (TA/AN-001)';

  @override
  String get communityPotaRef => 'POTA 참조 (TA-0001)';

  @override
  String get communityScheduledTime => '예정 시간';

  @override
  String get communityNote => '메모 (선택사항)';

  @override
  String get communityNoteHint => '활성화에 대한 간단한 정보...';

  @override
  String get communityAnnounceButton => '발표';

  @override
  String get communityAnnounced => '활성화가 발표되었습니다!';

  @override
  String get communityRateLimit => '방금 발표하셨습니다. 몇 분 기다려 주세요.';

  @override
  String get communityCallsignRequired => '콜사인이 필요합니다';

  @override
  String get communityReferenceRequired => '참조번호가 필요합니다';

  @override
  String get communityBandRequired => '최소 하나의 밴드를 선택하세요';

  @override
  String get communityActivations => '활성화';

  @override
  String get communityChat => '채팅';

  @override
  String get communityEditActivation => '활성화 편집';

  @override
  String get communityDeleteActivation => '활성화 삭제';

  @override
  String get communityDeleteActivationConfirm =>
      '이 활성화를 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get communityUpdated => '활성화가 업데이트되었습니다';

  @override
  String get chatRooms => '채팅방';

  @override
  String get chatGeneral => '일반';

  @override
  String get chatGeneralSubtitle => '공용 언어: 영어';

  @override
  String get chatMessageHint => '메시지를 입력하세요…';

  @override
  String get chatSend => '보내기';

  @override
  String get chatEdit => '편집';

  @override
  String get chatDelete => '삭제';

  @override
  String get chatDeleteConfirm => '이 메시지를 삭제하시겠습니까?';

  @override
  String get chatEdited => '수정됨';

  @override
  String get chatNoStation => '채팅하려면 활성 스테이션을 설정하세요';

  @override
  String get gifPreparing => '동영상 준비 중...';

  @override
  String gifCapturing(int percent) {
    return '프레임 캡처 중... $percent%';
  }

  @override
  String get gifEncoding => '동영상 인코딩 중...';

  @override
  String get comingSoon => '곧 출시';

  @override
  String get noCompassSensor => '나침반 센서 없음';

  @override
  String get fillFromGps => 'GPS에서 채우기';

  @override
  String get locationPermissionDenied => '위치 권한이 거부되었습니다';

  @override
  String gpsError(String error) {
    return 'GPS 오류: $error';
  }

  @override
  String get errParse => '서버 응답 파싱에 실패했습니다';

  @override
  String get errLocalStorage => '로컬 저장소 오류';

  @override
  String get errServer => '서버 오류';

  @override
  String get wpxPrefix => 'WPX 접두사';

  @override
  String get nowBtn => '지금';

  @override
  String get contestOtherCustom => '기타 / 사용자 정의';

  @override
  String get sigInfo => 'SIG 정보';

  @override
  String get migrationTitle => 'API v2가 필요합니다';

  @override
  String get migrationBody =>
      'Wavelog Mobile은 이제 Wavelog의 새로운 API 시스템을 사용합니다. 이전 API 키는 더 이상 유효하지 않습니다 — 아래 단계에 따라 몇 분 안에 마이그레이션하세요.';

  @override
  String get migrationStep1Title => '서버 패치 설치';

  @override
  String get migrationStep1Body =>
      'Wavelog 서버에 작은 업데이트 파일을 설치해야 합니다. 아래 설치 가이드 버튼을 눌러 단계별 안내를 따르세요.';

  @override
  String get migrationInstallGuideBtn => '설치 가이드';

  @override
  String get migrationStep2Title => '새 API 토큰 만들기';

  @override
  String get migrationStep2Body =>
      'Wavelog 웹 인터페이스에서:\n  1. 오른쪽 상단의 설정 메뉴 열기\n  2. \"API\" → \"API 토큰\" 이동\n  3. \"새 토큰\" 클릭\n  4. \"Wavelog Mobile\" 프리셋 선택\n  5. 확인 후 표시된 코드 복사\n  (토큰은 \"wl2_\"로 시작)';

  @override
  String get migrationStep3Title => '프로필 업데이트';

  @override
  String get migrationStep3Body =>
      '아래 버튼을 누르세요. 서버 주소는 유지됩니다 — 새 토큰을 필드에 붙여넣기만 하면 됩니다.';

  @override
  String get migrationUpdateTokenBtn => '토큰 업데이트';

  @override
  String get migrationHelpBtn => '도움말 & 설치 가이드';

  @override
  String get celebTitle => 'Wavelog v3.2.0';

  @override
  String get celebSubtitle => '서버 패치가 더 이상 필요하지 않습니다!';

  @override
  String get celebBody =>
      '이제 모든 기능이 Wavelog의 공식 API v2를 통해 직접 작동합니다. 서버에 업로드한 이전 패치를 제거할 수 있습니다.\n\n이 앱은 이제 Wavelog v3.2.0 이상이 필요합니다.';

  @override
  String get celebCreateToken => 'API 토큰 만들기';

  @override
  String get celebSkip => '건너뛰기';

  @override
  String get celebScopesTitle => 'API v2 토큰 스코프';

  @override
  String get celebScopesBody =>
      'Wavelog의 프로필 → API 토큰 → 새 토큰에서 새 토큰을 만들 때 다음 스코프를 선택하세요:';

  @override
  String get celebDone => '알겠습니다';

  @override
  String get scopeQsoRead => 'QSO 레코드 읽기';

  @override
  String get scopeQsoWrite => 'QSO 추가 / 업데이트';

  @override
  String get scopeQsoDelete => 'QSO 삭제';

  @override
  String get scopeStationRead => '스테이션 프로필 읽기';

  @override
  String get scopeStationWrite => '스테이션 만들기 / 업데이트';

  @override
  String get scopeStationDelete => '스테이션 삭제';

  @override
  String get scopeLogbookRead => '로그북 읽기';

  @override
  String get scopeLogbookWrite => '로그북 만들기 / 업데이트';

  @override
  String get scopeLogbookDelete => '로그북 삭제';

  @override
  String get scopeContestRead => '콘테스트 세션 읽기';

  @override
  String get scopeContestWrite => '콘테스트 세션 만들기 / 업데이트';

  @override
  String get scopeContestDelete => '콘테스트 세션 삭제';

  @override
  String get scopeCatalogRead => 'DXCC, 지역 구분 및 콘테스트 목록';

  @override
  String get scopeLookupRead => '콜사인 검색';

  @override
  String get scopeStatisticsRead => '통계 읽기';

  @override
  String get scopeConfirmationRead => 'LoTW / eQSL / QRZ.com 확인 읽기';

  @override
  String get scopeTestStation => '스테이션';

  @override
  String get scopeTestLogbook => '로그북';

  @override
  String get scopeTestQso => 'QSO';

  @override
  String get scopeTestContest => '콘테스트';

  @override
  String get scopeTestConfirmation => '확인';

  @override
  String get scopeTestStatistics => '통계';

  @override
  String get scopeTestLookup => '조회';

  @override
  String get apiScopeGuideBtn => 'API 스코프 가이드';

  @override
  String get apiScopeGuideTitle => 'API 토큰 스코프 가이드';

  @override
  String get apiScopeGuideIntro =>
      'Wavelog에서 새 API 토큰을 생성할 때(설정 → API 토큰) 앱의 전체 기능을 활성화하려면 아래의 모든 스코프를 선택하세요.';

  @override
  String get apiTokenNoticeTitle => '새 API 토큰 생성';

  @override
  String get apiTokenNoticeBody =>
      'Wavelog v2 API는 특정 스코프가 있는 새 토큰이 필요합니다. Wavelog → 설정 → API 토큰으로 이동하여 필요한 모든 스코프로 새 토큰을 만드세요. 전체 목록은 아래 API 스코프 가이드 버튼을 탭하세요.';

  @override
  String get apiTokenNoticeDontShow => '다시 표시 안 함';

  @override
  String get apiTokenNoticeIgnore => '무시';

  @override
  String get apiTokenNoticeScopeGuide => 'API 스코프 가이드';
}
