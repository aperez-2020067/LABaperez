import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/cita_model.dart';
import '../models/mascota_model.dart';
import '../models/veterinario_model.dart';


class AppointmentController extends GetxController {
  final appointments = <Appointment>[].obs;
  final pets = <Pet>[].obs;
  final veterinarians = <Veterinarian>[].obs;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
    loadPets();
    loadVeterinarians();
  }

  void loadAppointments() async {
    final ref = FirebaseDatabase.instance.ref('usuarios/$uid/citas');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final list = data.entries.map((e) {
        final json = Map<String, dynamic>.from(e.value);
        return Appointment.fromJson(json);
      }).toList();
      appointments.assignAll(list);
    } else {
      appointments.clear();
    }
  }

  void loadPets() async {
    final ref = FirebaseDatabase.instance.ref('usuarios/$uid/mascotas');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final list = data.entries.map((e) {
        final json = Map<String, dynamic>.from(e.value);
        return Pet.fromJson(json);
      }).toList();
      pets.assignAll(list);
    } else {
      pets.clear();
    }
  }

  void loadVeterinarians() async {
    final ref = FirebaseDatabase.instance.ref('veterinarios');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final list = data.entries.map((e) {
        final json = Map<String, dynamic>.from(e.value);
        return Veterinarian.fromJson(json);
      }).toList();
      veterinarians.assignAll(list);
    } else {
      veterinarians.clear();
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    final ref =
    FirebaseDatabase.instance.ref('usuarios/$uid/citas/${appointment.id}');
    await ref.set(appointment.toJson());
    loadAppointments();
  }

  Future<void> deleteAppointment(String id) async {
    final ref = FirebaseDatabase.instance.ref('usuarios/$uid/citas/$id');
    await ref.remove();
    loadAppointments();
  }

  Future<void> updateAppointment(Appointment appointment) async {
    final ref =
    FirebaseDatabase.instance.ref('usuarios/$uid/citas/${appointment.id}');
    await ref.set(appointment.toJson());
    loadAppointments();
  }
}
