import 'package:uuid/uuid.dart';

class CityEntity {
  final String id;
  final String nome;
  final String estado;
  final bool isAtivo;
  final DateTime? createdAt;

  const CityEntity({
    required this.id,
    required this.nome,
    required this.estado,
    required this.isAtivo,
    this.createdAt,
  });

  factory CityEntity.createNew({
    required String nome,
    required String estado,
    bool isAtivo = true,
  }) => CityEntity(
        id: const Uuid().v4(),
        nome: nome,
        estado: estado,
        isAtivo: isAtivo,
        createdAt: DateTime.now().toUtc(),
      );

  CityEntity copyWith({
    String? id,
    String? nome,
    String? estado,
    bool? isAtivo,
    DateTime? createdAt,
  }) => CityEntity(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        estado: estado ?? this.estado,
        isAtivo: isAtivo ?? this.isAtivo,
        createdAt: createdAt ?? this.createdAt,
      );
}
