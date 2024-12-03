import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perdidos_ya/objects/mensaje.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users;
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/objects/report.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:perdidos_ya/cloudinary.dart';

class HomePage extends StatefulWidget {
  final users.User user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int perdido = 0;
  final int encontrado = 1;
  Map<String, bool> mostrarBases = {
    'Mascotas perdidas': true,
    'Mascotas encontradas': true,
    'Anuncios de gatos': true,
    'Anuncios de perros': true,
    'Zonas preferidas': true,
  };
  final String baseMostrada = "Mascotas perdidas";
  final String queryLista = "";
  final String imageCatAPI = "https://api.thecatapi.com/v1/images/search";
  final String imageDogAPI = "https://dog.ceo/api/breeds/image/random";

  Future<void> _agregarAnuncio(String titulo, String descripcion, String zona, String ubicacion, String especie, String raza, int base, String? imageUrl) async {
    String tablaBaseDeDatos = '';
    
    if(base == perdido){
        tablaBaseDeDatos = 'Mascotas perdidas';
    }
    else if (base == encontrado){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Agregando a encontrados')),
      );
      tablaBaseDeDatos = 'Mascotas encontradas';
    }

    String id = await Reporte.generateId(tablaBaseDeDatos);

    Reporte reporte = Reporte(
      titulo: titulo, 
      descripcion: descripcion,
      zona: zona,
      ubicacion: ubicacion,
      raza: raza,
      especie: especie,
      user: widget.user.username,
      imageUrl: imageUrl!,
      id: id,
      type: tablaBaseDeDatos,
      email: widget.user.email
    );

    FirebaseFirestore.instance.collection(tablaBaseDeDatos).add(reporte.toMap());
    widget.user.reports.add(reporte);
    widget.user.updateDatabase();
    _updateReportesEnZona(zona,reporte);
  }

  void _updateReportesEnZona(String zonaBuscada, Reporte reporte) async {
    try {
      CollectionReference zonasRef = FirebaseFirestore.instance.collection('Zonas');
      QuerySnapshot snapshot = await zonasRef.where('zona', isEqualTo: zonaBuscada).get();

      if (snapshot.docs.isNotEmpty) {
        DocumentReference zonaRef = snapshot.docs.first.reference;

        await zonaRef.update({
          'reports': FieldValue.arrayUnion([reporte.toMap()])
        });

        print("Reporte agregado al array con éxito");
      } else {
        print("No se encontró la zona: $zonaBuscada");
      }
    } catch (error) {
    print("Error al agregar el reporte: $error");
  }
}
  
// Future<String?> obtenerImagenAleatoria(String urlAPI, String especieElegida) async {
//   String? imageUrl;
//     final response = await http.get(Uri.parse(urlAPI));
//     if (response.statusCode == 200) {
//       dynamic data = json.decode(response.body);
//       if(especieElegida == 'Gato'){
//         print(data);
//         imageUrl =  data.isNotEmpty ? data[0]['url'] : null;
//       }else{
//         print(data);
//         imageUrl =  data['message'];
//       }
//       return imageUrl;
//     }else {
//       throw Exception('Failed to load image');
//     }
//   }

  void _mostrarDialogoAgregarAnuncio(int base) async {
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
    // String urlAPI = 'vacio';
    String? imageUrl;


    await showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Agregar Anuncio'),
            content:SingleChildScrollView(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setDialogState){
                  return  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: imageUrl == null
                          ? Icon(Icons.help_center_outlined) // Si imageUrl es null, mostrar el indicador de carga
                          : Image.network(
                            imageUrl!,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return CircularProgressIndicator();
                            },
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                          ),
                      ),
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
                              onPressed: () async{
                                setDialogState(() {
                                  botonGatoPresionado = true;
                                  botonPerroPresionado = false;
                                  // urlAPI = imageCatAPI;
                                  especieSeleccionada = especies[0];
                                });
                                // imageUrl = await obtenerImagenAleatoria(urlAPI, especieSeleccionada);
                                setDialogState(() {});
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
                              onPressed: () async {
                                setDialogState(() {
                                  botonGatoPresionado = false;
                                  botonPerroPresionado = true;
                                  // urlAPI = imageDogAPI;
                                  especieSeleccionada = especies[1];
                                });
                                // imageUrl = await obtenerImagenAleatoria(urlAPI, especieSeleccionada);
                                setDialogState(() {});
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
                SizedBox(height: 20),
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
                TextButton(
                  onPressed: () async {
                    setDialogState(() {});
                  String? path = await pickAndUploadImage();
                  setDialogState(() {
                    imageUrl = path;
                  });
                },
                child: Text('Agregar Imagen'),
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
                onPressed: (){
                  _agregarAnuncio(titulo, descripcion, zona, ubicacion, especieSeleccionada, raza, base, imageUrl);
                  Navigator.of(context).pop();
                },
                child: const Text('Agregar'),
              ),
            ],
          );
        },
      );
    }

    Widget anuncioShowAlert(Reporte reporte) {
    return SizedBox(
      height: 300.0,
      width: 300.0,
      child: ReportInfoCard(reporte: reporte),
    );
  }

  void _enviarMensaje(String usuario, Mensaje mensaje) async {
      try {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: usuario)
          .get();

      if (userSnapshot.docs.isEmpty) {
        print('Usuario no encontrado');
        return;
      }

      DocumentSnapshot userDoc = userSnapshot.docs.first;

      await userDoc.reference.update({
        'messages': FieldValue.arrayUnion([mensaje.toMap()]),
      });
      } catch (e) {
        print('Error al enviar mensaje: $e');
      }
  }


  void mandarMensaje(String usuario,BuildContext context){
      TextEditingController tituloController = TextEditingController();
      TextEditingController bodyController = TextEditingController();
      Mensaje finalMensaje = Mensaje(
        title: "Titulo",
        body: "Body",
        from: widget.user.username,
        received: Timestamp.now(),
      );
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensaje'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Titulo'),
                  controller: tituloController,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Descripción'),
                  controller: bodyController,
                )
              ]
            ),
          ),
          actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  finalMensaje.title = tituloController.text;
                  finalMensaje.body =  bodyController.text;
                  _enviarMensaje(usuario, finalMensaje);
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
          ]
        );
      }
    );
  }

  void _mostrarAnuncio(Reporte reporte) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorTerciario,
          title: Center(child: Text(reporte.titulo),),
          content: anuncioShowAlert(reporte),
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
                mandarMensaje(reporte.user, context);
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
        return Filters(mostrarBases: mostrarBases, refresh: () {
          setState(() {
            mostrarBases = mostrarBases;
          });
        });
      },
    );
  }

  Stream<QuerySnapshot<Object?>> obtenerMascotasDinamicas(int baseDatos){
    String tablaBaseDeDatos = '';
      if(baseDatos == perdido){
          tablaBaseDeDatos = 'Mascotas perdidas';
      }
      else if(baseDatos == encontrado){
        tablaBaseDeDatos = 'Mascotas encontradas';
      }
    Query consulta= FirebaseFirestore.instance.collection(tablaBaseDeDatos);
    if (mostrarBases['Anuncios de gatos']! && !(mostrarBases['Anuncios de perros']!)){
      consulta = consulta.where("especie", isEqualTo: "Gato");
    }
    else if (mostrarBases['Anuncios de perros']! && !(mostrarBases['Anuncios de gatos']!)){
      consulta = consulta.where("especie", isEqualTo: "Perro");
    }
    if (widget.user.zones.isNotEmpty){
      if (mostrarBases['Zonas preferidas']!){
        consulta = consulta.where("zona", whereIn: widget.user.zones.map((zona) => zonaToString(zona)).toList());
      }
    }
    return consulta.snapshots();
  }

  Widget listasCombinadas() {
    return StreamBuilder<QuerySnapshot>(
      stream: obtenerMascotasDinamicas(perdido),
      builder: (context, lostSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: obtenerMascotasDinamicas(encontrado),
          builder: (context, foundSnapshot) {
          if (lostSnapshot.connectionState == ConnectionState.waiting || foundSnapshot.connectionState == ConnectionState.waiting ) {
            return Center(child: CircularProgressIndicator()); // **Retorno de cargador mientras no hay datos**
          }
          if ((!lostSnapshot.hasData || lostSnapshot.data!.docs.isEmpty) && (!foundSnapshot.hasData || foundSnapshot.data!.docs.isEmpty) ) {
            return Center(child: Text('No hay anuncios disponibles.'));
          } 
            List<QueryDocumentSnapshot<Object?>>  lostAlerts = [];
            List<QueryDocumentSnapshot<Object?>> foundAlerts = [];

            if (mostrarBases['Mascotas perdidas']!) {
              lostAlerts = lostSnapshot.data!.docs;
            }
            if (mostrarBases['Mascotas encontradas']!) { 
              foundAlerts = foundSnapshot.data!.docs;
            }

            List<Widget> combinedAlerts = [];
            // Agregar mascotas perdidas
            _createPetAlertWidget(combinedAlerts, lostAlerts);

            // Agregar mascotas encontradas
            _createPetAlertWidget(combinedAlerts, foundAlerts);

            return ListView(children: combinedAlerts); // **Retorno de la lista combinada**
          },
        );
      },
    );
  }

  void _createPetAlertWidget(List<Widget> combinedAlerts, List<QueryDocumentSnapshot<Object?>> alerts) {
    for (var alert in alerts) {
      final report = Reporte.fromMap(alert.data() as Map<String, dynamic>);
      if (widget.user.email != report.email){
        combinedAlerts.add(
          PetAlertWidget(username: report.user, reporte: report, onTap: () => _mostrarAnuncio(report))
        );
      }
    }
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
                      _mostrarDialogoAgregarAnuncio(perdido);
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
                      _mostrarDialogoAgregarAnuncio(encontrado);
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

class ReportInfoCard extends StatelessWidget {
  final Reporte reporte;

  const ReportInfoCard({required this.reporte});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: reporte.imageUrl == null
              ?  Icon(Icons.help_center_outlined)
              : CachedNetworkImage(
                  imageUrl: reporte.imageUrl!,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
            ),
        DetailTile(title: 'Zona', info: reporte.zona),
        DetailTile(title: 'Especie', info: reporte.especie),
        DetailTile(title: 'Raza', info: reporte.raza),
        DetailTile(title: 'Descripción', info: reporte.descripcion),
        DetailTile(title: 'Ubicacion', info: reporte.ubicacion),
      ],
    );
  }
}

class PetAlertWidget extends StatelessWidget {
  final String username;
  final Reporte reporte;
  final VoidCallback onTap;

  const PetAlertWidget({required this.username, required this.reporte, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          title: Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(reporte.titulo),
          onTap: onTap,
        ),
      ),
    );
  }

}

// class RandomImage {
//   static Future<String?> obtenerImagenAleatoria(String especieElegida) async {
//     const String imageCatAPI = "https://api.thecatapi.com/v1/images/search";
//     const String imageDogAPI = "https://dog.ceo/api/breeds/image/random";
    
//     String? imageUrl;

//     final response = await http.get(Uri.parse(especieElegida == 'Gato' ? imageCatAPI : imageDogAPI));

//     if (response.statusCode == 200) {
//       dynamic data = json.decode(response.body);

//       if (especieElegida == 'Gato'){
//         print(data);
//         imageUrl =  data.isNotEmpty ? data[0]['url'] : null;
//       }else{
//         print(data);
//         imageUrl =  data['message'];
//       }

//       return imageUrl;
      
//     }else {
//       throw Exception('Failed to load image');
//     }
//   }


// }

class ReportsFilterButton extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ReportsFilterButton({required this.text, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

}

class Filters extends StatelessWidget {
  final Map<String, bool> mostrarBases;
  final VoidCallback refresh;

  const Filters({super.key, required this.mostrarBases, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          backgroundColor: colorTerciario,
          title: Center(child: Text('Filtrar'),),
          content: Container(
            height: 400,
            width: 300,
            child: Center(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                      return  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: 
                        List<Widget>.from(mostrarBases.keys.map((key) {
                          return ReportsFilterButton(
                            text: key,
                            value: mostrarBases[key]!,
                            onChanged: (bool value) {
                              setDialogState(() {
                                mostrarBases[key] = value;
                                refresh();
                              });
                            },
                          );
                        }).toList()) + [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  ),
              ),
          ),
        );
  }
}

class DetailTile extends StatelessWidget {
  final String title;
  final String info;

  const DetailTile({required this.title, required this.info});

  @override
  Widget build(BuildContext context) {
    print('title: $title, info: $info');
    return ListTile(
      title: Text('$title:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      subtitle: Text(info),
    );
  }
}