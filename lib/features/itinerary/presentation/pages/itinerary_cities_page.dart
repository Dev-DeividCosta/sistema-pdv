import 'package:flutter/material.dart';
import '../../data/mock_itineraries.dart';
import '../widgets/city_group_card.dart';

class ItineraryCitiesPage extends StatelessWidget {
  const ItineraryCitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      
      appBar: AppBar(
        title: const Text('Roteiro de Viagem'),
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        centerTitle: true,
      ),
      
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: mockedItineraries.entries.map((group) {
                  return CityGroupCard(
                    letter: group.key,
                    cities: group.value,
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}