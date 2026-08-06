import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../providers/lookup_provider.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/lookup/callsign_info_card.dart';
import '../../../router.dart';

class CallsignLookupScreen extends ConsumerStatefulWidget {
  final String? prefillCallsign;
  const CallsignLookupScreen({super.key, this.prefillCallsign});

  @override
  ConsumerState<CallsignLookupScreen> createState() =>
      _CallsignLookupScreenState();
}

class _CallsignLookupScreenState
    extends ConsumerState<CallsignLookupScreen> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
        text: widget.prefillCallsign?.toUpperCase() ?? '');
    if (widget.prefillCallsign != null && widget.prefillCallsign!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(lookupProvider.notifier).lookup(widget.prefillCallsign!);
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _search() {
    final cs = _ctrl.text.trim().toUpperCase();
    if (cs.isEmpty) return;
    ref.read(lookupProvider.notifier).lookup(cs);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lookup = ref.watch(lookupProvider);
    final history = ref.watch(lookupHistoryProvider);

    return Scaffold(
      appBar: AppBar(leading: const DrawerMenuButton(), title: Text(l10n.lookupTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ctrl,
                    decoration: InputDecoration(
                      hintText: l10n.lookupHint,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _ctrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _ctrl.clear();
                                ref.read(lookupProvider.notifier).clear();
                              },
                            )
                          : null,
                    ),
                    textCapitalization: TextCapitalization.characters,
                    onFieldSubmitted: (_) => _search(),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _search,
                  child: Text(l10n.lookupBtn),
                ),
              ],
            ),
          ),

          Expanded(
            child: lookup.when(
              data: (result) {
                if (result == null) {
                  return history.when(
                    data: (hist) {
                      if (hist.isEmpty) {
                        return EmptyView(
                          message: l10n.lookupHint,
                          icon: Icons.manage_search,
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(l10n.recentSearches,
                                style: Theme.of(context).textTheme.labelLarge),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: hist.length,
                              itemBuilder: (context, i) => ListTile(
                                leading: const Icon(Icons.history),
                                title: Text(hist[i],
                                    style: const TextStyle(
                                        fontFamily: 'monospace')),
                                onTap: () {
                                  _ctrl.text = hist[i];
                                  _search();
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: CallsignInfoCard(
                    result: result,
                    onLogQso: () {
                      context.push(
                          '/add-qso?callsign=${result.callsign}');
                    },
                  ),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(
                message: e.toString(),
                onRetry: _search,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
