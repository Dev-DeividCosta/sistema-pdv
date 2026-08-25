import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/list/app_grouped_list_page.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../city/domain/entities/city.dart';
import '../../../city/presentation/pages/city_form_page.dart';
import '../../../city/presentation/providers/city_form_provider.dart';
import 'itinerary_planning_page.dart';

class ItineraryCitiesPage extends ConsumerWidget {
  const ItineraryCitiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final citiesAsync = ref.watch(citiesStreamProvider).whenData(
          (cities) => cities.where((c) => c.isAtivo).toList(),
        );

    return AppGroupedListPage<CityEntity>(
      title: 'Roteiro de Viagem',
      appBarColor: AppMenuColors.itinerary,
      searchHint: 'Buscar por nome ou estado...',
      emptyMessage: 'Nenhuma cidade cadastrada para o roteiro.',
      noResultsMessage: 'Nenhuma cidade encontrada para',
      loadingErrorLabel: 'Erro ao carregar cidades',
      itemsAsync: citiesAsync,
      actionLabel: 'Cidade',
      actionBackgroundColor: AppMenuColors.city,
      searchFields: (city) => [city.nome, city.estado],
      groupKey: (city) => city.nome.isNotEmpty ? city.nome[0].toUpperCase() : '',
      onAdd: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CityFormPage()),
      ),
      itemBuilder: (context, city, index, totalItems) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ItineraryPlanningPage(
                cityId: city.id,
                cityName: city.nome,
              ),
            ),
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