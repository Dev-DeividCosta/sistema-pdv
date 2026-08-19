import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/city_local_datasource.dart';
import '../../data/repositories/city_repository_impl.dart';
import '../../domain/entities/city.dart';
import '../../domain/repositories/city_repository.dart';
import '../../domain/usecases/save_city_usecase.dart';
import '../../../customer/presentation/providers/customer_form_provider.dart';

final cityLocalDataSourceProvider = Provider<CityLocalDataSource>((ref) {
  return CityLocalDataSource(ref.watch(appDatabaseProvider));
});

final cityRepositoryProvider = Provider<CityRepository>((ref) {
  return CityRepositoryImpl(ref.watch(cityLocalDataSourceProvider));
});

final citiesStreamProvider = StreamProvider.autoDispose<List<CityEntity>>((ref) {
  return ref.watch(cityRepositoryProvider).watchCities();
});

final saveCityUseCaseProvider = Provider<SaveCityUseCase>((ref) {
  return SaveCityUseCase(ref.watch(cityRepositoryProvider));
});

class CityFormNotifier extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> saveCity(CityEntity city) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(saveCityUseCaseProvider)(city));
    if (!state.hasError) ref.invalidate(citiesStreamProvider);
  }
}

final cityFormProvider = AutoDisposeAsyncNotifierProvider<CityFormNotifier, void>(
  CityFormNotifier.new,
);
