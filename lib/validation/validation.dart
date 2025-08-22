// lib/validation/validation.dart


class InputValidation {
  /// Verifica si la palabra ya existe en la lista
  static bool isDuplicate(String value, List<String> existingItems) {
    return existingItems.contains(value.trim());
  }
}
