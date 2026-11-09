class CompanyCheck {
  const CompanyCheck({
    required this.companyName,
    required this.summary,
    required this.sources,
    this.domain,
    this.domainAgeYears,
  });

  final String companyName;
  final String summary;
  final List<String> sources;
  final String? domain;
  final int? domainAgeYears;

  factory CompanyCheck.fromJson(Map<String, dynamic> json) {
    final rawSources = json['sources'];
    return CompanyCheck(
      companyName: json['companyName'] as String? ?? 'Unknown company',
      summary: json['summary'] as String? ?? 'No summary was provided.',
      sources: rawSources is List
          ? rawSources.whereType<String>().toList(growable: false)
          : const [],
      domain: json['domain'] as String?,
      domainAgeYears: (json['domainAgeYears'] as num?)?.toInt(),
    );
  }
}
