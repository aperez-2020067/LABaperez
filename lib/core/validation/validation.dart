
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
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return regex.hasMatch(password);
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    } else if (!isValidEmail(value.trim())) {
      return 'Correo electrónico no válido';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    } else if (!isValidPassword(value.trim())) {
      return 'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un símbolo.';
    }
    return null;
  }
}

class PerfilValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El número de teléfono es obligatorio';
    }

    final phoneRegex = RegExp(r'^[0-9]{6,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Número de teléfono no válido';
    }

    return null;
  }
}

class PetValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }
    return null;
  }

  static String? validateType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El tipo es obligatorio';
    }
    return null;
  }

  static String? validateBreed(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La raza es obligatoria';
    }
    return null;
  }
}


class CitaValidators {
  static String? validateDateTime(DateTime? fechaHora) {
    if (fechaHora == null) return 'Selecciona una fecha y hora válida';
    return null;
  }

  static String? validateText(String? value, String campo) {
    if (value == null || value.trim().isEmpty) {
      return 'El campo $campo es obligatorio';
    }
    return null;
  }

  static String? validateSelection(String? value, String campo) {
    if (value == null || value.trim().isEmpty) {
      return 'Debes seleccionar un $campo';
    }
    return null;
  }
}


