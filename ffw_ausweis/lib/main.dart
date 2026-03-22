// lib/main.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'theme/feuerwehr_theme.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('de_DE', null);
  runApp(const FFWAusweisApp());
}

class FFWAusweisApp extends StatelessWidget {
  const FFWAusweisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFW Ausweis',
      debugShowCheckedModeBanner: false,
      theme: feuerwehrTheme(),
      home: const LoginScreen(),
    );
  }
}
