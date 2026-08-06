import 'package:flutter/material.dart';
import '../../data/models/user_data.dart';
import 'status_tag.dart';

class ItineraryUserTile extends StatelessWidget {
  final int index;
  final UserData user;
  final VoidCallback onToggleVisited;
  final VoidCallback onConfirmNew;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  const ItineraryUserTile({
    super.key,
    required this.index,
    required this.user,
    required this.onToggleVisited,
    required this.onConfirmNew,
    this.onMoveUp,
    this.onMoveDown,
  });

  @override
  Widget build(BuildContext context) {
    final isVisited = user.isVisited;
    final cardBg = isVisited ? const Color(0xFF1A1A1A) : const Color(0xFF222222);
    final textOpacity = isVisited ? 0.4 : 1.0;
    final hasTags = user.isNew || isVisited;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: user.isNew
            ? Border.all(color: const Color(0xFFE2B93B).withValues(alpha: 0.5), width: 1.5)
            : isVisited
                ? Border.all(color: const Color(0xFF86C5A6).withValues(alpha: 0.2), width: 1)
                : null,
        boxShadow: isVisited
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Material(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Abrindo detalhes de ${user.name}...'),
                duration: const Duration(seconds: 1),
                backgroundColor: const Color(0xFF86C5A6),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 12.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onToggleVisited,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                    child: Icon(
                      isVisited ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      color: isVisited ? const Color(0xFF86C5A6) : Colors.grey.shade600,
                      size: 28,
                    ),
                  ),
                ),
                SizedBox(
                  width: 22,
                  child: Text(
                    user.isNew ? '#' : (index + 1).toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (user.isNew
                          ? const Color(0xFFE2B93B)
                          : const Color(0xFF86C5A6)).withValues(alpha: textOpacity),
                      fontSize: user.isNew ? 18 : 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Opacity(
                  opacity: textOpacity,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF323232),
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      image: DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?u=${user.name}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // LINHA 1: Tags (Fora de Opacity para manter cores vibrantes)
                      if (hasTags) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (user.isNew) ...[
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
                            if (isVisited) ...[
                              const StatusTag(
                                text: 'Visitado',
                                color: Color(0xFF86C5A6),
                              ),
                              const SizedBox(width: 6),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],

                      // LINHAS 2, 3 e 4: Dados do cliente (com a opacidade aplicada)
                      Opacity(
                        opacity: textOpacity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                decoration: isVisited ? TextDecoration.lineThrough : null,
                                decorationColor: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'CPF: ${user.cpf}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Tel: ${user.phone}',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade700,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Opacity(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}