import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/company_check.dart';

class CompanyService {
  CompanyService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<CompanyCheck> verify(String companyName) async {
    final name = companyName.trim();
    if (name.isEmpty) {
      throw ArgumentError.value(companyName, 'companyName', 'Enter a company name.');
    }

    final response = await _client.functions.invoke(
      'verify-company',
      body: {'companyName': name},
    );
    if (response.status < 200 || response.status >= 300) {
      throw Exception('Company verification failed (${response.status}).');
    }
    if (response.data is! Map) {
      throw const FormatException('The company verification response was invalid.');
    }
    return CompanyCheck.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
