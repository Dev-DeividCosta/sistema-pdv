import 'package:flutter/material.dart';
import 'city_tile.dart';

class CityGroupCard extends StatelessWidget {
  final String letter;
  final List<String> cities;

  const CityGroupCard({
    super.key,
    required this.letter,
    required this.cities,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              letter,
              style: const TextStyle(
                color: Color(0xFFA0A0A0),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF323232),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: cities.asMap().entries.map((entry) {
                return CityTile(
                  cityUf: entry.value,
                  index: entry.key,
                  totalItems: cities.length,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}