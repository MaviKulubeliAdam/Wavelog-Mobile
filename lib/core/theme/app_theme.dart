import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Seed & Palette ────────────────────────────────────────────────────────────
const Color _seed = Color(0xFFEA580C); // Orange-600 — warm, RF/energy

// ── Contrast accent (additive) ───────────────────────────────────────────────
/// Teal-600 — used for loaders, focus rings and the splash glow.
/// Additive only: does not replace existing palette colors.
const Color kAccentElectric = Color(0xFF0891B2);

/// "On-air"/pending-sync badge — amber, deliberately a different hue from the
/// orange brand seed so it still reads as a distinct alert, not the brand color.
const Color kOnAir = Color(0xFFFBBF24);

// Dark palette (Tailwind Stone family — warm neutrals to match the orange seed)
const Color _darkBg = Color(0xFF1C1917);        // stone-900
const Color _darkSurface = Color(0xFF292524);   // stone-800
const Color _darkBorderSubtle = Color(0xFF262220);
const Color _darkBorderMid = Color(0xFF3D3632);
const Color _darkBorder = Color(0xFF57534E);    // stone-600

// Light palette
const Color _lightBg = Color(0xFFF5F5F4);       // stone-100
const Color _lightSurface = Color(0xFFFFFFFF);
const Color _lightSurfaceAlt = Color(0xFFFAFAF9); // stone-50
const Color _lightBorder = Color(0xFFE7E5E4);   // stone-200
const Color _lightBorderMid = Color(0xFFD6D3D1); // stone-300

// ── Shared shape constants ────────────────────────────────────────────────────
const double _cardRadius = 16.0;
const double _inputRadius = 12.0;
const double _buttonRadius = 12.0;
const double _dialogRadius = 20.0;
const double _snackRadius = 12.0;

OutlineInputBorder _border(Color c, {double w = 1.0}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(_inputRadius),
      borderSide: BorderSide(color: c, width: w),
    );

// ── Typography ────────────────────────────────────────────────────────────────
// Manrope for headings, Inter for body/UI (set as ThemeData.fontFamily below),
// JetBrains Mono for callsigns/RST/grid squares — chosen over a generic
// monospace for disambiguated glyphs (0 vs O, 1 vs l vs I) which matters for
// values that mix letters and digits. All three are vendored under
// assets/fonts/ (no runtime Google Fonts fetch — this app is used offline in
// the field and ships a network-averse F-Droid build).
const String kHeadingFontFamily = 'Manrope';
const String kBodyFontFamily = 'Inter';
const String kMonoFontFamily = 'JetBrains Mono';

const TextStyle monoLabelLarge = TextStyle(
  fontFamily: kMonoFontFamily,
  fontWeight: FontWeight.w600,
  fontSize: 15,
  letterSpacing: 0.1,
);
const TextStyle monoLabelMedium = TextStyle(
  fontFamily: kMonoFontFamily,
  fontWeight: FontWeight.w500,
  fontSize: 13,
);
const TextStyle monoLabelSmall = TextStyle(
  fontFamily: kMonoFontFamily,
  fontWeight: FontWeight.w500,
  fontSize: 11,
);

// ── Semantic status colors (QSO confirmation state) ──────────────────────────
// Additive alongside the seed/accent palette above, not a replacement.
// Brighter values for dark surfaces, deeper values for light surfaces so
// contrast holds in both modes.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color confirmed; // LoTW/eQSL confirmed QSO
  final Color duplicate; // possible duplicate contact
  final Color needed; // new DXCC / "needed" entity

  const AppSemanticColors({
    required this.confirmed,
    required this.duplicate,
    required this.needed,
  });

  static const dark = AppSemanticColors(
    confirmed: Color(0xFF10B981),
    duplicate: Color(0xFFEC4899),
    needed: Color(0xFF8B5CF6),
  );
  static const light = AppSemanticColors(
    confirmed: Color(0xFF059669),
    duplicate: Color(0xFFDB2777),
    needed: Color(0xFF7C3AED),
  );

  @override
  AppSemanticColors copyWith(
          {Color? confirmed, Color? duplicate, Color? needed}) =>
      AppSemanticColors(
        confirmed: confirmed ?? this.confirmed,
        duplicate: duplicate ?? this.duplicate,
        needed: needed ?? this.needed,
      );

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      confirmed: Color.lerp(confirmed, other.confirmed, t)!,
      duplicate: Color.lerp(duplicate, other.duplicate, t)!,
      needed: Color.lerp(needed, other.needed, t)!,
    );
  }
}

/// `Theme.of(context).semanticColors` — confirmed/duplicate/needed QSO colors.
extension AppSemanticColorsX on BuildContext {
  AppSemanticColors get semanticColors =>
      Theme.of(this).extension<AppSemanticColors>()!;
}

// ── Dark Theme ────────────────────────────────────────────────────────────────
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: kBodyFontFamily,
  extensions: const [AppSemanticColors.dark],
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.dark,
  ).copyWith(
    surface: _darkSurface,
    surfaceContainerLowest: _darkBg,
    surfaceContainerLow: const Color(0xFF211D1A),
    surfaceContainer: _darkSurface,
    surfaceContainerHigh: const Color(0xFF332C28),
    surfaceContainerHighest: const Color(0xFF44403C),
    outline: _darkBorder,
    outlineVariant: _darkBorderMid,
  ),
  scaffoldBackgroundColor: _darkBg,

  // ── AppBar ─────────────────────────────────────────────────────────────────
  appBarTheme: AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.4),
    backgroundColor: _darkBg,
    surfaceTintColor: Colors.transparent,
    foregroundColor: Colors.white,
    titleTextStyle: const TextStyle(
      fontFamily: kHeadingFontFamily,
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: -0.4,
    ),
    iconTheme: const IconThemeData(color: Color(0xFFA8A29E), size: 22),
    actionsIconTheme: const IconThemeData(color: Color(0xFFA8A29E), size: 22),
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  ),

  // ── Cards ──────────────────────────────────────────────────────────────────
  cardTheme: CardThemeData(
    elevation: 0,
    color: _darkSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_cardRadius),
      side: const BorderSide(color: _darkBorderSubtle, width: 1),
    ),
    margin: EdgeInsets.zero,
    surfaceTintColor: Colors.transparent,
    clipBehavior: Clip.antiAlias,
  ),

  // ── Input ──────────────────────────────────────────────────────────────────
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF211D1A),
    isDense: true,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: _border(_darkBorderMid),
    enabledBorder: _border(_darkBorderSubtle),
    focusedBorder: _border(_seed, w: 2),
    errorBorder: _border(const Color(0xFFFB7185)),
    focusedErrorBorder: _border(const Color(0xFFFB7185), w: 2),
    disabledBorder: _border(const Color(0xFF292524)),
    labelStyle: const TextStyle(color: Color(0xFFA8A29E), fontSize: 14),
    hintStyle: const TextStyle(color: Color(0xFF57534E), fontSize: 14),
    prefixIconColor: const Color(0xFF78716C),
    suffixIconColor: const Color(0xFF78716C),
    errorStyle: const TextStyle(color: Color(0xFFFB7185), fontSize: 12),
    floatingLabelStyle: const TextStyle(
      color: _seed,
      fontWeight: FontWeight.w500,
    ),
  ),

  // ── Buttons ────────────────────────────────────────────────────────────────
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius)),
      padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 15, letterSpacing: 0.1),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius)),
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      side: const BorderSide(color: _darkBorderMid),
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius)),
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius)),
      padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      elevation: 0,
    ),
  ),

  // ── Navigation Bar ─────────────────────────────────────────────────────────
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: _darkSurface,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    indicatorColor: _seed.withValues(alpha: 0.18),
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
    height: 68,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: _seed, size: 22);
      }
      return const IconThemeData(color: Color(0xFF78716C), size: 22);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const TextStyle(
          color: _seed,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        );
      }
      return const TextStyle(
        color: Color(0xFF78716C),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      );
    }),
  ),

  // ── Bottom App Bar (Modern shell) ────────────────────────────────────────────
  bottomAppBarTheme: const BottomAppBarThemeData(
    color: _darkSurface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    height: 70,
    shape: CircularNotchedRectangle(),
  ),

  // ── Drawer (Modern shell) ─────────────────────────────────────────────────────
  drawerTheme: const DrawerThemeData(
    backgroundColor: _darkSurface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
    ),
  ),

  // ── Chips ──────────────────────────────────────────────────────────────────
  chipTheme: ChipThemeData(
    showCheckmark: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: const BorderSide(color: _darkBorderSubtle),
  ),

  // ── Divider ────────────────────────────────────────────────────────────────
  dividerTheme: const DividerThemeData(
    color: _darkBorderSubtle,
    thickness: 1,
    space: 1,
  ),

  // ── ListTile ───────────────────────────────────────────────────────────────
  listTileTheme: const ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  ),

  // ── Dialog ─────────────────────────────────────────────────────────────────
  dialogTheme: DialogThemeData(
    backgroundColor: _darkSurface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_dialogRadius),
      side: const BorderSide(color: _darkBorderMid),
    ),
    titleTextStyle: const TextStyle(
      fontFamily: kHeadingFontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: -0.2,
    ),
    contentTextStyle: const TextStyle(
      color: Color(0xFFD6D3D1),
      fontSize: 14,
      height: 1.5,
    ),
    elevation: 0,
  ),

  // ── SnackBar ───────────────────────────────────────────────────────────────
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFF231F1C),
    contentTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_snackRadius),
      side: const BorderSide(color: _darkBorderMid),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    insetPadding: const EdgeInsets.all(12),
  ),

  // ── Progress Indicator ─────────────────────────────────────────────────────
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: kAccentElectric,
  ),

  // ── FAB ────────────────────────────────────────────────────────────────────
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
    focusElevation: 0,
    hoverElevation: 2,
    highlightElevation: 0,
  ),

  // ── Switch ─────────────────────────────────────────────────────────────────
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? Colors.white
          : const Color(0xFF78716C);
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? _seed
          : const Color(0xFF44403C);
    }),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  ),

  // ── Bottom Sheet ───────────────────────────────────────────────────────────
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: _darkSurface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    elevation: 0,
    showDragHandle: true,
  ),

  // ── Text Theme ─────────────────────────────────────────────────────────────
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
        fontFamily: kHeadingFontFamily,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0),
    headlineMedium: TextStyle(
        fontFamily: kHeadingFontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5),
    headlineSmall: TextStyle(
        fontFamily: kHeadingFontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3),
    titleLarge: TextStyle(
        fontFamily: kHeadingFontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2),
    titleMedium:
        TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.1),
    titleSmall: TextStyle(fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 15, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, height: 1.5),
    bodySmall: TextStyle(fontSize: 12, height: 1.4),
    labelLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.3),
    labelSmall: TextStyle(letterSpacing: 0.5),
  ),
);

// ── Light Theme ───────────────────────────────────────────────────────────────
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: kBodyFontFamily,
  extensions: const [AppSemanticColors.light],
  colorScheme: ColorScheme.fromSeed(
    seedColor: _seed,
    brightness: Brightness.light,
  ).copyWith(
    surface: _lightSurface,
    surfaceContainerLowest: _lightBg,
    surfaceContainerLow: _lightSurfaceAlt,
    surfaceContainer: _lightSurface,
    surfaceContainerHigh: const Color(0xFFF0EDEA),
    surfaceContainerHighest: _lightBorder,
    outline: _lightBorderMid,
    outlineVariant: _lightBorder,
  ),
  scaffoldBackgroundColor: _lightBg,

  // ── AppBar ─────────────────────────────────────────────────────────────────
  appBarTheme: AppBarTheme(
    centerTitle: false,
    elevation: 0,
    scrolledUnderElevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.08),
    backgroundColor: _lightBg,
    surfaceTintColor: Colors.transparent,
    foregroundColor: const Color(0xFF1C1917),
    titleTextStyle: const TextStyle(
      fontFamily: kHeadingFontFamily,
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1C1917),
      letterSpacing: -0.4,
    ),
    iconTheme: const IconThemeData(color: Color(0xFF78716C), size: 22),
    actionsIconTheme:
        const IconThemeData(color: Color(0xFF78716C), size: 22),
    systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  ),

  // ── Cards ──────────────────────────────────────────────────────────────────
  cardTheme: CardThemeData(
    elevation: 0,
    color: _lightSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_cardRadius),
      side: const BorderSide(color: _lightBorder, width: 1),
    ),
    margin: EdgeInsets.zero,
    surfaceTintColor: Colors.transparent,
    clipBehavior: Clip.antiAlias,
  ),

  // ── Input ──────────────────────────────────────────────────────────────────
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _lightSurfaceAlt,
    isDense: true,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: _border(_lightBorderMid),
    enabledBorder: _border(_lightBorder),
    focusedBorder: _border(_seed, w: 2),
    errorBorder: _border(const Color(0xFFDC2626)),
    focusedErrorBorder: _border(const Color(0xFFDC2626), w: 2),
    disabledBorder: _border(_lightBorder),
    labelStyle: const TextStyle(color: Color(0xFF78716C), fontSize: 14),
    hintStyle: const TextStyle(color: Color(0xFFA8A29E), fontSize: 14),
    prefixIconColor: const Color(0xFFA8A29E),
    suffixIconColor: const Color(0xFFA8A29E),
    errorStyle: const TextStyle(color: Color(0xFFDC2626), fontSize: 12),
    floatingLabelStyle: TextStyle(
      color: _seed.withValues(alpha: 0.9),
      fontWeight: FontWeight.w600,
    ),
  ),

  // ── Buttons ────────────────────────────────────────────────────────────────
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius)),
      padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 15, letterSpacing: 0.1),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius)),
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      side: const BorderSide(color: _lightBorderMid),
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius)),
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      textStyle: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 14),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_buttonRadius)),
      padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      elevation: 0,
    ),
  ),

  // ── Navigation Bar ─────────────────────────────────────────────────────────
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: _lightSurface,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    indicatorColor: _seed.withValues(alpha: 0.14),
    indicatorShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
    height: 68,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: Color(0xFFC2410C), size: 22);
      }
      return const IconThemeData(color: Color(0xFFA8A29E), size: 22);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const TextStyle(
          color: Color(0xFFC2410C),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        );
      }
      return const TextStyle(
        color: Color(0xFFA8A29E),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      );
    }),
  ),

  // ── Bottom App Bar (Modern shell) ────────────────────────────────────────────
  bottomAppBarTheme: const BottomAppBarThemeData(
    color: _lightSurface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    height: 70,
    shape: CircularNotchedRectangle(),
  ),

  // ── Drawer (Modern shell) ─────────────────────────────────────────────────────
  drawerTheme: const DrawerThemeData(
    backgroundColor: _lightSurface,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
    ),
  ),

  // ── Chips ──────────────────────────────────────────────────────────────────
  chipTheme: ChipThemeData(
    showCheckmark: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: const BorderSide(color: _lightBorder),
  ),

  // ── Divider ────────────────────────────────────────────────────────────────
  dividerTheme: const DividerThemeData(
    color: _lightBorder,
    thickness: 1,
    space: 1,
  ),

  // ── ListTile ───────────────────────────────────────────────────────────────
  listTileTheme: const ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  ),

  // ── Dialog ─────────────────────────────────────────────────────────────────
  dialogTheme: DialogThemeData(
    backgroundColor: _lightSurface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_dialogRadius),
    ),
    titleTextStyle: const TextStyle(
      fontFamily: kHeadingFontFamily,
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1C1917),
      letterSpacing: -0.2,
    ),
    contentTextStyle: const TextStyle(
      color: Color(0xFF57534E),
      fontSize: 14,
      height: 1.5,
    ),
    elevation: 2,
  ),

  // ── SnackBar ───────────────────────────────────────────────────────────────
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFF292524),
    contentTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_snackRadius),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    insetPadding: const EdgeInsets.all(12),
  ),

  // ── Progress Indicator ─────────────────────────────────────────────────────
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: kAccentElectric,
  ),

  // ── FAB ────────────────────────────────────────────────────────────────────
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 2,
    focusElevation: 2,
    hoverElevation: 4,
    highlightElevation: 2,
  ),

  // ── Switch ─────────────────────────────────────────────────────────────────
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(Colors.white),
    trackColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected)
          ? _seed
          : const Color(0xFFD6D3D1);
    }),
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  ),

  // ── Bottom Sheet ───────────────────────────────────────────────────────────
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: _lightSurface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    elevation: 0,
    showDragHandle: true,
  ),

  // ── Text Theme ─────────────────────────────────────────────────────────────
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
        fontFamily: kHeadingFontFamily,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0),
    headlineMedium: TextStyle(
        fontFamily: kHeadingFontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5),
    headlineSmall: TextStyle(
        fontFamily: kHeadingFontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3),
    titleLarge: TextStyle(
        fontFamily: kHeadingFontFamily,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2),
    titleMedium:
        TextStyle(fontWeight: FontWeight.w600, letterSpacing: -0.1),
    titleSmall: TextStyle(fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 15, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, height: 1.5),
    bodySmall: TextStyle(fontSize: 12, height: 1.4),
    labelLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.3),
    labelSmall: TextStyle(letterSpacing: 0.5),
  ),
);
