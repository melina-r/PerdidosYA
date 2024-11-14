
import 'package:flutter/material.dart';
import 'package:perdidos_ya/users.dart';

class EditUsername extends StatelessWidget {
  final User user;

  const EditUsername({required this.user});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: Text("Modificar nombre de usuario"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Nombre de usuario",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            user.username = controller.text;
            user.updateDatabase();
            Navigator.pop(context);
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}