import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'users.dart'; // Asegúrate de importar la clase User

class Inicio extends StatefulWidget {
  final User user;

  Inicio({required this.user});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0;
  final int perdido = 0;
  final int encontrado = 0;

  void _onItemTapped(int index) {
    if (index == 2) {                     //"Agregar"
      _mostrarDialogoAgregarAnuncio(this.perdido);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _agregarAnuncio(String titulo, String descripcion, String zona, String? especie, String raza, int tipoAnuncio) {
    String tablaBaseDeDatos = '';
    if(tipoAnuncio == this.perdido){
        tablaBaseDeDatos = 'Mascotas perdidas';
    }
    else if(tipoAnuncio == this.encontrado){
      tablaBaseDeDatos = 'Mascotas encontradas';
    }
    FirebaseFirestore.instance.collection(tablaBaseDeDatos).add({
      'Zona': zona,
      'user': widget.user.username,
      'especie': especie,
      'raza': raza,
      'titulo': titulo,
      'descripcion': descripcion,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _mostrarDialogoAgregarAnuncio(int tipoAnuncio) {
    String titulo = '';
    String descripcion = '';
    String raza = '';
    String zona = '';
    String? _especieSeleccionada;
    final List<String> especies = ['Gato','Perro'];

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
            DropdownButton<String>(
              hint: Text('Selecciona una opción'),
              value: _especieSeleccionada, // Valor actual
              onChanged: (String? newValue) {
                setState(() {
                  print(newValue);
                  _especieSeleccionada = newValue; // Actualiza el valor seleccionado
                });
              },
              items: especies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
              TextField(
                decoration: InputDecoration(labelText: 'Raza'),
                onChanged: (value) {
                  raza = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Codigo Postal'),
                onChanged: (value) {
                  zona= value;
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
                _agregarAnuncio(titulo, descripcion, zona, _especieSeleccionada, raza, tipoAnuncio);
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

void _mostrarAnuncio(String titulo, String descripcion, String zona, String especie, String raza) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [Text('Especie: ', style: TextStyle(fontWeight: FontWeight.bold,),),Text(especie)]),
              Row(children: [Text('Raza: ', style: TextStyle(fontWeight: FontWeight.bold,),),Text(raza)]),
              Row(children: [Text('Codigo Postal: ', style: TextStyle(fontWeight: FontWeight.bold,),),Text(zona)]),
              Row(children: [Text('Descripción: ', style: TextStyle(fontWeight: FontWeight.bold,),),Text(descripcion)]),
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
                Navigator.of(context).pop();
              },
              child: const Text('Mandar Mensaje'),
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
        backgroundColor: Colors.amber,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
      ),
      title: Text('Inicio'),
      ),
      backgroundColor: Colors.white,    //Cambiar color
      body:
      Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(5.0), // Espaciado interno
              decoration: BoxDecoration(
                color: Colors.transparent, // Color de fondo 
              ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Espacio entre botones
              children: [
                Container(
                  width: 150, // Ancho del primer botón
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      _mostrarDialogoAgregarAnuncio(this.perdido);
                    },
                    child: Text('Mascota Perdida', textAlign: TextAlign.center),// Texto del botón
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color de fondo
                      foregroundColor: Colors.white, // Color del texto
                      shape: CircleBorder(),
                    ),  
                  ),
                ),
                Container(
                  width: 150, // Ancho del primer botón
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      _mostrarDialogoAgregarAnuncio(this.encontrado);
                    },
                    child: Text('Mascota Encontrada', textAlign: TextAlign.center,),// Texto del botón
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Color de fondo
                      foregroundColor: Colors.white, // Color del texto
                      shape: CircleBorder(),
                    ),  
                  ),
                ),
              ],
            ),
          ),
        ),
          Expanded(child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Mascotas perdidas')
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
                final raza = alertData['raza'];
                final especie = alertData['especie'];
                final zona = alertData['Zona'];
                final user = alertData['user'];


                final alertWidget = Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text('$user: $titulo', style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: (){
                        
                        _mostrarAnuncio('$titulo', '$descripcion', '$zona', '$especie', '$raza' );},
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
        ),
      ]
      ),
      drawer: drawerMenu(context),
    );
  }
}




Drawer drawerMenu (context){
  return Drawer( // El Drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
              Container(
                height: 40,
                color: Colors.transparent, // Color de fondo del encabezado
              ),
              Container(
                  width: 150, // Ancho del primer botón
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Botón presionado');
                    },
                    child: Text('Perfil', textAlign: TextAlign.center,),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: CircleBorder(),
                    ),  
                  ),
                ),
            Divider(),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Mapa'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Mensajes'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
}
