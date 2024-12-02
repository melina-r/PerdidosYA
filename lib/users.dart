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
  List<Reporte> reports = [];
  List<Zona> zones;
  String icon;
  bool notifications = true;

  User({required this.username, required this.email, required this.password, required this.pets, required this.zones, required this.reports, required this.icon, required this.notifications});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'pets': pets.map((pet) => pet.toMap()).toList(),
      'reports': reports.map((report) => report.toMap()).toList(),
      'zones': zones.map((zona) => zonaToString(zona)).toList(),
      'icon': icon,
      'notifications': notifications,
    };
  }

  static bool isNotEmpty(Map<String, dynamic> map, String key) {
    return map.containsKey(key) && map[key].length > 0;
  }

  static User fromMap(Object? userMap) {
    Map<String, dynamic> map = userMap as Map<String, dynamic>;
    return User(
      username: map['username'],
      email: map['email'],
      password: map['password'],
      pets: isNotEmpty(map, 'pets') ? List<Pet>.from(map['pets'].map((pet) => Pet.fromMap(pet))) : [],
      reports: isNotEmpty(map, 'reports') ? List<Reporte>.from(map['reports'].map((reporte) => Reporte.fromMap(reporte.toMap()))) : [],
      zones: isNotEmpty(map, 'zones') ? List<Zona>.from(map['zones'].map((zona) => stringToZona(zona))) : [],
      icon: map.containsKey("icon")? map['icon'] : 'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png',
      notifications: map['notifications'],
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
      reports = user.reports;
      zones = user.zones;
      icon = user.icon;
      notifications = user.notifications;
    });
  }

  Future<void> updateDatabase() async {
    final userId = (await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get()).docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(userId).update(toMap());
  }

  void deleteReport(Reporte report) {
    reports.remove(report);
    FirebaseFirestore.instance.collection(report.type).where('id', isEqualTo: report.id).get().then((value) {
      value.docs.first.reference.delete();
    });
    FirebaseFirestore.instance.collection('Zonas').where('zona', isEqualTo: report.zona).get().then((value) {
      value.docs.first.reference.update({
        'reports': FieldValue.arrayRemove([report.toMap()])
      });
    });
    updateDatabase();
  }

}