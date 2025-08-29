import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/mascota_model.dart';
import '../../../core/validation/validation.dart';

class PetController extends GetxController {
  final RxList<Pet> pets = <Pet>[].obs;

  final nameController = TextEditingController();
  final selectedType = ''.obs;
  final selectedBreed = ''.obs;
  final editingPet = Rx<Pet?>(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Tipos y razas disponibles
  final types = ['Perro', 'Gato', 'Ave'];
  final breedsByType = {
    'Perro': ['Labrador', 'Bulldog', 'Chihuahua', 'Poodle', 'Pastor Alemán'],
    'Gato': ['Siames', 'Persa', 'Bengala', 'Esfinge', 'Maine Coon'],
    'Ave': ['Canario', 'Perico', 'Loro', 'Cacatúa', 'Agaporni'],
  };

  @override
  void onInit() {
    super.onInit();
    loadPets();
  }

  // Cargar mascotas del usuario desde Firebase
  void loadPets() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseDatabase.instance.ref().child('usuarios/$uid/mascotas');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final loaded = data.entries.map((e) {
        final json = Map<String, dynamic>.from(e.value);
        return Pet.fromJson(json);
      }).toList();

      pets.assignAll(loaded);
    } else {
      pets.clear();
    }
  }

  // Limpiar el formulario
  void clearForm() {
    nameController.clear();
    selectedType.value = '';
    selectedBreed.value = '';
    editingPet.value = null;
  }

  // Cargar datos de una mascota para editar
  void loadPetForEditing(Pet pet) {
    nameController.text = pet.name;
    selectedType.value = pet.type;
    selectedBreed.value = pet.breed;
    editingPet.value = pet;
  }

  // Guardar o modificar mascota
  Future<void> saveOrUpdatePet() async {
    if (!formKey.currentState!.validate()) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      Get.snackbar('Error', 'Usuario no autenticado');
      return;
    }

    final isEditing = editingPet.value != null;

    final pet = Pet(
      id: isEditing
          ? editingPet.value!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      type: selectedType.value,
      breed: selectedBreed.value,
      clientId: uid,
    );

    final ref = FirebaseDatabase.instance
        .ref()
        .child('usuarios/$uid/mascotas/${pet.id}');

    await ref.set(pet.toJson());

    if (isEditing) {
      final index = pets.indexWhere((p) => p.id == pet.id);
      if (index != -1) pets[index] = pet;
      Get.snackbar('Actualizado', 'Mascota actualizada correctamente');
    } else {
      pets.add(pet);
      Get.snackbar('¡Éxito!', 'Mascota registrada correctamente');
    }

    clearForm();
  }

  // Eliminar mascota
  Future<void> deletePet(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref =
    FirebaseDatabase.instance.ref().child('usuarios/$uid/mascotas/$id');
    await ref.remove();

    pets.removeWhere((p) => p.id == id);
    Get.snackbar('Eliminado', 'Mascota eliminada correctamente');

    if (editingPet.value?.id == id) clearForm();
  }

  // Validaciones
  String? validateName(String? value) => PetValidators.validateName(value);
  String? validateType(String? value) => PetValidators.validateType(value);
  String? validateBreed(String? value) => PetValidators.validateBreed(value);
}



