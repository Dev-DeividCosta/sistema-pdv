import '../../domain/entities/payment_method.dart';

class PaymentMethodModel {
  final String id;
  final String nome;
  final bool isAtivo;
  final DateTime createdAt;

  const PaymentMethodModel({
    required this.id,
    required this.nome,
    required this.isAtivo,
    required this.createdAt,
  });

  PaymentMethodEntity toEntity() => PaymentMethodEntity(
        id: id,
        nome: nome,
        isAtivo: isAtivo,
        createdAt: createdAt,
      );
}
