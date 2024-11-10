import 'package:cloud_firestore/cloud_firestore.dart';

class Reporte {
  String titulo;
  String zona;
  String ubicacion;
  String raza;
  String especie;
  String descripcion;
  dynamic timestamp;
  String user;

  Reporte({required this.titulo, required this.descripcion, required this.zona, required this.ubicacion, required this.raza, required this.especie, required this.timestamp, required this.user});

  factory Reporte.fromMap(Map<String, dynamic> reporte) {
    return Reporte(
      titulo: reporte['titulo'] ?? '',
      zona: reporte['Zona'] ?? '',
      ubicacion: reporte['ubicacion'] ?? '',
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
      'ubicacion': ubicacion,
      'raza': raza,
      'especie': especie,
      'descripcion': descripcion,
      'timestamp': timestamp,
      'user': user,
    };
  }
}