import 'package:uuid/uuid.dart';

const _undefined = Object();

class CompanyEntity {
  final String id;
  final String razaoSocial;
  final String? nomeFantasia;
  final String? cnpj;
  final String? telefone;
  final String? email;
  final String? endereco;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? uf;
  final String? cep;
  final bool isAtivo;
  final DateTime createdAt;

  const CompanyEntity({
    required this.id,
    required this.razaoSocial,
    this.nomeFantasia,
    this.cnpj,
    this.telefone,
    this.email,
    this.endereco,
    this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.uf,
    this.cep,
    required this.isAtivo,
    required this.createdAt,
  });

  factory CompanyEntity.createNew({
    required String razaoSocial,
    String? nomeFantasia,
    String? cnpj,
    String? telefone,
    String? email,
    String? endereco,
    String? numero,
    String? complemento,
    String? bairro,
    String? cidade,
    String? uf,
    String? cep,
    required bool isAtivo,
  }) {
    return CompanyEntity(
      id: const Uuid().v4(),
      razaoSocial: razaoSocial,
      nomeFantasia: nomeFantasia,
      cnpj: cnpj,
      telefone: telefone,
      email: email,
      endereco: endereco,
      numero: numero,
      complemento: complemento,
      bairro: bairro,
      cidade: cidade,
      uf: uf,
      cep: cep,
      isAtivo: isAtivo,
      createdAt: DateTime.now().toUtc(),
    );
  }

  CompanyEntity copyWith({
    String? id,
    String? razaoSocial,
    Object? nomeFantasia = _undefined,
    Object? cnpj = _undefined,
    Object? telefone = _undefined,
    Object? email = _undefined,
    Object? endereco = _undefined,
    Object? numero = _undefined,
    Object? complemento = _undefined,
    Object? bairro = _undefined,
    Object? cidade = _undefined,
    Object? uf = _undefined,
    Object? cep = _undefined,
    bool? isAtivo,
    DateTime? createdAt,
  }) {
    return CompanyEntity(
      id: id ?? this.id,
      razaoSocial: razaoSocial ?? this.razaoSocial,
      nomeFantasia: nomeFantasia == _undefined ? this.nomeFantasia : nomeFantasia as String?,
      cnpj: cnpj == _undefined ? this.cnpj : cnpj as String?,
      telefone: telefone == _undefined ? this.telefone : telefone as String?,
      email: email == _undefined ? this.email : email as String?,
      endereco: endereco == _undefined ? this.endereco : endereco as String?,
      numero: numero == _undefined ? this.numero : numero as String?,
      complemento: complemento == _undefined ? this.complemento : complemento as String?,
      bairro: bairro == _undefined ? this.bairro : bairro as String?,
      cidade: cidade == _undefined ? this.cidade : cidade as String?,
      uf: uf == _undefined ? this.uf : uf as String?,
      cep: cep == _undefined ? this.cep : cep as String?,
      isAtivo: isAtivo ?? this.isAtivo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
