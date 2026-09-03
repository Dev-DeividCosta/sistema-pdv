import '../../domain/entities/employee.dart';

class EmployeeModel {
  final String id;
  final String nome;
  final String? apelido;
  final String? cpf;
  final bool isAtivo;
  final DateTime createdAt;

  const EmployeeModel({
    required this.id,
    required this.nome,
    this.apelido,
    this.cpf,
    required this.isAtivo,
    required this.createdAt,
  });

  factory EmployeeModel.fromRow(Map<String, dynamic> row) {
    return EmployeeModel(
      id: row['id'] as String,
      nome: row['nome'] as String,
      apelido: row['apelido'] as String?,
      cpf: row['cpf'] as String?,
      isAtivo: (row['is_ativo'] as int? ?? 1) == 1,
      createdAt:
          DateTime.tryParse(row['created_at'] as String? ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
    );
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
      id: id,
      nome: nome,
      apelido: apelido,
      cpf: cpf,
      isAtivo: isAtivo,
      createdAt: createdAt,
    );
  }
}