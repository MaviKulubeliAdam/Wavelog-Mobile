import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/adif_generator.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/callsign_lookup_model.dart';
import '../../../data/models/qso_model.dart';
import '../../../providers/lookup_provider.dart';
import '../../../providers/qso_provider.dart';
import 'add_qso_screen.dart';

class QsoDetailScreen extends ConsumerWidget {
  final String qsoId;
  const QsoDetailScreen({super.key, required this.qsoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qsoAsync = ref.watch(qsoProvider);

    final qso = qsoAsync.valueOrNull?.where((q) => q.localId == qsoId).firstOrNull;
    if (qso != null) return _QsoDetailView(qso: qso);

    return qsoAsync.when(
      data: (_) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.qsoDetailTitle)),
        body: Center(child: Text(context.l10n.qsoNotFound)),
      ),
      loading: () => Scaffold(
        appBar: AppBar(title: Text(context.l10n.qsoDetailTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(context.l10n.qsoDetailTitle)),
        body: Center(child: Text('${context.l10n.error}: $e')),
      ),
    );
  }
}

class _QsoDetailView extends ConsumerWidget {
  final QsoModel qso;
  const _QsoDetailView({required this.qso});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final dt = qso.dateTimeOn.toUtc();

    String continentName(String code) {
      switch (code.toUpperCase()) {
        case 'AF': return l10n.continentAF;
        case 'AN': return l10n.continentAN;
        case 'AS': return l10n.continentAS;
        case 'EU': return l10n.continentEU;
        case 'NA': return l10n.continentNA;
        case 'OC': return l10n.continentOC;
        case 'SA': return l10n.continentSA;
        default: return code;
      }
    }

    Future<void> handleDelete() async {
      if (!context.mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.deleteQsoTitle),
          content: Text(
            l10n.deleteQsoConfirm(
              qso.callsign,
              DateFormat('dd.MM.yyyy').format(dt),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      if (context.mounted) Navigator.of(context).pop();
      await ref.read(qsoProvider.notifier).deleteQso(qso);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(qso.callsign,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.editTooltip,
            onPressed: () async {
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddQsoScreen(editQso: qso),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.delete,
            onPressed: handleDelete,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: l10n.shareAdifTooltip,
            onPressed: () => _shareAdif(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // ── Offline banner ─────────────────────────────────────────────
          if (!qso.synced)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                const Icon(Icons.cloud_off, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(l10n.localNotSynced,
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
              ]),
            ),

          // ── Hero card ──────────────────────────────────────────────────
          _HeroCard(qso: qso, dt: dt),
          const SizedBox(height: 12),

          // ── QRZ Profile section ────────────────────────────────────────
          _QrzSection(callsign: qso.callsign),
          const SizedBox(height: 8),

          // ── Signal section ─────────────────────────────────────────────
          _Section(
            title: l10n.signal,
            icon: Icons.signal_cellular_alt,
            children: [
              _TwoCol(
                left: _LabelValue(l10n.rstSent, qso.rstSent),
                right: _LabelValue(l10n.rstReceived, qso.rstRcvd),
              ),
              if (qso.txPower != null && qso.txPower!.isNotEmpty)
                _LabelValue(l10n.txPower, '${qso.txPower} W'),
              if (qso.propMode != null && qso.propMode!.isNotEmpty)
                _LabelValue(l10n.propMode, qso.propMode!),
              if (qso.satName != null && qso.satName!.isNotEmpty) ...[
                _LabelValue(l10n.satellite, qso.satName!),
                if (qso.satMode != null)
                  _LabelValue(l10n.satelliteMode, qso.satMode!),
              ],
              if (qso.antenna != null && qso.antenna!.isNotEmpty)
                _LabelValue(l10n.antenna, qso.antenna!),
              if (qso.distance != null && qso.distance!.isNotEmpty)
                _LabelValue(l10n.distance, '${qso.distance} km'),
            ],
          ),
          const SizedBox(height: 8),

          // ── Contact info section ───────────────────────────────────────
          _Section(
            title: l10n.counterStation,
            icon: Icons.person_outline,
            children: [
              if (qso.name != null && qso.name!.isNotEmpty)
                _LabelValue(l10n.nameLabel, qso.name!),
              if (qso.qth != null && qso.qth!.isNotEmpty)
                _LabelValue('QTH', qso.qth!),
              if (qso.gridSquare != null && qso.gridSquare!.isNotEmpty)
                _LabelValue(l10n.gridSquare, qso.gridSquare!),
              if (qso.country != null && qso.country!.isNotEmpty)
                _LabelValue(l10n.country, qso.country!),
              if (qso.dxcc != null && qso.dxcc!.isNotEmpty)
                _LabelValue('DXCC', qso.dxcc!),
              if (qso.continent != null && qso.continent!.isNotEmpty)
                _LabelValue(l10n.continent, continentName(qso.continent!)),
              if (qso.cqZone != null)
                _LabelValue(l10n.cqZone, qso.cqZone.toString()),
              if (qso.ituZone != null)
                _LabelValue(l10n.ituZone, qso.ituZone.toString()),
              if (qso.state != null && qso.state!.isNotEmpty)
                _LabelValue(l10n.stateProvince, qso.state!),
              if (qso.county != null && qso.county!.isNotEmpty)
                _LabelValue(l10n.county, qso.county!),
              if (qso.pfx != null && qso.pfx!.isNotEmpty)
                _LabelValue(l10n.wpxPrefix, qso.pfx!),
            ],
          ),
          const SizedBox(height: 8),

          // ── QSL Status section ─────────────────────────────────────────
          _QslSection(qso: qso),
          const SizedBox(height: 8),

          // ── Awards section ─────────────────────────────────────────────
          if (_hasAwards(qso)) ...[
            _Section(
              title: l10n.awards,
              icon: Icons.emoji_events_outlined,
              children: [
                if (qso.iota != null && qso.iota!.isNotEmpty)
                  _LabelValue('IOTA', qso.iota!),
                if (qso.sotaRef != null && qso.sotaRef!.isNotEmpty)
                  _LabelValue('SOTA', qso.sotaRef!),
                if (qso.wwffRef != null && qso.wwffRef!.isNotEmpty)
                  _LabelValue('WWFF', qso.wwffRef!),
                if (qso.potaRef != null && qso.potaRef!.isNotEmpty)
                  _LabelValue('POTA', qso.potaRef!),
                if (qso.sigRef != null && qso.sigRef!.isNotEmpty)
                  _LabelValue(l10n.sigLabel, qso.sigRef!),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // ── My station section ─────────────────────────────────────────
          if (_hasMyStation(qso)) ...[
            _Section(
              title: l10n.myStation,
              icon: Icons.cell_tower_outlined,
              children: [
                if (qso.myCallsign != null && qso.myCallsign!.isNotEmpty)
                  _LabelValue(l10n.callsign, qso.myCallsign!),
                if (qso.myGridSquare != null && qso.myGridSquare!.isNotEmpty)
                  _LabelValue(l10n.gridSquare, qso.myGridSquare!),
                if (qso.myCity != null && qso.myCity!.isNotEmpty)
                  _LabelValue(l10n.city, qso.myCity!),
                if (qso.myCountry != null && qso.myCountry!.isNotEmpty)
                  _LabelValue(l10n.country, qso.myCountry!),
                if (qso.myCqZone != null)
                  _LabelValue(l10n.cqZone, qso.myCqZone.toString()),
                if (qso.myItuZone != null)
                  _LabelValue(l10n.ituZone, qso.myItuZone.toString()),
                if (qso.myState != null && qso.myState!.isNotEmpty)
                  _LabelValue(l10n.stateProvince, qso.myState!),
                if (qso.mySota != null && qso.mySota!.isNotEmpty)
                  _LabelValue('SOTA', qso.mySota!),
                if (qso.myPota != null && qso.myPota!.isNotEmpty)
                  _LabelValue('POTA', qso.myPota!),
                if (qso.myIota != null && qso.myIota!.isNotEmpty)
                  _LabelValue('IOTA', qso.myIota!),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // ── Contest section ────────────────────────────────────────────
          if (_hasContest(qso)) ...[
            _Section(
              title: l10n.contest,
              icon: Icons.leaderboard_outlined,
              children: [
                if (qso.contestId != null && qso.contestId!.isNotEmpty)
                  _LabelValue(l10n.contestIdLabel, qso.contestId!),
                if (qso.srxString != null && qso.srxString!.isNotEmpty)
                  _LabelValue(l10n.exchangeReceived, qso.srxString!)
                else if (qso.srx != null && qso.srx!.isNotEmpty)
                  _LabelValue(l10n.serialReceived, qso.srx!),
                if (qso.stxString != null && qso.stxString!.isNotEmpty)
                  _LabelValue(l10n.exchangeSent, qso.stxString!)
                else if (qso.stx != null && qso.stx!.isNotEmpty)
                  _LabelValue(l10n.serialSent, qso.stx!),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // ── Space weather ──────────────────────────────────────────────
          if (qso.sfi != null || qso.aIndex != null || qso.kIndex != null) ...[
            _Section(
              title: l10n.solarConditions,
              icon: Icons.sunny_snowing,
              children: [
                if (qso.sfi != null && qso.sfi!.isNotEmpty)
                  _LabelValue(l10n.sfi, qso.sfi!),
                if (qso.aIndex != null && qso.aIndex!.isNotEmpty)
                  _LabelValue(l10n.aIndex, qso.aIndex!),
                if (qso.kIndex != null && qso.kIndex!.isNotEmpty)
                  _LabelValue(l10n.kIndex, qso.kIndex!),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // ── Comment / Notes ────────────────────────────────────────────
          if ((qso.comment != null && qso.comment!.isNotEmpty) ||
              (qso.notes != null && qso.notes!.isNotEmpty)) ...[
            _Section(
              title: l10n.commentNotes,
              icon: Icons.notes_outlined,
              children: [
                if (qso.comment != null && qso.comment!.isNotEmpty)
                  _LabelValue(l10n.commentLabel, qso.comment!),
                if (qso.notes != null && qso.notes!.isNotEmpty)
                  _LabelValue(l10n.notesSection, qso.notes!),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // ── Raw ADIF fields ────────────────────────────────────────────
          _RawAdifSection(qso: qso),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _shareAdif(BuildContext context) async {
    final adif = AdifGenerator.generateSingle(qso);
    final dir = await getTemporaryDirectory();
    final safeCall = qso.callsign.replaceAll('/', '_');
    final file = File('${dir.path}/${safeCall}_qso.adif');
    await file.writeAsString(adif);
    await Share.shareXFiles([XFile(file.path)],
        text: '${qso.callsign} QSO — Wavelog Mobile');
  }

  bool _hasAwards(QsoModel q) =>
      (q.iota?.isNotEmpty ?? false) ||
      (q.sotaRef?.isNotEmpty ?? false) ||
      (q.wwffRef?.isNotEmpty ?? false) ||
      (q.potaRef?.isNotEmpty ?? false) ||
      (q.sigRef?.isNotEmpty ?? false);

  bool _hasMyStation(QsoModel q) =>
      (q.myCallsign?.isNotEmpty ?? false) ||
      (q.myGridSquare?.isNotEmpty ?? false) ||
      (q.myCity?.isNotEmpty ?? false) ||
      q.myCqZone != null ||
      (q.mySota?.isNotEmpty ?? false) ||
      (q.myPota?.isNotEmpty ?? false);

  bool _hasContest(QsoModel q) =>
      (q.contestId?.isNotEmpty ?? false) ||
      (q.srxString?.isNotEmpty ?? false) ||
      (q.stxString?.isNotEmpty ?? false) ||
      (q.srx?.isNotEmpty ?? false) ||
      (q.stx?.isNotEmpty ?? false);
}

// ── QRZ Section ──────────────────────────────────────────────────────────────

class _QrzSection extends ConsumerWidget {
  final String callsign;
  const _QrzSection({required this.callsign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lookupAsync = ref.watch(callsignInfoProvider(callsign));

    return lookupAsync.when(
      loading: () => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(l10n.qrzProfileLoading,
                style: const TextStyle(fontSize: 13)),
          ]),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (info) {
        final hasPhoto = info.imageUrl != null && info.imageUrl!.isNotEmpty;
        final hasEmail = info.email != null && info.email!.isNotEmpty;
        final hasQsl = info.lotwMember || info.eqslMember ||
            info.buqslMember || (info.qslManager?.isNotEmpty ?? false);

        if (!hasPhoto && !hasEmail && !hasQsl) return const SizedBox.shrink();

        final qrzUrl = Uri.parse(
            'https://www.qrz.com/db/${callsign.toUpperCase()}');

        return _Section(
          title: l10n.qrzProfile,
          icon: Icons.account_circle_outlined,
          children: [
            if (hasPhoto) _QrzPhoto(imageUrl: info.imageUrl!, name: info.name),
            if (hasEmail) _EmailRow(email: info.email!),
            if (hasQsl) _QslMethodsRow(info: info),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => launchUrl(qrzUrl,
                    mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.open_in_browser, size: 16),
                label: Text(l10n.viewOnQrz(callsign.toUpperCase())),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QrzPhoto extends StatelessWidget {
  final String imageUrl;
  final String? name;
  const _QrzPhoto({required this.imageUrl, this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 72,
                height: 72,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.person, size: 36),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(Icons.person, size: 36),
              ),
            ),
          ),
          if (name != null) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name!,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmailRow extends StatelessWidget {
  final String email;
  const _EmailRow({required this.email});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse('mailto:$email')),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(Icons.email_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                email,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QslMethodsRow extends StatelessWidget {
  final CallsignLookupModel info;
  const _QslMethodsRow({required this.info});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.qslMethods,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _QslMethodChip(
                  label: 'LoTW',
                  active: info.lotwMember,
                  icon: Icons.cloud_done_outlined),
              _QslMethodChip(
                  label: 'eQSL',
                  active: info.eqslMember,
                  icon: Icons.mark_email_read_outlined),
              _QslMethodChip(
                  label: l10n.bureau,
                  active: info.buqslMember,
                  icon: Icons.local_post_office_outlined),
              if (info.qslManager != null && info.qslManager!.isNotEmpty)
                _QslMethodChip(
                    label: l10n.qslManagerPrefix(info.qslManager!),
                    active: true,
                    icon: Icons.manage_accounts_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class _QslMethodChip extends StatelessWidget {
  final String label;
  final bool active;
  final IconData icon;
  const _QslMethodChip(
      {required this.label, required this.active, required this.icon});

  @override
  Widget build(BuildContext context) {
    final color = active
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outline;
    final bg = active
        ? Theme.of(context).colorScheme.primaryContainer
        : Theme.of(context).colorScheme.surfaceContainerHighest;
    final textColor = active
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: active ? color : color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor),
            ),
          ),
          if (active) ...[
            const SizedBox(width: 4),
            Icon(Icons.check_circle, size: 11, color: color),
          ] else ...[
            const SizedBox(width: 4),
            Icon(Icons.cancel_outlined, size: 11, color: color),
          ],
        ],
      ),
    ),
    );
  }
}

// ── Hero card ────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final QsoModel qso;
  final DateTime dt;
  const _HeroCard({required this.qso, required this.dt});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final mode = qso.submode != null && qso.submode!.isNotEmpty
        ? '${qso.mode} / ${qso.submode}'
        : qso.mode;
    final freq = qso.freqMhz != null
        ? '${qso.freqMhz!.toStringAsFixed(3)} MHz'
        : null;
    final timeOff = qso.timeOff;
    final timeOnStr = DateFormat('HH:mm:ss').format(dt);
    String timeStr = timeOnStr;
    if (timeOff != null && timeOff.length >= 4) {
      final hh = timeOff.substring(0, 2);
      final mm = timeOff.substring(2, 4);
      timeStr = '$timeOnStr – $hh:$mm';
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onLongPress: () {
                          Clipboard.setData(
                              ClipboardData(text: qso.callsign));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(l10n.callsignCopied),
                                duration: const Duration(seconds: 1)),
                          );
                        },
                        child: Text(
                          qso.callsign,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (qso.name != null && qso.name!.isNotEmpty)
                        Text(qso.name!,
                            style: TextStyle(color: cs.secondary)),
                    ],
                  ),
                ),
                if (qso.continent != null && qso.continent!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      qso.continent!.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: cs.onSecondaryContainer,
                          fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _Chip(label: qso.band, color: cs.primaryContainer,
                    textColor: cs.onPrimaryContainer),
                _Chip(label: mode, color: cs.tertiaryContainer,
                    textColor: cs.onTertiaryContainer),
                if (freq != null)
                  _Chip(label: freq, color: cs.surfaceContainerHighest,
                      textColor: cs.onSurface),
              ],
            ),
            const SizedBox(height: 12),

            Row(children: [
              Icon(Icons.calendar_today_outlined,
                  size: 14, color: cs.secondary),
              const SizedBox(width: 6),
              Text(
                DateFormat('dd.MM.yyyy').format(dt),
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time_outlined, size: 14, color: cs.secondary),
              const SizedBox(width: 6),
              Text(
                '$timeStr UTC',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ]),

            if (qso.country != null && qso.country!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.public_outlined, size: 14, color: cs.secondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    [
                      if (qso.country != null) qso.country!,
                      if (qso.dxcc != null && qso.dxcc!.isNotEmpty)
                        'DXCC ${qso.dxcc}',
                    ].join(' • '),
                    style: const TextStyle(fontSize: 13),
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
}

// ── QSL Section ──────────────────────────────────────────────────────────────

class _QslSection extends StatelessWidget {
  final QsoModel qso;
  const _QslSection({required this.qso});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final hasAny = (qso.qslSent != null) ||
        (qso.qslRcvd != null) ||
        (qso.lotwSent != null) ||
        (qso.lotwRcvd != null) ||
        (qso.eqslSent != null) ||
        (qso.eqslRcvd != null) ||
        (qso.qrzSent != null) ||
        (qso.qrzRcvd != null) ||
        (qso.clublogStatus != null) ||
        (qso.hrdlogStatus != null);

    if (!hasAny) return const SizedBox.shrink();

    String uploadStatusLabel(String s) {
      switch (s.toUpperCase()) {
        case 'Y': return l10n.uploadedStatus;
        case 'N': return l10n.notUploadedStatus;
        case 'M': return l10n.matchedStatus;
        case 'D': return l10n.toDeleteStatus;
        default:  return s;
      }
    }

    return _Section(
      title: l10n.qslStatus,
      icon: Icons.mail_outline,
      children: [
        _QslRow(
          label: l10n.paperQsl,
          sent: qso.qslSent,
          rcvd: qso.qslRcvd,
          sentVia: qso.qslSentVia,
          rcvdVia: qso.qslRcvdVia,
          sentDate: qso.qslSdate,
          rcvdDate: qso.qslRdate,
        ),
        _QslRow(
          label: l10n.lotwQsl,
          sent: qso.lotwSent,
          rcvd: qso.lotwRcvd,
          sentDate: qso.lotwSdate,
          rcvdDate: qso.lotwRdate,
        ),
        _QslRow(
          label: l10n.eqslQsl,
          sent: qso.eqslSent,
          rcvd: qso.eqslRcvd,
        ),
        if (qso.qrzSent != null || qso.qrzRcvd != null)
          _QslRow(
            label: l10n.qrzQsl,
            sent: qso.qrzSent,
            rcvd: qso.qrzRcvd,
          ),
        if (qso.clublogStatus != null)
          _LabelValue('ClubLog', uploadStatusLabel(qso.clublogStatus!)),
        if (qso.hrdlogStatus != null)
          _LabelValue('HRDLog', uploadStatusLabel(qso.hrdlogStatus!)),
      ],
    );
  }
}

class _QslRow extends StatelessWidget {
  final String label;
  final String? sent;
  final String? rcvd;
  final String? sentVia;
  final String? rcvdVia;
  final String? sentDate;
  final String? rcvdDate;

  const _QslRow({
    required this.label,
    this.sent,
    this.rcvd,
    this.sentVia,
    this.rcvdVia,
    this.sentDate,
    this.rcvdDate,
  });

  @override
  Widget build(BuildContext context) {
    if (sent == null && rcvd == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (sent != null)
                  _QslStatusChip(
                      isSent: true,
                      status: sent!,
                      via: sentVia,
                      date: sentDate),
                if (rcvd != null)
                  _QslStatusChip(
                      isSent: false,
                      status: rcvd!,
                      via: rcvdVia,
                      date: rcvdDate),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QslStatusChip extends StatelessWidget {
  final bool isSent;
  final String status;
  final String? via;
  final String? date;

  const _QslStatusChip(
      {required this.isSent,
      required this.status,
      this.via,
      this.date});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final prefix = isSent ? l10n.qslSent : l10n.qslReceived;

    final (color, icon) = switch (status.toUpperCase()) {
      'Y' => (Colors.green, Icons.check_circle),
      'R' => (Colors.orange, Icons.hourglass_top),
      'M' => (Colors.orange, Icons.hourglass_empty),
      'N' => (Colors.grey, Icons.cancel_outlined),
      'I' => (Colors.red, Icons.block),
      ''  => (Colors.blue, Icons.hourglass_empty),
      _ => (Colors.grey, Icons.help_outline),
    };

    final label = switch (status.toUpperCase()) {
      'Y' => l10n.yes,
      'R' => l10n.requested,
      'M' => l10n.pending,
      'N' => l10n.no,
      'I' => l10n.invalid,
      ''  => l10n.pending,
      _ => status,
    };

    String tooltip = '$prefix: $label';
    if (via != null && via!.isNotEmpty) {
      final viaLabel = switch (via!.toUpperCase()) {
        'B' => l10n.bureau,
        'D' => l10n.viaDirect,
        'E' => l10n.viaElectronic,
        'M' => l10n.viaMail,
        _ => via,
      };
      tooltip += ' ($viaLabel)';
    }
    if (date != null && date!.length >= 8) {
      final y = date!.substring(0, 4);
      final m = date!.substring(4, 6);
      final d = date!.substring(6, 8);
      tooltip += ' — $d.$m.$y';
    }

    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              '$prefix: $label',
              style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Raw ADIF collapse section ─────────────────────────────────────────────────

class _RawAdifSection extends StatefulWidget {
  final QsoModel qso;
  const _RawAdifSection({required this.qso});

  @override
  State<_RawAdifSection> createState() => _RawAdifSectionState();
}

class _RawAdifSectionState extends State<_RawAdifSection> {
  bool _expanded = false;

  static const _shownKeys = {
    'CALL', 'QSO_DATE', 'TIME_ON', 'TIME_OFF', 'BAND', 'FREQ', 'MODE',
    'SUBMODE', 'RST_SENT', 'RST_RCVD', 'NAME', 'QTH', 'GRIDSQUARE',
    'COUNTRY', 'DXCC', 'CONT', 'CQZ', 'ITUZ', 'STATE', 'CNTY',
    'QSL_SENT', 'QSL_RCVD', 'QSL_SENT_VIA', 'QSL_RCVD_VIA',
    'QSLSDATE', 'QSLRDATE', 'LOTW_QSL_SENT', 'LOTW_QSL_RCVD',
    'LOTW_QSLSDATE', 'LOTW_QSLRDATE', 'EQSL_QSL_SENT', 'EQSL_QSL_RCVD',
    'CLUBLOG_QSO_UPLOAD_STATUS', 'HRDLOG_QSO_UPLOAD_STATUS',
    'TX_PWR', 'PROP_MODE', 'SAT_NAME', 'SAT_MODE', 'ANTENNA', 'DISTANCE',
    'IOTA', 'SOTA_REF', 'WWFF_REF', 'POTA_REF', 'SIG_INFO', 'PFX',
    'CONTEST_ID', 'SRX', 'STX', 'SRX_STRING', 'STX_STRING',
    'STATION_CALLSIGN', 'OPERATOR', 'MY_GRIDSQUARE', 'MY_CITY',
    'MY_COUNTRY', 'MY_CQ_ZONE', 'MY_ITU_ZONE', 'MY_STATE',
    'MY_SOTA_REF', 'MY_POTA_REF', 'MY_IOTA', 'MY_DXCC',
    'A_INDEX', 'K_INDEX', 'SFI', 'COMMENT', 'NOTES',
  };

  @override
  Widget build(BuildContext context) {
    final raw = widget.qso.rawAdif;
    if (raw == null || raw.isEmpty) return const SizedBox.shrink();

    final extra = raw.entries
        .where((e) => !_shownKeys.contains(e.key) && e.value.isNotEmpty)
        .toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (extra.isEmpty) return const SizedBox.shrink();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.code_outlined, size: 20),
            title: Text(context.l10n.otherAdifFields(extra.length),
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            trailing: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: extra
                    .map((e) => _LabelValue(e.key, e.value))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Reusable widgets ─────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _Section(
      {required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    final nonEmpty =
        children.where((c) => c is! SizedBox).toList();
    if (nonEmpty.isEmpty) return const SizedBox.shrink();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 6),
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary)),
            ]),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _TwoCol extends StatelessWidget {
  final Widget left;
  final Widget right;
  const _TwoCol({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}

class _LabelValue extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValue(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _Chip(
      {required this.label,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: textColor),
      ),
    );
  }
}
