enum SizePet { chico, mediano, grande }
enum AgePet { cachorro, adulto, anciano }

class Pet {
  AgePet age;
  SizePet size;
  String name;
  String color;
  String raza;
  String especie;
  String? description;

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
      age: agePetFromInt(mascota['age'] ?? 0),
      size: sizePetFromInt(mascota['size'] ?? 0),
      name: mascota['name'] ?? '',
      color: mascota['color'] ?? '',
      raza: mascota['raza'] ?? '',
      especie: mascota['especie'] ?? '',
      description: mascota['description'] ?? '',
    );
  }

  // Métodos para mapear int a enums específicos
  static AgePet agePetFromInt(int value) {
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

  static SizePet sizePetFromInt(int value) {
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

  Map<String, dynamic> toMap() {
    return {
      'age': _agePetToInt(age),
      'size': _sizePetToInt(size),
      'name': name,
      'color': color,
      'raza': raza,
      'especie': especie,
      'description': description,
    };
  }

  static int _agePetToInt(AgePet age) {
    switch (age) {
      case AgePet.cachorro:
        return 0;
      case AgePet.adulto:
        return 1;
      case AgePet.anciano:
        return 2;
      default:
        throw ArgumentError("Valor inválido para AgePet: $age");
    }
  }

  static int _sizePetToInt(SizePet size) {
    switch (size) {
      case SizePet.chico:
        return 0;
      case SizePet.mediano:
        return 1;
      case SizePet.grande:
        return 2;
      default:
        throw ArgumentError("Valor inválido para SizePet: $size");
    }
  }

  String _getStringValue(Enum value) {
    return value.toString().split('.').last;
  }

  String get ageString => _getStringValue(age);
  String get sizeString => _getStringValue(size);
}
