// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/member.dart';
import '../theme/feuerwehr_theme.dart';
import 'card_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwortController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _passwortSichtbar = false;
  String? _fehler;

  @override
  void dispose() {
    _emailController.dispose();
    _passwortController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _fehler = null;
    });

    try {
      final Member? member = await _authService.login(
        _emailController.text,
        _passwortController.text,
      );

      if (!mounted) return;

      if (member != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => CardScreen(member: member)),
        );
      } else {
        setState(() {
          _fehler = 'E-Mail oder Passwort ungültig.';
        });
      }
    } catch (e) {
      setState(() {
        _fehler = 'Verbindungsfehler. Bitte erneut versuchen.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FFWColors.grauHell,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Logo / Icon
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: FFWColors.rot,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: FFWColors.rot.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  size: 50,
                  color: FFWColors.weiss,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Freiwillige Feuerwehr',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: FFWColors.dunkel,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Digitaler Mitgliedsausweis',
                style: TextStyle(
                  fontSize: 14,
                  color: FFWColors.grau,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 48),

              // Login-Karte
              Container(
                decoration: BoxDecoration(
                  color: FFWColors.weiss,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'E-Mail',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwortController,
                      obscureText: !_passwortSichtbar,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'Passwort',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwortSichtbar
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () => setState(
                              () => _passwortSichtbar = !_passwortSichtbar),
                        ),
                      ),
                    ),
                    if (_fehler != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red.shade700, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _fehler!,
                                style: TextStyle(
                                    color: Colors.red.shade700, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: FFWColors.weiss,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text('Anmelden'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Demo-Hinweis (Phase 1)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.amber.shade800, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Demo-Zugangsdaten (Phase 1)',
                          style: TextStyle(
                            color: Colors.amber.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'max.mustermann@ffw-musterstadt.de\nPasswort: ffw1234',
                      style: TextStyle(
                        color: Colors.amber.shade900,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
