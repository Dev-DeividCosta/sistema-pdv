import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

import '../../../../core/widgets/hub/app_entity_hub_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/city.dart';
import '../builders/city_hub_menu_builder.dart';
import '../providers/city_form_provider.dart';

class CityHubPage extends StatelessWidget {
  final CityEntity city;
  final CityHubMenuBuilder menuBuilder;

  const CityHubPage({
    super.key,
    required this.city,
    this.menuBuilder = const CityHubMenuBuilderImpl(),
  });

  @override
  Widget build(BuildContext context) {
    return AppEntityHubPage<CityEntity>(
      item: city,
            title: 'Detalhes da Cidade',
      appBarColor: AppMenuColors.city,
      itemsProvider: citiesStreamProvider,
      idOf: (item) => item.id,
      menuItemsBuilder: menuBuilder.getMenuItems,
      previewBuilder: (_, currentCity) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF262626),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    currentCity.nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StatusTag(
                  text: currentCity.isAtivo ? 'Ativo' : 'Inativo',
                  color: currentCity.isAtivo ? const Color(0xFF86C5A6) : Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Estado: ${currentCity.estado}',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
