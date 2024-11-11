import 'package:flutter/material.dart';
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

Widget MensajeShowAlert(String body, String from, DateTime recibido) {
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
            subtitle: Text(recibido.toString()),
          ),
        ],
      )
    );
  }

  void _mostrarMensaje(String titulo, String body, String from, DateTime recibido) {
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
  Widget listarMensajes(){
    List<Widget> mensajes = [];
      // Agregar mascotas perdidas
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: this.widget.user.email)
        .snapshots(),
      builder: (context, messageSnapshot) {
        final userDoc = messageSnapshot.data!.docs.first;
        if (messageSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // **Retorno de cargador mientras no hay datos**
            }
        List<dynamic> messagesAlerts = userDoc['mensajes'] ?? [];
        if (messagesAlerts.isEmpty) {
              return Center(child: Text('No hay mensajes disponibles.'));
            }
        else{
          for (var mensaje in  messagesAlerts) {
          
            final titulo = mensaje['title'];
            final body = mensaje['body'];
            final from = mensaje['from'];
            final recibido = mensaje['received'];
            mensajes.add(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: (){
                      _mostrarMensaje(titulo,body,from,recibido);},
                  ),
                ),
              ),
            );
          }
          return Center(child: Text(mensajes.length.toString()),);
          return ListView(children: mensajes);
        }
      }
    );
  }
    @override
Widget build(BuildContext context) {
     return Column(
        children: [
          AppBar(
            backgroundColor: colorPrincipalUno ,
            title: Center(child: Text('Mensajes'),),
            automaticallyImplyLeading: false,
          ),
          listarMensajes(),
        ]
     );
}

}

  