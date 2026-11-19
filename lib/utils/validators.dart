class Validators {
  static String? required(String? v, [String field = 'Campo']) {
    if (v == null || v.trim().isEmpty) return '$field é obrigatório';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'E-mail inválido';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Informe a senha';
    if (v.length < 6) return 'Mínimo de 6 caracteres';
    return null;
  }

  static String? year(String? v) {
    if (v == null || v.trim().isEmpty) return 'Informe o ano';
    final y = int.tryParse(v.trim());
    if (y == null) return 'Ano inválido';
    if (y < 1888 || y > DateTime.now().year + 5) return 'Ano fora do intervalo';
    return null;
  }
}
