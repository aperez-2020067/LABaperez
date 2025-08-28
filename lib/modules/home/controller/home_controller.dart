import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/validation/validation.dart';




class HomeController extends GetxController {
  var current = ''.obs;
  var history = <String>[].obs;
  var favorites = <String>[].obs;

  final GlobalKey<AnimatedListState> historyListKey = GlobalKey<AnimatedListState>();

  void setCurrent(String value) {
    // Bloquea si la palabra ya existe en el historial
    if (InputValidation.isDuplicate(value, history)) {
      Get.snackbar('Error', 'Esta palabra ya fue agregada');
      return;
    }

    current.value = value;
  }

  void addCurrentToHistory() {
    if (current.trim().isEmpty) return;

    // Validación adicional por si se intenta agregar manualmente
    if (InputValidation.isDuplicate(current.value, history)) {
      Get.snackbar('Error', 'Esta palabra ya fue agregada');
      return;
    }

    history.insert(0, current.value);
    historyListKey.currentState?.insertItem(0);
    toggleFavorite(current.value);
    clearCurrent();
  }

  void toggleFavorite(String item) {
    if (favorites.contains(item)) {
      favorites.remove(item);
    } else {
      favorites.add(item);
    }
  }

  void removeFavorite(String item) {
    favorites.remove(item);
  }

  void clearCurrent() {
    current.value = '';
  }
}
