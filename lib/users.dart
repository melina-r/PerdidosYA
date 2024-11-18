import 'package:perdidos_ya/objects/mensaje.dart';
import 'package:perdidos_ya/objects/barrios.dart';
import 'objects/pet.dart';
import 'objects/report.dart';

class User {
  String username; 
  String email;
  String password;
  List<Pet> pets;
  List<Reporte> reportes = [];
  List<Zona> zones;
  String icon = 'assets/images/user.png';
  bool notificaciones = true;

  User({required this.username, required this.email, required this.password, required this.pets, required this.zones, required List<Reporte> reportes});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'pets': pets.map((pet) => pet.toMap()).toList(),
      'reportes': reportes.map((reporte) => reporte.toMap()).toList(),
      'zones': zones,
      'icon': icon,
      'notificaciones': notificaciones,
    };
  }

}