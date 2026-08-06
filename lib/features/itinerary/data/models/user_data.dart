class UserData {
  final String name;
  final String cpf;
  final String phone;
  bool isNew;
  bool isVisited;

  UserData({
    required this.name,
    required this.cpf,
    required this.phone,
    this.isNew = false,
    this.isVisited = false,
  });
}