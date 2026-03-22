# FFW Ausweis – Digitaler Mitgliedsausweis
Flutter-App für die Freiwillige Feuerwehr

---

## Schnellstart

### Voraussetzungen
- Flutter SDK ≥ 3.0 ([flutter.dev](https://flutter.dev/docs/get-started/install))
- Android Studio oder VS Code mit Flutter-Plugin

### Installation

```bash
cd ffw_ausweis
flutter pub get
flutter run
```

### Demo-Login (Phase 1)
| E-Mail | Passwort |
|--------|----------|
| max.mustermann@ffw-musterstadt.de | ffw1234 |
| anna.beispiel@ffw-musterstadt.de  | ffw1234 |

---

## Projektstruktur

```
lib/
├── main.dart                  # App-Einstiegspunkt
├── theme/
│   └── feuerwehr_theme.dart   # Farben & Theme (rot/weiß)
├── models/
│   └── member.dart            # Datenmodell (inkl. fromJson für Phase 2)
├── data/
│   └── dummy_data.dart        # Lokale Testdaten (Phase 1)
├── services/
│   └── auth_service.dart      # Login-Logik (Phase 2: HTTP ersetzen)
└── screens/
    ├── login_screen.dart      # Login-Maske
    └── card_screen.dart       # Digitaler Ausweis mit QR-Code
```

---

## Phase 2 – Server-Anbindung

Alle Phase-2-Stellen sind im Code mit `// Phase 2:` markiert.

### Checkliste

- [ ] `lib/services/auth_service.dart` → HTTP-Login aktivieren, JWT speichern
- [ ] `lib/data/dummy_data.dart` → durch echten API-Call ersetzen
- [ ] `lib/models/member.dart` → `fromJson` ist bereits implementiert
- [ ] Foto-Upload: `Member.fotoUrl` wird bereits unterstützt
- [ ] QR-Verifikation: QR enthält `ausweisNummer|Name|Dienstgrad|Einheit`

### Empfohlener Backend-Stack
- **REST-API**: FastAPI (Python) oder Node.js/Express
- **Auth**: JWT mit Refresh Token
- **Datenbank**: PostgreSQL
- **Foto-Storage**: S3-kompatibel (z.B. MinIO)

### Foto-Integration (Phase 1.5 – ohne Server)
Fotos können über `image_picker` vom Gerät geladen werden:
```yaml
# pubspec.yaml
image_picker: ^1.0.0
```

---

## Ausweis-Inhalt

| Feld | Quelle |
|------|--------|
| Name, Vorname | `Member.vorname/nachname` |
| Dienstgrad | `Member.dienstgrad` |
| Einheit | `Member.einheit` |
| Gültig bis | `Member.gueltigBis` |
| Lehrgänge | `Member.lehrgaenge` (Liste) |
| QR-Code | `ausweisNummer|vollname|dienstgrad|einheit` |
| Foto | `Member.fotoUrl` (optional) |

---

## Anpassungen

### Andere Ortsfeuerwehr
In `lib/data/dummy_data.dart` → `ortsfeuerwehr` anpassen.

### Eigenes Logo
`assets/images/logo.png` hinzufügen und in `pubspec.yaml` einbinden,
dann `_AusweisKarte` um `Image.asset('assets/images/logo.png')` erweitern.

### App-Icon
```bash
flutter pub add flutter_launcher_icons
# logo in assets ablegen, pubspec.yaml konfigurieren
flutter pub run flutter_launcher_icons
```
