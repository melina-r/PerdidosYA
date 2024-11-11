import 'package:perdidos_ya/objects/mensaje.dart';

import 'objects/pet.dart';
import 'objects/report.dart';

class User {
  String username; 
  String email;
  String password;
  List<Pet> pets;
  List<Reporte> reportes = [];
  List<Mensaje> mensajes = [];
  List<String> zones;
  String icon = 'assets/images/user.png';
  bool notificaciones = true;

  User({required this.username, required this.email, required this.password, required this.pets, required this.zones, required List<Reporte> reportes, required List<Mensaje> mensajes});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'pets': pets.map((pet) => pet.toMap()).toList(),
      'reportes': reportes.map((reporte) => reporte.toMap()).toList(),
      'mensajes': mensajes.map((mensaje) => mensaje.toMap()).toList(),
      'zones': zones,
      'icon': icon,
      'notificaciones': notificaciones,
    };
  }

}