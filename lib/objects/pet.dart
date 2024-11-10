enum SizePet { chico, mediano, grande }
enum AgePet { cachorro, adulto, anciano }
enum RazaPerro { mestizo, bulldog, labrador, pastorAleman, pastorBelga, boxer, chihuahua, dalmata, doberman, goldenRetriever, huskySiberiano, pug, rottweiler, sanBernardo, schnauzer, shihTzu, yorkshireTerrier }
enum RazaGato { mestizo, siames, persa, bengala, ragdoll, sphynx, maineCoon, britishShorthair, scottishFold, munchkin }
enum Especie { perro, gato }

class Pet {
  AgePet age;
  SizePet size;
  String name;
  String color;
  Especie especie;
  dynamic raza;
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
      raza: razaFromString(mascota['raza'], especieFromInt(mascota['especie'] ?? 0)),
      especie: especieFromInt(mascota['especie'] ?? 0),
      description: mascota['description'] ?? '',
    );
  }

  static dynamic razaFromString(String raza, Especie especie) {
    if (especie == Especie.perro) {
      return RazaPerro.values.firstWhere((e) => e.toString().split('.').last == raza, orElse: () => RazaPerro.mestizo);
    } else if (especie == Especie.gato) {
      return RazaGato.values.firstWhere((e) => e.toString().split('.').last == raza, orElse: () => RazaGato.mestizo);
    } else {
      throw ArgumentError("Especie no soportada: $especie");
    }
  }

  String razaToString() {
    return raza.toString().split('.').last;
  }

  // Métodos para mapear int a enums específicos
  static Especie especieFromInt(int value) {
    return Especie.values[value];
  }

  static int especieToInt(Especie especie) {
    return especie.index;
  }

  static AgePet agePetFromInt(int value) {
    return AgePet.values[value];
  }

  static SizePet sizePetFromInt(int value) {
    return SizePet.values[value];
  }

  Map<String, dynamic> toMap() {
    return {
      'age': _agePetToInt(age),
      'size': _sizePetToInt(size),
      'name': name,
      'color': color,
      'raza': razaToString(),
      'especie': especieToInt(especie),
      'description': description,
    };
  }

  static int _agePetToInt(AgePet age) {
    return age.index;
  }

  static int _sizePetToInt(SizePet size) {
    return size.index;
  }

  String _getStringValue(Enum value) {
    return value.toString().split('.').last;
  }

  String get ageString => _getStringValue(age);
  String get sizeString => _getStringValue(size);
  String get razaString => razaToString();
  String get especieString => _getStringValue(especie);
}
