import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/contest_data.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/contest_model.dart';
import '../../../providers/remote_datasource_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/station_provider.dart';

// ── Contest list provider ─────────────────────────────────────────────────────

final _serverContestListProvider =
    FutureProvider.autoDispose<List<ContestTemplate>>((ref) async {
  return ref.read(wavelogRemoteDatasourceProvider).getContestList();
});

// ── Screen ────────────────────────────────────────────────────────────────────

class ContestCreateScreen extends ConsumerStatefulWidget {
  /// When non-null, the screen acts in edit mode.
  final ContestSession? editSession;

  const ContestCreateScreen({super.key, this.editSession});

  @override
  ConsumerState<ContestCreateScreen> createState() =>
      _ContestCreateScreenState();
}

class _ContestCreateScreenState extends ConsumerState<ContestCreateScreen> {
  ContestTemplate? _selectedContest;
  final _sessionNameCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();
  DateTime _timeStart = DateTime.now().toUtc();
  DateTime _timeEnd = DateTime.now().toUtc().add(const Duration(hours: 24));
  int? _stationId;
  bool _useSerial = true;
  bool _useGrid   = false;
  bool _useExch   = false;
  bool _isSaving = false;

  ContestSession? get _editSession => widget.editSession;
  bool get _isEditing => _editSession != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final s = _editSession!;
      _selectedContest =
          ContestTemplate(id: 0, name: s.contestName, adifName: s.adifName);
      _sessionNameCtrl.text = s.customName;
      _timeStart = s.timeStart;
      _timeEnd = s.timeEnd ?? s.timeStart.add(const Duration(hours: 24));
      _stationId = s.stationId;
      final f = s.exchangeFields;
      _useSerial = f.contains('serial');
      _useGrid   = f.contains('gridsquare');
      _useExch   = f.contains('exchange');
    } else {
      final settings = ref.read(settingsProvider);
      _stationId = settings.activeStationProfileId;
    }
  }

  @override
  void dispose() {
    _sessionNameCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Contest picker sheet ──────────────────────────────────────────────────

  Future<void> _pickContest() async {
    final serverList = ref.read(_serverContestListProvider).valueOrNull ?? [];
    final l10n = context.l10n;
    String query = '';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          final q = query.toLowerCase();
          final serverFiltered = serverList
              .where((c) =>
                  c.name.toLowerCase().contains(q) ||
                  c.adifName.toLowerCase().contains(q))
              .toList();
          final builtinAsTemplate = kBuiltinContests
              .where((c) =>
                  c.adifName.toLowerCase().contains(q) ||
                  c.displayName.toLowerCase().contains(q))
              .map((b) =>
                  ContestTemplate(id: 0, name: b.displayName, adifName: b.adifName))
              .toList();

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.75,
            maxChildSize: 0.95,
            builder: (ctx, scroll) => Column(
              children: [
                Container(
                  width: 36, height: 4, margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.searchContest,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (v) => setS(() => query = v),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scroll,
                    children: [
                      if (serverFiltered.isNotEmpty) ...[
                        _SectionHeader(label: l10n.serverContests),
                        ...serverFiltered.map((c) => _ContestTile(
                          contest: c,
                          onTap: () {
                            setState(() => _selectedContest = c);
                            Navigator.of(ctx).pop();
                          },
                        )),
                      ],
                      _SectionHeader(label: l10n.builtinContests),
                      ...builtinAsTemplate.map((c) => _ContestTile(
                        contest: c,
                        onTap: () {
                          setState(() => _selectedContest = c);
                          Navigator.of(ctx).pop();
                        },
                      )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Date/time picker ──────────────────────────────────────────────────────

  Future<DateTime?> _pickDateTime(DateTime initial) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial.toLocal(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial.toLocal()),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute)
        .toUtc();
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (_selectedContest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.selectContest)),
      );
      return;
    }
    if (_stationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.noActiveStation)),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      final fields = [
        if (_useSerial) 'serial',
        if (_useGrid)   'gridsquare',
        if (_useExch)   'exchange',
      ];
      if (fields.isEmpty) fields.add('serial'); // fallback

      final remote = ref.read(wavelogRemoteDatasourceProvider);

      if (_isEditing) {
        await remote.updateContestSession(
          contestSessionId: _editSession!.id,
          contestAdifId: _selectedContest!.id,
          adifName: _selectedContest!.adifName,
          timeStart: _timeStart,
          timeEnd: _timeEnd,
          stationId: _stationId!,
          customName: _sessionNameCtrl.text.trim(),
          exchangeFields: fields,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.sessionUpdated),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      } else {
        final sessionId = await remote.createContestSession(
          contestAdifId: _selectedContest!.id,
          adifName: _selectedContest!.adifName,
          timeStart: _timeStart,
          timeEnd: _timeEnd,
          stationId: _stationId!,
          customName: _sessionNameCtrl.text.trim(),
          exchangeFields: fields,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.sessionCreated),
            backgroundColor: Colors.green,
          ),
        );
        final session = ContestSession(
          id: sessionId,
          contestName: _selectedContest!.name,
          adifName: _selectedContest!.adifName,
          timeStart: _timeStart,
          timeEnd: _timeEnd,
          stationId: _stationId!,
          qsoCount: 0,
          customName: _sessionNameCtrl.text.trim(),
          exchangeFields: fields,
        );
        context.pushReplacement('/contest/log', extra: session);
      }
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dateFmt = DateFormat('dd.MM.yy HH:mm');
    final stations = ref.watch(stationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editContestSession : l10n.createContestSession),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Contest picker ─────────────────────────────────────────────
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: _pickContest,
            child: Row(children: [
              Expanded(
                child: _selectedContest == null
                    ? Text(
                        l10n.selectContest,
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_selectedContest!.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          if (_selectedContest!.adifName.isNotEmpty)
                            Text(_selectedContest!.adifName,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary)),
                        ],
                      ),
              ),
              const Icon(Icons.arrow_drop_down),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Session name ───────────────────────────────────────────────
          TextField(
            controller: _sessionNameCtrl,
            decoration: InputDecoration(
              labelText: l10n.sessionName,
              hintText: l10n.sessionNameHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // ── Start date/time ────────────────────────────────────────────
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.play_circle_outline),
            title: Text(l10n.startDateTime),
            subtitle: Text(dateFmt.format(_timeStart.toLocal())),
            trailing: const Icon(Icons.edit_calendar),
            onTap: () async {
              final dt = await _pickDateTime(_timeStart);
              if (dt != null) setState(() => _timeStart = dt);
            },
          ),
          Wrap(spacing: 8, children: [
            _QuickBtn(
              label: 'Now',
              onTap: () => setState(() => _timeStart = DateTime.now().toUtc()),
            ),
          ]),
          const SizedBox(height: 4),

          // ── End date/time ──────────────────────────────────────────────
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.stop_circle_outlined),
            title: Text(l10n.endDateTime),
            subtitle: Text(dateFmt.format(_timeEnd.toLocal())),
            trailing: const Icon(Icons.edit_calendar),
            onTap: () async {
              final dt = await _pickDateTime(_timeEnd);
              if (dt != null) setState(() => _timeEnd = dt);
            },
          ),
          Wrap(spacing: 8, children: [
            _QuickBtn(
              label: l10n.durationShortcut4h,
              onTap: () => setState(
                  () => _timeEnd = _timeStart.add(const Duration(hours: 4))),
            ),
            _QuickBtn(
              label: l10n.durationShortcut12h,
              onTap: () => setState(
                  () => _timeEnd = _timeStart.add(const Duration(hours: 12))),
            ),
            _QuickBtn(
              label: l10n.durationShortcut24h,
              onTap: () => setState(
                  () => _timeEnd = _timeStart.add(const Duration(hours: 24))),
            ),
            _QuickBtn(
              label: l10n.durationShortcut48h,
              onTap: () => setState(
                  () => _timeEnd = _timeStart.add(const Duration(hours: 48))),
            ),
          ]),
          const SizedBox(height: 12),

          // ── Station ────────────────────────────────────────────────────
          stations.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
            data: (list) => InputDecorator(
              decoration: InputDecoration(
                labelText: l10n.stationProfileField,
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _stationId,
                  isDense: true,
                  items: list
                      .map((s) => DropdownMenuItem(
                            value: s.id,
                            child: Text(s.callsign.isNotEmpty
                                ? '${s.callsign} — ${s.profileName}'
                                : s.profileName),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _stationId = v),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Exchange type ──────────────────────────────────────────────
          Text(l10n.exchangeType,
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text(l10n.exchangeTypeSerial),
                selected: _useSerial,
                onSelected: (v) => setState(() => _useSerial = v),
              ),
              FilterChip(
                label: const Text('Grid Square'),
                selected: _useGrid,
                onSelected: (v) => setState(() => _useGrid = v),
              ),
              FilterChip(
                label: Text(l10n.exchangeTypeExchange),
                selected: _useExch,
                onSelected: (v) => setState(() => _useExch = v),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Submit ─────────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _isSaving ? null : _submit,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      _isEditing ? l10n.saveChanges : l10n.createSession,
                      style: const TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Text(label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                )),
      );
}

class _ContestTile extends StatelessWidget {
  final ContestTemplate contest;
  final VoidCallback onTap;
  const _ContestTile({required this.contest, required this.onTap});

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(contest.name),
        subtitle: contest.adifName.isNotEmpty ? Text(contest.adifName) : null,
        onTap: onTap,
      );
}

class _QuickBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 12)),
      );
}
