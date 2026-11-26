import 'dart:io';

import 'package:flutter/foundation.dart';

/// Runtime configuration.
///
/// Values arrive from `--dart-define` / `--dart-define-from-file=.env`, plus an
/// optional `.env` file read at startup for local `flutter run` sessions.
/// Nothing here is ever logged, printed, or committed.
class AppConfig {
  const AppConfig({required this.supabaseUrl, required this.supabaseAnonKey});

  static const String _defineUrl = String.fromEnvironment('SUPABASE_URL');
  static const String _defineKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  final String supabaseUrl;
  final String supabaseAnonKey;

  /// True when both values are present, i.e. use the Supabase repository.
  bool get hasSupabase =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  static const AppConfig empty = AppConfig(supabaseUrl: '', supabaseAnonKey: '');

  /// Reads `--dart-define` first, then `.env` next to the working directory.
  /// Never prints the values.
  static Future<AppConfig> load({String envPath = '.env'}) async {
    if (_defineUrl.isNotEmpty && _defineKey.isNotEmpty) {
      return const AppConfig(
        supabaseUrl: _defineUrl,
        supabaseAnonKey: _defineKey,
      );
    }

    try {
      final File file = File(envPath);
      if (await file.exists()) {
        final Map<String, String> values = parseEnv(await file.readAsString());
        final String url = values['SUPABASE_URL'] ?? '';
        final String key = values['SUPABASE_ANON_KEY'] ?? '';
        if (url.isNotEmpty && key.isNotEmpty) {
          return AppConfig(supabaseUrl: url, supabaseAnonKey: key);
        }
      }
    } catch (e) {
      debugPrint('config: .env not readable, using offline demo data');
    }
    return empty;
  }

  /// Minimal dotenv parser: `KEY=VALUE`, `#` comments, optional quotes.
  static Map<String, String> parseEnv(String contents) {
    final Map<String, String> out = <String, String>{};
    for (final String line in contents.split('\n')) {
      final String trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
      final int eq = trimmed.indexOf('=');
      if (eq <= 0) continue;
      final String key = trimmed.substring(0, eq).trim();
      String value = trimmed.substring(eq + 1).trim();
      if (value.length >= 2 &&
          ((value.startsWith('"') && value.endsWith('"')) ||
              (value.startsWith("'") && value.endsWith("'")))) {
        value = value.substring(1, value.length - 1);
      }
      out[key] = value;
    }
    return out;
  }
}
