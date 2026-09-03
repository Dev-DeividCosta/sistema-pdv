import 'package:uuid/uuid.dart';

class PaymentMethodEntity {
  final String id;
  final String nome;
  final bool isAtivo;
  final DateTime createdAt;

  const PaymentMethodEntity({
    required this.id,
    required this.nome,
    required this.isAtivo,
    required this.createdAt,
  });

  factory PaymentMethodEntity.createNew({
    required String nome,
    required bool isAtivo,
  }) => PaymentMethodEntity(
        id: const Uuid().v4(),
        nome: nome,
        isAtivo: isAtivo,
        createdAt: DateTime.now().toUtc(),
      );

  PaymentMethodEntity copyWith({
    String? id,
    String? nome,
    bool? isAtivo,
    DateTime? createdAt,
  }) => PaymentMethodEntity(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        isAtivo: isAtivo ?? this.isAtivo,
        createdAt: createdAt ?? this.createdAt,
      );
}
