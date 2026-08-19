import 'package:drift/drift.dart';
import '../../../../app/database/app_database.dart';

class CityLocalDataSource {
  final AppDatabase _db;

  CityLocalDataSource(this._db);

  Stream<List<City>> watchCities() {
    return (_db.select(_db.cities)
          ..where((table) => table.isDeleted.equals(false))
          ..orderBy([(table) => OrderingTerm(expression: table.nome)]))
        .watch();
  }

  Future<void> saveCity(CitiesCompanion city) async {
    await _db.into(_db.cities).insert(city, mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteCity(String id) async {
    await (_db.update(_db.cities)..where((table) => table.id.equals(id))).write(
      const CitiesCompanion(isDeleted: Value(true)),
    );
  }
}
