import '../../../../app/database/app_database.dart' as db;
import '../../domain/entities/customer.dart';

extension CustomerModelMapper on db.Customer {
  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id,
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
      createdAt: createdAt,
    );
  }
}