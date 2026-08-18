import 'package:flutter/material.dart';
import '../../data/models/user_data.dart';
import '../widgets/itinerary_progress_header.dart';
import '../widgets/itinerary_user_tile.dart';
import '../../../customer/presentation/pages/customer_form_page.dart';

class ItineraryPlanningPage extends StatefulWidget {
  final String cityName;

  const ItineraryPlanningPage({super.key, required this.cityName});

  @override
  State<ItineraryPlanningPage> createState() => _ItineraryPlanningPageState();
}

class _ItineraryPlanningPageState extends State<ItineraryPlanningPage> {
  late List<UserData> mockUsers;

  @override
  void initState() {
    super.initState();
    mockUsers = [
      UserData(name: 'Peter', cpf: '111.222.333-44', phone: '(11) 99999-1111'),
      UserData(name: 'deniseeisenlohr', cpf: '222.333.444-55', phone: '(11) 98888-2222', isVisited: true),
      UserData(name: 'freddy', cpf: '333.444.555-66', phone: '(11) 97777-3333'),
      UserData(name: 'Anna', cpf: '444.555.666-77', phone: '(11) 96666-4444'),
      UserData(name: 'Akilah', cpf: '555.666.777-88', phone: '(11) 95555-5555', isVisited: true),
      UserData(name: 'manuel', cpf: '666.777.888-99', phone: '(11) 94444-6666'),
      UserData(name: 'Peter', cpf: '111.222.333-44', phone: '(11) 99999-1111'),
      UserData(name: 'deniseeisenlohr', cpf: '222.333.444-55', phone: '(11) 98888-2222'),
      UserData(name: 'freddy', cpf: '333.444.555-66', phone: '(11) 97777-3333'),
      UserData(name: 'Anna', cpf: '444.555.666-77', phone: '(11) 96666-4444'),
    ];
  }

  void _toggleVisited(int index) {
    setState(() {
      mockUsers[index].isVisited = !mockUsers[index].isVisited;
    });
  }

  void _confirmResetVisits() {
    final visitedCount = mockUsers.where((u) => u.isVisited).length;
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
            onPressed: () {
              setState(() {
                for (var user in mockUsers) {
                  user.isVisited = false;
                }
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Todos os clientes foram desmarcados!'),
                  backgroundColor: Color(0xFF86C5A6),
                  behavior: SnackBarBehavior.floating,
                ),
              );
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
        builder: (_) => const CustomerFormPage(mode: CustomerFormMode.create),
      ),
    );
  }

  void _confirmNewUser(UserData user) {
    setState(() {
      user.isNew = false;
    });
  }

  void _moveUp(int index) {
    if (index > 0) {
      setState(() {
        final item = mockUsers.removeAt(index);
        mockUsers.insert(index - 1, item);
      });
    }
  }

  void _moveDown(int index) {
    if (index < mockUsers.length - 1) {
      setState(() {
        final item = mockUsers.removeAt(index);
        mockUsers.insert(index + 1, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visitedCount = mockUsers.where((u) => u.isVisited).length;
    final totalCount = mockUsers.length;

    return Scaffold(
      backgroundColor: const Color(0xFF171717),
      appBar: AppBar(
        title: Text(
          widget.cityName,
          style: const TextStyle(
            color: Color(0xFFEBE1CA),
            fontSize: 22,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          ItineraryProgressHeader(
            visitedCount: visitedCount,
            totalCount: totalCount,
            onReset: _confirmResetVisits,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80.0, top: 4.0),
              itemCount: mockUsers.length,
              itemBuilder: (context, index) {
                final user = mockUsers[index];
                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: ItineraryUserTile(
                      index: index,
                      user: user,
                      onToggleVisited: () => _toggleVisited(index),
                      onConfirmNew: () => _confirmNewUser(user),
                      onMoveUp: index > 0 ? () => _moveUp(index) : null,
                      onMoveDown: index < mockUsers.length - 1 ? () => _moveDown(index) : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewClient,
        label: const Text(
          'Cliente',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF86C5A6),
        foregroundColor: const Color(0xFF171717),
      ),
    );
  }
}