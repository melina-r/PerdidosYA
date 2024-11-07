enum SizePet { chico, mediano, grande }
enum AgePet { bebe, adulto, anciano }

class Pet {
  final AgePet age;
  final SizePet size;
  final String name;
  final String color;
  final String? description;

  Pet({
    required this.age,
    required this.size,
    required this.name,
    required this.color,
    this.description
  });
}