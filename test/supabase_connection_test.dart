import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://fosgclukncaiwerxkgmp.supabase.co',
  );
  const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  test('Live Supabase connection and clients query test', () async {
    final client = SupabaseClient(url, anonKey);

    // Verify reading from 'clients' table
    final data = await client
        .from('clients')
        .select()
        .order('created_at', ascending: true);

    expect(data, isA<List<dynamic>>());
  }, skip: anonKey.isEmpty ? 'Set SUPABASE_ANON_KEY to run live test' : false);
}
