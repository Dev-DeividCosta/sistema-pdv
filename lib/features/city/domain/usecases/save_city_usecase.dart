import '../entities/city.dart';
import '../repositories/city_repository.dart';

class SaveCityUseCase {
  final CityRepository _repository;

  SaveCityUseCase(this._repository);

  Future<void> call(CityEntity city) {
    final nome = city.nome.trim();
    final estado = city.estado.trim();
    if (nome.isEmpty) throw Exception('O nome da cidade é obrigatório.');
    if (estado.isEmpty) throw Exception('O estado é obrigatório.');
    return _repository.saveCity(city.copyWith(nome: nome, estado: estado));
  }
}
