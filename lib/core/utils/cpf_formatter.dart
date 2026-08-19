String formatCpf(String? cpf) {
  if (cpf == null || cpf.trim().isEmpty) return 'Não informado';

  final digits = cpf.replaceAll(RegExp(r'\D'), '');
  if (digits.length != 11) return cpf;

  return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9)}';
}
