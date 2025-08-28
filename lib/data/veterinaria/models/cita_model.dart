class Cita {
  final String id;
  final String fecha;
  final String hora;
  final String mascotaId;
  final String veterinarioId;
  final String motivo;

  Cita({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.mascotaId,
    required this.veterinarioId,
    required this.motivo,
  });

  factory Cita.fromJson(Map<String, dynamic> json) => Cita(
    id: json['id'],
    fecha: json['fecha'],
    hora: json['hora'],
    mascotaId: json['mascotaId'],
    veterinarioId: json['veterinarioId'],
    motivo: json['motivo'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fecha': fecha,
    'hora': hora,
    'mascotaId': mascotaId,
    'veterinarioId': veterinarioId,
    'motivo': motivo,
  };
}
