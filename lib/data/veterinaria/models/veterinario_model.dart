class Veterinarian {
  final String id;
  final String name;
  final String specialty;
  final String email;

  Veterinarian({
    required this.id,
    required this.name,
    required this.specialty,
    required this.email,
  });

  factory Veterinarian.fromJson(Map<String, dynamic> json) => Veterinarian(
    id: json['id'],
    name: json['nombre'],
    specialty: json['especialidad'],
    email: json['email'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': name,
    'especialidad': specialty,
    'email': email,
  };
}
