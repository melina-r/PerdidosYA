import 'objects/pet.dart';
import 'objects/report.dart';

class User {
  String username; 
  String email;
  String password;
  List<Pet> pets;
  List<Reporte> reportes = [];
  List<String> zones;
  String icon = 'assets/images/user.png';

  User({required this.username, required this.email, required this.password, required this.pets, required this.zones});
}