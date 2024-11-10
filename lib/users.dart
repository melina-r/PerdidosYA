
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
  String icon = 'lib/assets/images/user.png';
  bool notificaciones = true;

  User({required this.username, required this.email, required this.password, required this.pets, required this.zones, required List<Reporte> reportes});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'pets': pets.map((pet) => pet.toMap()).toList(),
      'reportes': reportes.map((reporte) => reporte.toMap()).toList(),
      'zonas': zones.map((zona) => zonaToString(zona)).toList(),
      'icon': icon,
      'notificaciones': notificaciones,
    };
  }

  static User fromMap(Object? userMap) {
    Map<String, dynamic> map = userMap as Map<String, dynamic>;
    return User(
      username: map['username'],
      email: map['email'],
      password: map['password'],
      pets: List<Pet>.from(map['pets'].map((pet) => Pet.fromMap(pet))),
      reportes: List<Reporte>.from(map['reportes'].map((reporte) => Reporte.fromMap(reporte))),
      zones: List<Zona>.from(map['zonas'].map((zona) => stringToZona(zona))),
    );
  }

}