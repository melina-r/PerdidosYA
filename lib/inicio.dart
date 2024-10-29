import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perdidos_ya/theme.dart';
import 'users.dart'; // Asegúrate de importar la clase User

class Inicio extends StatefulWidget {
  final User user;

  const Inicio({required this.user});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {                     //"Agregar"
      _mostrarDialogoAgregarAnuncio();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _agregarAnuncio(String titulo, String descripcion) {
    // Guardar el anuncio en Firestore con una marca de tiempo
    FirebaseFirestore.instance.collection('alerts').add({
      'user': widget.user.username,
      'titulo': titulo,
      'descripcion': descripcion,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _mostrarDialogoAgregarAnuncio() {
    String titulo = '';
    String descripcion = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Anuncio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Título'),
                onChanged: (value) {
                  titulo = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  descripcion = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _agregarAnuncio(titulo, descripcion);
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: colorTerciario,    //Cambiar color
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('alerts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final alerts = snapshot.data!.docs;

          List<Widget> alertWidgets = [];
          for (var alert in alerts) {
            final alertData = alert.data() as Map<String, dynamic>;
            final titulo = alertData['titulo'];
            final descripcion = alertData['descripcion'];
            final user = alertData['user'];

            final alertWidget = Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text('$user: $titulo', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(descripcion),
                ),
              ),
            );

            alertWidgets.add(alertWidget);
          }

          return ListView(
            children: alertWidgets,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 45.0),
            label: 'Agregar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorSecundarioUno,
        onTap: _onItemTapped,
      ),
    );
  }
}