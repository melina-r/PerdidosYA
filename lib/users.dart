import 'package:perdidos_ya/objects/mensaje.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String icon;
  bool notificaciones = true;

  User({required this.username, required this.email, required this.password, required this.pets, required this.zones, required List<Reporte> reportes, required this.icon});

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
  
  static User fromMap(Object? userMap) {
    Map<String, dynamic> map = userMap as Map<String, dynamic>;
    return User(
      username: map['username'],
      email: map['email'],
      password: map['password'],
      pets: List<Pet>.from(map['pets'].map((pet) => Pet.fromMap(pet))),
      reportes: List<Reporte>.from(map['reportes'].map((reporte) => Reporte.fromMap(reporte))),
      zones: List<Zona>.from(map['zonas'].map((zona) => stringToZona(zona))),
      icon: map.containsKey("icon")? map['icon'] : 'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png',
    );
  }

  Future<void> loadFromDatabase() async {
    final currentUserid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(currentUserid).get().then((value) {
      var user = User.fromMap(value.data());
      username = user.username;
      email = user.email;
      password = user.password;
      pets = user.pets;
      reportes = user.reportes;
      zones = user.zones;
      icon = user.icon;
      notificaciones = user.notificaciones;
    });
  }

  Future<void> updateDatabase() async {
    final userId = (await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get()).docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(userId).update(toMap());
  }

}