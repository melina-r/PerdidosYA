import 'package:flutter/material.dart';

class ToggleList extends StatelessWidget {
  final List<ToggleData> sections;

  // Constructor para recibir una lista de secciones
  const ToggleList({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: sections.map((section) => _buildToggleSection(section)).toList(),
    );
  }

  // Método para construir una sección genérica de ExpansionTile
  Widget _buildToggleSection(ToggleData section) {
    return ExpansionTile(
      leading: Icon(section.icon),
      title: Text(section.title),
      children: _buildTiles(section.content),
    );
  }

  // Método para construir las ListTiles
  List<Widget> _buildTiles(List<String> content) {
    return content.map((item) => ListTile(title: Text(item))).toList();
  }
}

// Clase de datos para encapsular cada sección de la lista
class ToggleData {
  final IconData icon;
  final String title;
  final List<String> content;

  ToggleData({
    required this.icon,
    required this.title,
    required this.content,
  });
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile_picture.png'),
              ),
              SizedBox(height: 10),
              Text(
                '@username',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ToggleList(
                sections: [
                  ToggleData(
                    icon: Icons.pets,
                    title: 'Mascotas',
                    content: ['Firulais', 'Michifus'],
                  ),
                  ToggleData(
                    icon: Icons.location_on,
                    title: 'Zonas preferidas',
                    content: ['Belgrano', 'San Telmo'],
                  ),
                  ToggleData(
                    icon: Icons.announcement,
                    title: 'Mis anuncios',
                    content: ['Publica y gestiona tus anuncios'],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

