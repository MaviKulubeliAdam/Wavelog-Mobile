import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Status model
// ─────────────────────────────────────────────────────────────────────────────

enum AutoSpotStatusKind { willSpot, inCooldown, keyChanged }

class AutoSpotStatus {
  final AutoSpotStatusKind kind;
  final String reference;
  final Duration remaining;
  final List<String> changedFields; // 'freq' | 'mode' | 'ref'

  const AutoSpotStatus._({
    required this.kind,
    required this.reference,
    this.remaining = Duration.zero,
    this.changedFields = const [],
  });

  factory AutoSpotStatus.willSpot(String reference) =>
      AutoSpotStatus._(kind: AutoSpotStatusKind.willSpot, reference: reference);

  factory AutoSpotStatus.inCooldown(String reference, Duration remaining) =>
      AutoSpotStatus._(
          kind: AutoSpotStatusKind.inCooldown,
          reference: reference,
          remaining: remaining);

  factory AutoSpotStatus.keyChanged(
          String reference, Duration remaining, List<String> changed) =>
      AutoSpotStatus._(
          kind: AutoSpotStatusKind.keyChanged,
          reference: reference,
          remaining: remaining,
          changedFields: changed);

  AutoSpotStatus withReference(String newRef) {
    switch (kind) {
      case AutoSpotStatusKind.willSpot:
        return AutoSpotStatus.willSpot(newRef);
      case AutoSpotStatusKind.inCooldown:
        return AutoSpotStatus.inCooldown(newRef, remaining);
      case AutoSpotStatusKind.keyChanged:
        return AutoSpotStatus.keyChanged(newRef, remaining, changedFields);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Internal key
// ─────────────────────────────────────────────────────────────────────────────

class _SpotKey {
  final String freqKhz;
  final String mode;
  final String reference;
  final int stationId;

  const _SpotKey({
    required this.freqKhz,
    required this.mode,
    required this.reference,
    required this.stationId,
  });

  bool sameAs(_SpotKey other) =>
      freqKhz == other.freqKhz &&
      mode == other.mode &&
      reference == other.reference &&
      stationId == other.stationId;
}

// ─────────────────────────────────────────────────────────────────────────────
// Service
// ─────────────────────────────────────────────────────────────────────────────

/// Generic auto-spot service with a 30-minute cooldown.
/// Activity-specific logic (POTA / SOTA) is injected via [sendSpot].
/// State persists across restarts via SharedPreferences using [prefix].
class AutoSpotService {
  final Future<void> Function({
    required String callsign,
    required String freqKhz,
    required String mode,
    required String reference,
  }) _sendSpot;

  final String _kFreq;
  final String _kMode;
  final String _kRef;
  final String _kStationId;
  final String _kTime;

  _SpotKey? _lastKey;
  DateTime? _lastSpotTime;
  late final Future<void> _loadFuture;

  static const _cooldown = Duration(minutes: 30);

  AutoSpotService({
    required Future<void> Function({
      required String callsign,
      required String freqKhz,
      required String mode,
      required String reference,
    }) sendSpot,
    String prefix = 'as',
  })  : _sendSpot = sendSpot,
        _kFreq = '${prefix}_last_freq',
        _kMode = '${prefix}_last_mode',
        _kRef = '${prefix}_last_ref',
        _kStationId = '${prefix}_last_station',
        _kTime = '${prefix}_last_time' {
    _loadFuture = _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final freq      = prefs.getString(_kFreq);
    final mode      = prefs.getString(_kMode);
    final ref       = prefs.getString(_kRef);
    final stationId = prefs.getInt(_kStationId);
    final timeMs    = prefs.getInt(_kTime);

    if (freq != null && mode != null && ref != null && stationId != null) {
      _lastKey = _SpotKey(
          freqKhz: freq, mode: mode, reference: ref, stationId: stationId);
    }
    if (timeMs != null) {
      _lastSpotTime = DateTime.fromMillisecondsSinceEpoch(timeMs);
    }
  }

  Future<void> _save(_SpotKey key, DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFreq, key.freqKhz);
    await prefs.setString(_kMode, key.mode);
    await prefs.setString(_kRef, key.reference);
    await prefs.setInt(_kStationId, key.stationId);
    await prefs.setInt(_kTime, time.millisecondsSinceEpoch);
  }

  AutoSpotStatus queryStatus({
    required String freqKhz,
    required String mode,
    required String reference,
    required int stationId,
  }) {
    if (_lastKey == null || _lastSpotTime == null) {
      return AutoSpotStatus.willSpot(reference);
    }

    final now = DateTime.now();
    final elapsed = now.difference(_lastSpotTime!);

    if (elapsed >= _cooldown) {
      return AutoSpotStatus.willSpot(reference);
    }

    final remaining = _cooldown - elapsed;
    final key = _SpotKey(
        freqKhz: freqKhz, mode: mode, reference: reference, stationId: stationId);

    if (key.sameAs(_lastKey!)) {
      return AutoSpotStatus.inCooldown(reference, remaining);
    }

    final changed = <String>[];
    if (freqKhz != _lastKey!.freqKhz) changed.add('freq');
    if (mode != _lastKey!.mode) changed.add('mode');
    if (reference != _lastKey!.reference) changed.add('ref');

    return AutoSpotStatus.keyChanged(reference, remaining, changed);
  }

  Future<bool> maybeAutoSpot({
    required String callsign,
    required String freqKhz,
    required String mode,
    required String reference,
    required int stationId,
  }) async {
    if (freqKhz.isEmpty || reference.isEmpty) return false;

    // İlk yüklemenin gerçekten bitmesini bekle — aksi hâlde uygulama
    // açılışının hemen ardından cooldown durumu okunmadan spot atılabilir
    await _loadFuture;

    final key = _SpotKey(
        freqKhz: freqKhz, mode: mode, reference: reference, stationId: stationId);
    final now = DateTime.now();

    final cooldownActive = _lastSpotTime != null &&
        now.difference(_lastSpotTime!) < _cooldown;
    final sameKey = _lastKey != null && key.sameAs(_lastKey!);

    if (cooldownActive && sameKey) return false;

    await _sendSpot(
      callsign: callsign,
      freqKhz: freqKhz,
      mode: mode,
      reference: reference,
    );

    _lastKey = key;
    _lastSpotTime = now;
    await _save(key, now);
    return true;
  }
}
