// Per-language bad-word lists. Keys match chat room IDs.
// Words are stored lower-case; matching is case-insensitive.
const Map<String, List<String>> _wordLists = {
  'en': ['fuck', 'shit', 'bitch', 'asshole', 'cunt', 'bastard', 'damn', 'dick', 'cock', 'pussy', 'faggot', 'nigger', 'whore', 'slut'],
  'tr': ['sik', 'orospu', 'ibne', 'göt', 'piç', 'amk', 'amına', 'oç', 'salak', 'aptal', 'mal', 'gerizekalı', 'kahpe'],
  'de': ['scheiße', 'scheiss', 'ficken', 'arschloch', 'wichser', 'hurensohn', 'fotze', 'nutte', 'dummkopf'],
  'fr': ['merde', 'putain', 'salope', 'connard', 'enculé', 'bâtard', 'couille', 'niquer'],
  'it': ['cazzo', 'stronzo', 'vaffanculo', 'puttana', 'merda', 'bastardo', 'coglione', 'fottere'],
  'pl': ['kurwa', 'chuj', 'pizda', 'skurwysyn', 'jebać', 'dupek', 'zasraniec', 'pierdolić'],
  'ja': ['くそ', 'うんこ', 'バカ', 'あほ', '死ね', '殺す', 'ファック'],
  'ko': ['씨발', '개새끼', '지랄', '꺼져', '닥쳐', '미친', '병신'],
  'ru': ['блять', 'блядь', 'пиздец', 'ебать', 'хуй', 'пизда', 'сука', 'мудак', 'ёбаный'],
  'general': [], // inherits English list
};

// Returns the text with bad words replaced by asterisks.
// `roomId` selects the language list; falls back to English.
String filterProfanity(String text, String roomId) {
  final words = _wordLists[roomId] ?? _wordLists['en']!;
  // 'general' room uses English list
  final effectiveWords = words.isEmpty ? (_wordLists['en']!) : words;

  var result = text;
  for (final word in effectiveWords) {
    // word-boundary-like match: surround by non-letter characters
    final pattern = RegExp(
      '(?<=[^\\p{L}]|^)${RegExp.escape(word)}(?=[^\\p{L}]|\$)',
      caseSensitive: false,
      unicode: true,
    );
    result = result.replaceAllMapped(
      pattern,
      (m) => '*' * m.group(0)!.length,
    );
  }
  return result;
}

bool containsProfanity(String text, String roomId) =>
    filterProfanity(text, roomId) != text;
