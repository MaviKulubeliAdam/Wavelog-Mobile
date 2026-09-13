# Wavelog Mobile — Design System

Kaynak: `lib/core/theme/app_theme.dart`. Bu dosya kalıcı stil rehberi — Faz D'deki
her paralel ajanın sabit girdisi. Buradaki değerler değişirse önce `app_theme.dart`
güncellenir, sonra bu dosya senkron tutulur.

Onaylanan görsel önizleme: [Wavelog Redesign artifact](https://claude.ai/code/artifact/8d7f70e4-7c20-4983-9bc9-31298678911b)
(2026-09-13 tarihinde kullanıcı tarafından onaylandı).

## Renk

**2026-09-13 güncellemesi:** İlk redesign turunda marka rengi (Sky mavi) ve Slate
nötrler bilinçli olarak korunmuştu — kullanıcı geri bildirimi bunun yetersiz
kaldığını, gerçekten farklı bir tema istediğini gösterdi. Palet tamamen
değiştirildi: **Sky mavi → Orange-600, Slate (soğuk gri) → Stone (sıcak gri)**.

60/30/10 kuralı:

| Rol | Kaynak | Pay |
|---|---|---|
| Nötr yüzey (bg/surface/border) | Tailwind Stone ölçeği | ~60% |
| Marka / etkileşim | `_seed` — Orange-600 `#EA580C` | ~30% |
| Vurgu (odak halkası, on-air, semantik) | `kAccentElectric` (Teal-600 `#0891B2`), `kOnAir` (Amber-400 `#FBBF24`), `AppSemanticColors` | ~10% |

Semantik renkler (`AppSemanticColors`, `Theme.of(context).extension()` veya
`context.semanticColors`) — QSO durumları için, marka renginin yerine geçmez.
`duplicate` turuncu/amber değil pembe seçildi — artık marka rengiyle
(`_seed`) çakışmaması için:

| Anlam | Koyu tema | Açık tema |
|---|---|---|
| Onaylı (LoTW/eQSL) | `#10B981` | `#059669` |
| Olası tekrar (dupe) | `#EC4899` | `#DB2777` |
| Yeni DXCC ("needed") | `#8B5CF6` | `#7C3AED` |

Orange seed ve Stone nötrler artık marka çıpası — bir sonraki palet
değişikliğinde de bu bölüm güncellenmeli.

## Tipografi

Üç aile, toplam max 4 boyut / 2 ağırlık kuralına uyulur (her ailenin kendi içinde):

| Rol | Aile | Ağırlıklar | Nerede |
|---|---|---|---|
| Başlık | Manrope | 700, 800 | AppBar/Dialog başlıkları, `headlineLarge/Medium/Small`, `titleLarge` |
| Gövde/UI | Inter | 400, 500, 600 | `ThemeData.fontFamily` — her yerin varsayılanı |
| Veri (mono) | JetBrains Mono | 500, 600 | Çağrı işareti, RST, grid kare, frekans, ADIF dökümü |

Sabitler: `kHeadingFontFamily`, `kBodyFontFamily`, `kMonoFontFamily`,
`monoLabelLarge/Medium/Small` (`lib/core/theme/app_theme.dart`).

**Kritik kısıtlama:** Fontlar `assets/fonts/` altına gömülü (OFL lisanslı, Google
Fonts'tan tek seferlik indirildi) — `google_fonts` paketinin çalışma-zamanı CDN
indirmesi **kullanılmıyor**. Uygulama sahada offline kullanılıyor ve F-Droid
derlemesi ağ bağımlılığına duyarlı; bu yüzden hiçbir ekran fontu ilk açılışta
internetten çekmemeli.

JetBrains Mono özellikle seçildi: 0/O ve 1/l/I karışmasını önlüyor — çağrı
işaretleri ve grid kareleri harf+rakam karışımı olduğu için bu önemli.

## Boşluk & Köşe Yarıçapı

8px ızgara: 8 / 16 / 24 / 32 / 40 / 48.

| Öğe | Radius |
|---|---|
| Kart | 16 |
| Girdi | 12 |
| Buton | 12 |
| Diyalog | 20 |
| Snackbar | 12 |
| Chip/Switch | 999 (tam yuvarlak) |

Sabitler: `_cardRadius`, `_inputRadius`, `_buttonRadius`, `_dialogRadius`,
`_snackRadius` (`app_theme.dart` içinde private — yeni bir yerden radius
gerekiyorsa bu sabitleri public'e çıkarmak yerine aynı sayısal değeri kullan).

## Navigasyon

İki kabuk da korunuyor (`lib/router.dart`): `_ClassicShell` (6 sekmeli
`NavigationBar`) ve `_ModernShell` (4 sekme + FAB + `Drawer`). İkisi de artık
merkezi temadan besleniyor (`navigationBarTheme`, `bottomAppBarTheme`,
`drawerTheme`). Birleştirme bu modernizasyonun kapsamı dışında — kullanıcı
tercihi olarak (`useModernNav`) ikisi de canlı kalmaya devam ediyor.

## Ekranlarda Kullanım Kuralları

- Yeni bir ekran/widget yazarken **renk/font/radius'u asla elle (hardcoded)
  girme** — `Theme.of(context)` üzerinden veya yukarıdaki sabitlerden al.
- Çağrı işareti, RST, grid kare, frekans gibi "veri" alanları → mono stil.
- Onaylı/tekrar/yeni-DXCC göstergesi gerekiyorsa → `context.semanticColors`,
  ham renk literal'i yazma.
- 800 satır sınırına yaklaşan dosyalarda (`add_qso_screen.dart`,
  `contest_log_screen.dart`, `statistics_screen.dart`, `settings_screen.dart`,
  `chat_screen.dart`) görsel değişiklik markup eklemeyi gerektiriyorsa, önce
  ilgili bölümü ayrı bir widget dosyasına çıkar — sunum katmanı çıkarma her
  zaman serbest, state/provider mantığına dokunma.
