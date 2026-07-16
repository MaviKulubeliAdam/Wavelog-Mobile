// Çağrı işareti prefix'inden bayrak emojisi ve etiket üretir.
// (Önceden QsoListTile widget'ının içindeydi — veri tablosu UI'dan ayrıldı.)

/// (bayrak emoji, etiket) veya null döner.
(String, String)? flagForCallsign(String callsign, String? country) {
  final cs = callsign.toUpperCase().replaceAll(RegExp(r'/.*'), '');

  // 1. Özel bayraklar (4→3→2→1 karakter, uzun önce)
  for (int len = 4; len >= 1; len--) {
    if (cs.length < len) continue;
    final prefix = cs.substring(0, len);
    final emoji = _specialEmoji[prefix];
    if (emoji != null) {
      return (emoji, _specialLabel[prefix] ?? prefix);
    }
  }

  // 2. Standart prefix → ISO → bayrak
  for (int len = 4; len >= 1; len--) {
    if (cs.length < len) continue;
    final iso = _prefixMap[cs.substring(0, len)];
    if (iso != null) return (_toFlag(iso), iso);
  }

  // 3. ADIF ülke adı yedek
  final iso = _isoFromCountry(country);
  if (iso != null) return (_toFlag(iso), iso);

  return null;
}

// ── Bölgesel gösterge → bayrak emoji ─────────────────────────────────────
String _toFlag(String iso) => iso.toUpperCase().codeUnits
    .map((c) => String.fromCharCode(c - 65 + 0x1F1E6))
    .join();

// ── Özel bayraklar (alt bölge/özel toprak) ───────────────────────────────
// Standart iki harfli ISO ile hesaplanamayan bayraklar buraya girer.
const _specialEmoji = <String, String>{
  // ── İngiltere (England) ──────────────────────────────────────────────
  'G'  : '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
  'M'  : '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
  '2E' : '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
  'GC' : '🏴󠁧󠁢󠁥󠁮󠁧󠁿',

  // ── Galler (Wales) ───────────────────────────────────────────────────
  'GW' : '🏴󠁧󠁢󠁷󠁬󠁳󠁿',
  'MW' : '🏴󠁧󠁢󠁷󠁬󠁳󠁿',
  '2W' : '🏴󠁧󠁢󠁷󠁬󠁳󠁿',
  '2C' : '🏴󠁧󠁢󠁷󠁬󠁳󠁿',

  // ── İskoçya (Scotland) ───────────────────────────────────────────────
  'GM' : '🏴󠁧󠁢󠁳󠁣󠁴󠁿',
  'MM' : '🏴󠁧󠁢󠁳󠁣󠁴󠁿',
  '2M' : '🏴󠁧󠁢󠁳󠁣󠁴󠁿',

  // ── Kuzey İrlanda (Northern Ireland) — standart Unicode emoji yok ────
  'GI' : '🇬🇧',
  'MI' : '🇬🇧',
  '2I' : '🇬🇧',

  // ── Man Adası (Isle of Man) ───────────────────────────────────────────
  'GD' : '🇮🇲',
  'MD' : '🇮🇲',
  '2D' : '🇮🇲',

  // ── Guernsey ─────────────────────────────────────────────────────────
  'GU' : '🇬🇬',
  'MU' : '🇬🇬',

  // ── Jersey ───────────────────────────────────────────────────────────
  'GJ' : '🇯🇪',
  'MJ' : '🇯🇪',

  // ── Cebelitarık (Gibraltar) ───────────────────────────────────────────
  'ZB' : '🇬🇮',

  // ── Porto Riko (Puerto Rico) ──────────────────────────────────────────
  'KP' : '🇵🇷', 'NP' : '🇵🇷', 'WP' : '🇵🇷',

  // ── Guam ─────────────────────────────────────────────────────────────
  'KH4': '🇬🇺',

  // ── Hawaii — ABD bayrağı ──────────────────────────────────────────────
  'KH6': '🇺🇸', 'KH7': '🇺🇸',

  // ── Alaska — ABD bayrağı ──────────────────────────────────────────────
  'KL' : '🇺🇸', 'NL' : '🇺🇸', 'WL' : '🇺🇸',

  // ── Faroe Adaları ─────────────────────────────────────────────────────
  'OY' : '🇫🇴',

  // ── Grönland ──────────────────────────────────────────────────────────
  'OX' : '🇬🇱',

  // ── Åland Adaları (OH0) ───────────────────────────────────────────────
  'OH0': '🇦🇽',

  // ── Kanaryalar (EA8) — İspanya bayrağı ────────────────────────────────
  'EA8': '🇮🇨',

  // ── Madeira (CT3) — Portekiz bayrağı ─────────────────────────────────
  'CT3': '🇵🇹',

  // ── Azorlar (CU) — Portekiz bayrağı ──────────────────────────────────
  'CU' : '🇵🇹',

  // ── Korsika — Fransa bayrağı ──────────────────────────────────────────
  'TK' : '🇫🇷',

  // ── Reunion (FR/TO) ───────────────────────────────────────────────────
  'FR' : '🇷🇪',

  // ── Martinik ─────────────────────────────────────────────────────────
  'FM' : '🇲🇶',

  // ── Mayotte ──────────────────────────────────────────────────────────
  'FH' : '🇾🇹',

  // ── Yeni Kaledonya ────────────────────────────────────────────────────
  'FK' : '🇳🇨',

  // ── Fransız Polinezyası ───────────────────────────────────────────────
  'FO' : '🇵🇫',

  // ── Wallis & Futuna ───────────────────────────────────────────────────
  'FW' : '🇼🇫',

  // ── Kosova — resmi Unicode emoji yok ─────────────────────────────────
  'Z6' : '🇽🇰',

  // ── Kıbrıs ───────────────────────────────────────────────────────────
  '5B' : '🇨🇾',
  'P3' : '🇨🇾',

  // ── Hong Kong ─────────────────────────────────────────────────────────
  'VR' : '🇭🇰',

  // ── Makao ────────────────────────────────────────────────────────────
  'XX' : '🇲🇴',
};

const _specialLabel = <String, String>{
  'G': 'ENG', 'M': 'ENG', '2E': 'ENG', 'GC': 'ENG',
  'GW': 'WAL', 'MW': 'WAL', '2W': 'WAL', '2C': 'WAL',
  'GM': 'SCO', 'MM': 'SCO', '2M': 'SCO',
  'GI': 'NIR', 'MI': 'NIR', '2I': 'NIR',
  'GD': 'IM',  'MD': 'IM',  '2D': 'IM',
  'GU': 'GG',  'MU': 'GG',
  'GJ': 'JE',  'MJ': 'JE',
  'ZB': 'GIB',
  'KP': 'PR',  'NP': 'PR',  'WP': 'PR',
  'KH4': 'GUM',
  'KH6': 'HAW', 'KH7': 'HAW',
  'KL': 'AK',  'NL': 'AK',  'WL': 'AK',
  'OY': 'FO',
  'OX': 'GL',
  'OH0': 'AX',
  'EA8': 'IC',
  'CT3': 'MDR',
  'CU': 'AZR',
  'TK': 'COR',
  'FR': 'RE',  'FM': 'MQ',  'FH': 'YT',
  'FK': 'NC',  'FO': 'PF',  'FW': 'WF',
  'Z6': 'XK',
  '5B': 'CY',  'P3': 'CY',
  'VR': 'HK',
  'XX': 'MO',
};

// ── Standart prefix → ISO 3166-1 alpha-2 ─────────────────────────────────
// Not: İngiltere alt bölgeleri (_specialEmoji) burada YOK.
const _prefixMap = <String, String>{
  // ── Türkiye ──────────────────────────────────────────────────────────
  'TA': 'TR', 'TB': 'TR', 'TC': 'TR',

  // ── Almanya ──────────────────────────────────────────────────────────
  'DA': 'DE', 'DB': 'DE', 'DC': 'DE', 'DD': 'DE', 'DE': 'DE',
  'DF': 'DE', 'DG': 'DE', 'DH': 'DE', 'DI': 'DE', 'DJ': 'DE',
  'DK': 'DE', 'DL': 'DE', 'DM': 'DE', 'DN': 'DE', 'DO': 'DE',
  'DP': 'DE', 'DQ': 'DE', 'DR': 'DE',

  // ── Polonya ──────────────────────────────────────────────────────────
  'SP': 'PL', 'SQ': 'PL', 'SR': 'PL', 'SN': 'PL', 'SO': 'PL',
  'HF': 'PL', '3Z': 'PL',

  // ── Japonya ──────────────────────────────────────────────────────────
  'JA': 'JP', 'JB': 'JP', 'JC': 'JP', 'JD': 'JP', 'JE': 'JP',
  'JF': 'JP', 'JG': 'JP', 'JH': 'JP', 'JI': 'JP', 'JJ': 'JP',
  'JK': 'JP', 'JL': 'JP', 'JM': 'JP', 'JN': 'JP', 'JO': 'JP',
  'JP': 'JP', 'JQ': 'JP', 'JR': 'JP', 'JS': 'JP',
  '7J': 'JP', '7K': 'JP', '7L': 'JP', '7M': 'JP', '7N': 'JP',
  '8J': 'JP', '8K': 'JP', '8L': 'JP', '8M': 'JP', '8N': 'JP',

  // ── İtalya ───────────────────────────────────────────────────────────
  'IK': 'IT', 'IZ': 'IT', 'IW': 'IT', 'IU': 'IT', 'IV': 'IT',
  'II': 'IT', 'IO': 'IT', 'IR': 'IT', 'IS': 'IT',
  'I' : 'IT',

  // ── İspanya ──────────────────────────────────────────────────────────
  'EA': 'ES', 'EB': 'ES', 'EC': 'ES', 'ED': 'ES', 'EE': 'ES',
  'EF': 'ES', 'EG': 'ES', 'EH': 'ES',
  'AM': 'ES', 'AN': 'ES', 'AO': 'ES',

  // ── Fransa ───────────────────────────────────────────────────────────
  'F' : 'FR', 'TM': 'FR', 'TO': 'FR',

  // ── Hollanda ─────────────────────────────────────────────────────────
  'PA': 'NL', 'PB': 'NL', 'PC': 'NL', 'PD': 'NL', 'PE': 'NL',
  'PF': 'NL', 'PG': 'NL', 'PH': 'NL', 'PI': 'NL',

  // ── Belçika ──────────────────────────────────────────────────────────
  'ON': 'BE', 'OO': 'BE', 'OT': 'BE',

  // ── İsveç ────────────────────────────────────────────────────────────
  'SA': 'SE', 'SB': 'SE', 'SC': 'SE', 'SD': 'SE', 'SE': 'SE',
  'SF': 'SE', 'SG': 'SE', 'SH': 'SE', 'SI': 'SE', 'SJ': 'SE',
  'SK': 'SE', 'SL': 'SE', 'SM': 'SE',
  '7S': 'SE', '8S': 'SE',

  // ── Norveç ───────────────────────────────────────────────────────────
  'LA': 'NO', 'LB': 'NO', 'LC': 'NO', 'LD': 'NO', 'LE': 'NO',
  'LF': 'NO', 'LG': 'NO', 'LH': 'NO', 'LI': 'NO', 'LJ': 'NO',
  'LK': 'NO', 'LL': 'NO', 'LM': 'NO', 'LN': 'NO',

  // ── Finlandiya ───────────────────────────────────────────────────────
  'OF': 'FI', 'OG': 'FI', 'OH': 'FI', 'OI': 'FI', 'OJ': 'FI',

  // ── Danimarka ────────────────────────────────────────────────────────
  'OU': 'DK', 'OV': 'DK', 'OW': 'DK', 'OZ': 'DK',

  // ── İsviçre ──────────────────────────────────────────────────────────
  'HB': 'CH', 'HE': 'CH',

  // ── Avusturya ────────────────────────────────────────────────────────
  'OE': 'AT',

  // ── Çek Cumhuriyeti ──────────────────────────────────────────────────
  'OK': 'CZ', 'OL': 'CZ',

  // ── Slovakya ─────────────────────────────────────────────────────────
  'OM': 'SK',

  // ── Macaristan ───────────────────────────────────────────────────────
  'HA': 'HU', 'HG': 'HU',

  // ── Romanya ──────────────────────────────────────────────────────────
  'YO': 'RO', 'YP': 'RO', 'YQ': 'RO', 'YR': 'RO',

  // ── Bulgaristan ──────────────────────────────────────────────────────
  'LZ': 'BG',

  // ── Sırbistan ────────────────────────────────────────────────────────
  'YT': 'RS', 'YU': 'RS',

  // ── Hırvatistan ──────────────────────────────────────────────────────
  '9A': 'HR',

  // ── Slovenya ─────────────────────────────────────────────────────────
  'S5': 'SI',

  // ── Ukrayna ──────────────────────────────────────────────────────────
  'UR': 'UA', 'US': 'UA', 'UT': 'UA', 'UU': 'UA', 'UV': 'UA',
  'UW': 'UA', 'UX': 'UA', 'UY': 'UA', 'UZ': 'UA',
  'EM': 'UA', 'EN': 'UA', 'EO': 'UA',

  // ── Rusya ────────────────────────────────────────────────────────────
  'UA': 'RU', 'UB': 'RU', 'UC': 'RU', 'UD': 'RU', 'UE': 'RU',
  'UF': 'RU', 'UG': 'RU', 'UH': 'RU', 'UI': 'RU',
  'R' : 'RU',
  'RA': 'RU', 'RB': 'RU', 'RC': 'RU', 'RD': 'RU', 'RE': 'RU',
  'RF': 'RU', 'RG': 'RU', 'RJ': 'RU', 'RK': 'RU', 'RL': 'RU',
  'RM': 'RU', 'RN': 'RU', 'RO': 'RU', 'RP': 'RU', 'RQ': 'RU',
  'RR': 'RU', 'RS': 'RU', 'RT': 'RU', 'RU': 'RU', 'RV': 'RU',
  'RW': 'RU', 'RX': 'RU', 'RY': 'RU', 'RZ': 'RU',

  // ── Beyaz Rusya ──────────────────────────────────────────────────────
  'EU': 'BY', 'EV': 'BY', 'EW': 'BY',

  // ── Litvanya ─────────────────────────────────────────────────────────
  'LY': 'LT',

  // ── Letonya ──────────────────────────────────────────────────────────
  'YL': 'LV',

  // ── Estonya ──────────────────────────────────────────────────────────
  'ES': 'EE',

  // ── Yunanistan ───────────────────────────────────────────────────────
  'SV': 'GR', 'SX': 'GR', 'SY': 'GR', 'SZ': 'GR', 'J4': 'GR',

  // ── Portekiz ─────────────────────────────────────────────────────────
  'CT': 'PT', 'CR': 'PT', 'CS': 'PT',

  // ── Amerika ──────────────────────────────────────────────────────────
  'AA': 'US', 'AB': 'US', 'AC': 'US', 'AD': 'US', 'AE': 'US',
  'AF': 'US', 'AG': 'US', 'AH': 'US', 'AI': 'US', 'AJ': 'US',
  'AK': 'US', 'AL': 'US',
  'K' : 'US', 'N' : 'US', 'W' : 'US',
  'KH': 'US', 'WH': 'US', 'NH': 'US',

  // ── Kanada ───────────────────────────────────────────────────────────
  'VA': 'CA', 'VB': 'CA', 'VC': 'CA', 'VD': 'CA', 'VE': 'CA',
  'VF': 'CA', 'VG': 'CA', 'VY': 'CA',
  'CF': 'CA', 'CG': 'CA', 'CI': 'CA', 'CK': 'CA',

  // ── Avustralya ───────────────────────────────────────────────────────
  'VH': 'AU', 'VI': 'AU', 'VJ': 'AU', 'VK': 'AU', 'VL': 'AU',
  'VM': 'AU', 'VN': 'AU', 'VZ': 'AU',
  'AX': 'AU',

  // ── Yeni Zelanda ─────────────────────────────────────────────────────
  'ZK': 'NZ', 'ZL': 'NZ', 'ZM': 'NZ',

  // ── Brezilya ─────────────────────────────────────────────────────────
  'PP': 'BR', 'PQ': 'BR', 'PR': 'BR', 'PS': 'BR', 'PT': 'BR',
  'PU': 'BR', 'PV': 'BR', 'PW': 'BR', 'PX': 'BR', 'PY': 'BR',
  'ZV': 'BR', 'ZW': 'BR', 'ZX': 'BR', 'ZY': 'BR', 'ZZ': 'BR',

  // ── Arjantin ─────────────────────────────────────────────────────────
  'AY': 'AR', 'AZ': 'AR',
  'LO': 'AR', 'LP': 'AR', 'LQ': 'AR', 'LR': 'AR', 'LS': 'AR',
  'LT': 'AR', 'LU': 'AR', 'LV': 'AR', 'LW': 'AR',

  // ── Lüksemburg ───────────────────────────────────────────────────────
  'LX': 'LU',

  // ── İrlanda ──────────────────────────────────────────────────────────
  'EI': 'IE', 'EJ': 'IE',

  // ── İzlanda ──────────────────────────────────────────────────────────
  'TF': 'IS',

  // ── Çin ──────────────────────────────────────────────────────────────
  'BA': 'CN', 'BT': 'CN', 'BY': 'CN', 'BZ': 'CN',
  'B' : 'CN',

  // ── Tayvan ───────────────────────────────────────────────────────────
  'BV': 'TW',

  // ── Güney Kore ───────────────────────────────────────────────────────
  'DS': 'KR', 'DT': 'KR', 'HL': 'KR',
  '6K': 'KR', '6L': 'KR', '6M': 'KR', '6N': 'KR',

  // ── Hindistan ────────────────────────────────────────────────────────
  'AT': 'IN', 'AU': 'IN', 'AV': 'IN', 'AW': 'IN',
  'VU': 'IN',

  // ── İsrail ───────────────────────────────────────────────────────────
  '4X': 'IL', '4Z': 'IL',

  // ── Suudi Arabistan ──────────────────────────────────────────────────
  'HZ': 'SA', '7Z': 'SA', '8Z': 'SA',

  // ── BAE ──────────────────────────────────────────────────────────────
  'A6': 'AE',

  // ── Katar ────────────────────────────────────────────────────────────
  'A7': 'QA',

  // ── Bahreyn ──────────────────────────────────────────────────────────
  'A9': 'BH',

  // ── Umman ────────────────────────────────────────────────────────────
  'A4': 'OM',

  // ── Kuveyt ───────────────────────────────────────────────────────────
  '9K': 'KW',

  // ── Ürdün ────────────────────────────────────────────────────────────
  'JY': 'JO',

  // ── Lübnan ───────────────────────────────────────────────────────────
  'OD': 'LB',

  // ── Suriye ───────────────────────────────────────────────────────────
  'YK': 'SY',

  // ── Irak ─────────────────────────────────────────────────────────────
  'HN': 'IQ', 'YI': 'IQ',

  // ── İran ─────────────────────────────────────────────────────────────
  'EP': 'IR', 'EQ': 'IR',

  // ── Pakistan ─────────────────────────────────────────────────────────
  'AP': 'PK', 'AS': 'PK',

  // ── Güney Afrika ─────────────────────────────────────────────────────
  'ZR': 'ZA', 'ZS': 'ZA', 'ZT': 'ZA', 'ZU': 'ZA',

  // ── Mısır ────────────────────────────────────────────────────────────
  'SU': 'EG',

  // ── Kazakistan ───────────────────────────────────────────────────────
  'UN': 'KZ', 'UO': 'KZ', 'UP': 'KZ', 'UQ': 'KZ',

  // ── Azerbaycan ───────────────────────────────────────────────────────
  '4J': 'AZ', '4K': 'AZ',

  // ── Gürcistan ────────────────────────────────────────────────────────
  '4L': 'GE',

  // ── Ermenistan ───────────────────────────────────────────────────────
  'EK': 'AM',

  // ── Kırgızistan ──────────────────────────────────────────────────────
  'EX': 'KG',

  // ── Tacikistan ───────────────────────────────────────────────────────
  'EY': 'TJ',

  // ── Türkmenistan ─────────────────────────────────────────────────────
  'EZ': 'TM',

  // ── Moldova ──────────────────────────────────────────────────────────
  'ER': 'MD',

  // ── Makedonya ────────────────────────────────────────────────────────
  'Z3': 'MK',

  // ── Karadağ ──────────────────────────────────────────────────────────
  '4O': 'ME',

  // ── Bosna Hersek ─────────────────────────────────────────────────────
  'E7': 'BA', 'T9': 'BA',

  // ── Arnavutluk ───────────────────────────────────────────────────────
  'ZA': 'AL',

  // ── Endonezya ────────────────────────────────────────────────────────
  'YB': 'ID', 'YC': 'ID', 'YD': 'ID', 'YE': 'ID',
  'YF': 'ID', 'YG': 'ID', 'YH': 'ID',

  // ── Filipinler ───────────────────────────────────────────────────────
  'DU': 'PH', 'DV': 'PH', 'DW': 'PH', 'DX': 'PH', 'DY': 'PH',
  'DZ': 'PH',

  // ── Tayland ──────────────────────────────────────────────────────────
  'HS': 'TH', 'E2': 'TH',

  // ── Malezya ──────────────────────────────────────────────────────────
  '9M': 'MY',

  // ── Singapur ─────────────────────────────────────────────────────────
  '9V': 'SG',

  // ── Vietnam ──────────────────────────────────────────────────────────
  '3W': 'VN', 'XV': 'VN',

  // ── Meksika ──────────────────────────────────────────────────────────
  'XA': 'MX', 'XB': 'MX', 'XC': 'MX', 'XD': 'MX',
  'XE': 'MX', 'XF': 'MX',
  '4A': 'MX', '4B': 'MX', '6D': 'MX',

  // ── Küba ─────────────────────────────────────────────────────────────
  'CM': 'CU', 'CO': 'CU', 'CL': 'CU', 'T4': 'CU',

  // ── Mongolya ─────────────────────────────────────────────────────────
  'JT': 'MN', 'JU': 'MN', 'JV': 'MN',

  // ── Fas ──────────────────────────────────────────────────────────────
  'CN': 'MA',

  // ── Tunus ────────────────────────────────────────────────────────────
  '3V': 'TN', 'TS': 'TN',

  // ── Cezayir ──────────────────────────────────────────────────────────
  '7R': 'DZ', '7T': 'DZ', '7U': 'DZ', '7V': 'DZ',
  '7W': 'DZ', '7X': 'DZ', '7Y': 'DZ',

  // ── Libya ────────────────────────────────────────────────────────────
  '5A': 'LY',

  // ── Nijerya ──────────────────────────────────────────────────────────
  '5N': 'NG',

  // ── Gana ─────────────────────────────────────────────────────────────
  '9G': 'GH',

  // ── Kenya ────────────────────────────────────────────────────────────
  '5Z': 'KE',

  // ── Kolombiya ────────────────────────────────────────────────────────
  'HJ': 'CO', 'HK': 'CO', '5J': 'CO', '5K': 'CO',

  // ── Şili ─────────────────────────────────────────────────────────────
  'CA': 'CL', 'CB': 'CL', 'CC': 'CL', 'CD': 'CL', 'CE': 'CL',
  'XQ': 'CL', 'XR': 'CL',

  // ── Peru ─────────────────────────────────────────────────────────────
  'OA': 'PE', 'OB': 'PE', 'OC': 'PE',

  // ── Uruguay ──────────────────────────────────────────────────────────
  'CV': 'UY', 'CW': 'UY',

  // ── Andorra ──────────────────────────────────────────────────────────
  'C3': 'AD',

  // ── San Marino ───────────────────────────────────────────────────────
  'T7': 'SM',

  // ── Monako ───────────────────────────────────────────────────────────
  '3A': 'MC',

  // ── Vatikan ──────────────────────────────────────────────────────────
  'HV': 'VA',

  // ── Malta ────────────────────────────────────────────────────────────
  '9H': 'MT',

  // ── Namibya ──────────────────────────────────────────────────────────
  'V5': 'NA',
};

// ── ADIF ülke adı → ISO (prefix map'te bulunamazsa) ──────────────────────
String? _isoFromCountry(String? country) {
  if (country == null || country.isEmpty) return null;
  return _countryMap[country];
}

const _countryMap = <String, String>{
  'Fed. Rep. of Germany': 'DE', 'Federal Republic of Germany': 'DE',
  'Germany': 'DE',
  'European Russia': 'RU', 'Asiatic Russia': 'RU', 'Russia': 'RU',
  'Turkey': 'TR', 'Türkiye': 'TR',
  'Poland': 'PL',
  'Japan': 'JP',
  'United States': 'US', 'USA': 'US',
  'Italy': 'IT',
  'Spain': 'ES',
  'France': 'FR',
  'England': 'GB', 'Scotland': 'GB', 'Wales': 'GB',
  'Northern Ireland': 'GB', 'United Kingdom': 'GB',
  'Netherlands': 'NL',
  'Belgium': 'BE',
  'Sweden': 'SE',
  'Norway': 'NO',
  'Finland': 'FI',
  'Denmark': 'DK',
  'Switzerland': 'CH',
  'Austria': 'AT',
  'Czech Republic': 'CZ', 'Czechia': 'CZ',
  'Slovak Republic': 'SK', 'Slovakia': 'SK',
  'Hungary': 'HU',
  'Romania': 'RO',
  'Bulgaria': 'BG',
  'Serbia': 'RS',
  'Croatia': 'HR',
  'Slovenia': 'SI',
  'Ukraine': 'UA',
  'Belarus': 'BY',
  'Lithuania': 'LT',
  'Latvia': 'LV',
  'Estonia': 'EE',
  'Greece': 'GR',
  'Portugal': 'PT',
  'Canada': 'CA',
  'Australia': 'AU',
  'New Zealand': 'NZ',
  'Brazil': 'BR',
  'Argentina': 'AR',
  'China': 'CN',
  'South Korea': 'KR',
  'India': 'IN',
  'Israel': 'IL',
  'South Africa': 'ZA',
  'Egypt': 'EG',
  'Kazakhstan': 'KZ',
  'Azerbaijan': 'AZ',
  'Georgia': 'GE',
  'Armenia': 'AM',
  'Moldova': 'MD',
  'Luxembourg': 'LU',
  'Ireland': 'IE',
  'Iceland': 'IS',
  'Malta': 'MT',
  'Cyprus': 'CY',
  'Mexico': 'MX',
  'Chile': 'CL',
  'Colombia': 'CO',
  'Peru': 'PE',
  'Uruguay': 'UY',
  'Indonesia': 'ID',
  'Philippines': 'PH',
  'Thailand': 'TH',
  'Malaysia': 'MY',
  'Singapore': 'SG',
  'Vietnam': 'VN',
  'Pakistan': 'PK',
  'Saudi Arabia': 'SA',
  'United Arab Emirates': 'AE',
  'Qatar': 'QA',
  'Kuwait': 'KW',
  'Bahrain': 'BH',
  'Oman': 'OM',
  'Jordan': 'JO',
  'Lebanon': 'LB',
  'Syria': 'SY',
  'Iraq': 'IQ',
  'Iran': 'IR',
  'Morocco': 'MA',
  'Tunisia': 'TN',
  'Algeria': 'DZ',
  'Libya': 'LY',
  'North Macedonia': 'MK', 'Macedonia': 'MK',
  'Bosnia-Herzegovina': 'BA',
  'Montenegro': 'ME',
  'Albania': 'AL',
  'Andorra': 'AD',
  'San Marino': 'SM',
  'Monaco': 'MC',
  'Taiwan': 'TW',
  'Hong Kong': 'HK',
  'Mongolia': 'MN',
  'Greenland': 'GL',
  'Faroe Islands': 'FO',
  'Kosovo': 'XK',
  'Kyrgyzstan': 'KG',
  'Tajikistan': 'TJ',
  'Turkmenistan': 'TM',
  'Nigeria': 'NG',
  'Ghana': 'GH',
  'Kenya': 'KE',
  'Gibraltar': 'GI',
  'Isle of Man': 'IM',
  'Guernsey': 'GG',
  'Jersey': 'JE',
};
