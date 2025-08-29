import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../core/validation/validation.dart';
import '../controllers/cita_controller.dart';
import '../models/cita_model.dart';

class AppointmentPage extends StatelessWidget {
  final controller = Get.put(AppointmentController());
  final Rx<Appointment?> editingAppointment = Rx<Appointment?>(null);
  final selectedDateTime = Rxn<DateTime>();
  final reasonController = TextEditingController();
  final RxString selectedPet = ''.obs;
  final RxString selectedVet = ''.obs;

  final uuid = Uuid();

  void _openDateTimePicker(BuildContext context) async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.value ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: selectedDateTime.value != null
            ? TimeOfDay.fromDateTime(selectedDateTime.value!)
            : TimeOfDay.now(),
      );

      if (time != null) {
        final selected = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        selectedDateTime.value = selected;
      }
    }
  }

  void _showForm(BuildContext context, {Appointment? appoitment}) {
    final primaryBlue = const Color(0xFF0D47A1);

    if (appoitment != null) {
      // Modo edición
      editingAppointment.value = appoitment;
      selectedDateTime.value = appoitment.dateTime;
      reasonController.text = appoitment.reason;
      selectedPet.value = appoitment.petId;
      selectedVet.value = appoitment.veterinarianId;
    } else {
      // Modo nuevo
      editingAppointment.value = null;
      selectedDateTime.value = null;
      reasonController.clear();
      selectedPet.value = '';
      selectedVet.value = '';
    }

    Get.bottomSheet(
      Obx(() {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  appoitment != null ? 'Editar Cita' : 'Nueva Cita',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _openDateTimePicker(context),
                  icon: const Icon(Icons.calendar_today),
                  label: Text(selectedDateTime.value == null
                      ? 'Seleccionar Hora y Fecha'
                      : DateFormat('dd-MM-yyyy – HH:mm')
                      .format(selectedDateTime.value!)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    labelText: 'Razon',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedPet.value.isEmpty ? null : selectedPet.value,
                  decoration: _dropdownDecoration('Select Pet'),
                  items: controller.pets.map((m) {
                    return DropdownMenuItem(
                      value: m.id,
                      child: Text(m.name),
                    );
                  }).toList(),
                  onChanged: (value) => selectedPet.value = value ?? '',
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedVet.value.isEmpty ? null : selectedVet.value,
                  decoration: _dropdownDecoration('Seleccionar Veterinario'),
                  items: controller.veterinarians.map((v) {
                    return DropdownMenuItem(
                      value: v.id,
                      child: Text(v.name),
                    );
                  }).toList(),
                  onChanged: (value) => selectedVet.value = value ?? '',
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: Text(appoitment != null ? 'Actualizar' : 'Agregar'),
                        onPressed: () {
                          final errorDate = CitaValidators.validateDateTime(selectedDateTime.value);
                          final errorReason = CitaValidators.validateText(
                              reasonController.text, 'Motivo');
                          final errorPet = CitaValidators.validateSelection(selectedPet.value, 'mascota');
                          final errorVet = CitaValidators.validateSelection(selectedVet.value, 'veterinario');

                          if (errorDate != null ||
                              errorReason != null ||
                              errorPet != null ||
                              errorVet != null) {
                            Get.snackbar('Error', 'Completa todos los campos');
                            return;
                          }

                          final newAppointment = Appointment(
                            id: appoitment?.id ?? uuid.v4(),
                            dateTime: selectedDateTime.value!,
                            reason: reasonController.text.trim(),
                            petId: selectedPet.value,
                            veterinarianId: selectedVet.value,
                          );

                          if (appoitment == null) {
                            controller.addAppointment(newAppointment);
                          } else {
                            controller.updateAppointment(newAppointment);
                            editingAppointment.value = null;
                          }

                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    if (appoitment != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancelar'),
                          onPressed: () {
                            editingAppointment.value = null;
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  void _confirmDeletion(String id) {
    Get.defaultDialog(
      title: '¿Eliminar cita?',
      middleText: 'Esta acción no se puede deshacer',
      textConfirm: 'Sí, eliminar',
      textCancel: 'Cancelar',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteAppointment(id);
        if (editingAppointment.value?.id == id) {
          editingAppointment.value = null;
          Get.back();
        }
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryBlue = const Color(0xFF0D47A1);
    final lightBlue = const Color(0xFF64B5F6);

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Citas Registradas',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.white, size: 30),
                      onPressed: () => _showForm(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final appoitments = controller.appointments;

                  if (appoitments.isEmpty) {
                    return const Center(
                      child: Text('No hay citas registradas', style: TextStyle(color: Colors.white)),
                    );
                  }

                  return ListView.builder(
                    itemCount: appoitments.length,
                    itemBuilder: (context, index) {
                      final appoitment = appoitments[index];
                      final pet = controller.pets.firstWhereOrNull((m) => m.id == appoitment.petId);
                      final vet = controller.veterinarians.firstWhereOrNull((v) => v.id == appoitment.veterinarianId);

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            DateFormat('dd-MM-yyyy – HH:mm').format(appoitment.dateTime),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${pet?.name ?? 'Mascota'} con ${vet?.name ?? 'Veterinario'}\nMotivo: ${appoitment.reason}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => _showForm(context, appoitment: appoitment),
                              ),
                              Obx(() {
                                final isEditing = editingAppointment.value?.id == appoitment.id;
                                return IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: isEditing ? null : () => _confirmDeletion(appoitment.id),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
