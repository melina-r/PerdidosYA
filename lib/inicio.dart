import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perdidos_ya/theme.dart';
import 'users.dart'; 
import 'profile.dart';
import 'users.dart'; // Asegúrate de importar la clase User


class Inicio extends StatefulWidget {
  final User user;

  const Inicio({required this.user});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0;
  final int perdido = 0;
  final int encontrado = 0;

  void _onItemTapped(int index) {
  if (index == 4) { // "Perfil"
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  } else {
    setState(() {
      _selectedIndex = index;
    });
  }
}


  void _agregarAnuncio(String titulo, String descripcion, String zona, String especie, String raza, int tipoAnuncio) {
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
    String especieSeleccionada = '';
    final List<String> especies = ['Gato','Perro'];
    bool botonGatoPresionado = false;
    bool botonPerroPresionado = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Anuncio'),
          content:SingleChildScrollView(
            child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
                    return  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Título'),
                        onChanged: (value) {
                          titulo = value;
                        },
                      ),
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
                          width: 80, // Ancho del primer botón
                          height:80,
                          child: IconButton(
                            icon: Icon(FontAwesomeIcons.cat),
                            onPressed: () {
                              setDialogState(() {
                                botonGatoPresionado = true;
                                botonPerroPresionado = false;
                                especieSeleccionada = especies[0];
                              });
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: botonGatoPresionado?Colors.blue:Colors.amber
                            ),
                            splashColor: Colors.red.withOpacity(0.5),
                            highlightColor: Colors.red.withOpacity(0.3),   
                          ),
                        ),
                        Container(
                          width: 80, // Ancho del primer botón
                          height: 80,
                          child: IconButton(
                            icon: Icon(FontAwesomeIcons.dog),
                            onPressed: () {
                              setDialogState(() {
                                botonGatoPresionado = false;
                                botonPerroPresionado = true;
                                especieSeleccionada = especies[1];
                              });
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: botonPerroPresionado?Colors.blue:Colors.amber
                            ),
                            
                            splashColor: Colors.red.withOpacity(0.5),
                            highlightColor: Colors.red.withOpacity(0.3), 
                          ),
                        ),
                      ],
                    ),
                  ),
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
          );
        }
        ),
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
                _agregarAnuncio(titulo, descripcion, zona, especieSeleccionada, raza, tipoAnuncio);
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

Widget anuncioShowAlert(String titulo, String descripcion, String zona, String especie, String raza) {
  return Container(
    height: 300.0,
    width: 300.0,
    child: ListView(
      children: [
        ListTile(
          title: Text('Zona:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          subtitle: Text(zona),
        ),
        ListTile(
          title: Text('Especie:',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          subtitle: Text(especie),
        ),
        ListTile(
          title: Text('Raza:',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          subtitle: Text(raza),
        ),
        ListTile(
          title: Text('Descripción:',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          subtitle: Text(descripcion),
        ),
      ],
    )
  );
}

void _mostrarAnuncio(String titulo, String descripcion, String zona, String especie, String raza) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(titulo),),
          content:anuncioShowAlert(titulo, descripcion, zona, especie, raza),
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
        backgroundColor: colorTerciario,
        title: Center(child: Text('Inicio'),),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: colorTerciario,    //Cambiar color  //Cambiar color
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