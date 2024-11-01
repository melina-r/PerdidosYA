import 'package:flutter/material.dart';
import 'package:perdidos_ya/theme.dart';

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
    return 
    
    ExpansionTile(
      leading: Icon(section.icon),
      title: Text(section.title),
      iconColor: colorPrincipalUno,
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