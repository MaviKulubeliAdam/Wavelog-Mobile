import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/band_mode_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/qso_model.dart';
import '../../../data/models/station_model.dart';
import '../../../data/datasources/remote/pota_datasource.dart';
import '../../../providers/auto_spot_provider.dart';
import '../../../services/auto_spot_service.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../providers/qso_provider.dart';
import '../../../providers/remote_datasource_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/station_provider.dart';
import 'widgets/logbook_summary_card.dart';
import 'widgets/previous_qsos_card.dart';
import 'widgets/qso_mode_toggle.dart';
import 'widgets/qso_tablet_info_panel.dart';

class AddQsoScreen extends ConsumerStatefulWidget {
  final String? prefillCallsign;
  final QsoModel? editQso;
  const AddQsoScreen({super.key, this.prefillCallsign, this.editQso});

  @override
  ConsumerState<AddQsoScreen> createState() => _AddQsoScreenState();
}

class _AddQsoScreenState extends ConsumerState<AddQsoScreen> {
  // Remembered across QSOs within the same session
  static String? _memBand;
  static String? _memMode;
  static String? _memSubmode;

  final _formKey = GlobalKey<FormState>();

  bool _isLive = true;

  late TextEditingController _callsignCtrl;
  late TextEditingController _freqCtrl;
  late TextEditingController _rstSentCtrl;
  late TextEditingController _rstRcvdCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _qthCtrl;
  late TextEditingController _gridCtrl;
  late TextEditingController _commentCtrl;
  late TextEditingController _potaInputCtrl;
  late TextEditingController _sotaRefCtrl;
  late TextEditingController _wwffRefCtrl;

  final _pota = PotaDatasource();
  final Map<String, String?> _potaNameCache = {};
  List<String> _potaRefs = [];
  late FocusNode _callsignFocus;

  DateTime _dateTimeOn = DateTime.now().toUtc();
  String _band = '20m';
  String _mode = 'SSB';
  String? _submode;
  StationModel? _selectedStation;

  bool _isSaving = false;
  bool _lookupLoading = false;
  bool _lookupDone = false;
  bool _lookupSuccess = false;

  String? _dxccCountry;
  String? _dxccFlag;

  // Auto-spot banner
  AutoSpotStatus? _autoSpotStatus;
  Timer? _statusTimer;

  // Tablet right-panel callsign — debounced to avoid per-keystroke API calls
  String _currentCallsign = '';
  Timer? _callsignPanelTimer;
  Timer? _freqSaveDebounce;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _band = '20m';
    _mode = settings.defaultMode;

    final edit = widget.editQso;
    if (edit != null) {
      // Edit mode — prefill everything from the existing QSO
      _isLive = false;
      _band = edit.band;
      _mode = edit.mode;
      _submode = edit.submode;
      _dateTimeOn = edit.dateTimeOn;
      _currentCallsign = edit.callsign;
      _lookupDone = true;
      _lookupSuccess = true;

      _callsignCtrl = TextEditingController(text: edit.callsign);
      _freqCtrl = TextEditingController(
          text: edit.freqMhz?.toStringAsFixed(3) ??
              kBandCenterFreqMhz[_band]?.toString() ?? '');
      _rstSentCtrl = TextEditingController(text: edit.rstSent);
      _rstRcvdCtrl = TextEditingController(text: edit.rstRcvd);
      _nameCtrl = TextEditingController(text: edit.name ?? '');
      _qthCtrl = TextEditingController(text: edit.qth ?? '');
      _gridCtrl = TextEditingController(text: edit.gridSquare ?? '');
      _commentCtrl = TextEditingController(text: edit.comment ?? '');
      _potaRefs = (edit.rawAdif?['POTA_REF'] ?? '')
          .split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      _potaInputCtrl = TextEditingController();
      _sotaRefCtrl = TextEditingController(text: edit.rawAdif?['SOTA_REF'] ?? '');
      _wwffRefCtrl = TextEditingController(text: edit.rawAdif?['WWFF_REF'] ?? '');
      _dxccCountry = edit.country ?? edit.rawAdif?['COUNTRY'] ?? edit.dxcc;
      _dxccFlag = edit.rawAdif?['APP_WAVELOG_FLAG'];
    } else {
      // Start with the band-convention default; user's saved preference (loaded
      // asynchronously below) will override this if one exists for this band+mode.
      _submode = (_memBand == _band && _memMode == _mode)
          ? _memSubmode
          : defaultSubmodeFor(_band, _mode);

      _callsignCtrl = TextEditingController(
          text: widget.prefillCallsign?.toUpperCase() ?? '');
      _freqCtrl = TextEditingController(
          text: kBandCenterFreqMhz[_band]?.toString() ?? '');
      _rstSentCtrl = TextEditingController(text: getDefaultRst(_mode));
      _rstRcvdCtrl = TextEditingController(text: getDefaultRst(_mode));
      _nameCtrl = TextEditingController();
      _qthCtrl = TextEditingController();
      _gridCtrl = TextEditingController();
      _commentCtrl = TextEditingController();
      _potaInputCtrl = TextEditingController();
      _sotaRefCtrl = TextEditingController();
      _wwffRefCtrl = TextEditingController();
    }

    _callsignFocus = FocusNode();
    _callsignFocus.addListener(_onCallsignFocusChange);
    _freqCtrl.addListener(_updateAutoSpotStatus);
    if (widget.editQso == null) _freqCtrl.addListener(_saveFreqDebounced);
    _potaInputCtrl.addListener(_onPotaInputChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (edit == null &&
          widget.prefillCallsign != null &&
          widget.prefillCallsign!.isNotEmpty) {
        _currentCallsign = widget.prefillCallsign!.toUpperCase();
        _doLookup();
      }
      _updateAutoSpotStatus();
      _startStatusTimer();
      if (edit == null) {
        _loadLastBand();
        _loadLastFreq();
        _loadLastSubmode(_band, _mode);
      }
      if (_potaRefs.isNotEmpty) _lookupPotaRefs();
    });
  }

  void _saveFreqDebounced() {
    _freqSaveDebounce?.cancel();
    _freqSaveDebounce = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      final rawText = _freqCtrl.text.trim();
      if (rawText.isEmpty) return;

      // kHz → MHz: nokta yoksa otomatik dönüştür (÷1000 veya ÷10000)
      final freqText = autoFormatFreqInput(rawText);
      if (freqText != rawText) {
        _freqCtrl.value = TextEditingValue(
          text: freqText,
          selection: TextSelection.collapsed(offset: freqText.length),
        );
        return; // listener yeniden tetiklenir, bant tespiti orada yapılır
      }

      final ds = ref.read(settingsLocalDatasourceProvider);
      ds.saveLastFreq(freqText);
      final parsed = double.tryParse(freqText);
      if (parsed != null) {
        final detectedBand = getBandFromFreq(parsed);
        if (detectedBand != null && detectedBand != _band) {
          setState(() {
            _band = detectedBand;
            _submode = defaultSubmodeFor(detectedBand, _mode);
          });
          ds.saveLastBand(detectedBand);
          _loadLastSubmode(detectedBand, _mode);
        }
      }
    });
  }

  @override
  void dispose() {
    _callsignPanelTimer?.cancel();
    _statusTimer?.cancel();
    _freqSaveDebounce?.cancel();
    _freqCtrl.removeListener(_updateAutoSpotStatus);
    if (widget.editQso == null) _freqCtrl.removeListener(_saveFreqDebounced);
    _potaInputCtrl.removeListener(_onPotaInputChanged);
    _callsignFocus.removeListener(_onCallsignFocusChange);
    _callsignFocus.dispose();
    _callsignCtrl.dispose();
    _freqCtrl.dispose();
    _rstSentCtrl.dispose();
    _rstRcvdCtrl.dispose();
    _nameCtrl.dispose();
    _qthCtrl.dispose();
    _gridCtrl.dispose();
    _commentCtrl.dispose();
    _potaInputCtrl.dispose();
    _sotaRefCtrl.dispose();
    _wwffRefCtrl.dispose();
    super.dispose();
  }

  void _onPotaInputChanged() {
    final text = _potaInputCtrl.text;
    if (text.endsWith(',')) {
      final ref = text.replaceAll(',', '').trim().toUpperCase();
      _potaInputCtrl.clear();
      if (ref.isNotEmpty) _addPotaRef(ref);
    }
  }

  void _addPotaRef(String ref) {
    if (_potaRefs.contains(ref)) return;
    setState(() => _potaRefs.add(ref));
    _lookupPotaRef(ref);
  }

  void _removePotaRef(String ref) {
    setState(() {
      _potaRefs.remove(ref);
      _potaNameCache.remove(ref);
    });
  }

  Future<void> _lookupPotaRef(String ref) async {
    if (!ref.contains('-')) return;
    if (_potaNameCache.containsKey(ref)) return;
    if (mounted) setState(() => _potaNameCache[ref] = null);
    try {
      final info = await _pota.getPark(ref);
      if (mounted) setState(() => _potaNameCache[ref] = info?.name ?? '');
    } catch (_) {
      if (mounted) setState(() => _potaNameCache.remove(ref));
    }
  }

  Future<void> _lookupPotaRefs() async {
    for (final ref in List.of(_potaRefs)) {
      await _lookupPotaRef(ref);
    }
  }

  void _onCallsignFocusChange() {
    if (!_callsignFocus.hasFocus &&
        _callsignCtrl.text.trim().isNotEmpty &&
        !_lookupDone) {
      _doLookup();
    }
  }

  Future<void> _doLookup() async {
    final callsign = _callsignCtrl.text.trim().toUpperCase();
    if (callsign.isEmpty) return;

    // Update the tablet info panel immediately
    _callsignPanelTimer?.cancel();
    if (mounted && callsign != _currentCallsign) {
      setState(() => _currentCallsign = callsign);
    }

    setState(() {
      _lookupLoading = true;
      _lookupSuccess = false;
    });

    try {
      final remote = ref.read(wavelogRemoteDatasourceProvider);
      final result = await remote.lookupCallsign(
          callsign: callsign, band: _band, mode: _mode);
      if (!mounted) return;
      setState(() {
        _lookupLoading = false;
        _lookupDone = true;
        _lookupSuccess = true;
        if (result.name != null) _nameCtrl.text = result.name!;
        if (result.qth != null) _qthCtrl.text = result.qth!;
        if (result.gridSquare != null) _gridCtrl.text = result.gridSquare!;
        _dxccCountry = result.country;
        _dxccFlag = result.flag;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _lookupLoading = false;
          _lookupDone = true;
          _lookupSuccess = false;
        });
      }
    }
  }

  Future<void> _loadLastFreq() async {
    final ds = ref.read(settingsLocalDatasourceProvider);
    final lastFreq = await ds.getLastFreq();
    if (lastFreq == null || !mounted) return;
    final parsed = double.tryParse(lastFreq);
    if (parsed == null) return;
    // Yalnızca kayıtlı frekans mevcut bantla uyuşuyorsa geri yükle
    if (getBandFromFreq(parsed) == _band) {
      _freqCtrl.text = lastFreq;
    }
  }

  Future<void> _loadLastBand() async {
    final ds = ref.read(settingsLocalDatasourceProvider);
    final last = await ds.getLastBand();
    if (!mounted || last == null) return;
    setState(() {
      _band = last;
      _submode = defaultSubmodeFor(last, _mode);
      final freq = kBandCenterFreqMhz[last];
      if (freq != null) _freqCtrl.text = freq.toStringAsFixed(3);
    });
    _loadLastSubmode(last, _mode);
  }

  Future<void> _loadLastSubmode(String band, String mode) async {
    final ds = ref.read(settingsLocalDatasourceProvider);
    final saved = await ds.getLastSubmode(band, mode);
    if (!mounted) return;
    final resolved = (saved != null && (kSubmodes[mode]?.contains(saved) ?? false))
        ? saved
        : defaultSubmodeFor(band, mode);
    if (resolved != null) setState(() => _submode = resolved);
  }

  void _onModeChanged(String mode) {
    setState(() {
      _mode = mode;
      _submode = defaultSubmodeFor(_band, mode);
    });
    _rstSentCtrl.text = getDefaultRst(mode);
    _rstRcvdCtrl.text = getDefaultRst(mode);
    _updateAutoSpotStatus();
    _loadLastSubmode(_band, mode);
  }

  // ── Auto-spot status ──────────────────────────────────────────────────────

  void _startStatusTimer() {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) _updateAutoSpotStatus();
    });
  }

  void _updateAutoSpotStatus() {
    if (!mounted) return;
    if (widget.editQso != null) return;

    final settings = ref.read(settingsProvider);
    if (!settings.potaAutoSpotEnabled) {
      if (_autoSpotStatus != null) setState(() => _autoSpotStatus = null);
      return;
    }

    final stationId = _selectedStation?.id ?? settings.activeStationProfileId;
    if (stationId == null) {
      if (_autoSpotStatus != null) setState(() => _autoSpotStatus = null);
      return;
    }

    StationModel? station = _selectedStation;
    if (station == null) {
      final stations = ref.read(stationProvider).valueOrNull;
      if (stations != null) {
        for (final s in stations) {
          if (s.id == stationId) { station = s; break; }
        }
      }
    }

    final potaRef = station?.pota?.trim() ?? '';
    final sotaRef = station?.sota?.trim() ?? '';

    if (potaRef.isEmpty && sotaRef.isEmpty) {
      if (_autoSpotStatus != null) setState(() => _autoSpotStatus = null);
      return;
    }

    final freqMhz = double.tryParse(_freqCtrl.text.replaceAll(',', '.'));
    final freqKhz = freqMhz != null ? (freqMhz * 1000).round().toString() : '';

    // Combined display label e.g. "US-1234 + W4G/CE-001"
    final displayRef = [
      if (potaRef.isNotEmpty) potaRef,
      if (sotaRef.isNotEmpty) sotaRef,
    ].join(' + ');

    // Use POTA service for cooldown logic if POTA ref exists, else SOTA
    final primaryRef = potaRef.isNotEmpty ? potaRef : sotaRef;
    final service = potaRef.isNotEmpty
        ? ref.read(autoSpotServiceProvider)
        : ref.read(sotaAutoSpotServiceProvider);

    final status = service
        .queryStatus(freqKhz: freqKhz, mode: _mode,
            reference: primaryRef, stationId: stationId)
        .withReference(displayRef);

    setState(() => _autoSpotStatus = status);
  }

  void _onBandChanged(String band) {
    setState(() {
      _band = band;
      _submode = defaultSubmodeFor(band, _mode);
      final freq = kBandCenterFreqMhz[band];
      if (freq != null) _freqCtrl.text = freq.toStringAsFixed(3);
    });
    ref.read(settingsLocalDatasourceProvider).saveLastBand(band);
    // Load user's saved preference for this band+mode (overrides auto-default).
    _loadLastSubmode(band, _mode);
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTimeOn,
      firstDate: DateTime(1990),
      lastDate: DateTime.now().add(const Duration(hours: 1)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTimeOn),
    );
    if (time == null) return;
    setState(() {
      _dateTimeOn =
          DateTime.utc(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _resetForm() {
    _callsignPanelTimer?.cancel();
    _callsignCtrl.clear();
    _nameCtrl.clear();
    _qthCtrl.clear();
    _gridCtrl.clear();
    _commentCtrl.clear();
    _potaInputCtrl.clear();
    _sotaRefCtrl.clear();
    _wwffRefCtrl.clear();
    _potaRefs = [];
    _potaNameCache.clear();
    _rstSentCtrl.text = getDefaultRst(_mode);
    _rstRcvdCtrl.text = getDefaultRst(_mode);
    setState(() {
      // Restore submode from memory if band+mode unchanged, else use band default.
      _submode = (_memBand == _band && _memMode == _mode)
          ? _memSubmode
          : defaultSubmodeFor(_band, _mode);
      _currentCallsign = '';
      _lookupDone = false;
      _lookupSuccess = false;
      _dxccCountry = null;
      _dxccFlag = null;
      if (_isLive) _dateTimeOn = DateTime.now().toUtc();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Resolve the effective station: explicit selection → settings ID → first
    // active station in the loaded list (handles stale or null activeStationProfileId).
    final stationList = ref.read(stationProvider).valueOrNull ?? [];
    final settingStationId = ref.read(settingsProvider).activeStationProfileId;
    final effectiveStation = _selectedStation
        ?? stationList.where((s) => s.id == settingStationId).firstOrNull
        ?? stationList.where((s) => s.isActive).firstOrNull
        ?? stationList.firstOrNull;
    final stationId = effectiveStation?.id;
    if (stationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.noActiveStation)),
      );
      return;
    }

    final qsoTime = _isLive ? DateTime.now().toUtc() : _dateTimeOn;
    setState(() => _isSaving = true);

    final isOnline = ref.read(isOnlineProvider);
    final offlineMode = ref.read(settingsProvider).offlineModeEnabled;

    final rawAdifMap = <String, String>{
      ...?widget.editQso?.rawAdif,
      if (_dxccFlag != null) 'APP_WAVELOG_FLAG': _dxccFlag!,
      if (_potaRefs.isNotEmpty)
        'POTA_REF': _potaRefs.join(','),
      if (_sotaRefCtrl.text.trim().isNotEmpty)
        'SOTA_REF': _sotaRefCtrl.text.trim().toUpperCase(),
      if (_wwffRefCtrl.text.trim().isNotEmpty)
        'WWFF_REF': _wwffRefCtrl.text
            .split(',')
            .map((e) => e.trim().toUpperCase())
            .where((e) => e.isNotEmpty)
            .join(','),
    };

    final qso = QsoModel(
      callsign: _callsignCtrl.text.trim().toUpperCase(),
      dateTimeOn: qsoTime,
      band: _band,
      freqMhz: double.tryParse(_freqCtrl.text.replaceAll(',', '.')),
      mode: _mode,
      submode: _submode,
      rstSent: _rstSentCtrl.text.trim(),
      rstRcvd: _rstRcvdCtrl.text.trim(),
      name: _nameCtrl.text.trim().isEmpty ? null : _nameCtrl.text.trim(),
      qth: _qthCtrl.text.trim().isEmpty ? null : _qthCtrl.text.trim(),
      gridSquare: _gridCtrl.text.trim().isEmpty
          ? null
          : _gridCtrl.text.trim().toUpperCase(),
      comment:
          _commentCtrl.text.trim().isEmpty ? null : _commentCtrl.text.trim(),
      stationProfileId: stationId,
      rawAdif: rawAdifMap.isEmpty ? null : rawAdifMap,
      country: _dxccCountry,
      dxcc: widget.editQso?.dxcc,
      continent: widget.editQso?.continent,
    );

    try {
      final forceLocal = offlineMode || !isOnline;
      final l10n = context.l10n;
      final editQso = widget.editQso;

      if (editQso != null) {
        // Edit mode: update existing QSO
        final savedOnline = await ref
            .read(qsoProvider.notifier)
            .updateQso(editQso, qso, forceLocal: forceLocal);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(savedOnline
                  ? l10n.qsoUpdated
                  : l10n.qsoUpdatedLocal),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        // Add mode: create new QSO
        final savedOnline = await ref.read(qsoProvider.notifier).addQso(
              qso,
              forceLocal: forceLocal,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(savedOnline
                  ? l10n.qsoSaved(qso.callsign)
                  : l10n.qsoSavedLocal(qso.callsign)),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          ref.read(settingsLocalDatasourceProvider).saveLastFreq(_freqCtrl.text);
          _resetForm();
          _maybeAutoSpot(qso, stationId);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${context.l10n.error}: ${localizeError(context, e)}'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── Auto-spot ─────────────────────────────────────────────────────────────

  void _maybeAutoSpot(QsoModel qso, int stationId) {
    if (!ref.read(settingsProvider).potaAutoSpotEnabled) return;

    StationModel? station = _selectedStation;
    if (station == null) {
      final stations = ref.read(stationProvider).valueOrNull;
      if (stations != null) {
        for (final s in stations) {
          if (s.id == stationId) { station = s; break; }
        }
      }
    }
    if (station == null) return;

    final freqKhz = qso.freqMhz != null
        ? (qso.freqMhz! * 1000).round().toString()
        : '';
    if (freqKhz.isEmpty) return;

    // POTA: prefer QSO's MY_POTA_REF, fallback to station field
    final potaRef = (qso.myPota?.trim().isNotEmpty == true)
        ? qso.myPota!.trim()
        : station.pota?.trim() ?? '';

    // SOTA: prefer QSO's MY_SOTA_REF, fallback to station field
    final sotaRef = (qso.mySota?.trim().isNotEmpty == true)
        ? qso.mySota!.trim()
        : station.sota?.trim() ?? '';

    if (potaRef.isEmpty && sotaRef.isEmpty) return;

    final futures = <Future<bool>>[];
    final sentRefs = <String>[];

    if (potaRef.isNotEmpty) {
      futures.add(
        ref.read(autoSpotServiceProvider).maybeAutoSpot(
          callsign: station.callsign,
          freqKhz: freqKhz,
          mode: qso.mode,
          reference: potaRef,
          stationId: stationId,
        ).then((sent) { if (sent) sentRefs.add(potaRef); return sent; }),
      );
    }

    if (sotaRef.isNotEmpty) {
      futures.add(
        ref.read(sotaAutoSpotServiceProvider).maybeAutoSpot(
          callsign: station.callsign,
          freqKhz: freqKhz,
          mode: qso.mode,
          reference: sotaRef,
          stationId: stationId,
        ).then((sent) { if (sent) sentRefs.add(sotaRef); return sent; }),
      );
    }

    Future.wait(futures).then((_) {
      if (!mounted) return;
      if (sentRefs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.autoSpotSent(sentRefs.join(' + '))),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      _updateAutoSpotStatus();
    }).catchError((_) {});
  }

  // ── Auto-spot banner widget ───────────────────────────────────────────────

  Widget _buildAutoSpotBanner(BuildContext context) {
    final status = _autoSpotStatus;
    if (status == null) return const SizedBox.shrink();

    final l10n = context.l10n;
    final theme = Theme.of(context);

    Color bgColor;
    Color iconColor;
    IconData icon;
    String message;

    switch (status.kind) {
      case AutoSpotStatusKind.willSpot:
        bgColor = theme.colorScheme.primaryContainer;
        iconColor = theme.colorScheme.primary;
        icon = Icons.wifi_tethering;
        message = l10n.autoSpotWillFire;
      case AutoSpotStatusKind.inCooldown:
        bgColor = theme.colorScheme.surfaceContainerHighest;
        iconColor = theme.colorScheme.onSurfaceVariant;
        icon = Icons.check_circle_outline;
        message = status.remaining.inMinutes >= 1
            ? l10n.autoSpotCooldown(status.remaining.inMinutes)
            : l10n.autoSpotCooldownSoon;
      case AutoSpotStatusKind.keyChanged:
        bgColor = theme.colorScheme.tertiaryContainer;
        iconColor = theme.colorScheme.tertiary;
        icon = Icons.bolt;
        final fieldNames = status.changedFields.map((f) => switch (f) {
              'freq' => l10n.autoSpotFieldFreq,
              'mode' => l10n.autoSpotFieldMode,
              'ref'  => l10n.autoSpotFieldRef,
              _      => f,
            }).join(', ');
        message = l10n.autoSpotKeyChanged(fieldNames);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📡 Auto-Spot · ${status.reference}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isTablet = Responsive.useTabletLayout(context);

    final form = Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: _buildFormContent(context),
      ),
    );

    final Widget body = isTablet
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: form),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                flex: 4,
                child: QsoTabletInfoPanel(callsign: _currentCallsign),
              ),
            ],
          )
        : form;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editQso != null ? l10n.editQsoTitle : l10n.addQsoTitle),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(onPressed: _submit, child: Text(l10n.save)),
        ],
      ),
      body: body,
    );
  }

  List<Widget> _buildFormContent(BuildContext context) {
    final l10n = context.l10n;
    final stations = ref.watch(stationProvider);
    final cs = Theme.of(context).colorScheme;

    return [
      QsoModeToggle(
        isLive: _isLive,
        liveLabel: l10n.liveQso,
        historicalLabel: l10n.historicalQso,
        onChanged: (live) {
          setState(() {
            _isLive = live;
            // Tarihsel moda geçişte kalıcı bir başlangıç değeri bırak
            if (!live) _dateTimeOn = DateTime.now().toUtc();
          });
        },
      ),
      const SizedBox(height: 16),

      // ── Callsign ────────────────────────────────────────────────────
      TextFormField(
        controller: _callsignCtrl,
        focusNode: _callsignFocus,
        style: const TextStyle(fontFamily: kMonoFontFamily),
        decoration: InputDecoration(
          labelText: l10n.callsignField,
          prefixIcon: const Icon(Icons.radio),
          suffixIcon: _lookupLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : _lookupDone
                  ? Icon(
                      _lookupSuccess
                          ? Icons.check_circle_outline
                          : Icons.help_outline,
                      color: _lookupSuccess ? Colors.green : cs.onSurfaceVariant,
                      size: 20,
                    )
                  : IconButton(
                      icon: const Icon(Icons.search, size: 20),
                      tooltip: l10n.lookupSearch,
                      onPressed: () {
                        _lookupDone = false;
                        _doLookup();
                      },
                    ),
        ),
        textCapitalization: TextCapitalization.characters,
        validator: validateCallsign,
        onChanged: (v) {
          if (_lookupDone) {
            setState(() {
              _lookupDone = false;
              if (_lookupSuccess) {
                // Önceki lookup'tan gelen alanları temizle
                _nameCtrl.clear();
                _qthCtrl.clear();
                _gridCtrl.clear();
                _dxccCountry = null;
                _dxccFlag = null;
                _lookupSuccess = false;
              }
            });
          }
          // Debounced tablet panel refresh
          _callsignPanelTimer?.cancel();
          _callsignPanelTimer = Timer(const Duration(milliseconds: 600), () {
            final cs2 = v.trim().toUpperCase();
            if (mounted && cs2 != _currentCallsign) {
              setState(() => _currentCallsign = cs2);
            }
          });
        },
        onFieldSubmitted: (_) {
          _lookupDone = false;
          _doLookup();
        },
      ),

      // ── /P /M hızlı suffix butonları ────────────────────────────────
      Wrap(
        spacing: 6,
        children: ['/P', '/M', '/MM', '/QRP'].map((suffix) {
          return ActionChip(
            label: Text(suffix, style: const TextStyle(fontSize: 11)),
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              final current = _callsignCtrl.text.toUpperCase().trim();
              if (current.isEmpty) return;
              // Mevcut suffix varsa önce kaldır, sonra yenisini ekle
              final base = current.contains('/')
                  ? current.split('/').first
                  : current;
              final newVal = '$base$suffix';
              _callsignCtrl.text = newVal;
              _callsignCtrl.selection =
                  TextSelection.collapsed(offset: newVal.length);
              setState(() => _lookupDone = false);
            },
          );
        }).toList(),
      ),
      const SizedBox(height: 8),

      // ── Logbook özeti: bugün sayacı + son 5 QSO ────────────────────
      if (!Responsive.useTabletLayout(context))
        const LogbookSummaryCard(),

      // ── Previous QSOs inline (phone only — tablet uses right panel) ──
      if (!Responsive.useTabletLayout(context) && _currentCallsign.length >= 3)
        InlinePreviousQsosCard(callsign: _currentCallsign),

      // ── Date / Time ─────────────────────────────────────────────────
      _isLive
          ? QsoLiveClockTile(label: l10n.liveDateTimeLabel)
          : ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(l10n.dateTimeLabel),
              subtitle:
                  Text(DateFormat('dd.MM.yyyy  HH:mm').format(_dateTimeOn)),
              trailing: const Icon(Icons.edit_outlined),
              onTap: _pickDateTime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: cs.outlineVariant),
              ),
            ),
      const SizedBox(height: 12),

      // ── Band / Mode ─────────────────────────────────────────────────
      Row(children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _band,
            decoration: InputDecoration(labelText: l10n.bandField),
            items: kCommonBands
                .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                .toList(),
            onChanged: (v) => v != null ? _onBandChanged(v) : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: _mode,
            decoration: InputDecoration(labelText: l10n.modeField),
            items: kCommonModes
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => v != null ? _onModeChanged(v) : null,
          ),
        ),
        if ((kSubmodes[_mode]?.isNotEmpty ?? false)) ...[
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              key: ValueKey('submode_$_mode'),
              value: _submode,
              decoration: InputDecoration(labelText: context.l10n.submodeLabel),
              items: [
                const DropdownMenuItem<String>(
                    value: null, child: Text('—')),
                ...kSubmodes[_mode]!.map(
                    (s) => DropdownMenuItem(value: s, child: Text(s))),
              ],
              onChanged: (v) {
                setState(() => _submode = v);
                _memBand = _band;
                _memMode = _mode;
                _memSubmode = v;
                if (v != null) {
                  ref.read(settingsLocalDatasourceProvider).saveLastSubmode(_band, _mode, v);
                }
              },
            ),
          ),
        ],
      ]),
      const SizedBox(height: 12),

      // ── Frequency ───────────────────────────────────────────────────
      TextFormField(
        controller: _freqCtrl,
        style: const TextStyle(fontFamily: kMonoFontFamily),
        decoration: InputDecoration(
          labelText: l10n.frequencyField,
          prefixIcon: const Icon(Icons.waves),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: validateFrequency,
      ),
      const SizedBox(height: 12),

      // ── RST ─────────────────────────────────────────────────────────
      Row(children: [
        Expanded(
          child: TextFormField(
            controller: _rstSentCtrl,
            style: const TextStyle(fontFamily: kMonoFontFamily),
            decoration: InputDecoration(labelText: l10n.rstSentField),
            keyboardType: TextInputType.number,
            validator: (v) => validateRst(v, _mode),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _rstRcvdCtrl,
            style: const TextStyle(fontFamily: kMonoFontFamily),
            decoration: InputDecoration(labelText: l10n.rstRcvdField),
            keyboardType: TextInputType.number,
            validator: (v) => validateRst(v, _mode),
          ),
        ),
      ]),
      const SizedBox(height: 12),

      // ── Name / QTH ──────────────────────────────────────────────────
      Row(children: [
        Expanded(
          child: TextFormField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: l10n.nameField),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _qthCtrl,
            decoration: InputDecoration(labelText: l10n.qthField),
          ),
        ),
      ]),
      const SizedBox(height: 12),

      // ── Grid + DXCC country ─────────────────────────────────────────
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grid — narrower
          SizedBox(
            width: 110,
            child: TextFormField(
              controller: _gridCtrl,
              style: const TextStyle(fontFamily: kMonoFontFamily),
              decoration: InputDecoration(
                labelText: l10n.gridField,
                hintText: 'KN41',
              ),
              textCapitalization: TextCapitalization.characters,
              validator: validateGridSquare,
            ),
          ),
          const SizedBox(width: 12),
          // DXCC country — fills remaining width
          Expanded(
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'DXCC',
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
              child: _dxccCountry != null
                  ? Row(
                      children: [
                        if (_dxccFlag != null &&
                            _dxccFlag!.length <= 8)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(_dxccFlag!,
                                style: const TextStyle(fontSize: 16)),
                          ),
                        Expanded(
                          child: Text(
                            _dxccCountry!,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '—',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant),
                    ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      // ── Comment ─────────────────────────────────────────────────────
      TextFormField(
        controller: _commentCtrl,
        decoration: InputDecoration(labelText: l10n.commentField),
        maxLines: 2,
      ),

      // ── P2P referanslar (istasyonda POTA/SOTA/WWFF varsa görünür) ───
      Builder(builder: (context) {
        final stationList = stations.valueOrNull ?? [];
        final settingStationId =
            ref.read(settingsProvider).activeStationProfileId;
        final effectiveStation = _selectedStation
            ?? stationList.where((s) => s.id == settingStationId).firstOrNull
            ?? stationList.where((s) => s.isActive).firstOrNull
            ?? stationList.firstOrNull;
        final showPota = effectiveStation?.pota?.trim().isNotEmpty == true;
        final showSota = effectiveStation?.sota?.trim().isNotEmpty == true;
        final showWwff = effectiveStation?.wwff?.trim().isNotEmpty == true;
        if (!showPota && !showSota && !showWwff) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            if (showPota) ...[
              if (_potaRefs.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 48, bottom: 4),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      for (final potaRef in _potaRefs)
                        Builder(builder: (ctx) {
                          final cs = Theme.of(ctx).colorScheme;
                          return InputChip(
                            label: Text(potaRef,
                                style: TextStyle(
                                    fontSize: 13, color: cs.onInverseSurface)),
                            onDeleted: () => _removePotaRef(potaRef),
                            deleteIconColor: cs.onInverseSurface,
                            backgroundColor: cs.inverseSurface,
                            side: BorderSide.none,
                            visualDensity: VisualDensity.compact,
                          );
                        }),
                    ],
                  ),
                ),
              TextFormField(
                controller: _potaInputCtrl,
                decoration: const InputDecoration(
                  labelText: 'POTA P2P',
                  hintText: 'US-1234, Enter veya virgülle ekle',
                  prefixIcon: Icon(Icons.park_outlined, size: 20),
                ),
                textCapitalization: TextCapitalization.characters,
                onFieldSubmitted: (value) {
                  final r = value.trim().toUpperCase();
                  _potaInputCtrl.clear();
                  if (r.isNotEmpty) _addPotaRef(r);
                },
              ),
              if (_potaRefs.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 48, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < _potaRefs.length; i++)
                        Builder(builder: (ctx) {
                          final potaRef = _potaRefs[i];
                          final cs = Theme.of(ctx).colorScheme;
                          final labelStyle = TextStyle(
                              fontSize: 12, color: cs.onSurfaceVariant);
                          if (!_potaNameCache.containsKey(potaRef)) {
                            return Row(children: [
                              Text('${i + 1}. ', style: labelStyle),
                              SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: cs.onSurfaceVariant),
                              ),
                            ]);
                          }
                          final name = _potaNameCache[potaRef];
                          if (name == null) {
                            return Row(children: [
                              Text('${i + 1}. ', style: labelStyle),
                              SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: cs.onSurfaceVariant),
                              ),
                            ]);
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 1),
                            child: Text(
                              '${i + 1}. ${name.isEmpty ? potaRef : name}',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    name.isEmpty ? cs.error : cs.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }),
                    ],
                  ),
                ),
            ],
            if (showSota) ...[
              if (showPota) const SizedBox(height: 12),
              TextFormField(
                controller: _sotaRefCtrl,
                decoration: const InputDecoration(
                  labelText: 'SOTA P2P',
                  hintText: 'SP/KR-001',
                  prefixIcon: Icon(Icons.terrain_outlined, size: 20),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            ],
            if (showWwff) ...[
              if (showPota || showSota) const SizedBox(height: 12),
              TextFormField(
                controller: _wwffRefCtrl,
                decoration: const InputDecoration(
                  labelText: 'WWFF P2P',
                  hintText: 'SPFF-0001, TAFF-0001',
                  prefixIcon: Icon(Icons.forest_outlined, size: 20),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
            ],
          ],
        );
      }),
      const SizedBox(height: 12),

      // ── Station profile ─────────────────────────────────────────────
      stations.when(
        data: (list) {
          if (list.isEmpty) return const SizedBox.shrink();
          final editStationId = widget.editQso?.stationProfileId;
          final initial = _selectedStation ??
              (editStationId != null && editStationId != 0
                  ? list.where((s) => s.id == editStationId).firstOrNull
                  : null) ??
              list
                  .where((s) =>
                      s.id ==
                      ref.read(settingsProvider).activeStationProfileId)
                  .firstOrNull ??
              list.where((s) => s.isActive).firstOrNull;
          return DropdownButtonFormField<StationModel>(
            isExpanded: true,
            decoration:
                InputDecoration(labelText: l10n.stationProfileField),
            initialValue: initial,
            items: list
                .map((s) => DropdownMenuItem(
                    value: s,
                    child: Text(
                      '${s.callsign} — ${s.profileName}',
                      overflow: TextOverflow.ellipsis,
                    )))
                .toList(),
            onChanged: (v) {
              setState(() => _selectedStation = v);
              if (v != null) {
                ref.read(settingsProvider.notifier).setActiveStation(v);
              }
              _updateAutoSpotStatus();
            },
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),

      const SizedBox(height: 24),

      // ── Auto-spot status banner ──────────────────────────────────────
      _buildAutoSpotBanner(context),

      FilledButton.icon(
        onPressed: _isSaving ? null : _submit,
        icon: _isSaving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.save),
        label: Text(l10n.saveQsoBtn),
      ),
      const SizedBox(height: 16),
    ];
  }
}
