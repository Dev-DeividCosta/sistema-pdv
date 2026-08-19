import 'package:flutter/material.dart';
import '../../../../core/models/app_menu_item.dart';
import '../../../../core/widgets/forms/form_mode.dart'; // Importe o enum de modo
import '../../domain/entities/city.dart';
import '../pages/city_form_page.dart';

abstract class CityHubMenuBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context, CityEntity city);
}

class CityHubMenuBuilderImpl implements CityHubMenuBuilder {
  const CityHubMenuBuilderImpl();

  @override
  List<AppMenuItem> getMenuItems(BuildContext context, CityEntity city) {
    return [
      AppMenuItem(
        title: 'Visualizar',
        icon: Icons.visibility,
        color: const Color(0xFFB71C1C),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CityFormPage(
                city: city,
                mode: AppFormMode.view, // Usando o AppFormMode unificado
              ),
            ),
          );
        },
      ),
      AppMenuItem(
        title: 'Editar',
        icon: Icons.edit,
        color: const Color(0xFFB71C1C),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CityFormPage(
                city: city,
                mode: AppFormMode.edit, // Usando o AppFormMode unificado
              ),
            ),
          );
        },
      ),
    ];
  }
}