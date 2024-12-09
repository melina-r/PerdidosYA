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
    return StatefulBuilder(builder: (context, setState) => ExpansionTile(
        leading: Icon(section.icon, size: 30),
        title: Text(section.title, style: const TextStyle(fontSize: 24)),
        iconColor: colorPrincipalDos,
        collapsedIconColor: colorPrincipalUno,
        children: section.content,
      )
    );
  }
}

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