import 'package:uuid/uuid.dart';

class CustomerEntity {
  final String id;
  final String nome;
  final String? apelido;
  final String? rua;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? uf;
  final String? cep;
  final String? telefoneFixo;
  final String? celular;
  final String? email;
  final String? observacoes;
  final bool isAtivo;
  final DateTime createdAt;

  const CustomerEntity({
    required this.id,
    required this.nome,
    this.apelido,
    this.rua,
    this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.uf,
    this.cep,
    this.telefoneFixo,
    this.celular,
    this.email,
    this.observacoes,
    required this.isAtivo,
    required this.createdAt,
  });

  // Construtor factory prático para novos clientes (gera o ID e a data automaticamente)
  factory CustomerEntity.createNew({
    required String nome,
    String? apelido,
    String? rua,
    String? numero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? uf,
    String? cep,
    String? telefoneFixo,
    String? celular,
    String? email,
    String? observacoes,
    required bool isAtivo,
  }) {
    return CustomerEntity(
      id: const Uuid().v4(), // Necessário instalar o pacote 'uuid'
      nome: nome,
      apelido: apelido,
      rua: rua,
      numero: numero,
      complemento: complemento,
      bairro: bairro,
      cidade: cidade,
      uf: uf,
      cep: cep,
      telefoneFixo: telefoneFixo,
      celular: celular,
      email: email,
      observacoes: observacoes,
      isAtivo: isAtivo,
      createdAt: DateTime.now().toUtc(),
    );
  }

  CustomerEntity copyWith({
    String? id,
    String? nome,
    String? apelido,
    String? rua,
    String? numero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? uf,
    String? cep,
    String? telefoneFixo,
    String? celular,
    String? email,
    String? observacoes,
    bool? isAtivo,
    DateTime? createdAt,
  }) {
    return CustomerEntity(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      apelido: apelido ?? this.apelido,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cidade: cidade ?? this.cidade,
      uf: uf ?? this.uf,
      cep: cep ?? this.cep,
      telefoneFixo: telefoneFixo ?? this.telefoneFixo,
      celular: celular ?? this.celular,
      email: email ?? this.email,
      observacoes: observacoes ?? this.observacoes,
      isAtivo: isAtivo ?? this.isAtivo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}