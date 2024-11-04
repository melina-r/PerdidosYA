enum SizePet { chico, mediano, grande }
enum AgePet { cachorro, adulto, anciano }

class Pet {
  final AgePet age;
  final SizePet size;
  final String name;
  final String color;
  final String raza;
  final String especie;
  final String? description;

  Pet({
    required this.age,
    required this.size,
    required this.name,
    required this.color,
    required this.raza,
    required this.especie,
    this.description
  });

   // Método de fábrica para crear Pet desde el diccionario
  factory Pet.fromMap(Map<String, dynamic> mascota) {
    return Pet(
      age: _agePetFromInt(mascota['age'] ?? 0),
      size: _sizePetFromInt(mascota['size'] ?? 0),
      name: mascota['name'] ?? '',
      color: mascota['color'] ?? '',
      raza: mascota['raza'] ?? '',
      especie: mascota['especie'] ?? '',
      description: mascota['description'] ?? '',
    );
  }

  // Métodos para mapear int a enums específicos
  static AgePet _agePetFromInt(int value) {
    switch (value) {
      case 0:
        return AgePet.cachorro;
      case 1:
        return AgePet.adulto;
      case 2:
        return AgePet.anciano;
      default:
        throw ArgumentError("Valor inválido para AgePet: $value");
    }
  }

  static SizePet _sizePetFromInt(int value) {
    switch (value) {
      case 0:
        return SizePet.chico;
      case 1:
        return SizePet.mediano;
      case 2:
        return SizePet.grande;
      default:
        throw ArgumentError("Valor inválido para SizePet: $value");
    }
  }
}