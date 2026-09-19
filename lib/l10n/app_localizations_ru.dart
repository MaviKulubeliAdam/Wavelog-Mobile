// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Wavelog Mobile';

  @override
  String get splashConnecting => 'ПОДКЛЮЧЕНИЕ';

  @override
  String get navHome => 'Главная';

  @override
  String get navLogbook => 'Журнал';

  @override
  String get navLookup => 'Поиск';

  @override
  String get navStation => 'Профиль QTH';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get refresh => 'Обновить';

  @override
  String get continueBtn => 'Продолжить';

  @override
  String get close => 'Закрыть';

  @override
  String get retry => 'Повторить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get success => 'Успешно';

  @override
  String get change => 'Изменить';

  @override
  String get goWeb => 'Перейти →';

  @override
  String get editOnWeb => 'Редактировать на сайте';

  @override
  String get openInBrowser => 'Открыть в браузере';

  @override
  String get serverSetupTitle => 'Настройка сервера';

  @override
  String get serverSetupSubtitle => 'Настройте ваш сервер Wavelog';

  @override
  String get serverUrlLabel => 'URL сервера Wavelog';

  @override
  String get serverUrlHint => 'https://log.example.com';

  @override
  String get testConnection => 'Проверка соединения';

  @override
  String get testingConnection => 'Проверка...';

  @override
  String get sslIssueTitle => 'Проблема с SSL-сертификатом';

  @override
  String get sslIssueBody =>
      'Не удалось проверить SSL-сертификат этого сервера — возможно, он самоподписанный или просроченный. Продолжить без проверки? (Рекомендуется только для доверенных серверов.)';

  @override
  String get sslIssueAllow => 'Продолжить без проверки';

  @override
  String get scopeTestSectionTitle => 'Проверка областей доступа';

  @override
  String get scopeTestRunning => 'Проверка областей доступа…';

  @override
  String get scopeTestAllPassed =>
      'Все необходимые области доступа присутствуют';

  @override
  String get scopeTestSomeFailed => 'Некоторых областей доступа не хватает';

  @override
  String get scopeTestAddHint =>
      'Добавьте эту область доступа при создании токена API';

  @override
  String get connectionSuccess => 'Соединение установлено!';

  @override
  String get connectionFailed => 'Ошибка соединения';

  @override
  String get apiKeyCopied => 'Ключ API скопирован';

  @override
  String get loginTitle => 'Вход';

  @override
  String get serverBtn => 'Сервер';

  @override
  String get addAccountBtn => 'Добавить аккаунт';

  @override
  String get signInBtn => 'Войти';

  @override
  String get deleteProfile => 'Удалить';

  @override
  String get deleteProfileTitle => 'Удалить аккаунт';

  @override
  String deleteProfileConfirm(String name) {
    return 'Удалить $name с этого устройства?';
  }

  @override
  String get displayName => 'Отображаемое имя';

  @override
  String get callsign => 'Позывной';

  @override
  String get apiKeyLabel => 'Ключ API';

  @override
  String get validating => 'Проверка...';

  @override
  String get profileSaved => 'Аккаунт сохранён';

  @override
  String get loginFailed => 'Ошибка входа';

  @override
  String get noStationFound => 'Станция не найдена — используется позывной';

  @override
  String get homeTitle => 'Главная';

  @override
  String get addQso => 'Добавить QSO';

  @override
  String get recentQsos => 'Последние QSO';

  @override
  String get statsToday => 'Сегодня';

  @override
  String get statsMonth => 'Месяц';

  @override
  String get statsYear => 'Год';

  @override
  String get statsTotal => 'Всего';

  @override
  String get noRecentQsos => 'QSO нет';

  @override
  String get syncNow => 'Синхронизировать';

  @override
  String pendingSync(int count) {
    return '$count QSO ожидают синхронизации';
  }

  @override
  String get offlineBanner => 'Нет сети — QSO сохранены локально';

  @override
  String get activeStation => 'Активный профиль QTH';

  @override
  String get logbookTitle => 'Журнал';

  @override
  String get filterAll => 'Все';

  @override
  String get filterAllModes => 'Все виды модуляции';

  @override
  String get searchHint => 'Поиск позывного...';

  @override
  String get noQsos => 'QSO не найдены';

  @override
  String get qsoDetailTitle => 'Детали QSO';

  @override
  String get qsoNotFound => 'QSO не найдено';

  @override
  String get signal => 'Сигнал';

  @override
  String get rstSent => 'RST (TX)';

  @override
  String get rstReceived => 'RST (RX)';

  @override
  String get txPower => 'Мощность ТХ';

  @override
  String get counterStation => 'Корреспондент';

  @override
  String get country => 'Страна';

  @override
  String get continent => 'Континент';

  @override
  String get dxcc => 'DXCC';

  @override
  String get cqZone => 'Зона CQ';

  @override
  String get ituZone => 'Зона ITU';

  @override
  String get gridSquare => 'Квадрат QTH-локатора';

  @override
  String get propMode => 'Распространение';

  @override
  String get distance => 'Расстояние';

  @override
  String get qslStatus => 'Статус QSL';

  @override
  String get paperQsl => 'QSL-карточка';

  @override
  String get lotwQsl => 'LoTW';

  @override
  String get eqslQsl => 'eQSL';

  @override
  String get qrzQsl => 'QRZ.com';

  @override
  String get clublog => 'Clublog';

  @override
  String get hrdlog => 'HRDLog';

  @override
  String get qslSent => 'TX';

  @override
  String get qslRcvd => 'RX';

  @override
  String get qslReceived => 'Получено';

  @override
  String get qslMethod => 'Способ';

  @override
  String get awards => 'Референции';

  @override
  String get iota => 'IOTA';

  @override
  String get sota => 'SOTA';

  @override
  String get wwff => 'WWFF';

  @override
  String get pota => 'POTA';

  @override
  String get myStation => 'Моя профиль QTH';

  @override
  String get myCallsign => 'Мой позывной';

  @override
  String get contest => 'Контест';

  @override
  String get serialSent => 'Порядковый номер (TX)';

  @override
  String get serialReceived => 'Порядковый номер (RX)';

  @override
  String get solarConditions => 'Солнечная активность';

  @override
  String get aIndex => 'A-индекс';

  @override
  String get kIndex => 'K-индекс';

  @override
  String get sfi => 'SFI';

  @override
  String get notesSection => 'Заметки';

  @override
  String get rawAdif => 'Исходный ADIF';

  @override
  String get showAll => 'Показать всё';

  @override
  String get showLess => 'Свернуть';

  @override
  String get qrzProfile => 'Профиль QRZ';

  @override
  String get addQsoTitle => 'Добавить QSO';

  @override
  String get liveQso => 'Вживую';

  @override
  String get historicalQso => 'Прошедшее';

  @override
  String get callsignField => 'Позывной *';

  @override
  String get lookupSearch => 'Поиск в QRZ';

  @override
  String get liveDateTimeLabel => 'Дата/Время (UTC) — сейчас';

  @override
  String get dateTimeLabel => 'Дата/Время (UTC)';

  @override
  String get bandField => 'Диапазон *';

  @override
  String get modeField => 'Вид модуляции *';

  @override
  String get frequencyField => 'Частота (МГц)';

  @override
  String get rstSentField => 'RST передано *';

  @override
  String get rstRcvdField => 'RST принято *';

  @override
  String get nameField => 'Имя';

  @override
  String get qthField => 'QTH';

  @override
  String get gridField => 'QTH-локатор';

  @override
  String get commentField => 'Комментарий';

  @override
  String get stationProfileField => 'Профиль QTH';

  @override
  String get saveQsoBtn => 'Сохранить QSO';

  @override
  String qsoSaved(String callsign) {
    return '✓  $callsign сохранён';
  }

  @override
  String qsoSavedLocal(String callsign) {
    return '✓  $callsign сохранён локально';
  }

  @override
  String get noActiveStation => 'Активный профиль QTH не выбран';

  @override
  String get lookupTitle => 'Поиск позывного';

  @override
  String get lookupHint => 'Введите позывной...';

  @override
  String get lookupBtn => 'Поиск';

  @override
  String get recentSearches => 'Последние запросы';

  @override
  String get clearHistory => 'Очистить историю';

  @override
  String get makeQso => 'Записать QSO';

  @override
  String get notFound => 'Не найдено';

  @override
  String get stationsTitle => 'Профили QTH';

  @override
  String stationActivated(String callsign) {
    return '$callsign установлен как активный профиль QTH';
  }

  @override
  String get stationWebInfo =>
      'Добавляйте и редактируйте профили QTH через веб-интерфейс Wavelog.';

  @override
  String get noStations => 'Нет профилей QTH';

  @override
  String get noStationsHint =>
      'Добавьте профиль QTH через веб-интерфейс Wavelog.';

  @override
  String get addStationOnWeb => 'Добавить профиль QTH в Wavelog';

  @override
  String get adifTitle => 'Импорт / Экспорт ADIF';

  @override
  String get importTab => 'Импорт';

  @override
  String get exportTab => 'Экспорт';

  @override
  String get selectAdifFile => 'Выбрать ADIF файл';

  @override
  String get selectFileBtn => 'Выбрать файл (.adi / .adif)';

  @override
  String get stationRequired => 'Профиль QTH *';

  @override
  String importing(int done, int total) {
    return 'Импорт... $done/$total';
  }

  @override
  String get importBtn => 'Импорт';

  @override
  String get fileReadError => 'Не удалось прочитать файл, попробуйте снова';

  @override
  String get invalidFileExtension =>
      'Выберите файл с расширением .adi или .adif';

  @override
  String get exportFilters => 'Фильтры экспорта';

  @override
  String get stationFilter => 'Профиль QTH';

  @override
  String get allStations => 'Все профили QTH';

  @override
  String get startDate => 'Начало';

  @override
  String get endDate => 'Конец';

  @override
  String get notSelected => 'Не выбрано';

  @override
  String get clearDates => 'Сбросить даты';

  @override
  String get exporting => 'Экспорт...';

  @override
  String get exportAndShare => 'Экспорт и отправка';

  @override
  String get copyPath => 'Копировать путь';

  @override
  String get reshare => 'Поделиться снова';

  @override
  String get pathCopied => 'Путь скопирован';

  @override
  String qsoExported(int count) {
    return '$count QSO экспортировано';
  }

  @override
  String get noStationForExport => 'Профиль QTH для экспорта не найден';

  @override
  String qsoImported(int imported, int total) {
    return '$imported / $total QSO импортировано';
  }

  @override
  String get selectSaveLocation => 'Выбрать место сохранения';

  @override
  String get copySuffix => '(Копия)';

  @override
  String get errNetwork => 'Нет соединения — проверьте сеть';

  @override
  String get errTimeout => 'Превышено время ожидания';

  @override
  String get errUnauthorized => 'Неверный ключ API';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get connectionSection => 'Соединение';

  @override
  String get sessionSection => 'Сессия';

  @override
  String get loggedIn => 'Вы вошли';

  @override
  String get logoutBtn => 'Выйти';

  @override
  String get logoutTitle => 'Выход';

  @override
  String get logoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get switchAccountBtn => 'Сменить аккаунт';

  @override
  String get activeStationSection => 'Активный профиль QTH';

  @override
  String get selectStationBtn => 'Выбрать профиль QTH';

  @override
  String get addStationWeb => 'Добавить профиль QTH на сайте';

  @override
  String get defaultsSection => 'По умолчанию';

  @override
  String get defaultBand => 'Диапазон по умолчанию';

  @override
  String get defaultMode => 'Вид модуляции по умолчанию';

  @override
  String get appSection => 'Приложение';

  @override
  String get darkTheme => 'Тёмная тема';

  @override
  String get darkThemeHint => 'Рекомендуется для работы в поле';

  @override
  String get offlineMode => 'Офлайн-режим';

  @override
  String get offlineModeHint =>
      'Сначала сохраняйте QSO локально, синхронизируйте позже';

  @override
  String get allowInsecureSsl => 'Разрешить непроверенные SSL-сертификаты';

  @override
  String get allowInsecureSslHint =>
      'Доверять самоподписанным или сертификатам частного ЦС (для собственных серверов). Не рекомендуется в публичных сетях.';

  @override
  String get languageLabel => 'Язык';

  @override
  String get infoSection => 'Информация';

  @override
  String get aboutAppBtn => 'О приложении';

  @override
  String get aboutAppHint => 'Версия, разработчик, лицензия';

  @override
  String get dataSection => 'Данные';

  @override
  String get clearCacheBtn => 'Очистить кэш QSO';

  @override
  String get clearCacheHint => 'Удаляет локальный кэш QSO';

  @override
  String get clearCacheTitle => 'Очистить кэш';

  @override
  String get clearCacheConfirm =>
      'Локальный кэш QSO будет удалён. Это действие необратимо.';

  @override
  String get clearCacheAction => 'Очистить';

  @override
  String get cacheCleared => 'Кэш очищен';

  @override
  String get langSystem => 'Как в системе';

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
  String get langRussian => 'Русский';

  @override
  String get aboutTitle => 'О приложении';

  @override
  String get appDescription =>
      'Приложение для Android для Wavelog c открытым исходным кодом';

  @override
  String versionLabel(String version, String build) {
    return 'Версия $version  (Сборка $build)';
  }

  @override
  String get mobileDeveloperSection => 'Разработчик мобильного приложения';

  @override
  String get wavelogProjectSection => 'Проект Wavelog';

  @override
  String get wavelogDescription => 'Аппаратный журнал с веб-интерфейсом';

  @override
  String get coreDevelopers => 'Основные разработчики';

  @override
  String get mitLicense => 'Лицензия MIT';

  @override
  String get mitDescription =>
      'Это приложение и проект Wavelog распространяются под лицензией MIT. Открытый исходный код, без гарантий.';

  @override
  String get licenseSection => 'Лицензия';

  @override
  String get errorNoConnection => 'Нет соединения';

  @override
  String get errorUnauthorized => 'Не авторизован — проверьте ключ API';

  @override
  String get errorServer => 'Ошибка сервера';

  @override
  String get patchRequiredTitle => 'Требуется патч сервера';

  @override
  String get patchRequiredMessage =>
      'Для редактирования и удаления требуется патч Wavelog Mobile API на вашем сервере.\n\nИнструкции по установке: sp9aqg.pl/install.html';

  @override
  String get patchRequiredBanner =>
      'Для редактирования и удаления требуется патч Wavelog Mobile API на вашем сервере.';

  @override
  String get patchViewGuide => 'Просмотр руководства';

  @override
  String get setupGuideTitle => 'Руководство по настройке';

  @override
  String get setupGuideIntro =>
      'Перед записью QSO подключите приложение к серверу Wavelog. Следуйте шагам ниже.';

  @override
  String get setupGuideStep1Title => '1. Адрес сервера';

  @override
  String get setupGuideStep1Body =>
      'Введите адрес, который вы используете для доступа к Wavelog в браузере, например https://yourdomain.com — без завершающего слеша.';

  @override
  String get setupGuideStep2Title => '2. Токен API v2';

  @override
  String get setupGuideStep2Body =>
      'В Wavelog: Ваш профиль → Ключи API → Токены API (API v2) → Новый токен API и выберите нужные приложению разрешения (scopes) (после вставки токена приложение проверит их за вас). Скопируйте созданный токен (начинается с wl2_) и вставьте его в приложение.';

  @override
  String get setupGuideStep3Title => '3. Позывной и отображаемое имя';

  @override
  String get setupGuideStep3Body =>
      'Позывной: ваш личный позывной, используется для сопоставления с вашей станцией. Отображаемое имя: любой ярлык для идентификации этого входа на устройстве.';

  @override
  String get setupGuideContinueBtn => 'Начать настройку';

  @override
  String get migrationTokenHint => 'wl2_…';

  @override
  String get migrationTokenLabel => 'Токен API v2';

  @override
  String get migrationValidateBtn => 'Проверить и продолжить';

  @override
  String get migrationValidating => 'Проверка…';

  @override
  String get migrationTokenEmpty => 'Вставьте ваш токен wl2_.';

  @override
  String get migrationTokenInvalid =>
      'Токен недействителен — проверьте и попробуйте снова.';

  @override
  String get patchNotInstalledTitle => 'Патч не обнаружен';

  @override
  String get patchNotInstalledBody =>
      'Патч Wavelog Mobile не установлен на вашем сервере.\n\nТокен API v2 (wl2_…) не будет работать без патча. Сначала выполните шаг 1.';

  @override
  String get patchInstallFirst => 'Установить патч';

  @override
  String get appSubtitle =>
      'Приложение для ведения аппаратного журнала радиостанции';

  @override
  String get switchToLightTheme => 'Переключить на светлую тему';

  @override
  String get switchToDarkTheme => 'Переключить на тёмную тему';

  @override
  String get deleteQsoTitle => 'Удалить QSO';

  @override
  String deleteQsoConfirm(String callsign, String date) {
    return 'Удалить QSO с $callsign от $date?';
  }

  @override
  String get editTooltip => 'Редактировать';

  @override
  String get shareAdifTooltip => 'Поделиться ADIF';

  @override
  String get localNotSynced => 'Локальная запись — ещё не синхронизирована';

  @override
  String get satellite => 'Спутник';

  @override
  String get satelliteMode => 'Спутниковый режим';

  @override
  String get antenna => 'Антенна';

  @override
  String get nameLabel => 'Имя';

  @override
  String get stateProvince => 'Штат/Область';

  @override
  String get county => 'Округ/Район';

  @override
  String get city => 'Город';

  @override
  String get continentAF => 'Африка';

  @override
  String get continentAN => 'Антарктида';

  @override
  String get continentAS => 'Азия';

  @override
  String get continentEU => 'Европа';

  @override
  String get continentNA => 'Северная Америка';

  @override
  String get continentOC => 'Океания';

  @override
  String get continentSA => 'Южная Америка';

  @override
  String get qrzProfileLoading => 'Загрузка профиля QRZ...';

  @override
  String viewOnQrz(String callsign) {
    return 'Открыть на QRZ.com  ($callsign)';
  }

  @override
  String get qslMethods => 'Способы QSL';

  @override
  String get bureau => 'Бюро';

  @override
  String qslManagerPrefix(String manager) {
    return 'Менеджер: $manager';
  }

  @override
  String get callsignCopied => 'Позывной скопирован';

  @override
  String get uploadedStatus => 'Загружено';

  @override
  String get notUploadedStatus => 'Не загружено';

  @override
  String get matchedStatus => 'Совпадает';

  @override
  String get toDeleteStatus => 'К удалению';

  @override
  String get yes => 'Да';

  @override
  String get requested => 'Запрошено';

  @override
  String get no => 'Нет';

  @override
  String get invalid => 'Недействительно';

  @override
  String get viaDirect => 'Напрямую';

  @override
  String get viaElectronic => 'Электронно';

  @override
  String get viaMail => 'Почтой';

  @override
  String otherAdifFields(int count) {
    return 'Другие поля ADIF ($count)';
  }

  @override
  String get editQsoTitle => 'Редактировать QSO';

  @override
  String get qsoUpdated => 'QSO обновлено';

  @override
  String get qsoUpdatedLocal => 'QSO обновлено локально';

  @override
  String get counterStationHint =>
      'Введите позывной, чтобы увидеть информацию QRZ\nи предыдущие QSO.';

  @override
  String previousQsosCount(int count) {
    return 'Предыдущие QSO ($count)';
  }

  @override
  String morePreviousQsos(int count) {
    return '+$count ещё...';
  }

  @override
  String previousQsosWithCallsign(String callsign) {
    return 'Предыдущие QSO с $callsign';
  }

  @override
  String totalQsos(int count) {
    return 'Всего $count';
  }

  @override
  String get workedBefore => 'Работали ранее';

  @override
  String get lastQsoLabel => 'Последнее QSO';

  @override
  String get themeLabel => 'Тема';

  @override
  String get darkThemeActive => 'Тёмная тема активна';

  @override
  String get lightThemeActive => 'Светлая тема активна';

  @override
  String get lightThemeLabel => 'Светлая';

  @override
  String get darkThemeLabel => 'Тёмная';

  @override
  String get commentNotes => 'Комментарий / Заметки';

  @override
  String get commentLabel => 'Комментарий';

  @override
  String get exchangeReceived => 'Принятый контрольный номер';

  @override
  String get exchangeSent => 'Переданный контрольный номер';

  @override
  String get contestIdLabel => 'Контест';

  @override
  String get sigLabel => 'SIG';

  @override
  String get stationSetup => 'Настройка журнала';

  @override
  String get logbooks => 'Журналы';

  @override
  String get locations => 'Профили QTH';

  @override
  String get newLogbook => 'Новый журнал';

  @override
  String get logbookName => 'Название журнала';

  @override
  String get renameLogbook => 'Переименовать';

  @override
  String get deleteLogbook => 'Удалить журнал';

  @override
  String get setActiveLogbook => 'Сделать активным';

  @override
  String get activeLogbook => 'Активный журнал';

  @override
  String get editStation => 'Редактировать';

  @override
  String get cloneStation => 'Клонировать';

  @override
  String get deleteStation => 'Удалить';

  @override
  String get deleteStationConfirm => 'Удалить профиль QTH';

  @override
  String get deleteStationWarning =>
      'Все QSO в этом профиле QTH будут безвозвратно удалены. Продолжить?';

  @override
  String get stationDeleted => 'Профиль QTH удалён';

  @override
  String get stationUpdated => 'Профиль QTH обновлён';

  @override
  String get stationCloned => 'Профиль QTH клонирован';

  @override
  String get linkLocation => 'Привязать профиль QTH';

  @override
  String get unlinkLocation => 'Отвязать';

  @override
  String get linkedLocations => 'Привязанные профили QTH';

  @override
  String get newStationName => 'Название нового профиля QTH';

  @override
  String get deleteLogbookConfirm => 'Удалить журнал';

  @override
  String get deleteLogbookWarning =>
      'Этот журнал будет удалён. Связанные профили QTH сохранятся. Продолжить?';

  @override
  String get logbookDeleted => 'Журнал удалён';

  @override
  String get hrdlogCode => 'Код HRDLog';

  @override
  String get webAdifApiKey => 'ключ API WebADIF';

  @override
  String get webAdifApiUrl => 'URL API WebADIF';

  @override
  String get basicInfo => 'Основная информация';

  @override
  String get locationSectionTitle => 'Профиль QTH';

  @override
  String get awardReferences => 'Референции';

  @override
  String get integrationsSectionTitle => 'Интеграции';

  @override
  String get stationSettingsSection => 'Настройки профиля QTH';

  @override
  String get editStationTitle => 'Редактировать профиль QTH';

  @override
  String get newStationTitle => 'Новый профиль QTH';

  @override
  String get saveChangesBtn => 'Сохранить изменения';

  @override
  String get createStationBtn => 'Создать профиль QTH';

  @override
  String get stationCreated => 'Профиль QTH создан';

  @override
  String get stationCreateFailed =>
      'Ошибка. Профиль с таким именем уже существует.';

  @override
  String get stationProfileNameLabel => 'Название профиля QTH *';

  @override
  String get stationProfileNameHint => 'Дом';

  @override
  String get cityQth => 'Город / QTH';

  @override
  String get powerWatts => 'Мощность (Вт)';

  @override
  String get dxccCountry => 'DXCC / Страна';

  @override
  String get selectLabel => 'Выбрать...';

  @override
  String get dxccSearch => 'Поиск DXCC / Страны';

  @override
  String get deletedDxcc => 'Удалённый DXCC';

  @override
  String get eqslQthNicknameLabel => 'Псевдоним профиля QTH для eQSL';

  @override
  String get eqslDefaultMsgLabel => 'Сообщение eQSL по умолчанию';

  @override
  String get pending => 'Ожидает';

  @override
  String get uploadDisabled => 'Отключено';

  @override
  String get uploadEnabled => 'Включено';

  @override
  String get uploadRealtime => 'В реальном времени';

  @override
  String get qrzApiKeyLabel => 'Ключ API для журнала QRZ.com';

  @override
  String get qrzUploadLabel => 'Загрузка на QRZ.com';

  @override
  String get clublogIgnoreTitle => 'Игнорировать Clublog';

  @override
  String get clublogIgnoreSubtitle =>
      'Исключить этот профиль QTH из загрузок Clublog';

  @override
  String get clublogRealtimeTitle => 'Загрузка в Clublog в реальном времени';

  @override
  String get clublogRealtimeSubtitle =>
      'Загружать QSO в Clublog в реальном времени';

  @override
  String get hrdlogUsernameLabel => 'Имя пользователя HRDLog.net';

  @override
  String get hrdlogApiKeyLabel => 'Ключ API для HRDLog.net';

  @override
  String get hrdlogUploadLabel => 'Загрузка в HRDLog.net';

  @override
  String get qo100ApiKeyLabel => 'Ключ API QO-100 DX Club';

  @override
  String get qo100RealtimeTitle =>
      'Загрузка в QO-100 DX Club в реальном времени';

  @override
  String get qo100RealtimeSubtitle =>
      'Загружать QSO в QO-100 DX Club в реальном времени';

  @override
  String get oqrsSectionTitle => 'OQRS (Онлайн запрос QSL)';

  @override
  String get oqrsEnabledTitle => 'OQRS включён';

  @override
  String get oqrsEnabledSubtitle => 'Включить систему онлайн запросов QSL';

  @override
  String get oqrsTextLabel => 'Описание OQRS';

  @override
  String get oqrsEmailLabel => 'Email OQRS';

  @override
  String get setAsActiveStationTitle => 'Установить профиль QTH активным';

  @override
  String get setAsActiveStationSubtitle =>
      'Отметить этот профиль QTH, как активный в Wavelog';

  @override
  String get linkToActiveLogbookTitle => 'Привязать к активному журналу';

  @override
  String get linkToActiveLogbookSubtitle =>
      'Автоматически привязывать к активному журналу при создании';

  @override
  String get active => 'Активен';

  @override
  String get loadDetailsFailed => 'Не удалось загрузить подробности';

  @override
  String get cannotDeleteActiveStation =>
      'Нельзя удалить активный профиль QTH.';

  @override
  String get navStats => 'Статистика';

  @override
  String get statisticsTitle => 'Статистика';

  @override
  String get uniqueCallsigns => 'Уникальные позывные';

  @override
  String get currentStreak => 'Текущая серия';

  @override
  String streakDays(int count) {
    return '$count дн.';
  }

  @override
  String get bandDistribution => 'Распределение по диапазонам';

  @override
  String get modeDistribution => 'Распределение по видам модуляции';

  @override
  String get perStation => 'По профилям QTH';

  @override
  String get basedOnCache =>
      'Статистика по диапазонам/видам модуляции/профилям QTH основана на кэшированных QSO.';

  @override
  String get statsTab => 'Статистика';

  @override
  String get propagationTab => 'Прохождение';

  @override
  String get bandConditions => 'Условия на диапазонах';

  @override
  String get dayTime => 'День';

  @override
  String get nightTime => 'Ночь';

  @override
  String get conditionGood => 'Хорошее';

  @override
  String get conditionFair => 'Удовлетворительное';

  @override
  String get conditionPoor => 'Плохое';

  @override
  String lastUpdated(String time) {
    return 'Обновлено: $time';
  }

  @override
  String get noSolarData =>
      'Не удалось загрузить данные о солнечной активности';

  @override
  String get potaStats => 'Статистика POTA';

  @override
  String get potaTotalQsos => 'QSO POTA';

  @override
  String get potaActivatedParks => 'Активированные парки';

  @override
  String get potaAllParks => 'Все парки';

  @override
  String get potaActivatedBadge => 'Активирован';

  @override
  String get potaAttemptBadge => 'Попытка';

  @override
  String get potaNoStation => 'Профиль станции POTA не настроен';

  @override
  String get potaNoQsos => 'Нет QSO POTA в кэше';

  @override
  String get navSpot => 'Споты';

  @override
  String get spotTitle => 'Споты';

  @override
  String get spotAdd => 'Добавить спот';

  @override
  String get spotSend => 'Отправить спот';

  @override
  String get spotSent => 'Спот отправлен!';

  @override
  String get spotNoResults => 'Споты не найдены';

  @override
  String get spotLoadError => 'Не удалось загрузить споты';

  @override
  String get spotActivator => 'Позывной активатора';

  @override
  String get spotSpotter => 'Позывной спотера';

  @override
  String get spotFrequency => 'Частота (кГц)';

  @override
  String get spotReference => 'Референция';

  @override
  String get spotComments => 'Комментарии';

  @override
  String get spotCommentsHint => 'QRZ, CQ POTA...';

  @override
  String get spotInvalidRef => 'Неверный формат (например PL-0001)';

  @override
  String get sortNewest => 'Сначала новые';

  @override
  String get sortOldest => 'Сначала старые';

  @override
  String get filterBand => 'Диапазон';

  @override
  String get filterMode => 'Вид модуляции';

  @override
  String get filterCountry => 'Страна';

  @override
  String get filterAssociation => 'Ассоциация';

  @override
  String get spotAddComingSoon => 'Добавить спот — скоро';

  @override
  String get filterClear => 'Сбросить фильтры';

  @override
  String get mode => 'Вид модуляции';

  @override
  String get required => 'Требуется';

  @override
  String get invalidNumber => 'Неверное число';

  @override
  String get potaAutoSpot => 'Авто-спот';

  @override
  String get potaAutoSpotHint =>
      'Автоматически отправлять спот при записи QSO в профиле QTH POTA или SOTA (перерыв 30 минут)';

  @override
  String get spotRefreshLabel => 'Интервал обновления спотов';

  @override
  String get spotRefreshHint =>
      'Автоматически обновляет список спотов с этим интервалом';

  @override
  String autoSpotSent(String ref) {
    return 'Авто-спот отправлен: $ref';
  }

  @override
  String get autoSpotWillFire => 'QSO запустит отправку спота';

  @override
  String autoSpotCooldown(int min) {
    return 'Спот отправлен · Следующий через $min мин';
  }

  @override
  String get autoSpotCooldownSoon => 'Спот отправлен · Следующий спот скоро';

  @override
  String autoSpotKeyChanged(String fields) {
    return '$fields изменились · Будет отправлен новый спот';
  }

  @override
  String get autoSpotFieldFreq => 'Частота';

  @override
  String get autoSpotFieldMode => 'Вид модуляции';

  @override
  String get autoSpotFieldRef => 'Парк';

  @override
  String get logbookSummaryTitle => 'Последние QSO';

  @override
  String todayQsoCount(int count) {
    return 'Сегодня: $count QSO';
  }

  @override
  String get colDateTime => 'Дата/Время';

  @override
  String get colRstSent => 'RST(Прд)';

  @override
  String get colRstRcvd => 'RST(Прм)';

  @override
  String get submodeLabel => 'Подвид';

  @override
  String selectedCount(int count) {
    return '$count выбрано';
  }

  @override
  String get selectAll => 'Выбрать все';

  @override
  String get exportSelected => 'Экспорт';

  @override
  String get deleteSelected => 'Удалить';

  @override
  String deleteSelectedConfirm(int count) {
    return 'Удалить $count QSO?';
  }

  @override
  String get mapTitle => 'Карта';

  @override
  String get mapNoData => 'QSO с квадратом QTH-локатора не найдены';

  @override
  String mapStationCount(int count) {
    return '$count станций';
  }

  @override
  String get dxccProgress => 'Прогресс DXCC';

  @override
  String get workedCountries => 'Стработанные страны';

  @override
  String get dxccWorked => 'Стработано';

  @override
  String dxccUniqueEntities(int count) {
    return '$count уникальных DXCC';
  }

  @override
  String get dxccConfirmed => 'Подтверждено (LoTW / eQSL / QSL)';

  @override
  String get dxccRemaining => 'Осталось';

  @override
  String get dxccLegendConfirmed => 'Подтверждено';

  @override
  String get dxccLegendPending => 'В ожидании';

  @override
  String get dxccLegendNotWorked => 'Не стработано';

  @override
  String get spotSummitNotFound => 'Вершина не найдена';

  @override
  String get spotParkNotFound => 'Парк не найден';

  @override
  String get qsoTypeTitle => 'Записать QSO';

  @override
  String get normalQso => 'Обычное QSO';

  @override
  String get normalQsoDesc => 'Стандартная запись контакта';

  @override
  String get contestQso => 'QSO контеста';

  @override
  String get contestQsoDesc =>
      'Быстрое ведение журнала контеста с контрольными номерами';

  @override
  String get contestLog => 'Журнал контеста';

  @override
  String get contestSetup => 'Настройка контеста';

  @override
  String get contestNameHint => 'напр. CQ-WW-CW';

  @override
  String get ourExchange => 'Наш контрольный номер';

  @override
  String get serialStart => 'Начальный порядковый №';

  @override
  String get showExchangeFields => 'Поля контрольного номера';

  @override
  String get startContest => 'Начать запись журнала';

  @override
  String get endContest => 'Завершить контест-сессию';

  @override
  String get endContestConfirm =>
      'Завершить контест-сессию? (Счётчик последовательных номеров и настройки будут сброшены.)';

  @override
  String get serialSentLabel => '№ (TX)';

  @override
  String get serialRcvdLabel => '№ (RX)';

  @override
  String get exchangeSentLabel => 'Контр. (TX)';

  @override
  String get exchangeRcvdLabel => 'Контр. (RX)';

  @override
  String get gridSentLabel => 'QTH-лок. (TX)';

  @override
  String get gridRcvdLabel => 'QTH-лок. (RX)';

  @override
  String get logQso => 'Записать QSO';

  @override
  String get qsoLogged => 'QSO записано';

  @override
  String get contestRecentQsos => 'Последние';

  @override
  String get contestSessions => 'Контест-сессии';

  @override
  String get newSession => 'Новая контест-сессия';

  @override
  String get noContestSessions => 'Контест-сессий нет';

  @override
  String get noContestSessionsHint =>
      'Создайте контест-сессию на сайте или нажмите +, чтобы начать здесь.';

  @override
  String get contestSessionActive => 'Активна';

  @override
  String get contestSessionEnded => 'Завершена';

  @override
  String qsoCount(int count) {
    return '$count QSO';
  }

  @override
  String contestSessionDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get createContestSession => 'Создать контест-сессию';

  @override
  String get sessionName => 'Название контест-сессии (необязательно)';

  @override
  String get sessionNameHint => 'напр. Домашний QTH — CW';

  @override
  String get selectContest => 'Выбрать контест *';

  @override
  String get searchContest => 'Поиск контестов...';

  @override
  String get serverContests => 'С сервера';

  @override
  String get builtinContests => 'Популярные контесты';

  @override
  String get startDateTime => 'Дата/время начала *';

  @override
  String get endDateTime => 'Дата/время окончания *';

  @override
  String get durationShortcut4h => '+4ч';

  @override
  String get durationShortcut12h => '+12ч';

  @override
  String get durationShortcut24h => '+24ч';

  @override
  String get durationShortcut48h => '+48ч';

  @override
  String get exchangeType => 'Контрольные номера';

  @override
  String get exchangeTypeSerial => 'Порядковый номер';

  @override
  String get exchangeTypeExchange => 'Обмен (текст)';

  @override
  String get exchangeTypeBoth => 'Порядковый номер + обмен (текст)';

  @override
  String get createSession => 'Создать контест-сессию';

  @override
  String get sessionCreated => 'Контест-сессия создана';

  @override
  String get sessionUpdated => 'Контест-сессия обновлена';

  @override
  String get editContestSession => 'Редактировать контест-сессию';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get deleteSession => 'Удалить контест-сессию';

  @override
  String get deleteSessionConfirm =>
      'Удалить эту контест-сессию? QSO, записанные в ней, останутся в журнале.';

  @override
  String get openSession => 'Открыть для записи QSO';

  @override
  String get patchRequiredContest =>
      'Управление контест-сессиями требует обновлённого патча Wavelog Mobile.';

  @override
  String get contestCalendarTitle => 'Календарь контестов';

  @override
  String get contestCalendarNoContests => 'Контесты не найдены.';

  @override
  String get contestCalendarToday => 'Сегодня';

  @override
  String get contestCalendarThisWeek => 'На этой неделе';

  @override
  String get contestCalendarUpcoming => 'Предстоящие';

  @override
  String get contestCalendarRecentlyPast => 'Недавно прошедшие';

  @override
  String get contestCalendarLoadError =>
      'Не удалось загрузить календарь контестов';

  @override
  String get contestCalendarRefresh => 'Обновить';

  @override
  String get contestCalendarRetry => 'Повторить';

  @override
  String get upcomingContestsTitle => 'Предстоящие контесты';

  @override
  String get viewAll => 'Все';

  @override
  String get noUpcomingContests => 'Предстоящих контестов не найдено.';

  @override
  String get contestTodayBadge => 'СЕГОДНЯ';

  @override
  String get navStyleLabel => 'Стиль навигации';

  @override
  String get navStyleModern => 'Современный — FAB + меню';

  @override
  String get navStyleClassic => 'Классический — 6 вкладок';

  @override
  String get drawerMap => 'Карта';

  @override
  String get drawerContestCalendar => 'Календарь контестов';

  @override
  String get drawerContestSessions => 'Контест-сессии';

  @override
  String get drawerAdif => 'ADIF';

  @override
  String get drawerMenu => 'Меню';

  @override
  String get antennaCompassTitle => 'Направление антенны';

  @override
  String get targetGrid => 'Целевой квадрат QTH-локатора';

  @override
  String get calculate => 'Вычислить';

  @override
  String get shortPath => 'Короткий путь';

  @override
  String get longPath => 'Длинный путь';

  @override
  String get azimuth => 'Азимут';

  @override
  String get myHeading => 'Курс';

  @override
  String get invalidGrid => 'Неверный квадрат QTH-локатора';

  @override
  String get gpsLocating => 'Определение GPS… подождите';

  @override
  String get gpsUnavailable => 'GPS недоступен';

  @override
  String get drawerAntenna => 'Направление антенны';

  @override
  String get achievementsTitle => 'Достижения';

  @override
  String get achievementsEmpty =>
      'Запишите первое QSO, чтобы начать получать значки!';

  @override
  String get shareAchievement => 'Поделиться';

  @override
  String get achievementUnlocked => 'Достижение разблокировано!';

  @override
  String progressLabel(int done, int target) {
    return '$done / $target';
  }

  @override
  String get drawerAchievements => 'Достижения';

  @override
  String get drawerCommunity => 'Сообщество';

  @override
  String get communityTitle => 'Сообщество';

  @override
  String get communityNoActivations => 'Запланированных активаций нет';

  @override
  String get communityBeFirst => 'Будьте первым, кто объявит!';

  @override
  String get communityAnnounce => 'Объявить активацию';

  @override
  String get communityFollow => 'Подписаться';

  @override
  String get communityUnfollow => 'Отписаться';

  @override
  String communityFollowers(int count) {
    return '$count подписчиков';
  }

  @override
  String get communityTypeGeneral => 'Общая';

  @override
  String get communityCallsign => 'Позывной';

  @override
  String get communityReference => 'Референция';

  @override
  String get communitySotaRef => 'Референция SOTA (TA/AN-001)';

  @override
  String get communityPotaRef => 'Референция POTA (TA-0001)';

  @override
  String get communityScheduledTime => 'Запланированное время';

  @override
  String get communityNote => 'Заметка (необязательно)';

  @override
  String get communityNoteHint => 'Краткая информация об активации...';

  @override
  String get communityAnnounceButton => 'Объявить';

  @override
  String get communityAnnounced => 'Активация объявлена!';

  @override
  String get communityRateLimit =>
      'Вы недавно размещали объявление. Подождите несколько минут.';

  @override
  String get communityCallsignRequired => 'Позывной обязателен';

  @override
  String get communityReferenceRequired => 'Референция обязательна';

  @override
  String get communityBandRequired => 'Выберите хотя бы один диапазон';

  @override
  String get communityActivations => 'Активации';

  @override
  String get communityChat => 'Чат';

  @override
  String get communityEditActivation => 'Редактировать активацию';

  @override
  String get communityDeleteActivation => 'Удалить активацию';

  @override
  String get communityDeleteActivationConfirm =>
      'Удалить эту активацию? Это действие нельзя отменить.';

  @override
  String get communityUpdated => 'Активация обновлена';

  @override
  String get chatRooms => 'Комнаты чата';

  @override
  String get chatGeneral => 'Общие';

  @override
  String get chatGeneralSubtitle => 'Общий язык: английский';

  @override
  String get chatMessageHint => 'Введите сообщение…';

  @override
  String get chatSend => 'Отправить';

  @override
  String get chatEdit => 'Редактировать';

  @override
  String get chatDelete => 'Удалить';

  @override
  String get chatDeleteConfirm => 'Удалить это сообщение?';

  @override
  String get chatEdited => 'изменено';

  @override
  String get chatNoStation => 'Выберите активный профиль QTH для чата';

  @override
  String get chatToday => 'Сегодня';

  @override
  String get chatYesterday => 'Вчера';

  @override
  String get chatFollow => 'Подписаться';

  @override
  String get chatUnfollow => 'Отписаться';

  @override
  String get chatFollowing => 'Вы подписаны';

  @override
  String get chatAddReaction => 'Добавить реакцию';

  @override
  String get gifPreparing => 'Подготовка видео...';

  @override
  String gifCapturing(int percent) {
    return 'Захват кадров... $percent%';
  }

  @override
  String get gifEncoding => 'Кодирование видео...';

  @override
  String get comingSoon => 'Скоро';

  @override
  String get noCompassSensor => 'Нет датчика компаса';

  @override
  String get fillFromGps => 'Заполнить из GPS';

  @override
  String get locationPermissionDenied => 'Доступ к геолокации запрещён';

  @override
  String gpsError(String error) {
    return 'Ошибка GPS: $error';
  }

  @override
  String get errParse => 'Не удалось разобрать ответ сервера';

  @override
  String get errLocalStorage => 'Ошибка локального хранилища';

  @override
  String get errServer => 'Ошибка сервера';

  @override
  String get wpxPrefix => 'Префикс WPX';

  @override
  String get nowBtn => 'Сейчас';

  @override
  String get contestOtherCustom => 'Другой / Пользовательский';

  @override
  String get sigInfo => 'Информация SIG';

  @override
  String get migrationTitle => 'Требуется API v2';

  @override
  String get migrationBody =>
      'Wavelog Mobile теперь использует новый API Wavelog. Ваш старый ключ API недействителен — выполните шаги ниже для миграции.';

  @override
  String get migrationStep1Title => 'Установить патч сервера';

  @override
  String get migrationStep1Body =>
      'На ваш сервер Wavelog нужно установить небольшой файл обновления. Нажмите кнопку «Руководство по установке» ниже.';

  @override
  String get migrationInstallGuideBtn => 'Руководство по установке';

  @override
  String get migrationStep2Title => 'Создать новый токен API';

  @override
  String get migrationStep2Body =>
      'В веб-интерфейсе Wavelog:\n  1. Откройте меню настроек (вверху справа)\n  2. Перейдите в «Ключи API» → «Токены API (API v2) »\n  3. Нажмите «Создать новый токен API»\n  4. Выберите предустановку «Wavelog Mobile»\n  5. Подтвердите и скопируйте токен\n  (Токен начинается с «wl2_»)';

  @override
  String get migrationStep3Title => 'Обновить профиль';

  @override
  String get migrationStep3Body =>
      'Нажмите кнопку ниже. Адрес сервера сохранится — просто вставьте новый токен.';

  @override
  String get migrationUpdateTokenBtn => 'Обновить токен';

  @override
  String get migrationHelpBtn => 'Помощь и руководство по установке';

  @override
  String get celebTitle => 'Wavelog v3.2.0';

  @override
  String get celebSubtitle => 'Патч сервера больше не нужен!';

  @override
  String get celebBody =>
      'Все функции теперь работают напрямую через официальный API v2 Wavelog. Вы можете удалить старый патч с вашего сервера.\n\nЭто приложение теперь требует Wavelog v3.2.0 или выше.';

  @override
  String get celebCreateToken => 'Создать токен API';

  @override
  String get celebSkip => 'Пропустить';

  @override
  String get celebScopesTitle => 'Области доступа для токена API v2';

  @override
  String get celebScopesBody =>
      'При создании нового токена в интерфейсе Wavelog (Профиль → Ключи API → Создать новый токен API) выберите следующие области:';

  @override
  String get celebDone => 'Понятно';

  @override
  String get scopeQsoRead => 'Чтение QSO';

  @override
  String get scopeQsoWrite => 'Добавление / обновление QSO';

  @override
  String get scopeQsoDelete => 'Удаление QSO';

  @override
  String get scopeStationRead => 'Чтение профилей QTH';

  @override
  String get scopeStationWrite => 'Создание / обновление профилей QTH';

  @override
  String get scopeStationDelete => 'Удаление профилей QTH';

  @override
  String get scopeLogbookRead => 'Чтение журналов';

  @override
  String get scopeLogbookWrite => 'Создание / обновление журналов';

  @override
  String get scopeLogbookDelete => 'Удаление журналов';

  @override
  String get scopeContestRead => 'Чтение контест-сессий';

  @override
  String get scopeContestWrite => 'Создание / обновление контест-сессий';

  @override
  String get scopeContestDelete => 'Удаление контест-сессий';

  @override
  String get scopeCatalogRead =>
      'DXCC, административное деление и список контестов';

  @override
  String get scopeLookupRead => 'Поиск позывных';

  @override
  String get scopeStatisticsRead => 'Чтение статистики';

  @override
  String get scopeConfirmationRead =>
      'Чтение подтверждений LoTW / eQSL / QRZ.com';

  @override
  String get scopeTestStation => 'Профиль QTH';

  @override
  String get scopeTestLogbook => 'Журнал';

  @override
  String get scopeTestQso => 'QSO';

  @override
  String get scopeTestContest => 'Контест';

  @override
  String get scopeTestConfirmation => 'Подтверждение';

  @override
  String get scopeTestStatistics => 'Статистика';

  @override
  String get scopeTestLookup => 'Поиск';

  @override
  String get apiScopeGuideBtn => 'Руководство по областям доступа API';

  @override
  String get apiScopeGuideTitle => 'Руководство по областям доступа токена API';

  @override
  String get apiScopeGuideIntro =>
      'При создании нового токена API в Wavelog (Ваш профиль → Ключи API) выберите все области ниже для полной функциональности приложения.';

  @override
  String get apiTokenNoticeTitle => 'Создайте новый токен API';

  @override
  String get apiTokenNoticeBody =>
      'API v2 Wavelog требует новый токен с определёнными областями доступа. Перейдите в Wavelog → Ваш профиль → Ключи API и создайте новый токен со всеми необходимыми областями. Нажмите кнопку «Руководство по токенам API» ниже для подробной информации.';

  @override
  String get apiTokenNoticeDontShow => 'Не показывать снова';

  @override
  String get apiTokenNoticeIgnore => 'Игнорировать';

  @override
  String get apiTokenNoticeScopeGuide => 'Руководство по областям API';

  @override
  String get communitySignInTitle => 'Подтвердить позывной';

  @override
  String get communitySignInSubtitle =>
      'Войдите через Google, чтобы привязать аккаунт к своему позывному.';

  @override
  String get communitySignInButton => 'Войти через Google';

  @override
  String get communitySignInNoStation =>
      'Выберите активную станцию в настройках, прежде чем использовать функции сообщества.';

  @override
  String get communityCallsignTaken =>
      'Этот позывной уже привязан к другому аккаунту Google.';

  @override
  String get communitySignOut => 'Выйти и сменить аккаунт';
}
