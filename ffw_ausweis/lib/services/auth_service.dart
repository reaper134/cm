// lib/services/auth_service.dart
// Abstraktion des Login-Vorgangs.
// Phase 2: httpClient und baseUrl aktivieren, loginMitDummyDaten ersetzen.

import 'package:shared_preferences/shared_preferences.dart';
import '../models/member.dart';
import '../data/dummy_data.dart';

class AuthService {
  static const _keyLoggedIn = 'is_logged_in';
  static const _keyMemberId = 'member_id';

  // Phase 2: final String baseUrl = 'https://api.ffw-musterstadt.de/v1';

  /// Login: gibt Member zurück oder null bei Fehler
  Future<Member?> login(String email, String passwort) async {
    // Phase 1: Dummy-Login
    final member = await loginMitDummyDaten(email, passwort);

    // Phase 2: HTTP-Login ersetzen:
    // final response = await http.post(
    //   Uri.parse('$baseUrl/auth/login'),
    //   body: json.encode({'email': email, 'password': passwort}),
    //   headers: {'Content-Type': 'application/json'},
    // );
    // if (response.statusCode != 200) return null;
    // final member = Member.fromJson(json.decode(response.body));

    if (member != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyLoggedIn, true);
      await prefs.setString(_keyMemberId, member.id);
    }
    return member;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
    await prefs.remove(_keyMemberId);
  }

  Future<bool> istEingeloggt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }
}
