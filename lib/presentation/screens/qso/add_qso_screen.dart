import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/band_mode_data.dart';
import '../../../core/utils/error_l10n.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/callsign_lookup_model.dart';
import '../../../data/models/qso_model.dart';
import '../../../data/models/station_model.dart';
import '../../../providers/auto_spot_provider.dart';
import '../../../services/auto_spot_service.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../providers/lookup_provider.dart';
import '../../../providers/qso_provider.dart';
import '../../../providers/remote_datasource_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/station_provider.dart';

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
  late TextEditingController _potaRefCtrl;
  late TextEditingController _sotaRefCtrl;
  late TextEditingController _wwffRefCtrl;
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
    _band = settings.defaultBand;
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
      _potaRefCtrl = TextEditingController(text: edit.rawAdif?['POTA_REF'] ?? '');
      _sotaRefCtrl = TextEditingController(text: edit.rawAdif?['SOTA_REF'] ?? '');
      _wwffRefCtrl = TextEditingController(text: edit.rawAdif?['WWFF_REF'] ?? '');
      _dxccCountry = edit.country ?? edit.rawAdif?['COUNTRY'] ?? edit.dxcc;
      _dxccFlag = edit.rawAdif?['APP_WAVELOG_FLAG'];
    } else {
      // Restore last submode when band+mode match the remembered combination
      if (_memBand == _band && _memMode == _mode) {
        _submode = _memSubmode;
      }

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
      _potaRefCtrl = TextEditingController();
      _sotaRefCtrl = TextEditingController();
      _wwffRefCtrl = TextEditingController();
    }

    _callsignFocus = FocusNode();
    _callsignFocus.addListener(_onCallsignFocusChange);
    _freqCtrl.addListener(_updateAutoSpotStatus);
    if (widget.editQso == null) _freqCtrl.addListener(_saveFreqDebounced);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (edit == null &&
          widget.prefillCallsign != null &&
          widget.prefillCallsign!.isNotEmpty) {
        _currentCallsign = widget.prefillCallsign!.toUpperCase();
        _doLookup();
      }
      _updateAutoSpotStatus();
      _startStatusTimer();
      if (edit == null) _loadLastFreq();
    });
  }

  void _saveFreqDebounced() {
    _freqSaveDebounce?.cancel();
    _freqSaveDebounce = Timer(const Duration(milliseconds: 800), () {
      final freq = _freqCtrl.text.trim();
      if (freq.isNotEmpty) {
        ref.read(settingsLocalDatasourceProvider).saveLastFreq(freq);
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
    _potaRefCtrl.dispose();
    _sotaRefCtrl.dispose();
    _wwffRefCtrl.dispose();
    super.dispose();
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

  void _onModeChanged(String mode) {
    setState(() {
      _mode = mode;
      _submode = null; // Mode changed → forget submode
    });
    _rstSentCtrl.text = getDefaultRst(mode);
    _rstRcvdCtrl.text = getDefaultRst(mode);
    _updateAutoSpotStatus();
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
      _submode = null; // Band changed → forget submode
      final freq = kBandCenterFreqMhz[band];
      if (freq != null) _freqCtrl.text = freq.toString();
    });
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
    _potaRefCtrl.clear();
    _sotaRefCtrl.clear();
    _wwffRefCtrl.clear();
    _rstSentCtrl.text = getDefaultRst(_mode);
    _rstRcvdCtrl.text = getDefaultRst(_mode);
    setState(() {
      // Restore submode from memory if band+mode unchanged
      _submode = (_memBand == _band && _memMode == _mode) ? _memSubmode : null;
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
      if (_potaRefCtrl.text.trim().isNotEmpty)
        'POTA_REF': _potaRefCtrl.text.trim().toUpperCase(),
      if (_sotaRefCtrl.text.trim().isNotEmpty)
        'SOTA_REF': _sotaRefCtrl.text.trim().toUpperCase(),
      if (_wwffRefCtrl.text.trim().isNotEmpty)
        'WWFF_REF': _wwffRefCtrl.text.trim().toUpperCase(),
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
        borderRadius: BorderRadius.circular(10),
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
                child: _TabletInfoPanel(callsign: _currentCallsign),
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
      _ModeToggle(
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
                      color: _lookupSuccess ? Colors.green : Colors.grey,
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
        const _LogbookSummaryCard(),

      // ── Previous QSOs inline (phone only — tablet uses right panel) ──
      if (!Responsive.useTabletLayout(context) && _currentCallsign.length >= 3)
        _InlinePreviousQsos(callsign: _currentCallsign),

      // ── Date / Time ─────────────────────────────────────────────────
      _isLive
          ? _LiveClockTile(label: l10n.liveDateTimeLabel)
          : ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(l10n.dateTimeLabel),
              subtitle:
                  Text(DateFormat('dd.MM.yyyy  HH:mm').format(_dateTimeOn)),
              trailing: const Icon(Icons.edit_outlined),
              onTap: _pickDateTime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
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
              initialValue: _submode,
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
              },
            ),
          ),
        ],
      ]),
      const SizedBox(height: 12),

      // ── Frequency ───────────────────────────────────────────────────
      TextFormField(
        controller: _freqCtrl,
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
            decoration: InputDecoration(labelText: l10n.rstSentField),
            keyboardType: TextInputType.number,
            validator: (v) => validateRst(v, _mode),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: _rstRcvdCtrl,
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
            if (showPota)
              TextFormField(
                controller: _potaRefCtrl,
                decoration: const InputDecoration(
                  labelText: 'POTA P2P',
                  hintText: 'US-1234',
                  prefixIcon: Icon(Icons.park_outlined, size: 20),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
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
                  hintText: 'SPFF-0001',
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
          final initial = _selectedStation ??
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

// ── Mode toggle ───────────────────────────────────────────────────────────────

class _ModeToggle extends StatelessWidget {
  final bool isLive;
  final String liveLabel;
  final String historicalLabel;
  final ValueChanged<bool> onChanged;

  const _ModeToggle({
    required this.isLive,
    required this.liveLabel,
    required this.historicalLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _ToggleBtn(
            label: liveLabel,
            icon: Icons.radio_button_checked,
            active: isLive,
            activeColor: Colors.green,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ToggleBtn(
            label: historicalLabel,
            icon: Icons.history,
            active: !isLive,
            activeColor: cs.primary,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  const _ToggleBtn({
    required this.label,
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? activeColor.withValues(alpha: 0.15)
              : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active
                ? activeColor.withValues(alpha: 0.7)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 16, color: active ? activeColor : cs.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? activeColor : cs.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Live UTC clock tile ───────────────────────────────────────────────────────
// Kendi timer'ıyla tik atar — saati form state'inde tutmak tüm formu
// saniyede bir yeniden çiziyordu.

class _LiveClockTile extends StatefulWidget {
  final String label;

  const _LiveClockTile({required this.label});

  @override
  State<_LiveClockTile> createState() => _LiveClockTileState();
}

class _LiveClockTileState extends State<_LiveClockTile> {
  Timer? _timer;
  DateTime _now = DateTime.now().toUtc();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now().toUtc());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
      ),
      child: Row(children: [
        const Icon(Icons.circle, color: Colors.green, size: 10),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.label,
                style: TextStyle(fontSize: 11, color: cs.secondary)),
            Text(
              DateFormat('dd.MM.yyyy   HH:mm:ss').format(_now),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ],
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TABLET INFO PANEL
// ═══════════════════════════════════════════════════════════════════════════════

class _TabletInfoPanel extends ConsumerWidget {
  final String callsign;
  const _TabletInfoPanel({required this.callsign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (callsign.length < 3) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
        children: [
          // ── Placeholder ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person_search_outlined,
                    size: 72, color: cs.outlineVariant),
                const SizedBox(height: 20),
                Text(context.l10n.counterStation,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(height: 8),
                Text(
                  context.l10n.counterStationHint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),

          // ── Son QSO'lar ──────────────────────────────────────────
          const _LogbookSummaryCard(),
        ],
      );
    }

    final lookupAsync = ref.watch(callsignInfoProvider(callsign));
    final previousAsync = ref.watch(previousQsosByCallsignProvider(callsign));

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
      children: [
        // ── Callsign header ──────────────────────────────────────────
        Row(children: [
          Icon(Icons.radio, size: 16, color: cs.primary),
          const SizedBox(width: 6),
          Text(
            callsign,
            style: theme.textTheme.titleLarge?.copyWith(
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              color: cs.primary,
              letterSpacing: 1.5,
            ),
          ),
        ]),
        const SizedBox(height: 12),

        // ── QRZ info ────────────────────────────────────────────────
        lookupAsync.when(
          loading: () => const LinearProgressIndicator(minHeight: 2),
          error: (_, __) => const SizedBox.shrink(),
          data: (info) => Column(
            children: [
              _QrzInfoCard(info: info),
              const SizedBox(height: 12),
              _QsoMapCard(info: info),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Son QSO'lar ──────────────────────────────────────────────
        const _LogbookSummaryCard(),

        const SizedBox(height: 12),

        // ── Previous QSOs with this callsign ────────────────────────
        previousAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (qsos) =>
              qsos.isEmpty ? const SizedBox.shrink() : _PreviousQsosCard(qsos: qsos),
        ),
      ],
    );
  }
}

// ── QSO map card (tablet) ────────────────────────────────────────────────────

LatLng? _maidenheadToLatLng(String grid) {
  try {
    final g = grid.toUpperCase();
    if (g.length < 4) return null;
    double lon = (g.codeUnitAt(0) - 65) * 20.0 - 180.0
               + (g.codeUnitAt(2) - 48) * 2.0;
    double lat = (g.codeUnitAt(1) - 65) * 10.0 - 90.0
               + (g.codeUnitAt(3) - 48) * 1.0;
    if (g.length >= 6) {
      lon += (g.codeUnitAt(4) - 65) / 12.0 + 1.0 / 24.0;
      lat += (g.codeUnitAt(5) - 65) / 24.0 + 1.0 / 48.0;
    } else {
      lon += 1.0;
      lat += 0.5;
    }
    if (lat < -90 || lat > 90 || lon < -180 || lon > 180) return null;
    return LatLng(lat, lon);
  } catch (_) {
    return null;
  }
}


class _QsoMapCard extends ConsumerWidget {
  final CallsignLookupModel info;
  const _QsoMapCard({required this.info});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final settings = ref.watch(settingsProvider);
    final stations = ref.watch(stationProvider).valueOrNull ?? [];

    StationModel? myStation;
    try {
      myStation = stations.firstWhere(
          (s) => s.id == settings.activeStationProfileId);
    } catch (_) {
      myStation = stations.isNotEmpty ? stations.first : null;
    }
    final myGrid = myStation?.gridSquare;
    final remoteGrid = info.gridSquare;

    if (myGrid == null || myGrid.length < 4) return const SizedBox.shrink();
    if (remoteGrid == null || remoteGrid.length < 4) return const SizedBox.shrink();

    final myPos     = _maidenheadToLatLng(myGrid);
    final remotePos = _maidenheadToLatLng(remoteGrid);
    if (myPos == null || remotePos == null) return const SizedBox.shrink();

    final distKm = const Distance().as(LengthUnit.Kilometer, myPos, remotePos);
    final bounds = LatLngBounds.fromPoints([myPos, remotePos]);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 240,
            child: FlutterMap(
              options: MapOptions(
                initialCameraFit: CameraFit.bounds(
                  bounds: bounds,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 24),
                ),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.wavelog_mobile',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [myPos, remotePos],
                      color: Colors.red.withValues(alpha: 0.85),
                      strokeWidth: 2.0,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: myPos,
                      width: 22,
                      height: 22,
                      child: const Icon(Icons.star,
                          color: Colors.amber, size: 22),
                    ),
                    Marker(
                      point: remotePos,
                      width: 14,
                      height: 14,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(children: [
              Icon(Icons.straighten, size: 14, color: cs.primary),
              const SizedBox(width: 4),
              Text(
                '${distKm.round()} km',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Icon(Icons.grid_on, size: 13, color: cs.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(remoteGrid,
                  style: TextStyle(
                      fontSize: 12, color: cs.onSurfaceVariant)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── QRZ compact info card ─────────────────────────────────────────────────────

class _QrzInfoCard extends StatelessWidget {
  final CallsignLookupModel info;
  const _QrzInfoCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final hasPhoto = info.imageUrl != null && info.imageUrl!.isNotEmpty;
    final hasBasicInfo = info.name != null || info.country != null;
    final hasChips = info.dxcc != null ||
        info.gridSquare != null ||
        info.cqZone != null ||
        info.ituZone != null ||
        info.continent != null;
    final hasQsl = info.lotwMember || info.eqslMember || info.buqslMember;

    if (!hasBasicInfo && !hasPhoto && !hasChips && !hasQsl) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row: photo + name/country ──────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasPhoto) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: info.imageUrl!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => _photoPlaceholder(cs),
                      errorWidget: (_, __, ___) => _photoPlaceholder(cs),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (info.name != null)
                        Text(
                          info.name!,
                          style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600),
                        ),
                      if (info.qth != null || info.country != null) ...[
                        const SizedBox(height: 2),
                        Row(children: [
                          if (info.flag != null && info.flag!.isNotEmpty) ...[
                            Text(info.flag!,
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              [info.qth, info.country]
                                  .whereType<String>()
                                  .join(', '),
                              style: TextStyle(
                                  fontSize: 12, color: cs.onSurfaceVariant),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                      ],
                      if (info.workedBefore) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.green.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  size: 12, color: Colors.green),
                              const SizedBox(width: 4),
                              Text(context.l10n.workedBefore,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // ── Info chips ─────────────────────────────────────────────
            if (hasChips) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (info.dxcc != null)
                    _InfoChip('DXCC', info.dxcc!, cs),
                  if (info.gridSquare != null)
                    _InfoChip('Grid', info.gridSquare!, cs),
                  if (info.cqZone != null)
                    _InfoChip('CQ', info.cqZone!, cs),
                  if (info.ituZone != null)
                    _InfoChip('ITU', info.ituZone!, cs),
                  if (info.continent != null)
                    _InfoChip(context.l10n.continent, info.continent!, cs),
                ],
              ),
            ],

            // ── QSL badges ─────────────────────────────────────────────
            if (hasQsl) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.mail_outline, size: 13, color: cs.secondary),
                const SizedBox(width: 4),
                Text('QSL',
                    style: TextStyle(
                        fontSize: 12,
                        color: cs.secondary,
                        fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                if (info.lotwMember) const _QslBadge('LoTW', Colors.blue),
                if (info.lotwMember) const SizedBox(width: 4),
                if (info.eqslMember) const _QslBadge('eQSL', Colors.orange),
                if (info.eqslMember) const SizedBox(width: 4),
                if (info.buqslMember) _QslBadge(context.l10n.bureau, Colors.purple),
              ]),
            ],

            // ── Address ────────────────────────────────────────────────
            if (info.addr1 != null) ...[
              const SizedBox(height: 6),
              Text(
                info.addr1!,
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // ── Email ──────────────────────────────────────────────────
            if (info.email != null) ...[
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.email_outlined, size: 12, color: cs.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    info.email!,
                    style: TextStyle(
                        fontSize: 11,
                        color: cs.primary,
                        decoration: TextDecoration.underline),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _photoPlaceholder(ColorScheme cs) => Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.person, size: 32, color: cs.onSurfaceVariant),
      );
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  const _InfoChip(this.label, this.value, this.cs);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: '$label ',
              style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w400)),
          TextSpan(
              text: value,
              style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface,
                  fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

class _QslBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _QslBadge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.w700)),
    );
  }
}

// ── Previous QSOs card ────────────────────────────────────────────────────────

class _PreviousQsosCard extends StatelessWidget {
  final List<QsoModel> qsos;
  const _PreviousQsosCard({required this.qsos});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final displayed = qsos.take(15).toList();

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.history, size: 15, color: cs.primary),
              const SizedBox(width: 6),
              Text(
                context.l10n.previousQsosCount(qsos.length),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: cs.primary,
                ),
              ),
            ]),
            const Divider(height: 14),
            ...displayed.map((q) => _QsoHistoryRow(qso: q, cs: cs)),
            if (qsos.length > 15)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  context.l10n.morePreviousQsos(qsos.length - 15),
                  style:
                      TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QsoHistoryRow extends StatelessWidget {
  final QsoModel qso;
  final ColorScheme cs;
  const _QsoHistoryRow({required this.qso, required this.cs});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd.MM.yyyy').format(qso.dateTimeOn.toLocal());
    final time = DateFormat('HH:mm').format(qso.dateTimeOn.toUtc());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.radio_button_unchecked, size: 8, color: cs.primary),
          const SizedBox(width: 8),
          // Date + time
          SizedBox(
            width: 90,
            child: Text(
              '$date\n$time UTC',
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(width: 6),
          // Band badge
          _HistoryBadge(
              qso.band, cs.primaryContainer, cs.onPrimaryContainer),
          const SizedBox(width: 4),
          // Mode badge
          _HistoryBadge(
              qso.mode, cs.tertiaryContainer, cs.onTertiaryContainer),
          const SizedBox(width: 6),
          // RST
          if (qso.rstSent.isNotEmpty)
            Text(
              qso.rstSent,
              style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
            ),
          // Sync indicator
          const Spacer(),
          if (!qso.synced)
            Icon(Icons.cloud_off, size: 12, color: Colors.orange.shade300),
        ],
      ),
    );
  }
}

class _HistoryBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _HistoryBadge(this.label, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}

// ── Inline previous QSOs (phone layout only) ──────────────────────────────────

class _InlinePreviousQsos extends ConsumerWidget {
  final String callsign;
  const _InlinePreviousQsos({required this.callsign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(previousQsosByCallsignProvider(callsign));
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (qsos) {
        if (qsos.isEmpty) return const SizedBox.shrink();
        final displayed = qsos.take(5).toList();
        final cs = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            margin: EdgeInsets.zero,
            color: cs.surfaceContainerLow,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.history, size: 14, color: cs.primary),
                    const SizedBox(width: 6),
                    Text(
                      context.l10n.previousQsosWithCallsign(callsign),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      context.l10n.totalQsos(qsos.length),
                      style:
                          TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                    ),
                  ]),
                  const Divider(height: 10),
                  ...displayed.map((q) => _InlineQsoRow(qso: q, cs: cs)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InlineQsoRow extends StatelessWidget {
  final QsoModel qso;
  final ColorScheme cs;
  const _InlineQsoRow({required this.qso, required this.cs});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('dd.MM.yy HH:mm').format(qso.dateTimeOn.toUtc());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(Icons.radio_button_unchecked, size: 7, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$dateStr UTC',
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
          _HistoryBadge(qso.band, cs.primaryContainer, cs.onPrimaryContainer),
          const SizedBox(width: 4),
          _HistoryBadge(
              qso.mode, cs.tertiaryContainer, cs.onTertiaryContainer),
          if (qso.freqMhz != null) ...[
            const SizedBox(width: 6),
            Text(
              qso.freqMhz!.toStringAsFixed(3),
              style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
            ),
          ],
          if (qso.rstSent.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              qso.rstSent,
              style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Logbook özeti kartı (telefon düzeni) ──────────────────────────────────────
// Bugünün yerel QSO sayısını ve son 5 QSO'yu gösterir (çağrı işaretinden bağımsız).

class _LogbookSummaryCard extends ConsumerWidget {
  const _LogbookSummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(logbookSummaryProvider);
    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (summary) {
        final todayCount = summary.todayCount;
        final last5 = summary.last5;
        if (last5.isEmpty && todayCount == 0) return const SizedBox.shrink();
        final cs = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            margin: EdgeInsets.zero,
            color: cs.surfaceContainerLow,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Başlık satırı ──────────────────────────────────────
                  Row(children: [
                    Icon(Icons.list_alt, size: 14, color: cs.primary),
                    const SizedBox(width: 6),
                    Text(
                      l.logbookSummaryTitle,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: cs.primary),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l.todayQsoCount(todayCount),
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimaryContainer),
                      ),
                    ),
                  ]),
                  if (last5.isNotEmpty) ...[
                    const Divider(height: 8),
                    // ── Sütun başlıkları ──────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(children: [
                        Expanded(
                          flex: 24,
                          child: Text(l.colDateTime,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 28,
                          child: Text('QSO',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 12,
                          child: Text('Mod',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 12,
                          child: Text(l.colRstSent,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 12,
                          child: Text(l.colRstRcvd,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 12,
                          child: Text('Band',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant)),
                        ),
                      ]),
                    ),
                    ...last5.map((q) => _LogbookRow(qso: q, cs: cs)),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LogbookRow extends StatelessWidget {
  final QsoModel qso;
  final ColorScheme cs;
  const _LogbookRow({required this.qso, required this.cs});

  @override
  Widget build(BuildContext context) {
    final dt = qso.dateTimeOn.toUtc();
    final dateStr = DateFormat('dd/MM/yy HH:mm').format(dt);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          // Tarih/Saat
          Expanded(
            flex: 24,
            child: Text(
              dateStr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: cs.onSurfaceVariant),
            ),
          ),
          // QSO (çağrı işareti)
          Expanded(
            flex: 28,
            child: Text(
              qso.callsign,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: cs.primary),
            ),
          ),
          // Mod
          Expanded(
            flex: 12,
            child: Text(
              qso.mode,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10, color: cs.onSurface),
            ),
          ),
          // RST (G) — gönderilen
          Expanded(
            flex: 12,
            child: Text(
              qso.rstSent,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: cs.onSurface),
            ),
          ),
          // RST (A) — alınan
          Expanded(
            flex: 12,
            child: Text(
              qso.rstRcvd,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'monospace',
                  color: cs.onSurface),
            ),
          ),
          // Band
          Expanded(
            flex: 12,
            child: Text(
              qso.band,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
