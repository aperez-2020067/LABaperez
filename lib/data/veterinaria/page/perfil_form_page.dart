import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PerfilFormPage extends StatelessWidget {
  final nombreController = TextEditingController();
  final telefonoController = TextEditingController();

  void guardarPerfil() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseDatabase.instance
        .ref()
        .child('usuarios/$uid')
        .set({
      'uid': uid,
      'nombre': nombreController.text.trim(),
      'telefono': telefonoController.text.trim(),
    });

    Get.snackbar('Éxito', 'Perfil guardado correctamente',
        backgroundColor: Colors.white,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM);
    Get.offAllNamed('/home');
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 100, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  'Completa tu Perfil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(nombreController, 'Nombre completo', Icons.person),
                SizedBox(height: 20),
                _buildTextField(telefonoController, 'Número de teléfono', Icons.phone),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: guardarPerfil,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryBlue,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Guardar Perfil',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
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
      keyboardType: icon == Icons.phone ? TextInputType.phone : TextInputType.text,
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
