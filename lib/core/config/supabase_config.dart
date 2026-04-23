import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get url {
    final value = dotenv.env['SUPABASE_URL'];
    if (value == null || value.isEmpty) {
      throw Exception('Missing SUPABASE_URL in .env');
    }
    return value;
  }

  static String get anonKey {
    final value = dotenv.env['SUPABASE_ANON_KEY'];
    if (value == null || value.isEmpty) {
      throw Exception('Missing SUPABASE_ANON_KEY in .env');
    }
    return value;
  }
}