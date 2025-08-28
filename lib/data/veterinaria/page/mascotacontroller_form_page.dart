import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/mascota_controller.dart';
import '../models/mascota_model.dart';

class MascotaScreenUnica extends StatelessWidget {
  final nombreController = TextEditingController();
  final tipoController = TextEditingController();
  final razaController = TextEditingController();

  final mascotaController = Get.put(MascotaController());
  final Rx<Mascota?> mascotaEditando = Rx<Mascota?>(null);

  void limpiarFormulario() {
    nombreController.clear();
    tipoController.clear();
    razaController.clear();
    mascotaEditando.value = null;
  }

  void guardarOModificarMascota() {
    final uid = mascotaController.mascotas.firstOrNull?.clienteId ??
        FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      Get.snackbar('Error', 'Usuario no autenticado');
      return;
    }

    final esEdicion = mascotaEditando.value != null;

    final mascota = Mascota(
      id: esEdicion ? mascotaEditando.value!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombreController.text.trim(),
      tipo: tipoController.text.trim(),
      raza: razaController.text.trim(),
      clienteId: uid,
    );

    if (esEdicion) {
      mascotaController.editarMascota(mascota);
    } else {
      final ref = FirebaseDatabase.instance
          .ref()
          .child('usuarios/$uid/mascotas/${mascota.id}');
      ref.set(mascota.toJson());
      mascotaController.mascotas.add(mascota);
    }

    limpiarFormulario();

    Get.snackbar(
      '¡Éxito!',
      esEdicion ? 'Mascota actualizada' : 'Mascota registrada',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Color(0xFF0D47A1); // Azul marino
    final lightBlue = Color(0xFF64B5F6);   // Celeste

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
            child: Column(
              children: [
                Obx(() => Text(
                  mascotaEditando.value != null
                      ? 'Editar Mascota'
                      : 'Registrar Nueva Mascota',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
                SizedBox(height: 20),
                _buildTextField(nombreController, 'Nombre', Icons.pets),
                SizedBox(height: 12),
                _buildTextField(tipoController, 'Tipo', Icons.category),
                SizedBox(height: 12),
                _buildTextField(razaController, 'Raza', Icons.line_weight),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.save),
                        label: Text('Guardar'),
                        onPressed: guardarOModificarMascota,
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
                    if (mascotaEditando.value != null) ...[
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.clear),
                          label: Text('Cancelar'),
                          onPressed: limpiarFormulario,
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
                Obx(() {
                  final mascotas = mascotaController.mascotas;

                  if (mascotas.isEmpty) {
                    return Text(
                      'No hay mascotas registradas.',
                      style: TextStyle(color: Colors.white),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: mascotas.length,
                    itemBuilder: (context, index) {
                      final mascota = mascotas[index];
                      return Card(
                        color: Colors.white.withOpacity(0.9),
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.pets, color: primaryBlue),
                          title: Text(
                            mascota.nombre,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('${mascota.tipo} - ${mascota.raza}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed: () {
                                  nombreController.text = mascota.nombre;
                                  tipoController.text = mascota.tipo;
                                  razaController.text = mascota.raza;
                                  mascotaEditando.value = mascota;
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  mascotaController.eliminarMascota(mascota.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
