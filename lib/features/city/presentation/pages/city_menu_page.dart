import 'package:flutter/material.dart';
import '../../../../core/widgets/menu/base_menu_page.dart';
import '../builders/city_menu_builder.dart';

class CityMenuPage extends StatelessWidget {
  final CityMenuBuilder menuBuilder;

  const CityMenuPage({
    super.key,
    this.menuBuilder = const CityMenuBuilderImpl(),
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = menuBuilder.getMenuItems(context);

    return BaseMenuPage(
      title: 'Menu de Cidades',
      items: menuItems,
    );
  }
}