import 'package:flutter/material.dart';

class ReportImage extends StatelessWidget {
  final String? imageUrl;

  const ReportImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return imageUrl == null
      ? Icon(Icons.help_center_outlined) // Si imageUrl es null, mostrar el indicador de carga
      : Image.network(
        imageUrl!,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return CircularProgressIndicator();
        },
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      );
  }
}