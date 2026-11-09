import 'package:supabase_flutter/supabase_flutter.dart';

class FamilyAlert {
  const FamilyAlert({
    required this.id,
    required this.message,
    required this.createdAt,
  });

  final String id;
  final String message;
  final DateTime createdAt;
}

class FamilyService {
  FamilyService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<String> _ensureUser() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser != null) return currentUser.id;
    final response = await _client.auth.signInAnonymously();
    final userId = response.user?.id;
    if (userId == null) {
      throw StateError('Could not create an anonymous account for family features.');
    }
    return userId;
  }

  Future<String> createLinkCode() async {
    await _ensureUser();
    final result = await _client.rpc('create_family_link');
    if (result is! Map || result['code'] is! String) {
      throw const FormatException('The server returned an invalid family link.');
    }
    return result['code'] as String;
  }

  Future<void> joinWithCode(String code) async {
    await _ensureUser();
    final normalized = code.trim().toUpperCase();
    if (normalized.isEmpty) {
      throw ArgumentError.value(code, 'code', 'Enter a family link code.');
    }
    await _client.rpc('join_family_link', params: {'p_code': normalized});
  }

  Future<void> sendAlert(String message) async {
    final text = message.trim();
    if (text.isEmpty) {
      throw ArgumentError.value(message, 'message', 'Alert text cannot be empty.');
    }

    final userId = await _ensureUser();

    final link = await _client
        .from('family_links')
        .select('guardian_id')
        .eq('member_id', userId)
        .not('guardian_id', 'is', null)
        .limit(1)
        .maybeSingle();
    final guardianId = link?['guardian_id'] as String?;
    if (guardianId == null) {
      throw StateError('Link a family guardian before sending alerts.');
    }

    await _client.from('family_alerts').insert({
      'member_id': userId,
      'guardian_id': guardianId,
      'message': text,
    });
  }

  Future<List<FamilyAlert>> getAlerts() async {
    final userId = await _ensureUser();
    final rows = await _client
        .from('family_alerts')
        .select('id, message, created_at')
        .eq('guardian_id', userId)
        .order('created_at', ascending: false);

    return rows
        .map(
          (row) => FamilyAlert(
            id: row['id'] as String,
            message: row['message'] as String,
            createdAt: DateTime.parse(row['created_at'] as String),
          ),
        )
        .toList(growable: false);
  }
}
