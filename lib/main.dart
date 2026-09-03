import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:powersync/powersync.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sistema_pdv/app/database/app_database.dart';
import 'package:sistema_pdv/app/database/powersync_schema.dart';
import 'package:sistema_pdv/app/providers/app_database_provider.dart';
import 'package:sistema_pdv/features/home/presentation/builders/dashboard_menu_builder.dart';
import 'package:sistema_pdv/features/home/presentation/pages/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationSupportDirectory();
  final dbPath = join(dir.path, 'sistema_pdv.sqlite');

  final powerSyncDb = PowerSyncDatabase(
    schema: schema,
    path: dbPath,
  );
  
  await powerSyncDb.initialize();

  final bancoDeDados = createDatabase(powerSyncDb);
  await bancoDeDados.ensureSalesTables();
  await bancoDeDados.ensurePaymentMethodsTable();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(bancoDeDados),
        ],
        child: const MeuPDVApp(),
      ),
    );
  });
}

class MeuPDVApp extends StatelessWidget {
  const MeuPDVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu PDV',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.teal,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF131922),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF18202C),
          elevation: 2,
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
        bottomAppBarTheme: const BottomAppBarThemeData(
          color: Color(0xFF18202C),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF008080),
          foregroundColor: Colors.white,
        ),
      ),
      home: DashboardScreen(
        builder: DashboardBuilderImpl(),
      ),
    );
  }
}