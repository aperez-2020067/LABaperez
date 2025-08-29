class Pet {
  final String id;
  final String name;
  final String type;
  final String breed;
  final String clientId;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.clientId,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
    id: json['id'],
    name: json['nombre'],
    type: json['tipo'],
    breed: json['raza'],
    clientId: json['clienteId'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': name,
    'tipo': type,
    'raza': breed,
    'clienteId': clientId,
  };
}

