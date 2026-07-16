import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/dxcc_entity_model.dart';
import '../../../data/models/state_subdivision_model.dart';
import '../../../data/models/station_model.dart';
import '../../../providers/station_provider.dart';

class CreateStationScreen extends ConsumerStatefulWidget {
  final StationModel? existingStation;
  const CreateStationScreen({super.key, this.existingStation});

  @override
  ConsumerState<CreateStationScreen> createState() =>
      _CreateStationScreenState();
}

class _CreateStationScreenState extends ConsumerState<CreateStationScreen> {
  bool get _isEditing => widget.existingStation != null;

  final _formKey = GlobalKey<FormState>();

  // Basic
  final _nameCtrl     = TextEditingController();
  final _callsignCtrl = TextEditingController();
  final _gridCtrl     = TextEditingController();
  final _cityCtrl     = TextEditingController();
  final _powerCtrl    = TextEditingController(text: '100');

  // DXCC — stored as int id; DxccEntity holds name for display
  DxccEntity? _selectedDxcc;
  List<DxccEntity> _dxccList = [];
  bool _dxccLoading = false;
  bool _dxccError = false;

  // Location
  String? _selectedState;
  List<StateSubdivision> _stateList = [];
  bool _stateLoading = false;

  final _countyCtrl = TextEditingController();
  final _cqCtrl     = TextEditingController();
  final _ituCtrl    = TextEditingController();

  // Award references
  final _iotaCtrl    = TextEditingController();
  final _sotaCtrl    = TextEditingController();
  final _wwffCtrl    = TextEditingController();
  final _potaCtrl    = TextEditingController();
  final _sigCtrl     = TextEditingController();
  final _sigInfoCtrl = TextEditingController();

  // eQSL
  final _eqslNickCtrl = TextEditingController();
  final _eqslMsgCtrl  = TextEditingController();

  // Integrations
  final _qrzApiKeyCtrl     = TextEditingController();
  final _hrdlogUserCtrl    = TextEditingController();
  final _hrdlogCodeCtrl    = TextEditingController();
  final _webAdifApiKeyCtrl = TextEditingController();

  // OQRS
  final _oqrsTextCtrl  = TextEditingController();
  final _oqrsEmailCtrl = TextEditingController();

  // Flags
  bool _isActive        = false;
  bool _linkLogbook     = false;
  int  _qrzRealtime     = -1;
  bool _webAdifRealtime = false;
  bool _clublogRealtime = false;
  bool _clublogIgnore   = false;
  int  _hrdlogRealtime  = -1;
  bool _oqrsEnabled     = false;
  bool _saving          = false;

  @override
  void initState() {
    super.initState();
    _loadDxccList();
    final s = widget.existingStation;
    if (s != null) {
      _nameCtrl.text          = s.profileName;
      _callsignCtrl.text      = s.callsign;
      _gridCtrl.text          = s.gridSquare ?? '';
      _cityCtrl.text          = s.city ?? '';
      _powerCtrl.text         = s.power?.toString() ?? '100';
      _selectedState          = s.state;
      _countyCtrl.text        = s.county ?? '';
      _cqCtrl.text            = s.cqZone?.toString() ?? '';
      _ituCtrl.text           = s.ituZone?.toString() ?? '';
      _iotaCtrl.text          = s.iota ?? '';
      _sotaCtrl.text          = s.sota ?? '';
      _wwffCtrl.text          = s.wwff ?? '';
      _potaCtrl.text          = s.pota ?? '';
      _sigCtrl.text           = s.sig ?? '';
      _sigInfoCtrl.text       = s.sigInfo ?? '';
      _eqslNickCtrl.text      = s.eqslQthNickname ?? '';
      _eqslMsgCtrl.text       = s.eqslDefaultQslMsg ?? '';
      _qrzApiKeyCtrl.text     = s.qrzApiKey ?? '';
      _hrdlogUserCtrl.text    = s.hrdlogUsername ?? '';
      _hrdlogCodeCtrl.text    = s.hrdlogCode ?? '';
      _webAdifApiKeyCtrl.text = s.webAdifApiKey ?? '';
      _isActive               = s.isActive;
      _qrzRealtime            = s.qrzRealtime;
      _webAdifRealtime        = s.webAdifRealtime;
      _clublogRealtime        = s.clublogRealtime;
      _clublogIgnore          = s.clublogIgnore;
      _hrdlogRealtime         = s.hrdlogRealtime;
      _oqrsEnabled            = s.oqrsEnabled;
      _oqrsTextCtrl.text      = s.oqrsText ?? '';
      _oqrsEmailCtrl.text     = s.oqrsEmail ?? '';
    }
  }

  Future<void> _loadDxccList() async {
    setState(() { _dxccLoading = true; _dxccError = false; });
    try {
      final list = await ref.read(stationProvider.notifier).getDxccList();
      if (!mounted) return;
      setState(() {
        _dxccList = list;
        _dxccLoading = false;
        _dxccError = list.isEmpty;
        final s = widget.existingStation;
        if (s?.dxcc != null) {
          _selectedDxcc = list.where((d) => d.adif == s!.dxcc).firstOrNull;
          if (_selectedDxcc != null) _loadStateList(_selectedDxcc!.adif);
        }
      });
    } catch (_) {
      if (mounted) setState(() { _dxccLoading = false; _dxccError = true; });
    }
  }

  Future<void> _loadStateList(int dxcc) async {
    setState(() {
      _stateLoading = true;
      _stateList = [];
    });
    try {
      final list = await ref.read(stationProvider.notifier).getStateList(dxcc);
      if (!mounted) return;
      setState(() {
        _stateList = list;
        _stateLoading = false;
        if (_selectedState != null &&
            !list.any((s) => s.code == _selectedState)) {
          _selectedState = null;
        }
      });
    } catch (_) {
      if (mounted) setState(() => _stateLoading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _callsignCtrl.dispose();
    _gridCtrl.dispose();
    _cityCtrl.dispose();
    _powerCtrl.dispose();
    _countyCtrl.dispose();
    _cqCtrl.dispose();
    _ituCtrl.dispose();
    _iotaCtrl.dispose();
    _sotaCtrl.dispose();
    _wwffCtrl.dispose();
    _potaCtrl.dispose();
    _sigCtrl.dispose();
    _sigInfoCtrl.dispose();
    _eqslNickCtrl.dispose();
    _eqslMsgCtrl.dispose();
    _qrzApiKeyCtrl.dispose();
    _hrdlogUserCtrl.dispose();
    _hrdlogCodeCtrl.dispose();
    _webAdifApiKeyCtrl.dispose();
    _oqrsTextCtrl.dispose();
    _oqrsEmailCtrl.dispose();
    super.dispose();
  }

  String? _t(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  StationModel _buildModel({required int id}) => StationModel(
        id: id,
        profileName: _nameCtrl.text.trim(),
        callsign: _callsignCtrl.text.trim().toUpperCase(),
        gridSquare: _t(_gridCtrl)?.toUpperCase(),
        city: _t(_cityCtrl),
        dxcc: _selectedDxcc?.adif,
        power: int.tryParse(_powerCtrl.text.trim()),
        isActive: _isActive,
        state: _selectedState,
        county: _t(_countyCtrl),
        cqZone: int.tryParse(_cqCtrl.text.trim()),
        ituZone: int.tryParse(_ituCtrl.text.trim()),
        iota: _t(_iotaCtrl)?.toUpperCase(),
        sota: _t(_sotaCtrl)?.toUpperCase(),
        wwff: _t(_wwffCtrl)?.toUpperCase(),
        pota: _t(_potaCtrl)?.toUpperCase(),
        sig: _t(_sigCtrl),
        sigInfo: _t(_sigInfoCtrl),
        eqslQthNickname: _t(_eqslNickCtrl),
        eqslDefaultQslMsg: _t(_eqslMsgCtrl),
        qrzApiKey: _t(_qrzApiKeyCtrl),
        hrdlogUsername: _t(_hrdlogUserCtrl),
        hrdlogCode: _t(_hrdlogCodeCtrl),
        webAdifApiKey: _t(_webAdifApiKeyCtrl),
        qrzRealtime: _qrzRealtime,
        webAdifRealtime: _webAdifRealtime,
        clublogRealtime: _clublogRealtime,
        clublogIgnore: _clublogIgnore,
        hrdlogRealtime: _hrdlogRealtime,
        oqrsEnabled: _oqrsEnabled,
        oqrsText: _t(_oqrsTextCtrl),
        oqrsEmail: _t(_oqrsEmailCtrl),
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final l10n = context.l10n;

    if (_isEditing) {
      final station = _buildModel(id: widget.existingStation!.id);
      final err =
          await ref.read(stationProvider.notifier).updateStation(station);
      if (!mounted) return;
      setState(() => _saving = false);
      if (err == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.stationUpdated),
          backgroundColor: Colors.green,
        ));
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err), backgroundColor: Colors.red));
      }
    } else {
      final station = _buildModel(id: 0);
      final success = await ref
          .read(stationProvider.notifier)
          .createStation(station, linkActiveLogbook: _linkLogbook);
      if (!mounted) return;
      setState(() => _saving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.stationCreated),
          backgroundColor: Colors.green,
        ));
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.stationCreateFailed),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _pickDxcc() async {
    if (_dxccList.isEmpty) return;
    final result = await showModalBottomSheet<DxccEntity>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _DxccPickerSheet(
        entities: _dxccList,
        selected: _selectedDxcc,
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _selectedDxcc = result;
        if (result.cqZone > 0) _cqCtrl.text = result.cqZone.toString();
        if (result.ituZone > 0) _ituCtrl.text = result.ituZone.toString();
        _selectedState = null;
        _stateList = [];
      });
      _loadStateList(result.adif);
    }
  }

  Widget _uploadSelector({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        ),
        SegmentedButton<int>(
          segments: [
            ButtonSegment(value: -1, label: Text(l10n.uploadDisabled)),
            ButtonSegment(value: 0,  label: Text(l10n.uploadEnabled)),
            ButtonSegment(value: 1,  label: Text(l10n.uploadRealtime)),
          ],
          selected: {value},
          onSelectionChanged: (s) => onChanged(s.first),
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editStationTitle : l10n.newStationTitle),
        actions: [
          TextButton(
            onPressed: _saving ? null : _submit,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section(l10n.basicInfo),
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l10n.stationProfileNameLabel,
                hintText: l10n.stationProfileNameHint,
              ),
              validator: (v) =>
                  validateRequired(v, l10n.stationProfileNameLabel),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _callsignCtrl,
              decoration: InputDecoration(labelText: l10n.callsignField),
              textCapitalization: TextCapitalization.characters,
              validator: validateCallsign,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _gridCtrl,
              decoration: InputDecoration(
                labelText: l10n.gridField,
                hintText: 'KN41',
              ),
              textCapitalization: TextCapitalization.characters,
              validator: validateGridSquare,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cityCtrl,
              decoration: InputDecoration(labelText: l10n.cityQth),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _powerCtrl,
                  decoration: InputDecoration(
                      labelText: l10n.powerWatts, hintText: '100'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _section(l10n.locationSectionTitle),

            _DxccPickerField(
              selected: _selectedDxcc,
              loading: _dxccLoading,
              hasError: _dxccError,
              onTap: _dxccError ? _loadDxccList : _pickDxcc,
            ),
            const SizedBox(height: 12),

            if (_selectedDxcc != null) ...[
              if (_stateLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(),
                )
              else if (_stateList.isNotEmpty)
                DropdownButtonFormField<String>(
                  key: ValueKey('state_${_selectedDxcc?.adif}'),
                  initialValue: _selectedState,
                  decoration: InputDecoration(
                    labelText: l10n.stateProvince,
                    border: const OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('—')),
                    ..._stateList.map(
                      (s) => DropdownMenuItem(
                        value: s.code,
                        child: Text(s.displayName),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _selectedState = v),
                ),
              const SizedBox(height: 12),
            ],

            TextFormField(
              controller: _countyCtrl,
              decoration: InputDecoration(labelText: l10n.county),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _cqCtrl,
                  decoration: const InputDecoration(
                      labelText: 'CQ Zone', hintText: '20'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _ituCtrl,
                  decoration: const InputDecoration(
                      labelText: 'ITU Zone', hintText: '29'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _section(l10n.awardReferences),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _iotaCtrl,
                  decoration: InputDecoration(
                      labelText: l10n.iota, hintText: 'AS-099'),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _sotaCtrl,
                  decoration: InputDecoration(
                      labelText: l10n.sota, hintText: 'TA/EG-123'),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _wwffCtrl,
                  decoration: InputDecoration(
                      labelText: l10n.wwff, hintText: 'TAWF-001'),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _potaCtrl,
                  decoration: InputDecoration(
                      labelText: l10n.pota, hintText: 'TA-0001'),
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sigCtrl,
              decoration: InputDecoration(labelText: l10n.sigLabel),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _sigInfoCtrl,
              decoration: const InputDecoration(labelText: 'SIG Info'),
            ),

            const SizedBox(height: 24),
            _section('eQSL'),
            TextFormField(
              controller: _eqslNickCtrl,
              decoration:
                  InputDecoration(labelText: l10n.eqslQthNicknameLabel),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _eqslMsgCtrl,
              decoration: InputDecoration(labelText: l10n.eqslDefaultMsgLabel),
              maxLines: 2,
            ),

            const SizedBox(height: 24),
            _section(l10n.integrationsSectionTitle),

            _subSection('QRZ.com'),
            TextFormField(
              controller: _qrzApiKeyCtrl,
              decoration: InputDecoration(labelText: l10n.qrzApiKeyLabel),
              autocorrect: false,
            ),
            const SizedBox(height: 8),
            _uploadSelector(
              label: l10n.qrzUploadLabel,
              value: _qrzRealtime,
              onChanged: (v) => setState(() => _qrzRealtime = v),
            ),

            const SizedBox(height: 16),
            _subSection('Clublog'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.clublogIgnoreTitle),
              subtitle: Text(l10n.clublogIgnoreSubtitle),
              value: _clublogIgnore,
              onChanged: (v) => setState(() => _clublogIgnore = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.clublogRealtimeTitle),
              subtitle: Text(l10n.clublogRealtimeSubtitle),
              value: _clublogRealtime,
              onChanged: _clublogIgnore
                  ? null
                  : (v) => setState(() => _clublogRealtime = v),
            ),

            const SizedBox(height: 16),
            _subSection('HRDLog.net'),
            TextFormField(
              controller: _hrdlogUserCtrl,
              decoration: InputDecoration(labelText: l10n.hrdlogUsernameLabel),
              autocorrect: false,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _hrdlogCodeCtrl,
              decoration: InputDecoration(labelText: l10n.hrdlogApiKeyLabel),
              autocorrect: false,
              obscureText: true,
            ),
            const SizedBox(height: 8),
            _uploadSelector(
              label: l10n.hrdlogUploadLabel,
              value: _hrdlogRealtime,
              onChanged: (v) => setState(() => _hrdlogRealtime = v),
            ),

            const SizedBox(height: 16),
            _subSection('QO-100 DX Club'),
            TextFormField(
              controller: _webAdifApiKeyCtrl,
              decoration: InputDecoration(labelText: l10n.qo100ApiKeyLabel),
              autocorrect: false,
              obscureText: true,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.qo100RealtimeTitle),
              subtitle: Text(l10n.qo100RealtimeSubtitle),
              value: _webAdifRealtime,
              onChanged: (v) => setState(() => _webAdifRealtime = v),
            ),

            const SizedBox(height: 24),
            _section(l10n.oqrsSectionTitle),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.oqrsEnabledTitle),
              subtitle: Text(l10n.oqrsEnabledSubtitle),
              value: _oqrsEnabled,
              onChanged: (v) => setState(() => _oqrsEnabled = v),
            ),
            if (_oqrsEnabled) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _oqrsTextCtrl,
                decoration: InputDecoration(labelText: l10n.oqrsTextLabel),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _oqrsEmailCtrl,
                decoration: InputDecoration(labelText: l10n.oqrsEmailLabel),
                keyboardType: TextInputType.emailAddress,
              ),
            ],

            const SizedBox(height: 24),
            _section(l10n.stationSettingsSection),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.setAsActiveStationTitle),
              subtitle: Text(l10n.setAsActiveStationSubtitle),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
            ),
            if (!_isEditing)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.linkToActiveLogbookTitle),
                subtitle: Text(l10n.linkToActiveLogbookSubtitle),
                value: _linkLogbook,
                onChanged: (v) => setState(() => _linkLogbook = v),
              ),

            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save),
              label: Text(
                  _isEditing ? l10n.saveChangesBtn : l10n.createStationBtn),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      );

  Widget _subSection(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      );
}

// ── DXCC Picker Field ────────────────────────────────────────────────────────

class _DxccPickerField extends StatelessWidget {
  final DxccEntity? selected;
  final bool loading;
  final bool hasError;
  final VoidCallback onTap;
  const _DxccPickerField({
    required this.selected,
    required this.loading,
    required this.onTap,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.dxccCountry,
          border: const OutlineInputBorder(),
          errorText: hasError ? context.l10n.patchRequiredBanner : null,
          suffixIcon: loading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                )
              : hasError
                  ? const Icon(Icons.refresh)
                  : const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          selected != null
              ? '${selected!.name} (${selected!.prefix})  —  ADIF ${selected!.adif}'
              : l10n.selectLabel,
          style: selected == null
              ? TextStyle(color: theme.colorScheme.onSurfaceVariant)
              : null,
        ),
      ),
    );
  }
}

// ── DXCC Picker Modal Sheet ──────────────────────────────────────────────────

class _DxccPickerSheet extends StatefulWidget {
  final List<DxccEntity> entities;
  final DxccEntity? selected;
  const _DxccPickerSheet({required this.entities, this.selected});

  @override
  State<_DxccPickerSheet> createState() => _DxccPickerSheetState();
}

class _DxccPickerSheetState extends State<_DxccPickerSheet> {
  final _searchCtrl = TextEditingController();
  late List<DxccEntity> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = _sort(widget.entities);
    _searchCtrl.addListener(_filter);
  }

  List<DxccEntity> _sort(List<DxccEntity> src) {
    final active =
        src.where((e) => !e.deleted).toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    final deleted =
        src.where((e) => e.deleted).toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    return [...active, ...deleted];
  }

  void _filter() {
    final q = _searchCtrl.text.toLowerCase();
    setState(() {
      _filtered = _sort(widget.entities
          .where((e) =>
              e.name.toLowerCase().contains(q) ||
              e.prefix.toLowerCase().contains(q) ||
              e.adif.toString().contains(q))
          .toList());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (ctx, scrollCtrl) => Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.dxccSearch,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollCtrl,
              itemCount: _filtered.length,
              itemBuilder: (_, i) {
                final e = _filtered[i];
                final isSelected = e.adif == widget.selected?.adif;
                return ListTile(
                  selected: isSelected,
                  dense: true,
                  leading: isSelected
                      ? Icon(Icons.check,
                          color: Theme.of(context).colorScheme.primary)
                      : const SizedBox(width: 24),
                  title: Text(
                    e.name,
                    style: e.deleted
                        ? TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                            decoration: TextDecoration.lineThrough)
                        : null,
                  ),
                  subtitle: Text(
                    '${e.prefix}  •  ADIF ${e.adif}'
                    '  •  CQ ${e.cqZone}  ITU ${e.ituZone}'
                    '${e.deleted ? "  ⚠ ${l10n.deletedDxcc}" : ""}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onTap: () => Navigator.of(ctx).pop(e),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
