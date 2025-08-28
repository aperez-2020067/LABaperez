import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/cita_model.dart';
import '../models/mascota_model.dart';
import '../models/veterinario_model.dart';

class CitaController extends GetxController {
  final citas = <Cita>[].obs;
  final mascotas = <Mascota>[].obs;
  final veterinarios = <Veterinario>[].obs;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    cargarCitas();
    cargarMascotas();
    cargarVeterinarios();
  }

  void cargarCitas() async {
    final ref = FirebaseDatabase.instance.ref('usuarios/$uid/citas');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final lista = data.entries.map((e) {
        final json = Map<String, dynamic>.from(e.value);
        return Cita.fromJson(json);
      }).toList();
      citas.assignAll(lista);
    }
  }

  void cargarMascotas() async {
    final ref = FirebaseDatabase.instance.ref('usuarios/$uid/mascotas');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final lista = data.entries.map((e) {
        final json = Map<String, dynamic>.from(e.value);
        return Mascota.fromJson(json);
      }).toList();
      mascotas.assignAll(lista);
    }
  }

  void cargarVeterinarios() async {
    final ref = FirebaseDatabase.instance.ref('veterinarios');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final lista = data.entries.map((e) {
        final json = Map<String, dynamic>.from(e.value);
        return Veterinario.fromJson(json);
      }).toList();
      veterinarios.assignAll(lista);
    }
  }

  Future<void> agregarCita(Cita cita) async {
    final ref = FirebaseDatabase.instance.ref('usuarios/$uid/citas').child(cita.id);
    await ref.set(cita.toJson());
    cargarCitas();
  }

  Future<void> eliminarCita(String id) async {
    final ref = FirebaseDatabase.instance.ref('usuarios/$uid/citas/$id');
    await ref.remove();
    cargarCitas();
  }

  Future<void> editarCita(Cita cita) async {
    final ref = FirebaseDatabase.instance.ref('usuarios/$uid/citas/${cita.id}');
    await ref.set(cita.toJson());
    cargarCitas();
  }
}
