import 'package:cloud_firestore/cloud_firestore.dart';

class Reporte {
  String titulo;
  String zona;
  String raza;
  String especie;
  String descripcion;
  final timestamp;
  String user;

  Reporte({required this.titulo, required this.descripcion, required this.zona, required this.raza, required this.especie, required this.timestamp, required this.user});

  factory Reporte.fromMap(Map<String, dynamic> reporte) {
    return Reporte(
      titulo: reporte['titulo'] ?? '',
      zona: reporte['Zona'] ?? '',
      raza: reporte['raza'] ?? '',
      especie: reporte['especie'] ?? '',
      descripcion: reporte['descripcion'] ?? '',
      timestamp: reporte['timestamp'],
      user: reporte['user'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'zona': zona,
      'raza': raza,
      'especie': especie,
      'descripcion': descripcion,
      'timestamp': timestamp,
      'user': user,
    };
  }
}