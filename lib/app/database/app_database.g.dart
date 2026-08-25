// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _apelidoMeta =
      const VerificationMeta('apelido');
  @override
  late final GeneratedColumn<String> apelido = GeneratedColumn<String>(
      'apelido', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cpfMeta = const VerificationMeta('cpf');
  @override
  late final GeneratedColumn<String> cpf = GeneratedColumn<String>(
      'cpf', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ruaMeta = const VerificationMeta('rua');
  @override
  late final GeneratedColumn<String> rua = GeneratedColumn<String>(
      'rua', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<String> numero = GeneratedColumn<String>(
      'numero', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _complementoMeta =
      const VerificationMeta('complemento');
  @override
  late final GeneratedColumn<String> complemento = GeneratedColumn<String>(
      'complemento', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bairroMeta = const VerificationMeta('bairro');
  @override
  late final GeneratedColumn<String> bairro = GeneratedColumn<String>(
      'bairro', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<String> cityId = GeneratedColumn<String>(
      'city_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _ufMeta = const VerificationMeta('uf');
  @override
  late final GeneratedColumn<String> uf = GeneratedColumn<String>(
      'uf', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cepMeta = const VerificationMeta('cep');
  @override
  late final GeneratedColumn<String> cep = GeneratedColumn<String>(
      'cep', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telefoneFixoMeta =
      const VerificationMeta('telefoneFixo');
  @override
  late final GeneratedColumn<String> telefoneFixo = GeneratedColumn<String>(
      'telefone_fixo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _celularMeta =
      const VerificationMeta('celular');
  @override
  late final GeneratedColumn<String> celular = GeneratedColumn<String>(
      'celular', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _observacoesMeta =
      const VerificationMeta('observacoes');
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
      'observacoes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isAtivoMeta =
      const VerificationMeta('isAtivo');
  @override
  late final GeneratedColumn<bool> isAtivo = GeneratedColumn<bool>(
      'is_ativo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_ativo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        nome,
        apelido,
        cpf,
        rua,
        numero,
        complemento,
        bairro,
        cityId,
        uf,
        cep,
        telefoneFixo,
        celular,
        email,
        observacoes,
        isAtivo,
        isDeleted,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('apelido')) {
      context.handle(_apelidoMeta,
          apelido.isAcceptableOrUnknown(data['apelido']!, _apelidoMeta));
    }
    if (data.containsKey('cpf')) {
      context.handle(
          _cpfMeta, cpf.isAcceptableOrUnknown(data['cpf']!, _cpfMeta));
    }
    if (data.containsKey('rua')) {
      context.handle(
          _ruaMeta, rua.isAcceptableOrUnknown(data['rua']!, _ruaMeta));
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    }
    if (data.containsKey('complemento')) {
      context.handle(
          _complementoMeta,
          complemento.isAcceptableOrUnknown(
              data['complemento']!, _complementoMeta));
    }
    if (data.containsKey('bairro')) {
      context.handle(_bairroMeta,
          bairro.isAcceptableOrUnknown(data['bairro']!, _bairroMeta));
    }
    if (data.containsKey('city_id')) {
      context.handle(_cityIdMeta,
          cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta));
    }
    if (data.containsKey('uf')) {
      context.handle(_ufMeta, uf.isAcceptableOrUnknown(data['uf']!, _ufMeta));
    }
    if (data.containsKey('cep')) {
      context.handle(
          _cepMeta, cep.isAcceptableOrUnknown(data['cep']!, _cepMeta));
    }
    if (data.containsKey('telefone_fixo')) {
      context.handle(
          _telefoneFixoMeta,
          telefoneFixo.isAcceptableOrUnknown(
              data['telefone_fixo']!, _telefoneFixoMeta));
    }
    if (data.containsKey('celular')) {
      context.handle(_celularMeta,
          celular.isAcceptableOrUnknown(data['celular']!, _celularMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('observacoes')) {
      context.handle(
          _observacoesMeta,
          observacoes.isAcceptableOrUnknown(
              data['observacoes']!, _observacoesMeta));
    }
    if (data.containsKey('is_ativo')) {
      context.handle(_isAtivoMeta,
          isAtivo.isAcceptableOrUnknown(data['is_ativo']!, _isAtivoMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      apelido: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}apelido']),
      cpf: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cpf']),
      rua: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rua']),
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}numero']),
      complemento: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}complemento']),
      bairro: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bairro']),
      cityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city_id']),
      uf: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uf']),
      cep: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cep']),
      telefoneFixo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefone_fixo']),
      celular: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}celular']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      observacoes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observacoes']),
      isAtivo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_ativo'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
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
  final bool isDeleted;
  final DateTime createdAt;
  const Customer(
      {required this.id,
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
      required this.isDeleted,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    if (!nullToAbsent || apelido != null) {
      map['apelido'] = Variable<String>(apelido);
    }
    if (!nullToAbsent || cpf != null) {
      map['cpf'] = Variable<String>(cpf);
    }
    if (!nullToAbsent || rua != null) {
      map['rua'] = Variable<String>(rua);
    }
    if (!nullToAbsent || numero != null) {
      map['numero'] = Variable<String>(numero);
    }
    if (!nullToAbsent || complemento != null) {
      map['complemento'] = Variable<String>(complemento);
    }
    if (!nullToAbsent || bairro != null) {
      map['bairro'] = Variable<String>(bairro);
    }
    if (!nullToAbsent || cityId != null) {
      map['city_id'] = Variable<String>(cityId);
    }
    if (!nullToAbsent || uf != null) {
      map['uf'] = Variable<String>(uf);
    }
    if (!nullToAbsent || cep != null) {
      map['cep'] = Variable<String>(cep);
    }
    if (!nullToAbsent || telefoneFixo != null) {
      map['telefone_fixo'] = Variable<String>(telefoneFixo);
    }
    if (!nullToAbsent || celular != null) {
      map['celular'] = Variable<String>(celular);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['is_ativo'] = Variable<bool>(isAtivo);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      nome: Value(nome),
      apelido: apelido == null && nullToAbsent
          ? const Value.absent()
          : Value(apelido),
      cpf: cpf == null && nullToAbsent ? const Value.absent() : Value(cpf),
      rua: rua == null && nullToAbsent ? const Value.absent() : Value(rua),
      numero:
          numero == null && nullToAbsent ? const Value.absent() : Value(numero),
      complemento: complemento == null && nullToAbsent
          ? const Value.absent()
          : Value(complemento),
      bairro:
          bairro == null && nullToAbsent ? const Value.absent() : Value(bairro),
      cityId:
          cityId == null && nullToAbsent ? const Value.absent() : Value(cityId),
      uf: uf == null && nullToAbsent ? const Value.absent() : Value(uf),
      cep: cep == null && nullToAbsent ? const Value.absent() : Value(cep),
      telefoneFixo: telefoneFixo == null && nullToAbsent
          ? const Value.absent()
          : Value(telefoneFixo),
      celular: celular == null && nullToAbsent
          ? const Value.absent()
          : Value(celular),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      isAtivo: Value(isAtivo),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      apelido: serializer.fromJson<String?>(json['apelido']),
      cpf: serializer.fromJson<String?>(json['cpf']),
      rua: serializer.fromJson<String?>(json['rua']),
      numero: serializer.fromJson<String?>(json['numero']),
      complemento: serializer.fromJson<String?>(json['complemento']),
      bairro: serializer.fromJson<String?>(json['bairro']),
      cityId: serializer.fromJson<String?>(json['cityId']),
      uf: serializer.fromJson<String?>(json['uf']),
      cep: serializer.fromJson<String?>(json['cep']),
      telefoneFixo: serializer.fromJson<String?>(json['telefoneFixo']),
      celular: serializer.fromJson<String?>(json['celular']),
      email: serializer.fromJson<String?>(json['email']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      isAtivo: serializer.fromJson<bool>(json['isAtivo']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'apelido': serializer.toJson<String?>(apelido),
      'cpf': serializer.toJson<String?>(cpf),
      'rua': serializer.toJson<String?>(rua),
      'numero': serializer.toJson<String?>(numero),
      'complemento': serializer.toJson<String?>(complemento),
      'bairro': serializer.toJson<String?>(bairro),
      'cityId': serializer.toJson<String?>(cityId),
      'uf': serializer.toJson<String?>(uf),
      'cep': serializer.toJson<String?>(cep),
      'telefoneFixo': serializer.toJson<String?>(telefoneFixo),
      'celular': serializer.toJson<String?>(celular),
      'email': serializer.toJson<String?>(email),
      'observacoes': serializer.toJson<String?>(observacoes),
      'isAtivo': serializer.toJson<bool>(isAtivo),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Customer copyWith(
          {String? id,
          String? nome,
          Value<String?> apelido = const Value.absent(),
          Value<String?> cpf = const Value.absent(),
          Value<String?> rua = const Value.absent(),
          Value<String?> numero = const Value.absent(),
          Value<String?> complemento = const Value.absent(),
          Value<String?> bairro = const Value.absent(),
          Value<String?> cityId = const Value.absent(),
          Value<String?> uf = const Value.absent(),
          Value<String?> cep = const Value.absent(),
          Value<String?> telefoneFixo = const Value.absent(),
          Value<String?> celular = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> observacoes = const Value.absent(),
          bool? isAtivo,
          bool? isDeleted,
          DateTime? createdAt}) =>
      Customer(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        apelido: apelido.present ? apelido.value : this.apelido,
        cpf: cpf.present ? cpf.value : this.cpf,
        rua: rua.present ? rua.value : this.rua,
        numero: numero.present ? numero.value : this.numero,
        complemento: complemento.present ? complemento.value : this.complemento,
        bairro: bairro.present ? bairro.value : this.bairro,
        cityId: cityId.present ? cityId.value : this.cityId,
        uf: uf.present ? uf.value : this.uf,
        cep: cep.present ? cep.value : this.cep,
        telefoneFixo:
            telefoneFixo.present ? telefoneFixo.value : this.telefoneFixo,
        celular: celular.present ? celular.value : this.celular,
        email: email.present ? email.value : this.email,
        observacoes: observacoes.present ? observacoes.value : this.observacoes,
        isAtivo: isAtivo ?? this.isAtivo,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('apelido: $apelido, ')
          ..write('cpf: $cpf, ')
          ..write('rua: $rua, ')
          ..write('numero: $numero, ')
          ..write('complemento: $complemento, ')
          ..write('bairro: $bairro, ')
          ..write('cityId: $cityId, ')
          ..write('uf: $uf, ')
          ..write('cep: $cep, ')
          ..write('telefoneFixo: $telefoneFixo, ')
          ..write('celular: $celular, ')
          ..write('email: $email, ')
          ..write('observacoes: $observacoes, ')
          ..write('isAtivo: $isAtivo, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      nome,
      apelido,
      cpf,
      rua,
      numero,
      complemento,
      bairro,
      cityId,
      uf,
      cep,
      telefoneFixo,
      celular,
      email,
      observacoes,
      isAtivo,
      isDeleted,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.apelido == this.apelido &&
          other.cpf == this.cpf &&
          other.rua == this.rua &&
          other.numero == this.numero &&
          other.complemento == this.complemento &&
          other.bairro == this.bairro &&
          other.cityId == this.cityId &&
          other.uf == this.uf &&
          other.cep == this.cep &&
          other.telefoneFixo == this.telefoneFixo &&
          other.celular == this.celular &&
          other.email == this.email &&
          other.observacoes == this.observacoes &&
          other.isAtivo == this.isAtivo &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String?> apelido;
  final Value<String?> cpf;
  final Value<String?> rua;
  final Value<String?> numero;
  final Value<String?> complemento;
  final Value<String?> bairro;
  final Value<String?> cityId;
  final Value<String?> uf;
  final Value<String?> cep;
  final Value<String?> telefoneFixo;
  final Value<String?> celular;
  final Value<String?> email;
  final Value<String?> observacoes;
  final Value<bool> isAtivo;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.apelido = const Value.absent(),
    this.cpf = const Value.absent(),
    this.rua = const Value.absent(),
    this.numero = const Value.absent(),
    this.complemento = const Value.absent(),
    this.bairro = const Value.absent(),
    this.cityId = const Value.absent(),
    this.uf = const Value.absent(),
    this.cep = const Value.absent(),
    this.telefoneFixo = const Value.absent(),
    this.celular = const Value.absent(),
    this.email = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.isAtivo = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String nome,
    this.apelido = const Value.absent(),
    this.cpf = const Value.absent(),
    this.rua = const Value.absent(),
    this.numero = const Value.absent(),
    this.complemento = const Value.absent(),
    this.bairro = const Value.absent(),
    this.cityId = const Value.absent(),
    this.uf = const Value.absent(),
    this.cep = const Value.absent(),
    this.telefoneFixo = const Value.absent(),
    this.celular = const Value.absent(),
    this.email = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.isAtivo = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nome = Value(nome);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? apelido,
    Expression<String>? cpf,
    Expression<String>? rua,
    Expression<String>? numero,
    Expression<String>? complemento,
    Expression<String>? bairro,
    Expression<String>? cityId,
    Expression<String>? uf,
    Expression<String>? cep,
    Expression<String>? telefoneFixo,
    Expression<String>? celular,
    Expression<String>? email,
    Expression<String>? observacoes,
    Expression<bool>? isAtivo,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (apelido != null) 'apelido': apelido,
      if (cpf != null) 'cpf': cpf,
      if (rua != null) 'rua': rua,
      if (numero != null) 'numero': numero,
      if (complemento != null) 'complemento': complemento,
      if (bairro != null) 'bairro': bairro,
      if (cityId != null) 'city_id': cityId,
      if (uf != null) 'uf': uf,
      if (cep != null) 'cep': cep,
      if (telefoneFixo != null) 'telefone_fixo': telefoneFixo,
      if (celular != null) 'celular': celular,
      if (email != null) 'email': email,
      if (observacoes != null) 'observacoes': observacoes,
      if (isAtivo != null) 'is_ativo': isAtivo,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? nome,
      Value<String?>? apelido,
      Value<String?>? cpf,
      Value<String?>? rua,
      Value<String?>? numero,
      Value<String?>? complemento,
      Value<String?>? bairro,
      Value<String?>? cityId,
      Value<String?>? uf,
      Value<String?>? cep,
      Value<String?>? telefoneFixo,
      Value<String?>? celular,
      Value<String?>? email,
      Value<String?>? observacoes,
      Value<bool>? isAtivo,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CustomersCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      apelido: apelido ?? this.apelido,
      cpf: cpf ?? this.cpf,
      rua: rua ?? this.rua,
      numero: numero ?? this.numero,
      complemento: complemento ?? this.complemento,
      bairro: bairro ?? this.bairro,
      cityId: cityId ?? this.cityId,
      uf: uf ?? this.uf,
      cep: cep ?? this.cep,
      telefoneFixo: telefoneFixo ?? this.telefoneFixo,
      celular: celular ?? this.celular,
      email: email ?? this.email,
      observacoes: observacoes ?? this.observacoes,
      isAtivo: isAtivo ?? this.isAtivo,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (apelido.present) {
      map['apelido'] = Variable<String>(apelido.value);
    }
    if (cpf.present) {
      map['cpf'] = Variable<String>(cpf.value);
    }
    if (rua.present) {
      map['rua'] = Variable<String>(rua.value);
    }
    if (numero.present) {
      map['numero'] = Variable<String>(numero.value);
    }
    if (complemento.present) {
      map['complemento'] = Variable<String>(complemento.value);
    }
    if (bairro.present) {
      map['bairro'] = Variable<String>(bairro.value);
    }
    if (cityId.present) {
      map['city_id'] = Variable<String>(cityId.value);
    }
    if (uf.present) {
      map['uf'] = Variable<String>(uf.value);
    }
    if (cep.present) {
      map['cep'] = Variable<String>(cep.value);
    }
    if (telefoneFixo.present) {
      map['telefone_fixo'] = Variable<String>(telefoneFixo.value);
    }
    if (celular.present) {
      map['celular'] = Variable<String>(celular.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (isAtivo.present) {
      map['is_ativo'] = Variable<bool>(isAtivo.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('apelido: $apelido, ')
          ..write('cpf: $cpf, ')
          ..write('rua: $rua, ')
          ..write('numero: $numero, ')
          ..write('complemento: $complemento, ')
          ..write('bairro: $bairro, ')
          ..write('cityId: $cityId, ')
          ..write('uf: $uf, ')
          ..write('cep: $cep, ')
          ..write('telefoneFixo: $telefoneFixo, ')
          ..write('celular: $celular, ')
          ..write('email: $email, ')
          ..write('observacoes: $observacoes, ')
          ..write('isAtivo: $isAtivo, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitiesTable extends Cities with TableInfo<$CitiesTable, City> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  @override
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
      'estado', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isAtivoMeta =
      const VerificationMeta('isAtivo');
  @override
  late final GeneratedColumn<bool> isAtivo = GeneratedColumn<bool>(
      'is_ativo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_ativo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nome, estado, isAtivo, isDeleted, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cities';
  @override
  VerificationContext validateIntegrity(Insertable<City> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('estado')) {
      context.handle(_estadoMeta,
          estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta));
    } else if (isInserting) {
      context.missing(_estadoMeta);
    }
    if (data.containsKey('is_ativo')) {
      context.handle(_isAtivoMeta,
          isAtivo.isAcceptableOrUnknown(data['is_ativo']!, _isAtivoMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  City map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return City(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      estado: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estado'])!,
      isAtivo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_ativo'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CitiesTable createAlias(String alias) {
    return $CitiesTable(attachedDatabase, alias);
  }
}

class City extends DataClass implements Insertable<City> {
  final String id;
  final String nome;
  final String estado;
  final bool isAtivo;
  final bool isDeleted;
  final DateTime createdAt;
  const City(
      {required this.id,
      required this.nome,
      required this.estado,
      required this.isAtivo,
      required this.isDeleted,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nome'] = Variable<String>(nome);
    map['estado'] = Variable<String>(estado);
    map['is_ativo'] = Variable<bool>(isAtivo);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CitiesCompanion toCompanion(bool nullToAbsent) {
    return CitiesCompanion(
      id: Value(id),
      nome: Value(nome),
      estado: Value(estado),
      isAtivo: Value(isAtivo),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
    );
  }

  factory City.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return City(
      id: serializer.fromJson<String>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      estado: serializer.fromJson<String>(json['estado']),
      isAtivo: serializer.fromJson<bool>(json['isAtivo']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nome': serializer.toJson<String>(nome),
      'estado': serializer.toJson<String>(estado),
      'isAtivo': serializer.toJson<bool>(isAtivo),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  City copyWith(
          {String? id,
          String? nome,
          String? estado,
          bool? isAtivo,
          bool? isDeleted,
          DateTime? createdAt}) =>
      City(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        estado: estado ?? this.estado,
        isAtivo: isAtivo ?? this.isAtivo,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('City(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('estado: $estado, ')
          ..write('isAtivo: $isAtivo, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nome, estado, isAtivo, isDeleted, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is City &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.estado == this.estado &&
          other.isAtivo == this.isAtivo &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt);
}

class CitiesCompanion extends UpdateCompanion<City> {
  final Value<String> id;
  final Value<String> nome;
  final Value<String> estado;
  final Value<bool> isAtivo;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CitiesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.estado = const Value.absent(),
    this.isAtivo = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitiesCompanion.insert({
    required String id,
    required String nome,
    required String estado,
    this.isAtivo = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nome = Value(nome),
        estado = Value(estado);
  static Insertable<City> custom({
    Expression<String>? id,
    Expression<String>? nome,
    Expression<String>? estado,
    Expression<bool>? isAtivo,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (estado != null) 'estado': estado,
      if (isAtivo != null) 'is_ativo': isAtivo,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitiesCompanion copyWith(
      {Value<String>? id,
      Value<String>? nome,
      Value<String>? estado,
      Value<bool>? isAtivo,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CitiesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      estado: estado ?? this.estado,
      isAtivo: isAtivo ?? this.isAtivo,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (isAtivo.present) {
      map['is_ativo'] = Variable<bool>(isAtivo.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitiesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('estado: $estado, ')
          ..write('isAtivo: $isAtivo, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItineraryItemsTable extends ItineraryItems
    with TableInfo<$ItineraryItemsTable, ItineraryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItineraryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<String> cityId = GeneratedColumn<String>(
      'city_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _visitOrderMeta =
      const VerificationMeta('visitOrder');
  @override
  late final GeneratedColumn<int> visitOrder = GeneratedColumn<int>(
      'visit_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isVisitedMeta =
      const VerificationMeta('isVisited');
  @override
  late final GeneratedColumn<bool> isVisited = GeneratedColumn<bool>(
      'is_visited', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_visited" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, customerId, cityId, visitOrder, isVisited, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'itinerary_items';
  @override
  VerificationContext validateIntegrity(Insertable<ItineraryItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('city_id')) {
      context.handle(_cityIdMeta,
          cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta));
    } else if (isInserting) {
      context.missing(_cityIdMeta);
    }
    if (data.containsKey('visit_order')) {
      context.handle(
          _visitOrderMeta,
          visitOrder.isAcceptableOrUnknown(
              data['visit_order']!, _visitOrderMeta));
    }
    if (data.containsKey('is_visited')) {
      context.handle(_isVisitedMeta,
          isVisited.isAcceptableOrUnknown(data['is_visited']!, _isVisitedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItineraryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItineraryItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id'])!,
      cityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city_id'])!,
      visitOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}visit_order'])!,
      isVisited: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_visited'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ItineraryItemsTable createAlias(String alias) {
    return $ItineraryItemsTable(attachedDatabase, alias);
  }
}

class ItineraryItem extends DataClass implements Insertable<ItineraryItem> {
  final String id;
  final String userId;
  final String customerId;
  final String cityId;
  final int visitOrder;
  final bool isVisited;
  final DateTime createdAt;
  const ItineraryItem(
      {required this.id,
      required this.userId,
      required this.customerId,
      required this.cityId,
      required this.visitOrder,
      required this.isVisited,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['customer_id'] = Variable<String>(customerId);
    map['city_id'] = Variable<String>(cityId);
    map['visit_order'] = Variable<int>(visitOrder);
    map['is_visited'] = Variable<bool>(isVisited);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ItineraryItemsCompanion toCompanion(bool nullToAbsent) {
    return ItineraryItemsCompanion(
      id: Value(id),
      userId: Value(userId),
      customerId: Value(customerId),
      cityId: Value(cityId),
      visitOrder: Value(visitOrder),
      isVisited: Value(isVisited),
      createdAt: Value(createdAt),
    );
  }

  factory ItineraryItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItineraryItem(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      cityId: serializer.fromJson<String>(json['cityId']),
      visitOrder: serializer.fromJson<int>(json['visitOrder']),
      isVisited: serializer.fromJson<bool>(json['isVisited']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'customerId': serializer.toJson<String>(customerId),
      'cityId': serializer.toJson<String>(cityId),
      'visitOrder': serializer.toJson<int>(visitOrder),
      'isVisited': serializer.toJson<bool>(isVisited),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ItineraryItem copyWith(
          {String? id,
          String? userId,
          String? customerId,
          String? cityId,
          int? visitOrder,
          bool? isVisited,
          DateTime? createdAt}) =>
      ItineraryItem(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        customerId: customerId ?? this.customerId,
        cityId: cityId ?? this.cityId,
        visitOrder: visitOrder ?? this.visitOrder,
        isVisited: isVisited ?? this.isVisited,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('ItineraryItem(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('customerId: $customerId, ')
          ..write('cityId: $cityId, ')
          ..write('visitOrder: $visitOrder, ')
          ..write('isVisited: $isVisited, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, customerId, cityId, visitOrder, isVisited, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItineraryItem &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.customerId == this.customerId &&
          other.cityId == this.cityId &&
          other.visitOrder == this.visitOrder &&
          other.isVisited == this.isVisited &&
          other.createdAt == this.createdAt);
}

class ItineraryItemsCompanion extends UpdateCompanion<ItineraryItem> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> customerId;
  final Value<String> cityId;
  final Value<int> visitOrder;
  final Value<bool> isVisited;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ItineraryItemsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.cityId = const Value.absent(),
    this.visitOrder = const Value.absent(),
    this.isVisited = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItineraryItemsCompanion.insert({
    required String id,
    required String userId,
    required String customerId,
    required String cityId,
    this.visitOrder = const Value.absent(),
    this.isVisited = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        customerId = Value(customerId),
        cityId = Value(cityId);
  static Insertable<ItineraryItem> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? customerId,
    Expression<String>? cityId,
    Expression<int>? visitOrder,
    Expression<bool>? isVisited,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (customerId != null) 'customer_id': customerId,
      if (cityId != null) 'city_id': cityId,
      if (visitOrder != null) 'visit_order': visitOrder,
      if (isVisited != null) 'is_visited': isVisited,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItineraryItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? customerId,
      Value<String>? cityId,
      Value<int>? visitOrder,
      Value<bool>? isVisited,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ItineraryItemsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      customerId: customerId ?? this.customerId,
      cityId: cityId ?? this.cityId,
      visitOrder: visitOrder ?? this.visitOrder,
      isVisited: isVisited ?? this.isVisited,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (cityId.present) {
      map['city_id'] = Variable<String>(cityId.value);
    }
    if (visitOrder.present) {
      map['visit_order'] = Variable<int>(visitOrder.value);
    }
    if (isVisited.present) {
      map['is_visited'] = Variable<bool>(isVisited.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItineraryItemsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('customerId: $customerId, ')
          ..write('cityId: $cityId, ')
          ..write('visitOrder: $visitOrder, ')
          ..write('isVisited: $isVisited, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $CitiesTable cities = $CitiesTable(this);
  late final $ItineraryItemsTable itineraryItems = $ItineraryItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [customers, cities, itineraryItems];
}
