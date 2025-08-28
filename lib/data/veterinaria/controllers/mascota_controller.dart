import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/mascota_model.dart';

class MascotaController extends GetxController {
  final RxList<Mascota> mascotas = <Mascota>[].obs;

  @override
  void onInit() {
    super.onInit();
    cargarMascotas();
  }

  void cargarMascotas() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseDatabase.instance.ref().child('usuarios/$uid/mascotas');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final cargadas = data.entries.map((e) {
        final json = Map<String, dynamic>.from(e.value);
        return Mascota.fromJson(json);
      }).toList();

      mascotas.assignAll(cargadas);
    } else {
      mascotas.clear();
    }
  }

  Future<void> eliminarMascota(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseDatabase.instance.ref().child('usuarios/$uid/mascotas/$id');
    await ref.remove();

    mascotas.removeWhere((m) => m.id == id);
    Get.snackbar('Eliminado', 'Mascota eliminada correctamente');
  }

  Future<void> editarMascota(Mascota mascotaActualizada) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseDatabase.instance
        .ref()
        .child('usuarios/$uid/mascotas/${mascotaActualizada.id}');

    await ref.set(mascotaActualizada.toJson());

    // Actualizar
    final index = mascotas.indexWhere((m) => m.id == mascotaActualizada.id);
    if (index != -1) {
      mascotas[index] = mascotaActualizada;
    }

    Get.snackbar('Actualizado', 'Mascota actualizada correctamente');
  }
}
