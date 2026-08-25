import 'package:flutter/material.dart';
import '../../../../core/widgets/cards/app_customer_card.dart';
import '../../domain/entities/itinerary_item.dart';
import 'status_tag.dart';

class ItineraryUserTile extends StatelessWidget {
  final int index;
  final ItineraryItemEntity item;
  final VoidCallback onToggleVisited;
  final VoidCallback onConfirmNew;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback? onCardTap;

  const ItineraryUserTile({
    super.key,
    required this.index,
    required this.item,
    required this.onToggleVisited,
    required this.onConfirmNew,
    this.onMoveUp,
    this.onMoveDown,
    this.onCardTap,
  });

  /// Reaproveitando a mesma lógica de formatação de CPF da página de clientes.
  String _formatCpf(String? cpf) {
    if (cpf == null || cpf.trim().isEmpty) return 'Não informado';
    final clean = cpf.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 11) {
      return '${clean.substring(0, 3)}.${clean.substring(3, 6)}.${clean.substring(6, 9)}-${clean.substring(9)}';
    }
    return cpf;
  }

  @override
  Widget build(BuildContext context) {
    final customer = item.customer;
    final isVisited = item.isVisited;
    final isNew = item.isNew;

    // Resolução do telefone
    final phone = customer.celular?.isNotEmpty == true 
        ? customer.celular! 
        : (customer.telefoneFixo?.isNotEmpty == true ? customer.telefoneFixo! : 'Não informado');

    // Resolução do nome/apelido
    final displayName = customer.apelido != null && customer.apelido!.isNotEmpty 
        ? '${customer.nome} (${customer.apelido})'
        : customer.nome;

    final textOpacity = isVisited ? 0.4 : 1.0;

    return AppCustomerCard(
      name: displayName,
      cpf: _formatCpf(customer.cpf),
      phone: phone,
      isVisited: isVisited,
      isNew: isNew,
      onTap: onCardTap,
      
      // -- TAGS SUPERIORES --
      topTags: [
        if (isNew) ...[
          Tooltip(
            message: 'Confirmar posição na lista',
            child: StatusTag(
              text: 'Novo',
              color: const Color(0xFFE2B93B),
              icon: Icons.check,
              onTap: onConfirmNew,
            ),
          ),
          const SizedBox(width: 6),
        ],
        if (isVisited)
          const StatusTag(
            text: 'Visitado',
            color: Color(0xFF86C5A6),
          ),
      ],
      
      // -- ESQUERDA (Botão de check + Ordem numérica) --
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onToggleVisited,
            tooltip: isVisited ? 'Desmarcar como visitado' : 'Marcar como visitado',
            icon: Icon(
              isVisited ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isVisited ? const Color(0xFF86C5A6) : Colors.grey.shade600,
              size: 28,
            ),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
          SizedBox(
            width: 22,
            child: Text(
              isNew ? '#' : (index + 1).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: (isNew ? const Color(0xFFE2B93B) : const Color(0xFF86C5A6)).withValues(alpha: textOpacity),
                fontSize: isNew ? 18 : 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      
      // -- DIREITA (Botões de ordenação Up/Down) --
      // O AppCustomerCard já possui o `showChevron` nativo antes do trailing
      trailing: Opacity(
        opacity: textOpacity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onMoveUp,
              icon: const Icon(Icons.keyboard_arrow_up),
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              color: const Color(0xFF86C5A6),
              disabledColor: Colors.grey.shade800,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 4),
            IconButton(
              onPressed: onMoveDown,
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              color: const Color(0xFF86C5A6),
              disabledColor: Colors.grey.shade800,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}