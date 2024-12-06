import 'package:perdidos_ya/constants.dart';
import 'package:perdidos_ya/utils.dart';

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
  String? imageUrl;

  Pet({
    required this.age,
    required this.size,
    required this.name,
    required this.color,
    required this.raza,
    required this.especie,
    this.description,
    this.imageUrl,
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
      description: mascota['description'] ?? emptyDescription,
      imageUrl: mascota['imageUrl'] ?? defaultPetImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'age': getIntValueFromEnum(age),
      'size': getIntValueFromEnum(size),
      'name': name,
      'color': color,
      'raza': splitAndGetEnum(raza),
      'especie': getIntValueFromEnum(especie),
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  String get ageString => splitAndGetEnum(age);
  String get sizeString => splitAndGetEnum(size);
  String get razaString => splitAndGetEnum(raza);
  String get especieString => splitAndGetEnum(especie);
}

Especie especieFromInt(int value) {
  return Especie.values[value];
}

AgePet agePetFromInt(int value) {
  return AgePet.values[value];
}

SizePet sizePetFromInt(int value) {
  return SizePet.values[value];
}

Enum getRazaDefault(Especie especie) {
  return especie == Especie.gato ? RazaGato.mestizo : RazaPerro.mestizo;
}

dynamic razaFromString(String raza, Especie especie) {
  final especieToRaza = {
    Especie.perro: RazaPerro.values,
    Especie.gato: RazaGato.values,
  };

  final razas = especieToRaza[especie];
  return razas!.firstWhere(
    (value) => splitAndGetEnum(value) == raza, 
    orElse: () => getRazaDefault(especie)
  );
}
