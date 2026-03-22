// lib/screens/card_screen.dart

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../models/member.dart';
import '../theme/feuerwehr_theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class CardScreen extends StatelessWidget {
  final Member member;

  const CardScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FFWColors.grauHell,
      appBar: AppBar(
        title: const Text('Mein Ausweis'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Abmelden',
            onPressed: () => _abmelden(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _AusweisKarte(member: member),
              const SizedBox(height: 16),
              _LehrgaengeKarte(member: member),
              const SizedBox(height: 16),
              _QrKarte(member: member),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _abmelden(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Abmelden'),
        content: const Text('Möchten Sie sich wirklich abmelden?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Abbrechen')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: FFWColors.rot),
            child: const Text('Abmelden'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await AuthService().logout();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }
}

// ─── Haupt-Ausweiskarte ──────────────────────────────────────────────────────

class _AusweisKarte extends StatelessWidget {
  final Member member;
  const _AusweisKarte({required this.member});

  @override
  Widget build(BuildContext context) {
    final datumFormat = DateFormat('dd.MM.yyyy', 'de_DE');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // ── Roter Header ──
            Container(
              color: FFWColors.rot,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department,
                      color: FFWColors.weiss, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FREIWILLIGE FEUERWEHR',
                          style: TextStyle(
                            color: FFWColors.weiss,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          member.ortsfeuerwehr,
                          style: const TextStyle(
                            color: Color(0xFFFFCCCC),
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gültigkeits-Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: member.istGueltig
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFB71C1C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      member.istGueltig ? 'AKTIV' : 'ABGELAUFEN',
                      style: const TextStyle(
                        color: FFWColors.weiss,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Weißer Body ──
            Container(
              color: FFWColors.weiss,
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto
                  _FotoAvatar(member: member),
                  const SizedBox(width: 20),

                  // Daten
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.vollname,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: FFWColors.dunkel,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _InfoChip(
                          icon: Icons.military_tech_outlined,
                          text: member.dienstgrad,
                          color: FFWColors.rot,
                        ),
                        const SizedBox(height: 6),
                        _InfoChip(
                          icon: Icons.location_city_outlined,
                          text: member.einheit,
                          color: FFWColors.grau,
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _DatenFeld(
                                label: 'Mitglied seit',
                                wert: datumFormat
                                    .format(member.eintrittsdatum),
                              ),
                            ),
                            Expanded(
                              child: _DatenFeld(
                                label: 'Gültig bis',
                                wert:
                                    datumFormat.format(member.gueltigBis),
                                hervorheben: !member.istGueltig,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _DatenFeld(
                          label: 'Ausweis-Nr.',
                          wert: member.ausweisNummer,
                          mono: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Lehrgänge-Karte ─────────────────────────────────────────────────────────

class _LehrgaengeKarte extends StatelessWidget {
  final Member member;
  const _LehrgaengeKarte({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FFWColors.weiss,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.school_outlined, color: FFWColors.rot, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Qualifikationen & Lehrgänge',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: FFWColors.dunkel,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: FFWColors.rot.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${member.lehrgaenge.length}',
                  style: const TextStyle(
                    color: FFWColors.rot,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: member.lehrgaenge
                .map((lg) => _LehrgangBadge(name: lg))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ─── QR-Code-Karte ────────────────────────────────────────────────────────────

class _QrKarte extends StatelessWidget {
  final Member member;
  const _QrKarte({required this.member});

  @override
  Widget build(BuildContext context) {
    // QR-Daten: JSON-String für Phase 2 API-Verifikation
    final qrData = '${member.ausweisNummer}|${member.vollname}|'
        '${member.dienstgrad}|${member.einheit}';

    return Container(
      decoration: BoxDecoration(
        color: FFWColors.weiss,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(Icons.qr_code_2, color: FFWColors.rot, size: 20),
              SizedBox(width: 8),
              Text(
                'Verifikations-QR-Code',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: FFWColors.dunkel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 180,
            backgroundColor: FFWColors.weiss,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: FFWColors.dunkel,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: FFWColors.dunkel,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.ausweisNummer,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: FFWColors.grau,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Zum Scannen durch berechtigte Stellen',
            style: TextStyle(fontSize: 11, color: FFWColors.grau),
          ),
        ],
      ),
    );
  }
}

// ─── Hilfwidgets ─────────────────────────────────────────────────────────────

class _FotoAvatar extends StatelessWidget {
  final Member member;
  const _FotoAvatar({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 95,
      decoration: BoxDecoration(
        color: FFWColors.grauHell,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: member.fotoUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(member.fotoUrl!, fit: BoxFit.cover),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 40, color: FFWColors.grau),
                const SizedBox(height: 2),
                Text(
                  'Foto',
                  style: TextStyle(fontSize: 10, color: FFWColors.grau),
                ),
              ],
            ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DatenFeld extends StatelessWidget {
  final String label;
  final String wert;
  final bool hervorheben;
  final bool mono;
  const _DatenFeld({
    required this.label,
    required this.wert,
    this.hervorheben = false,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: FFWColors.grau),
        ),
        const SizedBox(height: 2),
        Text(
          wert,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: hervorheben ? FFWColors.ungueltig : FFWColors.dunkel,
            fontFamily: mono ? 'monospace' : null,
          ),
        ),
      ],
    );
  }
}

class _LehrgangBadge extends StatelessWidget {
  final String name;
  const _LehrgangBadge({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: FFWColors.rot.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FFWColors.rot.withOpacity(0.3)),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 12,
          color: FFWColors.rotDunkel,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
