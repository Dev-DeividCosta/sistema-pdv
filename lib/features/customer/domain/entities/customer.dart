import 'package:uuid/uuid.dart';

const _undefined = Object();

class CustomerEntity {
  final String id;
  final String nome;
  final String? apelido;
  final String? cpf;
  final String? rua;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cityId;
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
    this.cpf,
    this.rua,
    this.numero,
    this.complemento,
    this.bairro,
    this.cityId,
    this.uf,
    this.cep,
    this.telefoneFixo,
    this.celular,
    this.email,
    this.observacoes,
    required this.isAtivo,
    required this.createdAt,
  });

  factory CustomerEntity.createNew({
    required String nome,
    String? apelido,
    String? cpf,
    String? rua,
    String? numero,
    String? complemento,
    String? bairro,
    String? cityId,
    String? uf,
    String? cep,
    String? telefoneFixo,
    String? celular,
    String? email,
    String? observacoes,
    required bool isAtivo,
  }) => CustomerEntity(
        id: const Uuid().v4(),
        nome: nome,
        apelido: apelido,
        cpf: cpf,
        rua: rua,
        numero: numero,
        complemento: complemento,
        bairro: bairro,
        cityId: cityId,
        uf: uf,
        cep: cep,
        telefoneFixo: telefoneFixo,
        celular: celular,
        email: email,
        observacoes: observacoes,
        isAtivo: isAtivo,
        createdAt: DateTime.now().toUtc(),
      );

  CustomerEntity copyWith({
    String? id,
    String? nome,
    Object? apelido = _undefined,
    Object? cpf = _undefined,
    Object? rua = _undefined,
    Object? numero = _undefined,
    Object? complemento = _undefined,
    Object? bairro = _undefined,
    Object? cityId = _undefined,
    Object? uf = _undefined,
    Object? cep = _undefined,
    Object? telefoneFixo = _undefined,
    Object? celular = _undefined,
    Object? email = _undefined,
    Object? observacoes = _undefined,
    bool? isAtivo,
    DateTime? createdAt,
  }) => CustomerEntity(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        apelido: apelido == _undefined ? this.apelido : apelido as String?,
        cpf: cpf == _undefined ? this.cpf : cpf as String?,
        rua: rua == _undefined ? this.rua : rua as String?,
        numero: numero == _undefined ? this.numero : numero as String?,
        complemento: complemento == _undefined ? this.complemento : complemento as String?,
        bairro: bairro == _undefined ? this.bairro : bairro as String?,
        cityId: cityId == _undefined ? this.cityId : cityId as String?,
        uf: uf == _undefined ? this.uf : uf as String?,
        cep: cep == _undefined ? this.cep : cep as String?,
        telefoneFixo: telefoneFixo == _undefined ? this.telefoneFixo : telefoneFixo as String?,
        celular: celular == _undefined ? this.celular : celular as String?,
        email: email == _undefined ? this.email : email as String?,
        observacoes: observacoes == _undefined ? this.observacoes : observacoes as String?,
        isAtivo: isAtivo ?? this.isAtivo,
        createdAt: createdAt ?? this.createdAt,
      );
}
