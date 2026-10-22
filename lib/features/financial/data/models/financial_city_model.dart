import '../../domain/entities/financial_city.dart';

class FinancialCityModel {
  final String id;
  final String name;
  final String state;

  const FinancialCityModel({required this.id, required this.name, required this.state});

  String get displayName => state.trim().isEmpty ? name : '$name — $state';

  FinancialCity toEntity() => FinancialCity(id: id, name: name, state: state);
}
