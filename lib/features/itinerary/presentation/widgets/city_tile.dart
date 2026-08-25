import 'package:flutter/material.dart';
import '../pages/itinerary_planning_page.dart';

class CityTile extends StatelessWidget {
  final String cityId;
  final String cityUf;
  final int index;
  final int totalItems;

  const CityTile({
    super.key,
    required this.cityId,
    required this.cityUf,
    required this.index,
    required this.totalItems,
  });

  BorderRadius _getBorderRadius(int index, int totalItems) {
    if (totalItems == 1) {
      return BorderRadius.circular(12);
    } else if (index == 0) {
      return const BorderRadius.vertical(top: Radius.circular(12));
    } else if (index == totalItems - 1) {
      return const BorderRadius.vertical(bottom: Radius.circular(12));
    } else {
      return BorderRadius.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItineraryPlanningPage(
                  cityId: cityId,
                  cityName: cityUf,
                ),
              ),
            );
          },
          borderRadius: _getBorderRadius(index, totalItems),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0, 
              vertical: 18.0, 
            ),
            child: Text(
              cityUf,
              style: const TextStyle(
                color: Color(0xFFE2E2E2),
                fontSize: 16,
              ),
            ),
          ),
        ),
        
        if (index < totalItems - 1)
          const Divider(
            color: Color(0xFF242424),
            height: 1,
            thickness: 1,
          ),
      ],
    );
  }
}