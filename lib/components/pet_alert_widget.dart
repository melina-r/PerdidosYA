import 'package:flutter/material.dart';
import 'package:perdidos_ya/objects/report.dart';

class PetAlertWidget extends StatelessWidget {
  final String username;
  final Reporte reporte;
  final VoidCallback onTap;

  const PetAlertWidget({required this.username, required this.reporte, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(reporte.titulo),
          onTap: onTap,
        ),
      ),
    );
  }

}