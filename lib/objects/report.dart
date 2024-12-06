import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reporte {
  String titulo;
  String zona;
  String ubicacion;
  String raza;
  String especie;
  String descripcion;
  String user;
  String email;
  String? imageUrl;
  String type;
  String id;

  Reporte({required this.titulo, required this.descripcion, required this.zona, required this.ubicacion, required this.raza, required this.especie, required this.user, required this.email, required this.imageUrl, required this.type, required this.id});

  factory Reporte.fromMap(Map<String, dynamic> reporte) {
    final report = Reporte(
      titulo: reporte['titulo'] ?? '',
      zona: reporte['zona'] ?? '',
      ubicacion: reporte['ubicacion'] ?? '',
      raza: reporte['raza'] ?? '',
      especie: reporte['especie'] ?? '',
      descripcion: reporte['descripcion'] ?? '',
      user: reporte['user'] ?? '',
      email: reporte['email'] ?? '',
      imageUrl: reporte['imageUrl'] ?? '',
      type: reporte['type'] ?? 'Mascotas perdidas',
      id: reporte['id'] ?? generateId(reporte['type']),
    );
    return report;
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'zona': zona,
      'ubicacion': ubicacion,
      'raza': raza,
      'especie': especie,
      'descripcion': descripcion,
      'type': type,
      'id': id,
      'imageUrl': imageUrl,
      'user': user,
      'email': email,
    };
  }

  static generateId(String tablaBaseDeDatos) async {
    String idString = () {
      final random = Random();
      final id = List<int>.generate(10, (_) => random.nextInt(10)).join();
      return id;
    }();
    
    while ((await FirebaseFirestore.instance.collection(tablaBaseDeDatos).where('id', isEqualTo: idString).get()).docs.isNotEmpty) {
      idString = generateId(tablaBaseDeDatos);
    }
    return idString;
  }
}