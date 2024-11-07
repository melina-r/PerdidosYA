import 'package:flutter/material.dart';
import 'package:perdidos_ya/theme.dart';

import '../objects/pet.dart';
import '../objects/report.dart';

class CardDetails extends ListTile {
  final String cardTitle;
  final List<Widget> contentList;

  const CardDetails({super.key, required this.cardTitle, required this.contentList});
  
  @override
  ListTile build(BuildContext context) {
    return ListTile(title: Text(cardTitle, style: TextStyle(fontSize: 20),), contentPadding: EdgeInsets.only(left: 40), leading: Icon(Icons.arrow_outward), onTap: () {_showDetailCard(context);},);
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
      Text("Edad: ${_getStringValue(petInfo.age)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), 
      Text("Tamaño: ${_getStringValue(petInfo.size)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), 
      Text("Color: ${petInfo.color}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      SizedBox(height: 20),
      Text((petInfo.description != null) ? "${petInfo.description}" : "Sin descripción.", style: TextStyle(fontSize: 18),), 
    ];
  }
  
  static String _getStringValue(Enum value) {
    return value.toString().split('.').last;
  }

}

class ReportDetails extends CardDetails {
  final Reporte reportInfo;
  ReportDetails({required this.reportInfo})
      : super(
          cardTitle: reportInfo.titulo, 
          contentList: _buildContentList(reportInfo),
        );

  static List<Widget> _buildContentList(Reporte reportInfo) {
    return [
      Text("Especie: ${reportInfo.especie}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      Text("Raza: ${reportInfo.raza}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      Text("Zona: ${reportInfo.zona}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      const SizedBox(height: 20),
      Text(reportInfo.descripcion, style: const TextStyle(fontSize: 18),),
    ];
  }
}