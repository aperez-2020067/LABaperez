class Veterinario {
  final String id;
  final String nombre;
  final String especialidad;
  final String email;

  Veterinario({
    required this.id,
    required this.nombre,
    required this.especialidad,
    required this.email,
  });

  factory Veterinario.fromJson(Map<String, dynamic> json) => Veterinario(
    id: json['id'],
    nombre: json['nombre'],
    especialidad: json['especialidad'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'especialidad': especialidad,
    'email': email,
  };
}
