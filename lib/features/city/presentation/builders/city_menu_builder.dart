import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/app_menu_item.dart';
import '../pages/city_form_page.dart';
import '../pages/city_list_page.dart';

abstract class CityMenuBuilder {
  List<AppMenuItem> getMenuItems(BuildContext context);
}

class CityMenuBuilderImpl implements CityMenuBuilder {
  const CityMenuBuilderImpl();

  @override
  List<AppMenuItem> getMenuItems(BuildContext context) {
    return [
      AppMenuItem(
        title: 'Adicionar nova cidade',
        icon: Icons.location_city,
        color: AppMenuColors.city,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CityFormPage(),
            ),
          );
        },
      ),
      AppMenuItem(
        title: 'Listar cidades cadastradas',
        icon: Icons.list_alt,
        color: AppMenuColors.city,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CityListPage(),
            ),
          );
        },
      ),
      
    ];
  }
}