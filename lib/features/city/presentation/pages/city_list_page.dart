import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/list/app_grouped_list_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/entities/city.dart';
import '../providers/city_form_provider.dart';
import 'city_form_page.dart';
import 'city_hub_page.dart';

class CityListPage extends ConsumerWidget {
  const CityListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppGroupedListPage<CityEntity>(
      title: 'Lista de Cidades',
      searchHint: 'Buscar por nome ou estado...',
      emptyMessage: 'Nenhuma cidade cadastrada.',
      noResultsMessage: 'Nenhuma cidade encontrada para',
      loadingErrorLabel: 'Erro ao carregar cidades',
      itemsAsync: ref.watch(citiesStreamProvider),
      searchFields: (city) => [city.nome, city.estado],
      groupKey: (city) => city.nome,
      onAdd: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CityFormPage()),
      ),
      itemBuilder: (context, city, index, totalItems) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CityHubPage(city: city)),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: index < totalItems - 1
                    ? BorderSide(color: Colors.grey.withValues(alpha: 0.1))
                    : BorderSide.none,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Estado: ${city.estado}',
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                StatusTag(
                  text: city.isAtivo ? 'Ativo' : 'Inativo',
                  color: city.isAtivo
                      ? const Color(0xFF86C5A6)
                      : Colors.redAccent,
                ),
                const SizedBox(width: 12),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }
}
