import 'package:flutter/material.dart';

class ItineraryProgressHeader extends StatelessWidget {
  final int visitedCount;
  final int totalCount;
  final VoidCallback? onReset;

  const ItineraryProgressHeader({
    super.key,
    required this.visitedCount,
    required this.totalCount,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isResetEnabled = visitedCount > 0;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF222222),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: const Color(0xFF333333)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progresso: $visitedCount de $totalCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: totalCount > 0 ? visitedCount / totalCount : 0,
                        backgroundColor: const Color(0xFF333333),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF86C5A6)),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: isResetEnabled ? onReset : null,
                icon: Icon(
                  Icons.clear_all_rounded,
                  size: 20,
                  color: isResetEnabled ? const Color(0xFFE2B93B) : Colors.grey.shade700,
                ),
                label: Text(
                  'Desmarcar',
                  style: TextStyle(
                    color: isResetEnabled ? const Color(0xFFE2B93B) : Colors.grey.shade700,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}