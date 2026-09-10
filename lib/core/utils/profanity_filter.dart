// Robust multi-language profanity / hate-speech filter.
//
// Evasion defence layers (applied in order):
//   1. Lowercase
//   2. Unicode/accented → ASCII  (à→a, ö→o, ü→u …)
//   3. Leet-speak substitution   (@ →a, 3→e, 0→o, $→s, 1→i …)
//   4. Repeated-char collapse    (fuuuck → fuck, shhiit → shit)
//   5. Inter-char separator strip (f.u.c.k / f u c k / f-u-c-k → fuck)
//   6. Word-boundary check on normalised text
//   7. Full-condensed check (no spaces at all) — compound evasions
//
// Native-script words (Cyrillic, CJK, Korean) are checked against the
// original text directly; the ASCII pipeline doesn't apply to them.

// ── Normalisation helpers ─────────────────────────────────────────────────

const Map<String, String> _leetMap = {
  '@': 'a', '4': 'a',
  '8': 'b',
  '(': 'c',
  '3': 'e', '€': 'e',
  '6': 'g', '9': 'g',
  '1': 'i', '!': 'i',
  '0': 'o',
  '\$': 's', '5': 's',
  '7': 't', '+': 't',
  '2': 'z',
};

String _applyLeet(String s) {
  var r = s;
  _leetMap.forEach((k, v) { r = r.replaceAll(k, v); });
  return r;
}

String _unicodeToAscii(String s) => s
    .replaceAll(RegExp(r'[àáâãäåāăą]'), 'a')
    .replaceAll(RegExp(r'[æ]'), 'ae')
    .replaceAll(RegExp(r'[çćčĉ]'), 'c')
    .replaceAll(RegExp(r'[ðď]'), 'd')
    .replaceAll(RegExp(r'[èéêëēĕėęě]'), 'e')
    .replaceAll(RegExp(r'[ĝğġģ]'), 'g')
    .replaceAll(RegExp(r'[ĥħ]'), 'h')
    .replaceAll(RegExp(r'[ìíîïīĭįı]'), 'i')
    .replaceAll(RegExp(r'[ĵ]'), 'j')
    .replaceAll(RegExp(r'[ķ]'), 'k')
    .replaceAll(RegExp(r'[ĺļľŀł]'), 'l')
    .replaceAll(RegExp(r'[ñńņňŋ]'), 'n')
    .replaceAll(RegExp(r'[òóôõöøōŏő]'), 'o')
    .replaceAll(RegExp(r'[œ]'), 'oe')
    .replaceAll(RegExp(r'[ŕŗř]'), 'r')
    .replaceAll(RegExp(r'[śŝşšș]'), 's')
    .replaceAll(RegExp(r'[ß]'), 'ss')
    .replaceAll(RegExp(r'[ţťŧț]'), 't')
    .replaceAll(RegExp(r'[þ]'), 'th')
    .replaceAll(RegExp(r'[ùúûüūŭůűų]'), 'u')
    .replaceAll(RegExp(r'[ŵ]'), 'w')
    .replaceAll(RegExp(r'[ýÿŷ]'), 'y')
    .replaceAll(RegExp(r'[źżž]'), 'z')
    // Cyrillic lookalikes used in ASCII-evasion
    .replaceAll('а', 'a').replaceAll('е', 'e').replaceAll('о', 'o')
    .replaceAll('р', 'r').replaceAll('с', 'c').replaceAll('у', 'u')
    .replaceAll('х', 'x').replaceAll('ь', 'b');

// Collapse 3+ repeated chars: fuuuck → fuck, shhit → shit
String _collapseRepeats(String s) =>
    s.replaceAllMapped(RegExp(r'(.)\1{2,}'), (m) => m.group(1)!);

// "f u c k" / "f.u.c.k" / "f-u-c-k" → "fuck"
String _deSpace(String s) => s.replaceAllMapped(
  RegExp(r'(?<=[a-z])[\s._\-*#+/\\|]{1,3}(?=[a-z])'),
  (_) => '',
);

// Full normalisation pipeline
String _norm(String raw) {
  var s = raw.toLowerCase();
  s = _unicodeToAscii(s);
  s = _applyLeet(s);
  s = _collapseRepeats(s);
  s = _deSpace(s);
  return s;
}

// Condensed (no non-alpha chars at all) — catches compound evasions
String _condense(String s) => s.replaceAll(RegExp(r'[^a-z]'), '');

// ── Word lists ────────────────────────────────────────────────────────────
//
// _latinWords : pre-normalised ASCII — matched against _norm() of input text.
// _nativeWords: Cyrillic / CJK / Korean — matched directly against original.
//
// All latin entries are already lowercase ASCII (no accents, no leet chars).
// Entries that contain another entry are intentionally kept for partial-word
// defence (e.g. "ass" inside "assassin" is prevented by word-boundary check,
// but "asshole" is still caught without needing a separate entry).

const Set<String> _latinWords = {
  // ── English ──────────────────────────────────────────────────────────
  'fuck', 'fucker', 'fucking', 'fucked', 'fuckhead', 'fuckface',
  'motherfucker', 'motherfucking',
  'shit', 'bullshit', 'shitty', 'shithead', 'horseshit',
  'bitch', 'bitches', 'bitchy', 'bitchass',
  'asshole', 'arsehole', 'arse',
  'cunt', 'cunts',
  'cock', 'cocks', 'cocksucker',
  'dick', 'dicks', 'dickhead',
  'pussy', 'pussies',
  'whore', 'whores',
  'slut', 'sluts',
  'bastard', 'bastards',
  'faggot', 'fag', 'fags',
  'nigger', 'niggers', 'nigga', 'niggaz',
  'retard', 'retarded',
  'spic', 'kike', 'chink', 'gook', 'wetback', 'coon',
  'twat', 'twats',
  'wanker', 'wank',
  'prick', 'pricks',
  'jizz', 'cum', 'cumshot',
  'rape', 'rapist', 'raping',
  'pedophile', 'paedophile', 'pedo', 'nonce',
  'nazi', 'heil', 'jihad', 'terrorist',
  'kill yourself', 'kys',

  // ── Turkish (ASCII-normalised: ş→s, ğ→g, ü→u, ö→o, ı→i, ç→c) ──────
  'sik', 'sikmek', 'sikeyim', 'sikiyor', 'sikis', 'siktir', 'siktigimin',
  'orospu', 'orospucocugu', 'orospucuk',
  'ibne', 'ibnelik',
  'gotveren', 'gotlek',
  'pic', 'piclerin', 'piclik', 'pic evladi',
  'amina', 'aminakoyim', 'amcik',
  'kahpe', 'kahpeler',
  'yarrak',
  'pezevenk',
  'kaltak',
  'yavsak',
  'bok', 'boktan',
  'mal', 'gerzek', 'salak', 'aptal', 'ahmak', 'dangalak', 'gerizekalı',

  // ── German (ß→ss, ä→a, ö→o, ü→u already handled) ──────────────────
  'scheisse', 'scheiss',
  'ficken', 'fick',
  'arschloch', 'arsch',
  'wichser', 'wichsen',
  'hurensohn', 'hure',
  'fotze',
  'nutte',
  'schlampe',
  'schwuchtel',
  'kacke',
  'sau', 'drecksau',
  'vollidiot',

  // ── French (accents normalised above) ───────────────────────────────
  'merde', 'merdes',
  'putain', 'putains',
  'salope', 'salopes',
  'connard', 'connards', 'connasse',
  'encule', 'enculer',
  'batard', 'batards',
  'couille', 'couilles',
  'niquer', 'nique',
  'pute', 'putes',
  'baiser',
  'chier',
  'bordel',

  // ── Italian ─────────────────────────────────────────────────────────
  'cazzo', 'cazzi',
  'stronzo', 'stronza', 'stronzi',
  'vaffanculo', 'vaffa',
  'puttana', 'puttane',
  'merda',
  'bastardo', 'bastarda',
  'coglione', 'coglioni',
  'fottere',
  'minchia',
  'culo',
  'troia',
  'porco',
  'figlio di puttana',

  // ── Polish (ą→a, ę→e, ó→o, ś→s, ź→z, ż→z, ł→l, ń→n, ć→c) ────────
  'kurwa', 'kurwy', 'kurewstwo',
  'chuj', 'chuja',
  'pizda', 'pizdy',
  'skurwysyn', 'skurwiel',
  'jebac', 'jebanie', 'jebany',
  'dupek', 'dupa',
  'zasraniec',
  'pierdolic', 'pierdolony',
  'cwel',
  'gnoj',
  'sukinsyn',
  'burdel',
};

// Native-script words checked directly against original text (case-sensitive off)
const List<String> _nativeWords = [
  // Japanese
  'くそ', 'うんこ', 'バカ', 'ばか', 'あほ', 'アホ',
  '死ね', '殺す', 'ファック', 'クソ',
  'チンポ', 'まんこ', 'ちんぽ',
  // Korean
  '씨발', '개새끼', '지랄', '꺼져', '닥쳐', '미친', '병신',
  '존나', '좆', '보지', '자지', '창녀', '매춘부', '개년', '찐따',
  // Russian (Cyrillic originals)
  'блять', 'блядь', 'пиздец', 'ебать', 'хуй', 'пизда',
  'сука', 'суки', 'мудак', 'мудаки', 'ёбаный',
  'залупа', 'шлюха', 'проститутка', 'ублюдок',
  'выблядок', 'долбоёб', 'дрочить', 'пиздобол',
];

// ── Public API ────────────────────────────────────────────────────────────

/// Returns true if [text] contains profanity or hate-speech after all
/// normalisation and evasion-detection layers.
bool containsProfanity(String text) {
  // Native-script direct check
  final lower = text.toLowerCase();
  for (final w in _nativeWords) {
    if (lower.contains(w)) return true;
  }

  // Latin pipeline
  final normed = _norm(text);
  final condensed = _condense(normed);

  for (final word in _latinWords) {
    // Word-boundary match on normalised-but-spaced text
    if (normed.contains(
        RegExp('(?<![a-z])${RegExp.escape(word)}(?![a-z])'))) {
      return true;
    }
    // Full-condensed match — catches "f u c k", "f.u.c.k", mixed evasions
    if (condensed.contains(word.replaceAll(' ', ''))) return true;
  }
  return false;
}
