class CpfValidator {
  static bool isValid(String? cpf) {
    if (cpf == null || cpf.trim().isEmpty) return false;

    final cleanCpf = cpf.replaceAll(RegExp(r'\D'), '');

    if (cleanCpf.length != 11) return false;
    
    if (RegExp(r'^(\d)\1*$').hasMatch(cleanCpf)) return false;

    List<int> numbers = cleanCpf.split('').map((String d) => int.parse(d)).toList();

    int sum1 = 0;
    for (int i = 0; i < 9; i++) {
      sum1 += numbers[i] * (10 - i);
    }
    int digit1 = 11 - (sum1 % 11);
    if (digit1 >= 10) digit1 = 0;

    int sum2 = 0;
    for (int i = 0; i < 10; i++) {
      sum2 += numbers[i] * (11 - i);
    }
    int digit2 = 11 - (sum2 % 11);
    if (digit2 >= 10) digit2 = 0;

    return numbers[9] == digit1 && numbers[10] == digit2;
  }
}