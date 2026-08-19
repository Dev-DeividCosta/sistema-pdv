import '../entities/city.dart';

abstract class CityRepository {
  Stream<List<CityEntity>> watchCities();
  Future<void> saveCity(CityEntity city);
  Future<void> deleteCity(String id);
}
