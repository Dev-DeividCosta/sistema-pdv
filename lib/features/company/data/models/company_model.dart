import '../../domain/entities/company.dart';

class CompanyModel {
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

  const CompanyModel({
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

  factory CompanyModel.fromRow(Map<String, dynamic> row) {
    return CompanyModel(
      id: row['id'] as String,
      razaoSocial: row['razao_social'] as String,
      nomeFantasia: row['nome_fantasia'] as String?,
      cnpj: row['cnpj'] as String?,
      telefone: row['telefone'] as String?,
      email: row['email'] as String?,
      endereco: row['endereco'] as String?,
      numero: row['numero'] as String?,
      complemento: row['complemento'] as String?,
      bairro: row['bairro'] as String?,
      cidade: row['cidade'] as String?,
      uf: row['uf'] as String?,
      cep: row['cep'] as String?,
      isAtivo: (row['is_ativo'] as int? ?? 1) == 1,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  factory CompanyModel.fromEntity(CompanyEntity entity) => CompanyModel(
    id: entity.id,
    razaoSocial: entity.razaoSocial,
    nomeFantasia: entity.nomeFantasia,
    cnpj: entity.cnpj,
    telefone: entity.telefone,
    email: entity.email,
    endereco: entity.endereco,
    numero: entity.numero,
    complemento: entity.complemento,
    bairro: entity.bairro,
    cidade: entity.cidade,
    uf: entity.uf,
    cep: entity.cep,
    isAtivo: entity.isAtivo,
    createdAt: entity.createdAt,
  );

  CompanyEntity toEntity() => CompanyEntity(
    id: id,
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
    createdAt: createdAt,
  );
}
