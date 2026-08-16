enum AchievementId {
  firstQso,
  qso10,
  qso100,
  qso500,
  qso1000,
  qso5000,
  callsigns10,
  callsigns100,
  callsigns500,
  bands3,
  bands7,
  streak3,
  streak7,
  streak30,
}

class AchievementInput {
  final int totalQsos;
  final int uniqueCallsigns;
  final int bandsWorked;
  final int streakDays;

  const AchievementInput({
    required this.totalQsos,
    required this.uniqueCallsigns,
    required this.bandsWorked,
    required this.streakDays,
  });
}

class AchievementDef {
  final AchievementId id;
  final String emoji;
  final String titleEn;
  final String titleTr;
  final String titlePl;
  final String descEn;
  final String descTr;
  final String descPl;
  final int Function(AchievementInput) progress;
  final int target;

  const AchievementDef({
    required this.id,
    required this.emoji,
    required this.titleEn,
    required this.titleTr,
    required this.titlePl,
    required this.descEn,
    required this.descTr,
    required this.descPl,
    required this.progress,
    required this.target,
  });

  bool isUnlocked(AchievementInput input) => progress(input) >= target;
  double progressFraction(AchievementInput input) =>
      (progress(input) / target).clamp(0.0, 1.0);

  String localDesc(String locale) {
    if (locale == 'tr') return descTr;
    if (locale == 'pl') return descPl;
    return descEn;
  }
}

final allAchievements = <AchievementDef>[
  AchievementDef(
    id: AchievementId.firstQso,
    emoji: '📻',
    titleEn: 'First Contact',
    titleTr: 'İlk Temas',
    titlePl: 'Pierwszy Kontakt',
    descEn: 'Log your very first QSO',
    descTr: 'İlk QSO\'nuzu kaydedin',
    descPl: 'Zaloguj swój pierwszy kontakt QSO',
    progress: (i) => i.totalQsos.clamp(0, 1),
    target: 1,
  ),
  AchievementDef(
    id: AchievementId.qso10,
    emoji: '🔟',
    titleEn: '10 QSOs',
    titleTr: '10 QSO',
    titlePl: '10 QSO',
    descEn: 'Log 10 QSOs',
    descTr: '10 QSO kaydedin',
    descPl: 'Zaloguj 10 kontaktów QSO',
    progress: (i) => i.totalQsos,
    target: 10,
  ),
  AchievementDef(
    id: AchievementId.qso100,
    emoji: '💯',
    titleEn: '100 QSOs',
    titleTr: '100 QSO',
    titlePl: '100 QSO',
    descEn: 'Log 100 QSOs',
    descTr: '100 QSO kaydedin',
    descPl: 'Zaloguj 100 kontaktów QSO',
    progress: (i) => i.totalQsos,
    target: 100,
  ),
  AchievementDef(
    id: AchievementId.qso500,
    emoji: '🏅',
    titleEn: '500 QSOs',
    titleTr: '500 QSO',
    titlePl: '500 QSO',
    descEn: 'Log 500 QSOs',
    descTr: '500 QSO kaydedin',
    descPl: 'Zaloguj 500 kontaktów QSO',
    progress: (i) => i.totalQsos,
    target: 500,
  ),
  AchievementDef(
    id: AchievementId.qso1000,
    emoji: '🥇',
    titleEn: '1,000 QSOs',
    titleTr: '1.000 QSO',
    titlePl: '1 000 QSO',
    descEn: 'Log 1,000 QSOs',
    descTr: '1.000 QSO kaydedin',
    descPl: 'Zaloguj 1 000 kontaktów QSO',
    progress: (i) => i.totalQsos,
    target: 1000,
  ),
  AchievementDef(
    id: AchievementId.qso5000,
    emoji: '🏆',
    titleEn: '5,000 QSOs',
    titleTr: '5.000 QSO',
    titlePl: '5 000 QSO',
    descEn: 'Log 5,000 QSOs',
    descTr: '5.000 QSO kaydedin',
    descPl: 'Zaloguj 5 000 kontaktów QSO',
    progress: (i) => i.totalQsos,
    target: 5000,
  ),
  AchievementDef(
    id: AchievementId.callsigns10,
    emoji: '📡',
    titleEn: '10 Unique Callsigns',
    titleTr: '10 Farklı Çağrı',
    titlePl: '10 Unikalnych Znaków',
    descEn: 'Work 10 unique callsigns',
    descTr: '10 farklı çağrı işareti ile temas kurun',
    descPl: 'Pracuj z 10 różnymi znakami wywoławczymi',
    progress: (i) => i.uniqueCallsigns,
    target: 10,
  ),
  AchievementDef(
    id: AchievementId.callsigns100,
    emoji: '🌍',
    titleEn: '100 Unique Callsigns',
    titleTr: '100 Farklı Çağrı',
    titlePl: '100 Unikalnych Znaków',
    descEn: 'Work 100 unique callsigns',
    descTr: '100 farklı çağrı işareti ile temas kurun',
    descPl: 'Pracuj z 100 różnymi znakami wywoławczymi',
    progress: (i) => i.uniqueCallsigns,
    target: 100,
  ),
  AchievementDef(
    id: AchievementId.callsigns500,
    emoji: '🌐',
    titleEn: '500 Unique Callsigns',
    titleTr: '500 Farklı Çağrı',
    titlePl: '500 Unikalnych Znaków',
    descEn: 'Work 500 unique callsigns',
    descTr: '500 farklı çağrı işareti ile temas kurun',
    descPl: 'Pracuj z 500 różnymi znakami wywoławczymi',
    progress: (i) => i.uniqueCallsigns,
    target: 500,
  ),
  AchievementDef(
    id: AchievementId.bands3,
    emoji: '🎚️',
    titleEn: 'Multiband',
    titleTr: 'Çok Bantlı',
    titlePl: 'Wielopasmowy',
    descEn: 'Work on 3 different bands',
    descTr: '3 farklı bantta çalışın',
    descPl: 'Pracuj na 3 różnych pasmach',
    progress: (i) => i.bandsWorked,
    target: 3,
  ),
  AchievementDef(
    id: AchievementId.bands7,
    emoji: '🌈',
    titleEn: 'All Bands',
    titleTr: 'Tüm Bantlar',
    titlePl: 'Wszystkie Pasma',
    descEn: 'Work on 7 or more bands',
    descTr: '7 veya daha fazla bantta çalışın',
    descPl: 'Pracuj na 7 lub więcej pasmach',
    progress: (i) => i.bandsWorked,
    target: 7,
  ),
  AchievementDef(
    id: AchievementId.streak3,
    emoji: '🔥',
    titleEn: '3-Day Streak',
    titleTr: '3 Günlük Seri',
    titlePl: 'Seria 3 Dni',
    descEn: 'Log QSOs 3 days in a row',
    descTr: '3 gün üst üste QSO kaydedin',
    descPl: 'Loguj QSO przez 3 kolejne dni',
    progress: (i) => i.streakDays,
    target: 3,
  ),
  AchievementDef(
    id: AchievementId.streak7,
    emoji: '⚡',
    titleEn: 'Week Warrior',
    titleTr: 'Haftalık Savaşçı',
    titlePl: 'Tygodniowy Wojownik',
    descEn: 'Log QSOs 7 days in a row',
    descTr: '7 gün üst üste QSO kaydedin',
    descPl: 'Loguj QSO przez 7 kolejnych dni',
    progress: (i) => i.streakDays,
    target: 7,
  ),
  AchievementDef(
    id: AchievementId.streak30,
    emoji: '💎',
    titleEn: 'Month Master',
    titleTr: 'Ay Ustası',
    titlePl: 'Mistrz Miesiąca',
    descEn: 'Log QSOs 30 days in a row',
    descTr: '30 gün üst üste QSO kaydedin',
    descPl: 'Loguj QSO przez 30 kolejnych dni',
    progress: (i) => i.streakDays,
    target: 30,
  ),
];
