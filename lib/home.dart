import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/custom_appbar.dart';
import 'package:perdidos_ya/components/especies_buttons.dart';
import 'package:perdidos_ya/components/new_alert_buttons.dart';
import 'package:perdidos_ya/components/pet_alert_widget.dart';
import 'package:perdidos_ya/components/report_image.dart';
import 'package:perdidos_ya/components/report_info_card.dart';
import 'package:perdidos_ya/components/reports_filters.dart';
import 'package:perdidos_ya/objects/mensaje.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users;
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/objects/report.dart';
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

  Future<void> _agregarAnuncio(
      String titulo,
      String descripcion,
      String zona,
      String ubicacion,
      String especie,
      String raza,
      int base,
      String? imageUrl) async {
    String tablaBaseDeDatos = '';

    if (base == perdido) {
      tablaBaseDeDatos = 'Mascotas perdidas';
    } else if (base == encontrado) {
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

    FirebaseFirestore.instance
        .collection(tablaBaseDeDatos)
        .add(reporte.toMap());
    widget.user.reports.add(reporte);
    widget.user.updateDatabase();
    _updateReportesEnZona(zona, reporte);
  }

  void _updateReportesEnZona(String zonaBuscada, Reporte reporte) async {
    try {
      CollectionReference zonasRef =
          FirebaseFirestore.instance.collection('Zonas');
      QuerySnapshot snapshot =
          await zonasRef.where('zona', isEqualTo: zonaBuscada).get();

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

  void _mostrarDialogoAgregarAnuncio(int base) async {
    String titulo = '';
    String descripcion = '';
    String raza = '';
    String zona = '';
    String ubicacion = '';
    String especieSeleccionada = '';
    const zonas = Zona.values;
    Zona? zonaElegida;
    String? imageUrl;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Anuncio'),
          content: SingleChildScrollView(
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: ReportImage(imageUrl: imageUrl),
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
                      child: EspeciesButtons(onSelected: (especie) {
                        especieSeleccionada = especie;
                      }),
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
                  ),
                  TextField(
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
            }),
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
                _agregarAnuncio(titulo, descripcion, zona, ubicacion,
                    especieSeleccionada, raza, base, imageUrl);
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

  void mandarMensaje(String usuario, BuildContext context) {
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
                child: Column(children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Titulo'),
                    controller: tituloController,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'Descripción'),
                    controller: bodyController,
                  )
                ]),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    finalMensaje.title = tituloController.text;
                    finalMensaje.body = bodyController.text;
                    _enviarMensaje(usuario, finalMensaje);
                    Navigator.pop(context);
                  },
                  child: Text('Aceptar'),
                ),
              ]);
        });
  }

  void _mostrarAnuncio(Reporte reporte) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorTerciario,
          title: Center(
            child: Text(reporte.titulo),
          ),
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
        return Filters(
            mostrarBases: mostrarBases,
            refresh: () {
              setState(() {
                mostrarBases = mostrarBases;
              });
            });
      },
    );
  }

  Stream<QuerySnapshot<Object?>> obtenerMascotasDinamicas(int baseDatos) {
    String tablaBaseDeDatos = '';
    if (baseDatos == perdido) {
      tablaBaseDeDatos = 'Mascotas perdidas';
    } else if (baseDatos == encontrado) {
      tablaBaseDeDatos = 'Mascotas encontradas';
    }
    Query consulta = FirebaseFirestore.instance.collection(tablaBaseDeDatos);
    if (mostrarBases['Anuncios de gatos']! &&
        !(mostrarBases['Anuncios de perros']!)) {
      consulta = consulta.where("especie", isEqualTo: "Gato");
    } else if (mostrarBases['Anuncios de perros']! &&
        !(mostrarBases['Anuncios de gatos']!)) {
      consulta = consulta.where("especie", isEqualTo: "Perro");
    }
    if (widget.user.zones.isNotEmpty) {
      if (mostrarBases['Zonas preferidas']!) {
        consulta = consulta.where("zona",
            whereIn:
                widget.user.zones.map((zona) => zonaToString(zona)).toList());
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
            if (lostSnapshot.connectionState == ConnectionState.waiting ||
                foundSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // **Retorno de cargador mientras no hay datos**
            }
            if ((!lostSnapshot.hasData || lostSnapshot.data!.docs.isEmpty) &&
                (!foundSnapshot.hasData || foundSnapshot.data!.docs.isEmpty)) {
              return Center(child: Text('No hay anuncios disponibles.'));
            }
            List<QueryDocumentSnapshot<Object?>> lostAlerts = [];
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

            return ListView(
                children: combinedAlerts); // **Retorno de la lista combinada**
          },
        );
      },
    );
  }

  void _createPetAlertWidget(List<Widget> combinedAlerts,
      List<QueryDocumentSnapshot<Object?>> alerts) {
    for (var alert in alerts) {
      final report = Reporte.fromMap(alert.data() as Map<String, dynamic>);
      if (widget.user.email != report.email) {
        combinedAlerts.add(
          PetAlertWidget(
            username: report.user,
            reporte: report,
            onTap: () => _mostrarAnuncio(report)
          )
        );
      }
    }
  }

  Expanded listasFiltradas() {
    return Expanded(child: listasCombinadas());
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustomAppBar(user: widget.user, title: 'Inicio'),
      SizedBox(height: 20),
      Center(
        child: NewAlert(onPressed: _mostrarDialogoAgregarAnuncio),
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
      
      listasFiltradas(), //ACA VA LISTA FILTRADA
    ]);
  }
}