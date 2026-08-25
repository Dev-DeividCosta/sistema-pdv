import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/itinerary_progress_header.dart';
import '../widgets/itinerary_user_tile.dart';
import '../../../customer/presentation/pages/customer_form_page.dart';
import '../../../customer/presentation/pages/customer_hub_page.dart';
import '../../../../core/widgets/forms/form_mode.dart';
import '../../../../core/widgets/navigation/app_app_bar.dart';
import '../../../../core/widgets/navigation/app_navigation_bar.dart';
import '../providers/itinerary_provider.dart';
import '../../domain/entities/itinerary_item.dart';

class ItineraryPlanningPage extends ConsumerStatefulWidget {
  final String cityId;
  final String cityName;

  const ItineraryPlanningPage({
    super.key, 
    required this.cityId, 
    required this.cityName,
  });

  @override
  ConsumerState<ItineraryPlanningPage> createState() => _ItineraryPlanningPageState();
}

class _ItineraryPlanningPageState extends ConsumerState<ItineraryPlanningPage> {

  void _confirmResetVisits(List<ItineraryItemEntity> items) {
    final visitedCount = items.where((u) => u.isVisited).length;
    if (visitedCount == 0) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF262626),
        title: const Text(
          'Desmarcar todos?',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: Text(
          'Você vai voltar os $visitedCount clientes visitados para a lista de pendentes.',
          style: const TextStyle(color: Color(0xFFA0A0A0)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE2B93B),
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref.read(itineraryNotifierProvider.notifier).resetAllVisits(widget.cityId);
                if (!mounted) return;
                ref.invalidate(itineraryListProvider(widget.cityId));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todos os clientes foram desmarcados!'),
                    backgroundColor: Color(0xFF86C5A6),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (_) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Não foi possível desmarcar os clientes.'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Desmarcar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _addNewClient() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CustomerFormPage(mode: AppFormMode.create), 
      ),
    );
  }

  Future<void> _toggleVisited(ItineraryItemEntity item) async {
    await ref.read(itineraryNotifierProvider.notifier).toggleVisited(item, widget.cityId);
    if (mounted) ref.invalidate(itineraryListProvider(widget.cityId));
  }

  Future<void> _confirmNew(ItineraryItemEntity item, int index) async {
    await ref.read(itineraryNotifierProvider.notifier).confirmNewUser(item, widget.cityId, index);
    if (mounted) ref.invalidate(itineraryListProvider(widget.cityId));
  }

  Future<void> _moveUp(int index, List<ItineraryItemEntity> currentList) async {
    if (index <= 0) return;
    final newList = List<ItineraryItemEntity>.from(currentList);
    final item = newList.removeAt(index);
    newList.insert(index - 1, item);
    await ref.read(itineraryNotifierProvider.notifier).updateFullListOrder(newList, widget.cityId);
    if (mounted) ref.invalidate(itineraryListProvider(widget.cityId));
  }

  Future<void> _moveDown(int index, List<ItineraryItemEntity> currentList) async {
    if (index >= currentList.length - 1) return;
    final newList = List<ItineraryItemEntity>.from(currentList);
    final item = newList.removeAt(index);
    newList.insert(index + 1, item);
    await ref.read(itineraryNotifierProvider.notifier).updateFullListOrder(newList, widget.cityId);
    if (mounted) ref.invalidate(itineraryListProvider(widget.cityId));
  }

  @override
  Widget build(BuildContext context) {
    final itineraryAsync = ref.watch(itineraryListProvider(widget.cityId));
    final isSaving = ref.watch(itineraryNotifierProvider).isLoading;

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF171717),
      appBar: AppAppBar(
        title: widget.cityName,
        backgroundColor: AppMenuColors.itinerary,
      ),
      bottomNavigationBar: AppNavigationBar(
        contextualAction: ContextualActionButton(
          icon: Icons.add,
          label: 'Cliente',
          backgroundColor: AppMenuColors.customer,
          onTap: _addNewClient,
        ),
      ),
      body: itineraryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppMenuColors.itinerary)),
        error: (err, stack) => Center(child: Text('Erro: $err', style: const TextStyle(color: Colors.white))),
        data: (items) {
          final visitedCount = items.where((u) => u.isVisited).length;
          final totalCount = items.length;

          if (items.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum cliente encontrado para esta cidade.', 
                style: TextStyle(color: Colors.grey)
              )
            );
          }

          return Column(
            children: [
              ItineraryProgressHeader(
                visitedCount: visitedCount,
                totalCount: totalCount,
                onReset: isSaving ? null : () => _confirmResetVisits(items),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 110.0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: ItineraryUserTile(
                          key: ValueKey(item.customer.id),
                          index: index,
                          item: item,
                          onCardTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerHubPage(customer: item.customer),
                              ),
                            );
                          },
                          onToggleVisited: isSaving ? () {} : () => _toggleVisited(item),
                          onConfirmNew: isSaving ? () {} : () => _confirmNew(item, index),
                          onMoveUp: !isSaving && index > 0 ? () => _moveUp(index, items) : null,
                          onMoveDown: !isSaving && index < items.length - 1 ? () => _moveDown(index, items) : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}