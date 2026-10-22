class FinancialCity {
  final String id;
  final String name;
  final String state;

  const FinancialCity({required this.id, required this.name, required this.state});

  String get displayName => state.trim().isEmpty ? name : '$name — $state';
}
