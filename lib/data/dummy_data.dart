// lib/data/dummy_data.dart
// Phase 1: Lokale Testdaten ohne Server.
// Phase 2: Diesen Service durch einen HTTP-Service ersetzen.

import '../models/member.dart';

/// Simuliert einen erfolgreichen Login und gibt Mitgliedsdaten zurück.
/// Phase 2: Ersetzen durch AuthService.login(email, password) → JWT + Memberdaten
Future<Member?> loginMitDummyDaten(String email, String passwort) async {
  // Netzwerk-Latenz simulieren
  await Future.delayed(const Duration(milliseconds: 800));

  final nutzer = _dummyNutzer[email.toLowerCase().trim()];
  if (nutzer == null) return null;
  if (nutzer['passwort'] != passwort) return null;

  return _dummyMitglieder[nutzer['member_id']];
}

// Demo-Zugangsdaten (werden in Phase 2 durch echte Auth ersetzt)
final Map<String, Map<String, String>> _dummyNutzer = {
  'max.mustermann@ffw-musterstadt.de': {
    'passwort': 'ffw1234',
    'member_id': 'M001',
  },
  'anna.beispiel@ffw-musterstadt.de': {
    'passwort': 'ffw1234',
    'member_id': 'M002',
  },
};

final Map<String, Member> _dummyMitglieder = {
  'M001': Member(
    id: 'M001',
    vorname: 'Max',
    nachname: 'Mustermann',
    dienstgrad: 'Oberfeuerwehrmann',
    einheit: 'Löschzug 1 – Mitte',
    ortsfeuerwehr: 'FF Musterstadt',
    eintrittsdatum: DateTime(2015, 3, 15),
    gueltigBis: DateTime(2026, 12, 31),
    lehrgaenge: ['Truppmann', 'AGT', 'Sprechfunker', 'THL'],
  ),
  'M002': Member(
    id: 'M002',
    vorname: 'Anna',
    nachname: 'Beispiel',
    dienstgrad: 'Hauptfeuerwehrfrau',
    einheit: 'Löschzug 2 – Süd',
    ortsfeuerwehr: 'FF Musterstadt',
    eintrittsdatum: DateTime(2012, 6, 1),
    gueltigBis: DateTime(2026, 12, 31),
    lehrgaenge: ['Truppmann', 'Gruppenführer', 'AGT', 'Sprechfunker', 'Sanitätsdienst'],
  ),
};
