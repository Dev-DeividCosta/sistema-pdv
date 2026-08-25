import 'package:flutter/material.dart';

String _customerAvatarInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
}

class _AvatarInitials extends StatelessWidget {
  final String name;

  const _AvatarInitials({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF323232),
      alignment: Alignment.center,
      child: Text(
        _customerAvatarInitials(name),
        style: const TextStyle(
          color: Color(0xFF86C5A6),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AppCustomerCard extends StatelessWidget {
  final String name;
  final String cpf;
  final String phone;
  final String? avatarUrl;
  
  final List<Widget>? topTags;
  
  final Widget? leading;
  
  final Widget? trailing;
  
  final VoidCallback? onTap;
  final bool isVisited;
  final bool isNew;
  final bool showChevron;

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
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isVisited ? const Color(0xFF1A1A1A) : const Color(0xFF222222);
    final textOpacity = isVisited ? 0.4 : 1.0;
    final hasTags = topTags != null && topTags!.isNotEmpty;
    final normalizedAvatarUrl = avatarUrl?.trim();
    final resolvedAvatarUrl = normalizedAvatarUrl != null && normalizedAvatarUrl.isNotEmpty
        ? normalizedAvatarUrl
        : 'https://i.pravatar.cc/150?u=${Uri.encodeComponent(name)}';

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
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 8),
                ],

                Opacity(
                  opacity: textOpacity,
                  child: ClipOval(
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: Image.network(
                        resolvedAvatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _AvatarInitials(name: name),
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
                      if (hasTags) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: topTags!,
                        ),
                        const SizedBox(height: 4),
                      ],

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

                if (showChevron) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade700,
                    size: 18,
                  ),
                ],
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