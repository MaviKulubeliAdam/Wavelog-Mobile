import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/band_mode_data.dart';
import '../../../core/utils/adif_generator.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/callsign_lookup_model.dart';
import '../../../data/models/contest_model.dart';
import '../../../data/models/qso_model.dart';
import '../../../providers/connectivity_provider.dart';
import '../../../providers/lookup_provider.dart';
import '../../../providers/qso_provider.dart';
import '../../../providers/remote_datasource_provider.dart';
import '../../../providers/settings_provider.dart';

// ── Logged QSO entry (in-memory recent list) ──────────────────────────────────

class _LoggedQso {
  final String callsign;
  final DateTime time;
  final int serialSent;
  final String serialRcvd;
  final String gridRcvd;
  final String exchangeRcvd;

  const _LoggedQso({
    required this.callsign,
    required this.time,
    required this.serialSent,
    required this.serialRcvd,
    required this.gridRcvd,
    required this.exchangeRcvd,
  });
}

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
  final List<_LoggedQso> _recentQsos = [];

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
                        color: Colors.grey.shade400,
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
    final rstSent = _rstSentCtrl.text.trim().isEmpty ? '59' : _rstSentCtrl.text.trim();
    final rstRcvd = _rstRcvdCtrl.text.trim().isEmpty ? '59' : _rstRcvdCtrl.text.trim();
    final freq    = kBandCenterFreqMhz[_band];

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
          _LoggedQso(
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
            backgroundColor: Colors.red,
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
        _SessionBar(
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
                _CompactLookupCard(info: _lookupResult!),
              ],

              const SizedBox(height: 8),

              // ── RST row ────────────────────────────────────────────────
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _rstSentCtrl,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
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
                    decoration: InputDecoration(
                      labelText: l10n.rstRcvdField,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ]),
              // ── Serial row ─────────────────────────────────────────────
              if (_showSerial) ...[
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.serialSentLabel,
                        border: const OutlineInputBorder(),
                      ),
                      child: Text(
                        _serialSent.toString().padLeft(3, '0'),
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _serialRcvdCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: _showExchange
                          ? TextInputAction.next
                          : TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: l10n.serialRcvdLabel,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: _showExchange ? null : (_) => _logQso(),
                    ),
                  ),
                ]),
              ],

              // ── Gridsquare row ────────────────────────────────────────
              if (_showGridsquare) ...[
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _gridsquareSentCtrl,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: context.l10n.gridSentLabel,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => _gridsquareSent = v.trim(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _gridsquareRcvdCtrl,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: _showExchange
                          ? TextInputAction.next
                          : TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: context.l10n.gridRcvdLabel,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: _showExchange ? null : (_) => _logQso(),
                    ),
                  ),
                ]),
              ],

              // ── Exchange row ───────────────────────────────────────────
              if (_showExchange) ...[
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _exchangeSentCtrl,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.exchangeSentLabel,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => _exchangeSent = v.trim(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _exchangeRcvdCtrl,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: l10n.exchangeRcvdLabel,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _logQso(),
                    ),
                  ),
                ]),
              ],

              const SizedBox(height: 12),

              // ── LOG QSO button ─────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _logQso,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
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
              itemBuilder: (ctx, i) => _RecentQsoTile(
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
                  child: _ContestInfoPanel(callsign: _currentCallsign),
                ),
              ],
            )
          : formColumn,
    );
  }
}

// ── Session info bar ──────────────────────────────────────────────────────────

class _SessionBar extends StatelessWidget {
  final String contestId;
  final String band;
  final String mode;
  final int serialSent;
  final VoidCallback? onTap;

  const _SessionBar({
    required this.contestId,
    required this.band,
    required this.mode,
    required this.serialSent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: cs.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              children: [
                if (contestId.isNotEmpty) _Chip(label: contestId, color: cs.primary),
                _Chip(label: band,  color: cs.secondary),
                _Chip(label: mode,  color: cs.tertiary),
              ],
            ),
          ),
          Text(
            '# ${serialSent.toString().padLeft(3, '0')}',
            style: tt.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: cs.primary),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(Icons.edit, size: 14, color: cs.onSurfaceVariant),
          ],
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      );
}

// ── Compact lookup card (phone) ───────────────────────────────────────────────

class _CompactLookupCard extends StatelessWidget {
  final CallsignLookupModel info;
  const _CompactLookupCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasName = info.name != null && info.name!.isNotEmpty;
    final hasLocation = info.country != null || info.qth != null;
    if (!hasName && !hasLocation) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outline.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        if (info.flag != null && info.flag!.isNotEmpty) ...[
          Text(info.flag!, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasName)
                Text(info.name!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis),
              if (hasLocation)
                Text(
                  [info.qth, info.country]
                      .whereType<String>()
                      .join(', '),
                  style: TextStyle(
                      fontSize: 12, color: cs.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        if (info.workedBefore) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.green.withValues(alpha: 0.4)),
            ),
            child: const Text('B4',
                style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ]),
    );
  }
}

// ── Tablet info panel ─────────────────────────────────────────────────────────

class _ContestInfoPanel extends ConsumerWidget {
  final String callsign;
  const _ContestInfoPanel({required this.callsign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs    = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    if (callsign.length < 3) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_search_outlined,
                  size: 72, color: cs.outlineVariant),
              const SizedBox(height: 16),
              Text(
                context.l10n.counterStation,
                style: theme.textTheme.titleMedium
                    ?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    final lookupAsync = ref.watch(callsignInfoProvider(callsign));

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
      children: [
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
        lookupAsync.when(
          loading: () => const LinearProgressIndicator(minHeight: 2),
          error: (_, __) => const SizedBox.shrink(),
          data: (info) => _FullLookupCard(info: info),
        ),
      ],
    );
  }
}

// ── Full lookup card (tablet) ─────────────────────────────────────────────────

class _FullLookupCard extends StatelessWidget {
  final CallsignLookupModel info;
  const _FullLookupCard({required this.info});

  @override
  Widget build(BuildContext context) {
    final cs    = Theme.of(context).colorScheme;
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
            // ── Photo + name/country ───────────────────────────────────
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
                if (info.buqslMember)
                  _QslBadge(context.l10n.bureau, Colors.purple),
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
  Widget build(BuildContext context) => Container(
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

class _QslBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _QslBadge(this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
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

// ── Recent QSO tile ───────────────────────────────────────────────────────────

class _RecentQsoTile extends StatelessWidget {
  final _LoggedQso qso;
  final bool showGrid;
  final bool showExch;
  const _RecentQsoTile({required this.qso, required this.showGrid, required this.showExch});

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final tt      = Theme.of(context).textTheme;
    final timeFmt = DateFormat('HHmm');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        SizedBox(
          width: 38,
          child: Text(timeFmt.format(qso.time.toLocal()),
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        ),
        Expanded(
          flex: 3,
          child: Text(qso.callsign,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          width: 36,
          child: Text(qso.serialSent.toString().padLeft(3, '0'),
              style: tt.bodySmall?.copyWith(color: cs.primary)),
        ),
        SizedBox(
          width: 36,
          child: Text(qso.serialRcvd,
              style: tt.bodySmall?.copyWith(color: cs.secondary)),
        ),
        if (showGrid)
          Expanded(
            flex: 2,
            child: Text(qso.gridRcvd,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ),
        if (showExch)
          Expanded(
            flex: 2,
            child: Text(qso.exchangeRcvd,
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          ),
      ]),
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
