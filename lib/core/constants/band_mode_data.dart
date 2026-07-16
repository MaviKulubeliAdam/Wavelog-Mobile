const List<String> kCommonBands = [
  '160m', '80m', '60m', '40m', '30m', '20m', '17m', '15m', '12m',
  '10m', '6m', '2m', '70cm',
];

const Map<String, double> kBandCenterFreqMhz = {
  '160m': 1.850,
  '80m': 3.750,
  '60m': 5.357,
  '40m': 7.100,
  '30m': 10.125,
  '20m': 14.225,
  '17m': 18.130,
  '15m': 21.300,
  '12m': 24.940,
  '10m': 28.500,
  '6m': 50.150,
  '2m': 144.300,
  '70cm': 432.100,
};

const List<String> kCommonModes = [
  'SSB', 'CW', 'FT8', 'FT4', 'FM', 'AM', 'RTTY', 'PSK31', 'JS8',
];

const Map<String, List<String>> kSubmodes = {
  'SSB': ['USB', 'LSB'],
  'AM':  ['DSB', 'LSB', 'USB'],
  'FM':  ['NFM', 'WFM'],
};

const Map<String, String> kDefaultRst = {
  'SSB': '59',
  'AM': '59',
  'FM': '59',
  'CW': '599',
  'RTTY': '599',
  'FT8': '-10',
  'FT4': '-10',
  'JS8': '-10',
  'WSPR': '-10',
  'JT65': '-10',
  'JT9': '-10',
  'PSK31': '599',
};

String getDefaultRst(String mode) {
  return kDefaultRst[mode.toUpperCase()] ?? '59';
}

// Tek band-frekans tablosu — spot modelleri ve QSO formu bunu paylaşır.
// (Önceden 5 ayrı kopyası vardı.)
String? bandFromKhz(double khz) {
  if (khz >= 1800 && khz <= 2000) return '160m';
  if (khz >= 3500 && khz <= 4000) return '80m';
  if (khz >= 5300 && khz <= 5410) return '60m';
  if (khz >= 7000 && khz <= 7300) return '40m';
  if (khz >= 10100 && khz <= 10150) return '30m';
  if (khz >= 14000 && khz <= 14350) return '20m';
  if (khz >= 18068 && khz <= 18168) return '17m';
  if (khz >= 21000 && khz <= 21450) return '15m';
  if (khz >= 24890 && khz <= 24990) return '12m';
  if (khz >= 28000 && khz <= 29700) return '10m';
  if (khz >= 50000 && khz <= 54000) return '6m';
  if (khz >= 144000 && khz <= 148000) return '2m';
  if (khz >= 420000 && khz <= 450000) return '70cm';
  return null;
}

String? getBandFromFreq(double freqMhz) => bandFromKhz(freqMhz * 1000);
