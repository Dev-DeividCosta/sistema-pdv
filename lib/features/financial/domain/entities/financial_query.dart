class FinancialQuery {
  final String? cityId;
  final String? employeeId;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> statuses;

  FinancialQuery({
    required this.cityId,
    required this.employeeId,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> statuses,
  })  : startDate = DateTime(startDate.year, startDate.month, startDate.day),
        endDate = DateTime(endDate.year, endDate.month, endDate.day),
        statuses = List.unmodifiable(statuses.toSet().toList()..sort());

  @override
  bool operator ==(Object other) =>
      other is FinancialQuery &&
      other.cityId == cityId &&
      other.employeeId == employeeId &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      _statusKey(other.statuses) == _statusKey(statuses);

  @override
  int get hashCode => Object.hash(cityId, employeeId, startDate, endDate, _statusKey(statuses));

  static String _statusKey(List<String> values) => values.join('|');
}
