import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/band_mode_data.dart';
import '../../../data/models/planned_activation_model.dart';
import '../../../providers/community_provider.dart';

class PlanActivationScreen extends ConsumerStatefulWidget {
  const PlanActivationScreen({super.key});

  @override
  ConsumerState<PlanActivationScreen> createState() =>
      _PlanActivationScreenState();
}

class _PlanActivationScreenState extends ConsumerState<PlanActivationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _callsignCtrl = TextEditingController();
  final _referenceCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();

  ActivationType _type = ActivationType.general;
  DateTime _scheduledAt = DateTime.now().toUtc().add(const Duration(hours: 1));
  final Set<String> _bands = {'20m'};
  final Set<String> _modes = {'SSB'};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Callsign'ı settings'ten önceden doldur
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Callsign alanı kullanıcı tarafından doldurulur
    });
  }

  @override
  void dispose() {
    _callsignCtrl.dispose();
    _referenceCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt.toLocal(),
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt.toLocal()),
    );
    if (time == null || !mounted) return;
    setState(() {
      _scheduledAt = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      ).toUtc();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_bands.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En az bir band seçin')),
      );
      return;
    }

    setState(() => _saving = true);

    final activation = PlannedActivationModel(
      id: '',
      callsign: _callsignCtrl.text.trim().toUpperCase(),
      type: _type,
      reference: _referenceCtrl.text.trim().isEmpty
          ? null
          : _referenceCtrl.text.trim().toUpperCase(),
      scheduledAt: _scheduledAt,
      bands: _bands.toList(),
      modes: _modes.toList(),
      comment: _commentCtrl.text.trim(),
      subscriberCount: 0,
      createdAt: DateTime.now().toUtc(),
    );

    final error = await ref
        .read(communityNotifierProvider.notifier)
        .postActivation(activation);

    if (!mounted) return;
    setState(() => _saving = false);

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Aktivasyon duyuruldu!')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${DateFormat('dd MMM yyyy HH:mm').format(_scheduledAt.toLocal())} (yerel)';

    return Scaffold(
      appBar: AppBar(title: const Text('Aktivasyon Duyur')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tip seçimi
            SegmentedButton<ActivationType>(
              segments: const [
                ButtonSegment(
                    value: ActivationType.general,
                    label: Text('Genel'),
                    icon: Icon(Icons.radio)),
                ButtonSegment(
                    value: ActivationType.sota,
                    label: Text('SOTA'),
                    icon: Icon(Icons.terrain)),
                ButtonSegment(
                    value: ActivationType.pota,
                    label: Text('POTA'),
                    icon: Icon(Icons.park_outlined)),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() {
                _type = s.first;
                _referenceCtrl.clear();
              }),
            ),
            const SizedBox(height: 16),

            // Callsign
            TextFormField(
              controller: _callsignCtrl,
              decoration: const InputDecoration(
                labelText: 'Çağrı işareti',
                hintText: 'TA4RX',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.radio_outlined),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Çağrı işareti gerekli' : null,
            ),
            const SizedBox(height: 12),

            // Referans (SOTA/POTA için)
            if (_type != ActivationType.general) ...[
              TextFormField(
                controller: _referenceCtrl,
                decoration: InputDecoration(
                  labelText: _type == ActivationType.sota
                      ? 'SOTA Referans (TA/AN-001)'
                      : 'POTA Referans (TA-0001)',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    _type == ActivationType.sota
                        ? Icons.terrain
                        : Icons.park_outlined,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) {
                  if (_type == ActivationType.general) return null;
                  if (v == null || v.trim().isEmpty) return 'Referans gerekli';
                  return null;
                },
              ),
              const SizedBox(height: 12),
            ],

            // Tarih/Saat
            OutlinedButton.icon(
              onPressed: _pickDateTime,
              icon: const Icon(Icons.schedule),
              label: Text(timeStr),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 16),

            // Bandlar
            Text('Bandlar', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: kCommonBands.map((b) {
                final selected = _bands.contains(b);
                return FilterChip(
                  label: Text(b),
                  selected: selected,
                  onSelected: (v) => setState(() {
                    if (v) {
                      _bands.add(b);
                    } else {
                      _bands.remove(b);
                    }
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Modlar
            Text('Modlar', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: kCommonModes.map((m) {
                final selected = _modes.contains(m);
                return FilterChip(
                  label: Text(m),
                  selected: selected,
                  onSelected: (v) => setState(() {
                    if (v) {
                      _modes.add(m);
                    } else {
                      _modes.remove(m);
                    }
                  }),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Yorum
            TextFormField(
              controller: _commentCtrl,
              decoration: const InputDecoration(
                labelText: 'Not (opsiyonel)',
                hintText: 'Aktivasyon hakkında kısa bilgi...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 200,
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send_outlined),
              label: const Text('Duyur'),
            ),
          ],
        ),
      ),
    );
  }
}
