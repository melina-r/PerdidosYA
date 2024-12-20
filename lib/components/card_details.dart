import 'package:flutter/material.dart';
import 'package:perdidos_ya/constants.dart';
import 'package:perdidos_ya/theme.dart';

import '../objects/pet.dart';
import '../objects/report.dart';

class CardDetails extends ListTile {
  final String cardTitle;
  final List<Widget> contentList;
  final VoidCallback? longPress;

  const CardDetails({super.key, required this.cardTitle, required this.contentList, this.longPress});
  
  @override
  ListTile build(BuildContext context) {
    return ListTile(title: Text(cardTitle, style: TextStyle(fontSize: 20),), contentPadding: EdgeInsets.only(left: 40), leading: Icon(Icons.arrow_outward), onTap: () {_showDetailCard(context);}, onLongPress: longPress != null ? () {_showDialog(context, longPress);} : () {},);
  }

  void _showDetailCard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colorTerciario,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 500,
          width: 720,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  cardTitle,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(child: ListView(
                  children: contentList,
                ))                
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context, VoidCallback? longPress) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorTerciario,
          title: const Text("¿Estás seguro de que deseas eliminar este reporte?"),
          actions: [
            TextButton(
              onPressed: () {
                longPress!();
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      }
    );
  }
}

class PetDetails extends CardDetails {
  final Pet petInfo;
  PetDetails({required this.petInfo})
        : super(
            cardTitle: petInfo.name, 
            contentList: _buildContentList(petInfo),
          );

  static List<Widget> _buildContentList(Pet petInfo) {
    return [
      Image.network(petInfo.imageUrl!, height: 200, fit: BoxFit.contain),
      Text("Edad: ${petInfo.ageString}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), 
      Text("Tamaño: ${petInfo.sizeString}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), 
      Text("Color: ${petInfo.color}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      Text("Raza: ${petInfo.razaString}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      SizedBox(height: 20),
      Text((petInfo.description != null) ? "${petInfo.description}" : emptyDescription, style: TextStyle(fontSize: 18),), 
    ];
  }
}

class ReportDetails extends CardDetails {
  final Reporte reportInfo;
  final VoidCallback deleteFunction;

  ReportDetails({required this.reportInfo, required this.deleteFunction})
      : super(
          cardTitle: reportInfo.titulo, 
          contentList: _buildContentList(reportInfo),
          longPress: deleteFunction,
        );

  static List<Widget> _buildContentList(Reporte reportInfo) {
    return [
      Image.network(reportInfo.imageUrl ?? defaultReportImage, height: 200, fit: BoxFit.contain),
      const SizedBox(height: 20),
      Text("Especie: ${reportInfo.especie}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      Text("Raza: ${reportInfo.raza}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      Text("Zona: ${reportInfo.zona}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      const SizedBox(height: 20),
      Text(reportInfo.descripcion, style: const TextStyle(fontSize: 18),),
    ];
  }
}