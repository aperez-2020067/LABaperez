
class InputValidation {
  /// Verifica si la palabra ya existe en la lista
  static bool isDuplicate(String value, List<String> existingItems) {
    return existingItems.contains(value.trim());
  }
}

class Validators {
  static bool isValidEmail(String email) {
    final regex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return regex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Mínimo 8 caracteres, 1 mayúscula, 1 minúscula, 1 número, 1 símbolo
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
    );
    return regex.hasMatch(password);
  }
}
