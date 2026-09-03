import '../entities/company.dart';
import '../repositories/company_repository.dart';

class SaveCompanyUseCase {
  final CompanyRepository _repository;

  SaveCompanyUseCase(this._repository);

  Future<void> call(CompanyEntity company) {
    final razaoSocial = company.razaoSocial.trim();
    if (razaoSocial.isEmpty) {
      throw ArgumentError('A razão social é obrigatória.');
    }
    return _repository.saveCompany(company.copyWith(
      razaoSocial: razaoSocial,
      nomeFantasia: _clean(company.nomeFantasia),
      cnpj: _clean(company.cnpj),
      telefone: _clean(company.telefone),
      email: _clean(company.email),
      endereco: _clean(company.endereco),
      numero: _clean(company.numero),
      complemento: _clean(company.complemento),
      bairro: _clean(company.bairro),
      cidade: _clean(company.cidade),
      uf: _clean(company.uf)?.toUpperCase(),
      cep: _clean(company.cep),
    ));
  }

  String? _clean(String? value) {
    final cleaned = value?.trim();
    return cleaned == null || cleaned.isEmpty ? null : cleaned;
  }
}
