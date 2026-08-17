import 'package:flutter/material.dart';

class AppCustomerCard extends StatelessWidget {
  final String name;
  final String cpf;
  final String phone;
  final String? avatarUrl;
  
  /// Lista de tags exibidas EM LINHA e ACIMA do nome (ex: Ativo, Visitado, Novo)
  final List<Widget>? topTags;
  
  /// Widget opcional à esquerda do Avatar (ex: Checkbox + Número do Itinerário)
  final Widget? leading;
  
  /// Widget opcional à direita (ex: Setas de ordenação up/down)
  final Widget? trailing;
  
  final VoidCallback? onTap;
  final bool isVisited;
  final bool isNew;

  const AppCustomerCard({
    super.key,
    required this.name,
    required this.cpf,
    required this.phone,
    this.avatarUrl,
    this.topTags,
    this.leading,
    this.trailing,
    this.onTap,
    this.isVisited = false,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isVisited ? const Color(0xFF1A1A1A) : const Color(0xFF222222);
    final textOpacity = isVisited ? 0.4 : 1.0;
    final hasTags = topTags != null && topTags!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: isNew
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 12.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                // 1. Leading (Checkbox/Número no itinerário, se houver)
                ?leading,

                // 2. Avatar com ContinuousRectangleBorder (design original)
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
                        image: NetworkImage(
                          avatarUrl ?? 'https://i.pravatar.cc/150?u=$name',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 3. Coluna Central: Tags Em Cima + Nome + CPF + Telefone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // LINHA DE TAGS (Acima do nome)
                      if (hasTags) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: topTags!,
                        ),
                        const SizedBox(height: 4),
                      ],

                      // DADOS DO CLIENTE
                      Opacity(
                        opacity: textOpacity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              name,
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
                              'CPF: $cpf',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Tel: $phone',
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

                // 4. Chevron e Ações Trailing (Setas de reordenação)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade700,
                  size: 18,
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 4),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}