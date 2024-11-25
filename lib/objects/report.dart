class Reporte {
  String titulo;
  String zona;
  String ubicacion;
  String raza;
  String especie;
  String descripcion;
  String user;
  String imageUrl;

  Reporte({required this.titulo, required this.descripcion, required this.zona, required this.ubicacion, required this.raza, required this.especie, required this.user, required this.imageUrl});

  factory Reporte.fromMap(Map<String, dynamic> reporte) {
    return Reporte(
      titulo: reporte['titulo'] ?? '',
      zona: reporte['Zona'] ?? '',
      ubicacion: reporte['ubicacion'] ?? '',
      raza: reporte['raza'] ?? '',
      especie: reporte['especie'] ?? '',
      descripcion: reporte['descripcion'] ?? '',
      user: reporte['user'],
      imageUrl: reporte['imageUrl'] ?? ''
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
      'user': user,
      'imageUrl': imageUrl,
    };
  }
}