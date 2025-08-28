class UserProfile {
  final String uid;
  final String nombre;
  final String telefono;

  UserProfile({
    required this.uid,
    required this.nombre,
    required this.telefono,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    uid: json['uid'],
    nombre: json['nombre'],
    telefono: json['telefono'],
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'nombre': nombre,
    'telefono': telefono,
  };
}
