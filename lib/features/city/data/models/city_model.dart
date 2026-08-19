import '../../../../app/database/app_database.dart' as db;
import '../../domain/entities/city.dart';

extension CityModelMapper on db.City {
  CityEntity toEntity() => CityEntity(
        id: id,
        nome: nome,
        estado: estado,
        isAtivo: isAtivo,
        createdAt: createdAt,
      );
}
