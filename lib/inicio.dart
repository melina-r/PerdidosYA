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
  final int encontrado = 1;
  final bool mostrarBasePerdidos = true;
  final bool mostrarBaseEncontrados = true;
  final String baseMostrada = "Mascotas perdidas";
  final String queryLista = "";

  void _onItemTapped(int index) {
  if (index == 3) { // "Perfil"
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage(user: widget.user)),
    );
  } else {
    setState(() {
      _selectedIndex = index;
    });
  }
}


  void _agregarAnuncio(String titulo, String descripcion, String zona, String especie, String raza, int tipoAnuncio) {
    String tablaBaseDeDatos = '';
    if(tipoAnuncio == perdido){
        tablaBaseDeDatos = 'Mascotas perdidas';
    }
    else if(tipoAnuncio == encontrado){
      ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Agrgando a encontrados')),
                );
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
                              backgroundColor: botonGatoPresionado?colorPrincipalDos:colorSecundarioUno
                            ),
                            splashColor: colorTerciario.withOpacity(0.5),
                            highlightColor: colorTerciario.withOpacity(0.3),   
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
                              backgroundColor: botonPerroPresionado?colorPrincipalDos:colorSecundarioUno
                            ),
                            
                            splashColor: colorTerciario.withOpacity(0.5),
                            highlightColor: colorTerciario.withOpacity(0.3), 
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
          backgroundColor: colorTerciario,
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

 void _mostrarFiltros() {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorTerciario,
          title: Center(child: Text('hola'),),
          content:Center(child: Text('hola'),),
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


Widget listasCombinadas() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Mascotas perdidas')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, lostSnapshot) {
        if (!lostSnapshot.hasData) {
          return Center(child: CircularProgressIndicator()); // **Retorno de cargador mientras no hay datos**
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Mascotas encontradas')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, foundSnapshot) {
            if (!foundSnapshot.hasData) {
              return Center(child: CircularProgressIndicator()); // **Retorno de cargador mientras no hay datos**
            }
            List<QueryDocumentSnapshot<Object?>>  lostAlerts = [];
            List<QueryDocumentSnapshot<Object?>> foundAlerts = [];
            if(mostrarBasePerdidos){
              lostAlerts = lostSnapshot.data!.docs;
            }
            if(mostrarBaseEncontrados){
              foundAlerts = foundSnapshot.data!.docs;
            }

            List<Widget> combinedAlerts = [];

            // Agregar mascotas perdidas
            for (var alert in lostAlerts) {
              final alertData = alert.data() as Map<String, dynamic>;
              final titulo = alertData['titulo'];
              final descripcion = alertData['descripcion'];
              final raza = alertData['raza'];
              final especie = alertData['especie'];
              final zona = alertData['Zona'];
              final user = alertData['user'];

              combinedAlerts.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(titulo),
                      onTap: (){
                        _mostrarAnuncio('$titulo', '$descripcion', '$zona', '$especie', '$raza' );},
                    ),
                  ),
                ),
              );
            }

            // Agregar mascotas encontradas
            for (var alert in foundAlerts) {
              final alertData = alert.data() as Map<String, dynamic>;
              final titulo = alertData['titulo'];
              final descripcion = alertData['descripcion'];
              final raza = alertData['raza'];
              final especie = alertData['especie'];
              final zona = alertData['Zona'];
              final user = alertData['user'];  

              combinedAlerts.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(titulo),
                      onTap: (){
                        
                        _mostrarAnuncio('$titulo', '$descripcion', '$zona', '$especie', '$raza' );},
                    ),
                  ),
                ),
              );
            }
            return ListView(children: combinedAlerts); // **Retorno de la lista combinada**
          },
        );
      },
    );
  }



Expanded listasFiltradas(){
      return Expanded(child: listasCombinadas());
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrincipalUno ,
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
                      backgroundColor: colorSecundarioUno, // Color de fondo
                      foregroundColor: Colors.black, // Color del texto
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
                      backgroundColor: colorSecundarioUno, // Color de fondo
                      foregroundColor: Colors.black, // Color del texto
                      shape: CircleBorder(),
                    ),  
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
            alignment: Alignment.bottomLeft, // Alinea el botón a la izquierda
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton(
                onPressed: () {
                _mostrarFiltros();
              },
            child: Icon(Icons.filter_list),
            ),
          )
        ),
        listasFiltradas(),//ACA VA LISTA FILTRADA
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
        selectedItemColor: colorPrincipalDos,
        onTap: _onItemTapped,
      ),
    );
  }
}
