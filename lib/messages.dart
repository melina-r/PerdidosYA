import 'package:flutter/material.dart';
import 'package:perdidos_ya/objects/mensaje.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users;
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesPage extends StatefulWidget {
  final users.User user;

  MessagesPage({super.key, required this.user});

  @override
  _MessagesPageState createState() => _MessagesPageState();
}


class _MessagesPageState extends State<MessagesPage> {

Widget MensajeShowAlert(String body, String from, Timestamp recibido) {
    return SizedBox(
      height: 300.0,
      width: 300.0,
      child: ListView(
        children: [
          ListTile(
            title: Text('body:',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            subtitle: Text(body),
          ),
          ListTile(
            title: Text('De:',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            subtitle: Text(from),
          ),
          ListTile(
            title: Text('recibido:',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            subtitle: Text(recibido.toDate().day.toString()+'/'+recibido.toDate().month.toString()+'/'+recibido.toDate().year.toString()),
          ),
        ],
      )
    );
  }

  void _mostrarMensaje(String titulo, String body, String from, dynamic recibido) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorTerciario,
          title: Center(child: Text(titulo),),
          content:MensajeShowAlert(body,from,recibido),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

void _eliminarMensaje(Mensaje mensaje) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: widget.user.username)
        .get();

    if (userSnapshot.docs.isEmpty) {
      print('Usuario no encontrado');
      return;
    }

    DocumentSnapshot userDoc = userSnapshot.docs.first;

    await userDoc.reference.update({
      'messages': FieldValue.arrayRemove([mensaje.toMap()]),
    });
    } catch (e) {
      print('Error al eliminar el mensaje: $e');
    }
}

void eliminarMensaje(String title, String body, String from, dynamic received){
  Mensaje finalMensaje = Mensaje(
      title: title,
      body: body,
      from: from,
      received: received
    );
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("¿Eliminar mensaje de forma definitiva?"),
        actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                _eliminarMensaje(finalMensaje);
                Navigator.pop(context);
              },
              child: Text('Eliminar'),
            ),
        ]
      );
    }
  ); 
}

  Widget listarMensajes(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: widget.user.email)
              .snapshots(),
      builder: (context, messageSnapshot) {
        if (messageSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // **Retorno de cargador mientras no hay datos**
        }
        if (!messageSnapshot.hasData || messageSnapshot.data!.docs.isEmpty) {
          return Center(child: Text('No hay mensajes disponibles.'));
        }
        final userDoc = messageSnapshot.data!.docs.first;
        List<dynamic> messagesAlerts = userDoc['messages'] ?? [];
        List<Widget> mensajes = messagesAlerts.map((mensaje) {
          final titulo = mensaje['title'] ?? 'Sin título';
          final body = mensaje['body'] ?? 'Sin contenido';
          final from = mensaje['from'] ?? 'Remitente desconocido';
          dynamic recibido = mensaje['received'];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2.0,
              child: ListTile(
                title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(from),
                trailing: IconButton(
                icon: Icon(Icons.delete),
                  onPressed: () {
                      eliminarMensaje(titulo, body, from, recibido);
                  }
                ),
                onTap: () {
                  _mostrarMensaje(titulo, body, from, recibido);
                },
              ),
            ),
          );
        }).toList();

        // Retornar la lista de mensajes como un ListView
        return ListView.builder(
          itemCount: mensajes.length,
          itemBuilder: (context, index) => mensajes[index],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Mensajes")),
      body: listarMensajes(),
    );
  }
}

  