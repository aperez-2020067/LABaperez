import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mascota_controller.dart';


class SinglePetScreen extends StatelessWidget {
  final petController = Get.put(PetController());

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Color(0xFF0D47A1);
    final lightBlue = Color(0xFF64B5F6);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryBlue, lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Obx(
                  () => Form(
                key: petController.formKey,
                child: Column(
                  children: [
                    Text(
                      petController.editingPet.value != null
                          ? 'Editar Mascota'
                          : 'Registrar Nueva Mascota',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTextFormField(
                      controller: petController.nameController,
                      label: 'Nombre',
                      icon: Icons.pets,
                      validator: petController.validateName,
                    ),
                    SizedBox(height: 12),
                    _buildDropdown(
                      label: 'Tipo',
                      icon: Icons.category,
                      value: petController.selectedType.value.isEmpty
                          ? null
                          : petController.selectedType.value,
                      items: petController.types,
                      onChanged: (value) {
                        petController.selectedType.value = value!;
                        petController.selectedBreed.value = '';
                      },
                      validator: petController.validateType,
                    ),
                    SizedBox(height: 12),
                    _buildDropdown(
                      label: 'Raza',
                      icon: Icons.line_weight,
                      value: petController.selectedBreed.value.isEmpty
                          ? null
                          : petController.selectedBreed.value,
                      items: petController.breedsByType[
                      petController.selectedType.value] ??
                          [],
                      onChanged: (value) =>
                      petController.selectedBreed.value = value!,
                      validator: petController.validateBreed,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.save),
                            label: Text('Guardar'),
                            onPressed: petController.saveOrUpdatePet,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryBlue,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        if (petController.editingPet.value != null) ...[
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.clear),
                              label: Text('Cancelar'),
                              onPressed: petController.clearForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black87,
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 30),
                    Divider(color: Colors.white),
                    _buildPetList(primaryBlue),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      dropdownColor: Colors.white,
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildPetList(Color primaryBlue) {
    return Obx(() {
      final pets = petController.pets;
      final isEditing = petController.editingPet.value != null;

      if (pets.isEmpty) {
        return Center(
          child: Text(
            'No hay mascotas registradas.',
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: pets.length,
        itemBuilder: (_, index) {
          final pet = pets[index];
          return Card(
            color: Colors.white.withOpacity(0.9),
            child: ListTile(
              title: Text(pet.name),
              subtitle: Text('${pet.type} - ${pet.breed}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: primaryBlue),
                    onPressed: () =>
                        petController.loadPetForEditing(pet),
                  ),
                  if (!isEditing)
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeletion(pet.id),
                    ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _confirmDeletion(String id) {
    Get.defaultDialog(
      title: "Confirmar eliminación",
      middleText: "¿Estás seguro de que deseas eliminar esta mascota?",
      textConfirm: "Sí, eliminar",
      textCancel: "Cancelar",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        petController.deletePet(id);
        Get.back(); // cerrar el diálogo
      },
      onCancel: () {},
    );
  }
}



