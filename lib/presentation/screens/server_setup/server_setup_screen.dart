import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../data/datasources/remote/wavelog_remote_datasource.dart';
import '../../../providers/dio_provider.dart';
import '../../../providers/settings_provider.dart';

class ServerSetupScreen extends ConsumerStatefulWidget {
  const ServerSetupScreen({super.key});

  @override
  ConsumerState<ServerSetupScreen> createState() => _ServerSetupScreenState();
}

class _ServerSetupScreenState extends ConsumerState<ServerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _urlCtrl;
  bool _testing = false;
  String? _testResult;
  bool _testSuccess = false;
  bool _allowInsecureSsl = false;

  @override
  void initState() {
    super.initState();
    _urlCtrl = TextEditingController(
        text: ref.read(settingsProvider).serverUrl);
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;
    final cleanUrl = normalizeServerUrl(_urlCtrl.text.trim());
    await ref.read(settingsProvider.notifier).updateServerUrl(cleanUrl);
    await ref
        .read(settingsProvider.notifier)
        .setAllowInsecureSsl(_allowInsecureSsl);
    if (mounted) context.go('/login');
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _testing = true;
      _testResult = null;
    });

    // Auth olmadan sadece sunucunun erişilebilir bir Wavelog örneği olup
    // olmadığını kontrol et — API anahtarı bu adımda henüz girilmedi.
    final serverUrl = _urlCtrl.text.trim();
    final remote = WavelogRemoteDatasource(
      dio: buildWavelogDio(serverUrl,
          bearerToken: '', allowInsecureSsl: _allowInsecureSsl),
    );

    try {
      // checkVersion() (unlike getVersion()) rethrows on failure — needed
      // here so an SSL failure can be told apart from "no server here".
      final version = await remote.checkVersion();
      if (!mounted) return;
      setState(() {
        _testing = false;
        _testSuccess = true;
        _testResult = version != null
            ? 'Wavelog v$version — ${context.l10n.connectionSuccess}'
            : context.l10n.connectionSuccess;
      });
    } on SslException {
      if (!mounted) return;
      setState(() => _testing = false);
      await _offerInsecureSsl();
    } on UnauthorizedException {
      // 401/403 still proves the server is reachable and is a Wavelog instance
      if (!mounted) return;
      setState(() {
        _testing = false;
        _testSuccess = true;
        _testResult = context.l10n.connectionSuccess;
      });
    } on NetworkException {
      if (!mounted) return;
      setState(() {
        _testing = false;
        _testSuccess = false;
        _testResult = context.l10n.errNetwork;
      });
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _testing = false;
        _testSuccess = false;
        _testResult = context.l10n.errTimeout;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _testing = false;
        _testSuccess = true;
        _testResult = context.l10n.connectionSuccess;
      });
    }
  }

  Future<void> _offerInsecureSsl() async {
    final l10n = context.l10n;
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded,
            color: Colors.orange, size: 32),
        title: Text(l10n.sslIssueTitle),
        content: Text(l10n.sslIssueBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.sslIssueAllow),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (proceed == true) {
      setState(() => _allowInsecureSsl = true);
      await _testConnection();
    } else {
      setState(() {
        _testSuccess = false;
        _testResult = l10n.sslIssueTitle;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.cell_tower,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Wavelog Mobile',
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.serverSetupSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _urlCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.serverUrlLabel,
                      hintText: l10n.serverUrlHint,
                      prefixIcon: const Icon(Icons.link),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _saveAndContinue(),
                    validator: validateServerUrl,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _testing ? null : _testConnection,
                    icon: _testing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.wifi_find, size: 18),
                    label: Text(
                        _testing ? l10n.testingConnection : l10n.testConnection),
                  ),
                  if (_testResult != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _testSuccess
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color: _testSuccess ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _testResult!,
                            style: TextStyle(
                              color:
                                  _testSuccess ? Colors.green : Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (_allowInsecureSsl) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.no_encryption_gmailerrorred,
                            color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.sslIssueAllow,
                            style: const TextStyle(
                                color: Colors.orange, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _saveAndContinue,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(l10n.continueBtn),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
