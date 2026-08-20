import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';

/// Instância única do banco da aplicação, sobrescrita no ProviderScope do main.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw StateError('appDatabaseProvider não foi configurado no ProviderScope.');
});
