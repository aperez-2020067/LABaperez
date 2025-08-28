import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../controllers/cita_controller.dart';
import '../models/cita_model.dart';

class CitaPage extends StatelessWidget {
  final controller = Get.put(CitaController());

  final fechaController = TextEditingController();
  final horaController = TextEditingController();
  final motivoController = TextEditingController();

  final uuid = Uuid();

  final RxString mascotaSeleccionada = ''.obs;
  final RxString veterinarioSeleccionado = ''.obs;

  void mostrarFormulario({Cita? citaExistente}) {
    final primaryBlue = Color(0xFF0D47A1);

    if (citaExistente != null) {
      fechaController.text = citaExistente.fecha;
      horaController.text = citaExistente.hora;
      motivoController.text = citaExistente.motivo;
      mascotaSeleccionada.value = citaExistente.mascotaId;
      veterinarioSeleccionado.value = citaExistente.veterinarioId;
    } else {
      fechaController.clear();
      horaController.clear();
      motivoController.clear();
      mascotaSeleccionada.value = '';
      veterinarioSeleccionado.value = '';
    }

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                citaExistente == null ? 'Nueva Cita' : 'Editar Cita',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(fechaController, 'Fecha (DD-MM-YYYY)', Icons.calendar_today),
              SizedBox(height: 12),
              _buildTextField(horaController, 'Hora', Icons.access_time),
              SizedBox(height: 12),
              _buildTextField(motivoController, 'Motivo', Icons.description),
              SizedBox(height: 12),
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: mascotaSeleccionada.value.isEmpty ? null : mascotaSeleccionada.value,
                  decoration: _dropdownDecoration('Seleccionar Mascota'),
                  items: controller.mascotas.map((m) {
                    return DropdownMenuItem(
                      value: m.id,
                      child: Text(m.nombre),
                    );
                  }).toList(),
                  onChanged: (value) => mascotaSeleccionada.value = value ?? '',
                );
              }),
              SizedBox(height: 12),
              Obx(() {
                return DropdownButtonFormField<String>(
                  value: veterinarioSeleccionado.value.isEmpty ? null : veterinarioSeleccionado.value,
                  decoration: _dropdownDecoration('Seleccionar Veterinario'),
                  items: controller.veterinarios.map((v) {
                    return DropdownMenuItem(
                      value: v.id,
                      child: Text(v.nombre),
                    );
                  }).toList(),
                  onChanged: (value) => veterinarioSeleccionado.value = value ?? '',
                );
              }),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text(citaExistente == null ? 'Agregar Cita' : 'Actualizar Cita'),
                  onPressed: () {
                    final nuevaCita = Cita(
                      id: citaExistente?.id ?? uuid.v4(),
                      fecha: fechaController.text.trim(),
                      hora: horaController.text.trim(),
                      motivo: motivoController.text.trim(),
                      mascotaId: mascotaSeleccionada.value,
                      veterinarioId: veterinarioSeleccionado.value,
                    );

                    if (citaExistente == null) {
                      controller.agregarCita(nuevaCita);
                    } else {
                      controller.editarCita(nuevaCita);
                    }

                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

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
                      icon: Icon(Icons.add_circle, color: Colors.white, size: 30),
                      onPressed: () => mostrarFormulario(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final citas = controller.citas;

                  if (citas.isEmpty) {
                    return Center(
                      child: Text(
                        'No hay citas registradas.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: citas.length,
                    itemBuilder: (context, index) {
                      final cita = citas[index];
                      final mascota = controller.mascotas.firstWhereOrNull((m) => m.id == cita.mascotaId);
                      final veterinario = controller.veterinarios.firstWhereOrNull((v) => v.id == cita.veterinarioId);

                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text('${cita.fecha} - ${cita.hora}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${mascota?.nombre ?? 'Mascota'} con ${veterinario?.nombre ?? 'Veterinario'}\nMotivo: ${cita.motivo}'),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () => mostrarFormulario(citaExistente: cita),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => controller.eliminarCita(cita.id),
                              ),
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
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
