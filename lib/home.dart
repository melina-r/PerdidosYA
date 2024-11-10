import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users;
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/objects/report.dart';

class HomePage extends StatelessWidget {
  final int perdido = 0;
  final int encontrado = 1;
  final bool mostrarBasePerdidos = true;
  final bool mostrarBaseEncontrados = true;
  final String baseMostrada = "Mascotas perdidas";
  final String queryLista = "";
  final BuildContext context;
  final users.User user;


  const HomePage({super.key, required this.context, required this.user});

  void _agregarAnuncio(String titulo, String descripcion, String zona, String ubicacion, String especie, String raza, int tipoAnuncio) {
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

    Reporte reporte = Reporte(
      titulo: titulo, 
      descripcion: descripcion,
      zona: zona,
      ubicacion: ubicacion,
      raza: raza,
      especie: especie,
      timestamp: FieldValue.serverTimestamp(),
      user: user.username
      );

    FirebaseFirestore.instance.collection(tablaBaseDeDatos).add(reporte.toMap());

    // _updateReportesEnZona(zona,reporte);
  }

//   void _updateReportesEnZona(String zonaBuscada, Reporte nuevoReporte) async {
//   CollectionReference zonasRef = FirebaseFirestore.instance.collection('Zonas');

//   QuerySnapshot snapshot = await zonasRef.get();
//   for (var doc in snapshot.docs) {
//     if (doc['zona'] == zonaBuscada) {
//       DocumentReference zonaRef = zonasRef.doc(doc.id);
//       zonaRef.update({
//         'reportes': FieldValue.arrayUnion([nuevoReporte.toMap()])
//       }).then((_) {
//         print("Reporte agregado al array con éxito");
//       }).catchError((error) {
//         print("Error al agregar el reporte: $error");
//       });
//       break;
//     }
//   }
// }

  

  void _mostrarDialogoAgregarAnuncio(int tipoAnuncio) {
    String titulo = '';
    String descripcion = '';
    String raza = '';
    String zona = '';
    String ubicacion = '';
    String especieSeleccionada = '';
    final List<String> especies = ['Gato','Perro'];
    bool botonGatoPresionado = false;
    bool botonPerroPresionado = false;
    final zonas = Zona.values;
    Zona? zonaElegida;
    

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
                        SizedBox(
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
                              backgroundColor: botonGatoPresionado? colorPrincipalDos:colorSecundarioUno
                            ),
                            splashColor: colorTerciario.withOpacity(0.5),
                            highlightColor: colorTerciario.withOpacity(0.3),   
                          ),
                        ),
                        SizedBox(
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
               Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Zona>(
                      hint: Text(zonaElegida != null ? zona : 'Zona'),
                      value: zonaElegida,
                      onChanged: (Zona? nuevaZona) {
                        setDialogState(() {
                          zonaElegida = nuevaZona;
                          zona = zonaToString(zonaElegida!);
                        });
                      },
                      items: zonas.map((Zona zona) {
                        return DropdownMenuItem<Zona>(
                        value: zona,
                        child: Text(zonaToString(zona)),
                      );
                    }).toList(),
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  descripcion = value;
                },
              ),TextField(
                decoration: InputDecoration(labelText: 'Ubicacion (opcional)'),
                onChanged: (value) {
                  ubicacion = value;
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
                _agregarAnuncio(titulo, descripcion, zona, ubicacion, especieSeleccionada, raza, tipoAnuncio);
                Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Widget anuncioShowAlert(String titulo, String descripcion, String zona, String ubicacion, String especie, String raza) {
    return SizedBox(
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
          ),ListTile(
            title: Text('Ubicacion:',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            subtitle: Text(ubicacion),
          ),
        ],
      )
    );
  }

  void _mostrarAnuncio(String titulo, String descripcion, String zona, String ubicacion, String especie, String raza) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorTerciario,
          title: Center(child: Text(titulo),),
          content:anuncioShowAlert(titulo, descripcion, zona, ubicacion, especie, raza),
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
              final ubicacion =alertData['ubicacion'];
              final user = alertData['user'];

              combinedAlerts.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(titulo),
                      onTap: (){
                        _mostrarAnuncio('$titulo', '$descripcion', '$zona', '$ubicacion', '$especie', '$raza' );},
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
              final ubicacion =alertData['ubicacion'];
              final user = alertData['user'];  

              combinedAlerts.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(user, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(titulo),
                      onTap: (){
                        
                        _mostrarAnuncio('$titulo', '$descripcion', '$zona', '$ubicacion', '$especie', '$raza' );},
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
    return Column(
        children: [
          AppBar(
            backgroundColor: colorPrincipalUno ,
            title: Center(child: Text('Inicio'),),
            automaticallyImplyLeading: false,
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
                SizedBox(
                  width: 150, // Ancho del primer botón
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      _mostrarDialogoAgregarAnuncio(this.perdido);
                    },// Texto del botón
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorSecundarioUno, // Color de fondo
                      foregroundColor: Colors.black, // Color del texto
                      shape: CircleBorder(),
                    ),
                    child: Text('Mascota Perdida', textAlign: TextAlign.center),  
                  ),
                ),
                SizedBox(
                  width: 150, // Ancho del primer botón
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      _mostrarDialogoAgregarAnuncio(this.encontrado);
                    },// Texto del botón
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorSecundarioUno, // Color de fondo
                      foregroundColor: Colors.black, // Color del texto
                      shape: CircleBorder(),
                    ),
                    child: Text('Mascota Encontrada', textAlign: TextAlign.center,),  
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
      );
  }
}
