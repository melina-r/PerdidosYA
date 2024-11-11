import 'package:flutter/material.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users;

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
      if(widget.user.mensajes.isEmpty){
        return Center(child: Text("No hay Mensajes"),);
      }
      for (var mensaje in widget.user.mensajes) {
          mensajes.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  title: Text(mensaje.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: (){
                    _mostrarMensaje(mensaje.title,mensaje.body,mensaje.from,mensaje.timestamp);},
                ),
              ),
            ),
          );
      }
    return ListView(children: mensajes);
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

  