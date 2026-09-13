import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/band_mode_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/adif_generator.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/callsign_lookup_model.dart';
import '../../../data/models/contest_model.dart';
import '../../../data/models/qso_model.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../providers/qso_provider.dart';
import '../../../providers/remote_datasource_provider.dart';
import '../../../providers/settings_provider.dart';
import 'contest_exchange_fields.dart';
import 'contest_lookup_cards.dart';
import 'contest_session_widgets.dart';

// ── Screen ────────────────────────────────────────────────────────────────────

class ContestLogScreen extends ConsumerStatefulWidget {
  final ContestSession? session;
  const ContestLogScreen({super.key, this.session});

  @override
  ConsumerState<ContestLogScreen> createState() => _ContestLogScreenState();
}

class _ContestLogScreenState extends ConsumerState<ContestLogScreen> {
  // ── Session-level state (static — survives widget rebuilds) ────────────────
  static String _contestId = '';
  static String _band = '20m';
  static String _mode = 'SSB';
  static String _exchangeSent = '';
  static int _serialSent = 1;
  static bool _showSerial     = true;
  static bool _showGridsquare = false;
  static bool _showExchange   = false;
  static String _gridsquareSent = '';

  // ── Per-QSO controllers ───────────────────────────────────────────────────
  final _freqCtrl         = TextEditingController();
  Timer? _freqDebounce;
  final _callsignCtrl     = TextEditingController();
  final _rstSentCtrl      = TextEditingController(text: '59');
  final _rstRcvdCtrl      = TextEditingController(text: '59');
  final _serialRcvdCtrl   = TextEditingController();
  final _exchangeSentCtrl   = TextEditingController(); // persists between QSOs
  final _exchangeRcvdCtrl   = TextEditingController();
  final _gridsquareSentCtrl = TextEditingController(); // persists between QSOs
  final _gridsquareRcvdCtrl = TextEditingController();
  final _callsignFocus    = FocusNode();

  bool _isSaving = false;
  final List<LoggedQso> _recentQsos = [];

  // ── Lookup state ──────────────────────────────────────────────────────────
  bool _lookupLoading = false;
  bool _lookupDone = false;
  bool _lookupSuccess = false;
  CallsignLookupModel? _lookupResult;
  String _currentCallsign = '';    // tracks callsign for tablet panel
  String _lastLookedUp = '';       // avoid re-lookup for same callsign

  ContestSession? _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    if (_session != null) {
      _contestId = _session!.adifName;
      final fields = _session!.exchangeFields;
      _showSerial     = fields.contains('serial');
      _showGridsquare = fields.contains('gridsquare');
      _showExchange   = fields.contains('exchange');
    }
    _exchangeSentCtrl.text   = _exchangeSent;
    _gridsquareSentCtrl.text = _gridsquareSent;
    final centerFreq = kBandCenterFreqMhz[_band];
    if (centerFreq != null) _freqCtrl.text = centerFreq.toStringAsFixed(3);
    _freqCtrl.addListener(_onFreqChanged);
    _callsignFocus.addListener(_onCallsignFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_session == null && _contestId.isEmpty) {
        _openSetupSheet();
      } else {
        _callsignFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _freqDebounce?.cancel();
    _freqCtrl.removeListener(_onFreqChanged);
    _freqCtrl.dispose();
    _callsignFocus.removeListener(_onCallsignFocusChange);
    _callsignCtrl.dispose();
    _rstSentCtrl.dispose();
    _rstRcvdCtrl.dispose();
    _serialRcvdCtrl.dispose();
    _exchangeSentCtrl.dispose();
    _exchangeRcvdCtrl.dispose();
    _gridsquareSentCtrl.dispose();
    _gridsquareRcvdCtrl.dispose();
    _callsignFocus.dispose();
    super.dispose();
  }

  // ── Frequency → band auto-detection ──────────────────────────────────────

  void _onFreqChanged() {
    _freqDebounce?.cancel();
    _freqDebounce = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      final text = _freqCtrl.text.trim();
      if (text.isEmpty) {
        final center = kBandCenterFreqMhz[_band];
        if (center != null) _freqCtrl.text = center.toStringAsFixed(3);
        return;
      }

      // kHz → MHz: nokta yoksa otomatik dönüştür (÷1000 veya ÷10000)
      final freqText = autoFormatFreqInput(text);
      if (freqText != text) {
        _freqCtrl.value = TextEditingValue(
          text: freqText,
          selection: TextSelection.collapsed(offset: freqText.length),
        );
        return; // listener yeniden tetiklenir, band tespiti orada yapılır
      }

      final parsed = double.tryParse(freqText);
      if (parsed != null) {
        final detected = getBandFromFreq(parsed);
        if (detected != null && detected != _band) {
          setState(() => _band = detected);
        }
      }
    });
  }

  // ── Lookup ────────────────────────────────────────────────────────────────

  void _onCallsignFocusChange() {
    if (!_callsignFocus.hasFocus) {
      final cs = _callsignCtrl.text.trim().toUpperCase();
      if (cs.isNotEmpty && cs != _lastLookedUp) _doLookup(cs);
    }
  }

  Future<void> _doLookup(String callsign) async {
    if (callsign.isEmpty) return;
    _lastLookedUp = callsign;
    setState(() {
      _currentCallsign = callsign;
      _lookupLoading = true;
      _lookupDone = false;
      _lookupSuccess = false;
      _lookupResult = null;
    });
    try {
      final result = await ref
          .read(wavelogRemoteDatasourceProvider)
          .lookupCallsign(callsign: callsign, band: _band, mode: _mode);
      if (!mounted) return;
      setState(() {
        _lookupLoading = false;
        _lookupDone = true;
        _lookupSuccess = true;
        _lookupResult = result;
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

  // ── Setup sheet (standalone mode only) ────────────────────────────────────

  Future<void> _openSetupSheet() async {
    final contestCtrl  = TextEditingController(text: _contestId);
    final exchangeCtrl = TextEditingController(text: _exchangeSent);
    final serialCtrl   = TextEditingController(text: _serialSent.toString());
    var band     = _band;
    var mode     = _mode;
    var useSerial = _showSerial;
    var useGrid   = _showGridsquare;
    var useExch   = _showExchange;
    final l10n = context.l10n;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36, height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: Theme.of(ctx).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Text(l10n.contestSetup,
                    style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 20),
                TextField(
                  controller: contestCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: l10n.contestIdLabel,
                    hintText: l10n.contestNameHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.bandField,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: band,
                          isDense: true,
                          items: kCommonBands
                              .map((b) =>
                                  DropdownMenuItem(value: b, child: Text(b)))
                              .toList(),
                          onChanged: (v) => setS(() => band = v ?? band),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.modeField,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: mode,
                          isDense: true,
                          items: kCommonModes
                              .map((m) =>
                                  DropdownMenuItem(value: m, child: Text(m)))
                              .toList(),
                          onChanged: (v) => setS(() => mode = v ?? mode),
                        ),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                TextField(
                  controller: exchangeCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: l10n.ourExchange,
                    hintText: 'SP, 001, OH...',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: serialCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.serialStart,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Text(l10n.exchangeType,
                    style: Theme.of(ctx).textTheme.labelLarge),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: Text(l10n.exchangeTypeSerial),
                      selected: useSerial,
                      onSelected: (v) => setS(() => useSerial = v),
                    ),
                    FilterChip(
                      label: const Text('Grid'),
                      selected: useGrid,
                      onSelected: (v) => setS(() => useGrid = v),
                    ),
                    FilterChip(
                      label: Text(l10n.exchangeTypeExchange),
                      selected: useExch,
                      onSelected: (v) => setS(() => useExch = v),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        _contestId        = contestCtrl.text.trim().toUpperCase();
                        _exchangeSent     = exchangeCtrl.text.trim();
                        _exchangeSentCtrl.text = _exchangeSent;
                        _band             = band;
                        _mode             = mode;
                        _showSerial       = useSerial;
                        _showGridsquare   = useGrid;
                        _showExchange     = useExch;
                        _serialSent       =
                            int.tryParse(serialCtrl.text.trim()) ?? 1;
                      });
                      Navigator.of(ctx).pop();
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _callsignFocus.requestFocus());
                    },
                    child: Text(l10n.startContest),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Log QSO ───────────────────────────────────────────────────────────────

  Future<void> _logQso() async {
    final callsign = _callsignCtrl.text.trim().toUpperCase();
    if (callsign.isEmpty) {
      _callsignFocus.requestFocus();
      return;
    }

    final stationId = _session?.stationId ??
        ref.read(settingsProvider).activeStationProfileId;
    if (stationId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.noActiveStation)));
      }
      return;
    }

    setState(() => _isSaving = true);

    final now     = DateTime.now().toUtc();
    final rstSent  = _rstSentCtrl.text.trim().isEmpty ? '59' : _rstSentCtrl.text.trim();
    final rstRcvd  = _rstRcvdCtrl.text.trim().isEmpty ? '59' : _rstRcvdCtrl.text.trim();
    final freqText = _freqCtrl.text.trim();
    final freq     = freqText.isNotEmpty
        ? double.tryParse(freqText)
        : kBandCenterFreqMhz[_band];

    final raw = <String, String>{
      'CALL':     callsign,
      'QSO_DATE': _fmtDate(now),
      'TIME_ON':  _fmtTime(now),
      'BAND':     _band,
      'MODE':     _mode,
      'RST_SENT': rstSent,
      'RST_RCVD': rstRcvd,
    };
    if (freq != null) raw['FREQ'] = freq.toStringAsFixed(3);
    if (_contestId.isNotEmpty) raw['CONTEST_ID'] = _contestId;
    if (_showSerial) {
      raw['STX'] = _serialSent.toString().padLeft(3, '0');
      if (_serialRcvdCtrl.text.trim().isNotEmpty) raw['SRX'] = _serialRcvdCtrl.text.trim();
    }
    if (_showGridsquare) {
      final gs = _gridsquareSentCtrl.text.trim();
      if (gs.isNotEmpty) raw['MY_GRIDSQUARE'] = gs;
      if (_gridsquareRcvdCtrl.text.trim().isNotEmpty) raw['GRIDSQUARE'] = _gridsquareRcvdCtrl.text.trim();
    }
    if (_showExchange) {
      final exchSent = _exchangeSentCtrl.text.trim();
      if (exchSent.isNotEmpty) raw['STX_STRING'] = exchSent;
      if (_exchangeRcvdCtrl.text.trim().isNotEmpty) raw['SRX_STRING'] = _exchangeRcvdCtrl.text.trim();
    }

    final qso = QsoModel(
      callsign: callsign,
      dateTimeOn: now,
      band: _band,
      freqMhz: freq,
      mode: _mode,
      rstSent: rstSent,
      rstRcvd: rstRcvd,
      stationProfileId: stationId,
      rawAdif: raw,
    );

    try {
      final isOnline    = ref.read(isOnlineProvider);
      final offlineMode = ref.read(settingsProvider).offlineModeEnabled;
      final forceLocal  = offlineMode || !isOnline;

      if (_session != null && !forceLocal) {
        final adif = AdifGenerator.generateSingle(qso);
        await ref.read(wavelogRemoteDatasourceProvider).logContestQso(
              contestSessionId: _session!.id,
              stationProfileId: stationId,
              adifString: adif,
            );
        await ref.read(qsoProvider.notifier).addQso(qso, forceLocal: true);
      } else {
        await ref.read(qsoProvider.notifier).addQso(qso, forceLocal: forceLocal);
      }

      if (!mounted) return;

      final savedSerial     = _serialSent;
      final savedSerialRcvd = _serialRcvdCtrl.text.trim();
      final savedGridRcvd   = _gridsquareRcvdCtrl.text.trim();
      final savedExchRcvd   = _exchangeRcvdCtrl.text.trim();

      setState(() {
        _recentQsos.insert(
          0,
          LoggedQso(
            callsign:     callsign,
            time:         now,
            serialSent:   savedSerial,
            serialRcvd:   savedSerialRcvd,
            gridRcvd:     savedGridRcvd,
            exchangeRcvd: savedExchRcvd,
          ),
        );
        if (_recentQsos.length > 15) _recentQsos.removeLast();
        if (_showSerial) _serialSent++;
        _exchangeSent   = _exchangeSentCtrl.text.trim();
        _gridsquareSent = _gridsquareSentCtrl.text.trim();
        _callsignCtrl.clear();
        _rstSentCtrl.text = '59';
        _rstRcvdCtrl.text = '59';
        _serialRcvdCtrl.clear();
        // sent fields intentionally NOT cleared — persist between QSOs
        _exchangeRcvdCtrl.clear();
        _gridsquareRcvdCtrl.clear();
        // Reset lookup state for next QSO
        _lookupDone = false;
        _lookupSuccess = false;
        _lookupResult = null;
        _lastLookedUp = '';
        _currentCallsign = '';
      });
      _callsignFocus.requestFocus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.l10n.error}: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── End session ───────────────────────────────────────────────────────────

  Future<void> _endSession() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.endContest),
        content: Text(l10n.endContestConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.endContest)),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        _contestId    = '';
        _band         = '20m';
        _mode         = 'SSB';
        _exchangeSent = '';
        _serialSent   = 1;
        final defaultFreq = kBandCenterFreqMhz['20m'];
        _freqCtrl.text = defaultFreq != null ? defaultFreq.toStringAsFixed(3) : '';
        _showSerial     = true;
        _showGridsquare = false;
        _showExchange   = false;
        _gridsquareSent = '';
        _recentQsos.clear();
        _callsignCtrl.clear();
        _rstSentCtrl.text = '59';
        _rstRcvdCtrl.text = '59';
        _serialRcvdCtrl.clear();
        _exchangeSentCtrl.clear();
        _exchangeRcvdCtrl.clear();
        _gridsquareSentCtrl.clear();
        _gridsquareRcvdCtrl.clear();
        _lookupResult = null;
        _lookupDone = false;
        _lastLookedUp = '';
        _currentCallsign = '';
      });
      Navigator.of(context).pop();
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n     = context.l10n;
    final cs       = Theme.of(context).colorScheme;
    final tt       = Theme.of(context).textTheme;
    final isTablet = Responsive.useTabletLayout(context);

    final displayContest = _session?.adifName.isNotEmpty == true
        ? _session!.adifName
        : _contestId;
    final displayName = _session?.contestName.isNotEmpty == true
        ? _session!.contestName
        : null;

    final formColumn = Column(
      children: [
        ContestSessionBar(
          contestId: displayContest,
          band: _band,
          mode: _mode,
          serialSent: _serialSent,
          onTap: _session == null ? _openSetupSheet : null,
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: Column(
            children: [
              // ── Callsign ───────────────────────────────────────────────
              TextField(
                controller: _callsignCtrl,
                focusNode: _callsignFocus,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                style: tt.headlineMedium?.copyWith(
                  fontFamily: kMonoFontFamily,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                decoration: InputDecoration(
                  hintText: l10n.callsignField,
                  border: const OutlineInputBorder(),
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
                                  : Icons.clear,
                              color: _lookupSuccess ? Colors.green : Colors.grey,
                              size: 20,
                            )
                          : (_callsignCtrl.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _callsignCtrl.clear();
                                    setState(() {
                                      _lookupResult = null;
                                      _lookupDone = false;
                                      _lastLookedUp = '';
                                      _currentCallsign = '';
                                    });
                                    _callsignFocus.requestFocus();
                                  },
                                )
                              : null),
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (v) {
                  final cs = v.trim().toUpperCase();
                  if (cs.isNotEmpty && cs != _lastLookedUp) _doLookup(cs);
                },
              ),

              // ── Compact lookup result (phone only) ─────────────────────
              if (!isTablet && _lookupResult != null) ...[
                const SizedBox(height: 6),
                CompactLookupCard(info: _lookupResult!),
              ],

              const SizedBox(height: 8),

              // ── Frequency + Mode row ───────────────────────────────────
              Row(children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _freqCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(fontFamily: kMonoFontFamily),
                    decoration: InputDecoration(
                      labelText: l10n.frequencyField,
                      hintText: '14.225',
                      suffixText: 'MHz',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.modeField,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _mode,
                        isDense: true,
                        items: kCommonModes
                            .map((m) =>
                                DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _mode = v);
                        },
                      ),
                    ),
                  ),
                ),
              ]),

              const SizedBox(height: 8),

              // ── RST row ────────────────────────────────────────────────
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _rstSentCtrl,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontFamily: kMonoFontFamily),
                    decoration: InputDecoration(
                      labelText: l10n.rstSentField,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _rstRcvdCtrl,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontFamily: kMonoFontFamily),
                    decoration: InputDecoration(
                      labelText: l10n.rstRcvdField,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ]),

              ContestExchangeFields(
                showSerial: _showSerial,
                showGridsquare: _showGridsquare,
                showExchange: _showExchange,
                serialSent: _serialSent,
                serialRcvdCtrl: _serialRcvdCtrl,
                gridsquareSentCtrl: _gridsquareSentCtrl,
                gridsquareRcvdCtrl: _gridsquareRcvdCtrl,
                exchangeSentCtrl: _exchangeSentCtrl,
                exchangeRcvdCtrl: _exchangeRcvdCtrl,
                onGridSentChanged: (v) => _gridsquareSent = v.trim(),
                onExchangeSentChanged: (v) => _exchangeSent = v.trim(),
                onSubmitLog: _logQso,
              ),

              const SizedBox(height: 12),

              // ── LOG QSO button ─────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _logQso,
                  icon: _isSaving
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: cs.onPrimary),
                        )
                      : const Icon(Icons.check),
                  label: Text(l10n.logQso,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),
        const Divider(height: 1),

        // ── Recent QSOs ────────────────────────────────────────────────
        if (_recentQsos.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(children: [
              Text(l10n.contestRecentQsos,
                  style:
                      tt.labelMedium?.copyWith(color: cs.onSurfaceVariant)),
              const Spacer(),
              Text('${_recentQsos.length}',
                  style:
                      tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _recentQsos.length,
              itemBuilder: (ctx, i) => RecentQsoTile(
                  qso: _recentQsos[i],
                  showGrid: _showGridsquare,
                  showExch: _showExchange),
            ),
          ),
        ] else
          Expanded(
            child: Center(
              child: Text(l10n.contestRecentQsos,
                  style:
                      tt.bodySmall?.copyWith(color: cs.outline)),
            ),
          ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.contestLog),
            if (displayName != null && displayName != displayContest)
              Text(displayName,
                  style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant)),
          ],
        ),
        actions: [
          if (_session == null)
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: l10n.contestSetup,
              onPressed: _openSetupSheet,
            ),
          IconButton(
            icon: const Icon(Icons.stop_circle_outlined),
            tooltip: l10n.endContest,
            onPressed: _endSession,
          ),
        ],
      ),
      body: isTablet
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: formColumn),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(
                  flex: 4,
                  child: ContestInfoPanel(callsign: _currentCallsign),
                ),
              ],
            )
          : formColumn,
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

String _fmtDate(DateTime dt) =>
    '${dt.year.toString().padLeft(4, '0')}'
    '${dt.month.toString().padLeft(2, '0')}'
    '${dt.day.toString().padLeft(2, '0')}';

String _fmtTime(DateTime dt) =>
    '${dt.hour.toString().padLeft(2, '0')}'
    '${dt.minute.toString().padLeft(2, '0')}'
    '${dt.second.toString().padLeft(2, '0')}';
