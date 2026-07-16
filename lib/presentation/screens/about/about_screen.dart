import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/l10n_extension.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _version = '';
  String _build = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() { _version = info.version; _build = info.buildNumber; });
    });
  }

  Future<void> _open(String url) async =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  Future<void> _mail(String address) async =>
      launchUrl(Uri.parse('mailto:$address'), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.radio, size: 52, color: Colors.white),
                ),
                const SizedBox(height: 14),
                Text('Wavelog Mobile',
                    style: tt.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  _version.isEmpty ? '' : l10n.versionLabel(_version, _build),
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.appDescription,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          _SectionTitle(l10n.mobileDeveloperSection),
          _DevCard(
            avatar: 'TA4RX',
            name: 'Erkin',
            callsign: 'TA4RX / SP9AQG',
            rows: [
              _InfoRow(Icons.language, 'ta4rx.tr',
                  onTap: () => _open('https://ta4rx.tr')),
              _InfoRow(Icons.email_outlined, 'erkin@ta4rx.tr',
                  onTap: () => _mail('erkin@ta4rx.tr')),
            ],
          ),

          const SizedBox(height: 20),

          _SectionTitle(l10n.wavelogProjectSection),
          _WavelogCard(
            description: l10n.wavelogDescription,
            coreDevelopersLabel: l10n.coreDevelopers,
            mitLabel: l10n.mitLicense,
            onOpenSite: () => _open('https://www.wavelog.org'),
            onOpenGithub: () => _open('https://github.com/wavelog/wavelog'),
          ),

          const SizedBox(height: 20),

          _SectionTitle(l10n.licenseSection),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.mitLicense,
                      style: tt.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    l10n.mitDescription,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          Center(
            child: Text(
              '© 2024-2026 TA4RX / SP9AQG Erkin\n73 de TA4RX',
              textAlign: TextAlign.center,
              style: tt.bodySmall?.copyWith(color: cs.outlineVariant),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                )),
      );
}

class _DevCard extends StatelessWidget {
  final String avatar;
  final String name;
  final String callsign;
  final List<Widget> rows;
  const _DevCard(
      {required this.avatar,
      required this.name,
      required this.callsign,
      required this.rows});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: cs.primaryContainer,
                child: Text(avatar,
                    style: tt.labelMedium?.copyWith(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 11)),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: tt.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(callsign,
                      style: tt.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ]),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ...rows,
          ],
        ),
      ),
    );
  }
}

class _WavelogCard extends StatelessWidget {
  final String description;
  final String coreDevelopersLabel;
  final String mitLabel;
  final VoidCallback onOpenSite;
  final VoidCallback onOpenGithub;

  const _WavelogCard({
    required this.description,
    required this.coreDevelopersLabel,
    required this.mitLabel,
    required this.onOpenSite,
    required this.onOpenGithub,
  });

  static const _devs = [
    ('DF2ET', 'github.com/phl0'),
    ('DJ7NT', 'github.com/int2001'),
    ('HB9HIL', 'github.com/HB9HIL'),
    ('LA8AJA', 'github.com/AndreasK79'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.cloud_outlined,
                    size: 30, color: cs.onSecondaryContainer),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Wavelog',
                      style: tt.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(description,
                      style: tt.bodySmall
                          ?.copyWith(color: cs.onSurfaceVariant)),
                  Text('$mitLabel · wavelog.org',
                      style: tt.bodySmall?.copyWith(
                          color: cs.primary, fontSize: 11)),
                ],
              ),
            ]),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            Text(coreDevelopersLabel,
                style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _devs
                  .map((d) => Chip(
                        avatar: const Icon(Icons.person_outline, size: 14),
                        label: Text(d.$1,
                            style: const TextStyle(fontSize: 12)),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),

            const SizedBox(height: 12),

            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onOpenSite,
                  icon: const Icon(Icons.language, size: 16),
                  label: const Text('wavelog.org'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onOpenGithub,
                  icon: const Icon(Icons.code, size: 16),
                  label: const Text('GitHub'),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _InfoRow(this.icon, this.label, {this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 10),
          Text(label,
              style: TextStyle(
                  color: onTap != null ? cs.primary : null,
                  decoration:
                      onTap != null ? TextDecoration.underline : null,
                  decorationColor: cs.primary)),
        ]),
      ),
    );
  }
}
