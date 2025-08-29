class Appointment {
  final String id;
  final DateTime dateTime;
  final String petId;
  final String veterinarianId;
  final String reason;

  Appointment({
    required this.id,
    required this.dateTime,
    required this.petId,
    required this.veterinarianId,
    required this.reason,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'],
    dateTime: DateTime.parse(json['fechaHora']),
    petId: json['mascotaId'],
    veterinarianId: json['veterinarioId'],
    reason: json['motivo'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fechaHora': dateTime.toIso8601String(),
    'mascotaId': petId,
    'veterinarioId': veterinarianId,
    'motivo': reason,
  };
}
