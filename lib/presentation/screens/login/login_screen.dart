import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/l10n_extension.dart';
import '../../../data/datasources/remote/wavelog_remote_datasource.dart';
import '../../../data/models/station_model.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../providers/dio_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/settings_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profiles = ref.watch(profileProvider);
    final serverUrl = ref.watch(settingsProvider).serverUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loginTitle),
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/server-setup'),
            icon: const Icon(Icons.dns_outlined, size: 18),
            label: Text(l10n.serverBtn),
          ),
        ],
      ),
      body: profiles.when(
        data: (list) => list.isEmpty
            ? _EmptyState(serverUrl: serverUrl)
            : _ProfileList(profiles: list, serverUrl: serverUrl),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${context.l10n.error}: $e')),
      ),
      floatingActionButton: profiles.maybeWhen(
        data: (list) => list.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () =>
                    _showAddProfileSheet(context, ref, serverUrl),
                icon: const Icon(Icons.person_add),
                label: Text(l10n.addAccountBtn),
              )
            : null,
        orElse: () => null,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String serverUrl;
  const _EmptyState({required this.serverUrl});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.loginTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () =>
                  _showAddProfileSheet(context, null, serverUrl),
              icon: const Icon(Icons.person_add),
              label: Text(l10n.addAccountBtn),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileList extends ConsumerWidget {
  final List<UserProfileModel> profiles;
  final String serverUrl;

  const _ProfileList({required this.profiles, required this.serverUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...profiles.map(
          (p) => _ProfileCard(
            profile: p,
            serverUrl: serverUrl,
            onDelete: () =>
                ref.read(profileProvider.notifier).deleteProfile(p.id),
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends ConsumerWidget {
  final UserProfileModel profile;
  final String serverUrl;
  final VoidCallback onDelete;

  const _ProfileCard({
    required this.profile,
    required this.serverUrl,
    required this.onDelete,
  });

  Future<void> _login(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(settingsProvider.notifier);

    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    StationModel? autoStation;
    try {
      final remote = WavelogRemoteDatasource(
          dio: buildWavelogDio(serverUrl), apiKey: profile.apiKey);
      final stations = await remote.getStations();

      autoStation = stations.where((s) =>
          s.callsign.toUpperCase() == profile.callsign.toUpperCase()).firstOrNull;
      autoStation ??= stations.where((s) => s.isActive).firstOrNull;
      autoStation ??= stations.firstOrNull;

      if (autoStation != null) {
        final updated = profile.copyWith(
          defaultStationId: autoStation.id,
          defaultStationCallsign: autoStation.callsign,
          defaultStationName: autoStation.profileName,
        );
        await ref.read(profileProvider.notifier).updateProfile(updated);
      }
    } catch (e) {
      debugPrint('Auto-station fetch failed (non-fatal): $e');
    }

    await notifier.loginWithProfile(profile, autoStation);

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final initials = profile.callsign.isNotEmpty
        ? profile.callsign.substring(0, profile.callsign.length.clamp(0, 2))
        : '?';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                initials.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.callsign,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    profile.displayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  if (profile.defaultStationName != null)
                    Text(
                      profile.defaultStationName!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                    ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () => _login(context, ref),
              child: Text(l10n.signInBtn),
            ),
            PopupMenuButton<_ProfileAction>(
              icon: const Icon(Icons.more_vert),
              onSelected: (action) async {
                if (action == _ProfileAction.delete) {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (dialogCtx) => AlertDialog(
                      title: Text(l10n.deleteProfileTitle),
                      content: Text(
                          l10n.deleteProfileConfirm(profile.callsign)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx, false),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(dialogCtx, true),
                          child: Text(l10n.delete,
                              style: const TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) onDelete();
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: _ProfileAction.delete,
                  child: ListTile(
                    leading:
                        const Icon(Icons.delete_outline, color: Colors.red),
                    title: Text(l10n.delete,
                        style: const TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _ProfileAction { delete }

void _showAddProfileSheet(
    BuildContext context, WidgetRef? ref, String serverUrl) {
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => _AddProfileSheet(serverUrl: serverUrl),
    ),
  );
}

class _AddProfileSheet extends ConsumerStatefulWidget {
  final String serverUrl;
  const _AddProfileSheet({required this.serverUrl});

  @override
  ConsumerState<_AddProfileSheet> createState() => _AddProfileSheetState();
}

class _AddProfileSheetState extends ConsumerState<_AddProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _callsignCtrl = TextEditingController();
  final _apiKeyCtrl = TextEditingController();
  bool _keyObscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _callsignCtrl.dispose();
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  Future<void> _addAndLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final callsign = _callsignCtrl.text.trim().toUpperCase();
    final apiKey = _apiKeyCtrl.text.trim();

    List<StationModel> stations = [];
    try {
      final remote = WavelogRemoteDatasource(
          dio: buildWavelogDio(widget.serverUrl), apiKey: apiKey);
      stations = await remote.getStations();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = '${context.l10n.loginFailed}: $e';
      });
      return;
    }

    StationModel? match = stations
        .where((s) => s.callsign.toUpperCase() == callsign)
        .firstOrNull;
    match ??= stations.where((s) => s.isActive).firstOrNull;
    match ??= stations.firstOrNull;

    final profile = UserProfileModel(
      id: const Uuid().v4(),
      displayName: _nameCtrl.text.trim(),
      callsign: callsign,
      apiKey: apiKey,
      defaultStationId: match?.id,
      defaultStationCallsign: match?.callsign,
      defaultStationName: match?.profileName,
    );

    await ref.read(profileProvider.notifier).addProfile(profile);
    await ref.read(settingsProvider.notifier).loginWithProfile(profile, match);

    if (mounted) {
      Navigator.of(context).pop();
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addAccountBtn),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: '${l10n.displayName} *',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.displayName : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _callsignCtrl,
                decoration: InputDecoration(
                  labelText: '${l10n.callsign} *',
                  hintText: 'TA4RX',
                  prefixIcon: const Icon(Icons.cell_tower_outlined),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.callsign : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _apiKeyCtrl,
                decoration: InputDecoration(
                  labelText: '${l10n.apiKeyLabel} *',
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _keyObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => _keyObscure = !_keyObscure),
                  ),
                ),
                obscureText: _keyObscure,
                autocorrect: false,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.apiKeyLabel : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _loading ? null : _addAndLogin,
                icon: _loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.login),
                label: Text(_loading ? l10n.validating : l10n.signInBtn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

