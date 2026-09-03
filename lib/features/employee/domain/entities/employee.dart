import 'package:uuid/uuid.dart';

const _undefined = Object();

class EmployeeEntity {
  final String id;
  final String nome;
  final String? apelido;
  final String? cpf;
  final bool isAtivo;
  final DateTime createdAt;

  const EmployeeEntity({
    required this.id,
    required this.nome,
    this.apelido,
    this.cpf,
    required this.isAtivo,
    required this.createdAt,
  });

  factory EmployeeEntity.createNew({
    required String nome,
    String? apelido,
    String? cpf,
    required bool isAtivo,
  }) {
    return EmployeeEntity(
      id: const Uuid().v4(),
      nome: nome,
      apelido: apelido,
      cpf: cpf,
      isAtivo: isAtivo,
      createdAt: DateTime.now().toUtc(),
    );
  }

  EmployeeEntity copyWith({
    String? id,
    String? nome,
    Object? apelido = _undefined,
    Object? cpf = _undefined,
    bool? isAtivo,
    DateTime? createdAt,
  }) {
    return EmployeeEntity(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      apelido: apelido == _undefined
          ? this.apelido
          : apelido as String?,
      cpf: cpf == _undefined ? this.cpf : cpf as String?,
      isAtivo: isAtivo ?? this.isAtivo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}