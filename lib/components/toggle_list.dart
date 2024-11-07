import 'package:flutter/material.dart';
import 'package:perdidos_ya/objects/pet.dart';

class ToggleList extends StatelessWidget {
  final List<ToggleData> sections;

  const ToggleList({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: sections.map((section) => _buildToggleSection(section)).toList(),
    );
  }

  Widget _buildToggleSection(ToggleData section) {
    return ExpansionTile(
      leading: Icon(section.icon),
      title: Text(section.title),
      children: section.content,
    );
  }
}

// Clase de datos para encapsular cada sección de la lista
class ToggleData {
  final IconData icon;
  final String title;
  final List<ListTile> content;

  ToggleData({
    required this.icon,
    required this.title,
    required this.content,
  });
}

class PetDetails extends ListTile {
  final Pet petInfo;

  const PetDetails({super.key, required this.petInfo});

  @override
  ListTile build(BuildContext context) {
    return ListTile(title: Text(petInfo.name), onTap: () {_showDetailCard(context);},);
  }  

  void _showDetailCard(BuildContext context) {
    String petSize = petInfo.size.toString().split(".").last;
    final petAge = petInfo.age.toString().split(".").last;
    final petColor = petInfo.color.toString().split(".").last;

    showModalBottomSheet(
      context: context,
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
                  petInfo.name,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(child: ListView(
                  children: [
                    Text('Tamaño: $petSize', style: TextStyle(fontSize: 25)),
                    Text('Edad: $petAge', style: TextStyle(fontSize: 25)),
                    Text('Color: $petColor', style: TextStyle(fontSize: 25)),
                    Text(
                      (petInfo.description != null) ? petInfo.description! : "Sin información",
                      style: const TextStyle(fontSize: 25),
                    ),
                    const SizedBox(height: 20),
                  ],
                ))                
              ],
            ),
          ),
        );
      },
    );
  }

}

