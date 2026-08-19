import 'package:drift/drift.dart';
import '../../../../app/database/app_database.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/city_repository.dart';
import '../datasources/city_local_datasource.dart';
import '../models/city_model.dart';

class CityRepositoryImpl implements CityRepository {
  final CityLocalDataSource _localDataSource;

  CityRepositoryImpl(this._localDataSource);

  @override
  Stream<List<CityEntity>> watchCities() => _localDataSource
      .watchCities()
      .map((rows) => rows.map((row) => row.toEntity()).toList());

  @override
  Future<void> saveCity(CityEntity city) {
    return _localDataSource.saveCity(CitiesCompanion(
      id: Value(city.id),
      nome: Value(city.nome),
      estado: Value(city.estado),
      isAtivo: Value(city.isAtivo),
      isDeleted: const Value(false),
      createdAt: Value(city.createdAt ?? DateTime.now()),
    ));
  }

  @override
  Future<void> deleteCity(String id) => _localDataSource.deleteCity(id);
}
