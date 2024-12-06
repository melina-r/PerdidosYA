import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/detail_tile.dart';
import 'package:perdidos_ya/objects/report.dart';

class ReportInfoCard extends StatelessWidget {
  final Reporte reporte;

  const ReportInfoCard({required this.reporte});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: reporte.imageUrl == null
              ?  Icon(Icons.help_center_outlined)
              : CachedNetworkImage(
                  imageUrl: reporte.imageUrl!,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
            ),
        DetailTile(title: 'Zona', info: reporte.zona),
        DetailTile(title: 'Especie', info: reporte.especie),
        DetailTile(title: 'Raza', info: reporte.raza),
        DetailTile(title: 'Descripción', info: reporte.descripcion),
        DetailTile(title: 'Ubicacion', info: reporte.ubicacion),
      ],
    );
  }
}