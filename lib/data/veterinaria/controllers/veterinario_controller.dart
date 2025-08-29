import 'package:firebase_database/firebase_database.dart';

import '../models/veterinario_model.dart';


Future<void> createDefaultVeterinarians() async {
  final ref = FirebaseDatabase.instance.ref().child('veterinarios');

  // Default list of veterinarians
  final List<Veterinarian> veterinarians = [
    Veterinarian(
      id: 'vet001',
      name: 'Dr. Ana Gómez',
      specialty: 'Cirugía',
      email: 'ana.gomez@vetclinic.com',
    ),
    Veterinarian(
      id: 'vet002',
      name: 'Dr. Carlos Pérez',
      specialty: 'Dermatología',
      email: 'carlos.perez@vetclinic.com',
    ),
    Veterinarian(
      id: 'vet003',
      name: 'Dra. Laura Ruiz',
      specialty: 'Medicina interna',
      email: 'laura.ruiz@vetclinic.com',
    ),
  ];

  for (final vet in veterinarians) {
    await ref.child(vet.id).set(vet.toJson());
  }

  print('Default veterinarians inserted successfully');
}

