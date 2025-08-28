import 'package:firebase_database/firebase_database.dart';
import '../models/veterinario_model.dart';

Future<void> crearVeterinariosPorDefecto() async {
  final ref = FirebaseDatabase.instance.ref().child('veterinarios');

  // Lista de veterinarios por defecto
  final List<Veterinario> veterinarios = [
    Veterinario(
      id: 'vet001',
      nombre: 'Dr. Ana Gómez',
      especialidad: 'Cirugía',
      email: 'ana.gomez@vetclinic.com',
    ),
    Veterinario(
      id: 'vet002',
      nombre: 'Dr. Carlos Pérez',
      especialidad: 'Dermatología',
      email: 'carlos.perez@vetclinic.com',
    ),
    Veterinario(
      id: 'vet003',
      nombre: 'Dra. Laura Ruiz',
      especialidad: 'Medicina interna',
      email: 'laura.ruiz@vetclinic.com',
    ),
  ];

  for (final vet in veterinarios) {
    await ref.child(vet.id).set(vet.toJson());
  }

  print('Veterinarios por defecto insertados correctamente');
}
