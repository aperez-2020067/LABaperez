class Mascota {
  final String id;
  final String nombre;
  final String tipo;
  final String raza;
  final String clienteId;

  Mascota({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.raza,
    required this.clienteId,
  });

  factory Mascota.fromJson(Map<String, dynamic> json) => Mascota(
    id: json['id'],
    nombre: json['nombre'],
    tipo: json['tipo'],
    raza: json['raza'],
    clienteId: json['clienteId'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'tipo': tipo,
    'raza': raza,
    'clienteId': clienteId,
  };
}
