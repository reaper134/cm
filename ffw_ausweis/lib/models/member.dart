// lib/models/member.dart
// Datenmodell für ein Feuerwehrmitglied.
// Phase 2: JSON-Serialisierung für API-Anbindung ist vorbereitet.

class Member {
  final String id;
  final String vorname;
  final String nachname;
  final String dienstgrad;
  final String einheit;
  final String ortsfeuerwehr;
  final DateTime eintrittsdatum;
  final DateTime gueltigBis;
  final List<String> lehrgaenge;
  final String? fotoUrl; // null = Platzhalter-Avatar

  const Member({
    required this.id,
    required this.vorname,
    required this.nachname,
    required this.dienstgrad,
    required this.einheit,
    required this.ortsfeuerwehr,
    required this.eintrittsdatum,
    required this.gueltigBis,
    required this.lehrgaenge,
    this.fotoUrl,
  });

  String get vollname => '$vorname $nachname';

  String get ausweisNummer => 'FFW-${eintrittsdatum.year}-$id';

  bool get istGueltig => gueltigBis.isAfter(DateTime.now());

  // Phase 2: fromJson für REST-API
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      vorname: json['vorname'] as String,
      nachname: json['nachname'] as String,
      dienstgrad: json['dienstgrad'] as String,
      einheit: json['einheit'] as String,
      ortsfeuerwehr: json['ortsfeuerwehr'] as String,
      eintrittsdatum: DateTime.parse(json['eintrittsdatum'] as String),
      gueltigBis: DateTime.parse(json['gueltig_bis'] as String),
      lehrgaenge: List<String>.from(json['lehrgaenge'] as List),
      fotoUrl: json['foto_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vorname': vorname,
        'nachname': nachname,
        'dienstgrad': dienstgrad,
        'einheit': einheit,
        'ortsfeuerwehr': ortsfeuerwehr,
        'eintrittsdatum': eintrittsdatum.toIso8601String(),
        'gueltig_bis': gueltigBis.toIso8601String(),
        'lehrgaenge': lehrgaenge,
        'foto_url': fotoUrl,
      };
}
