
import 'package:flutter/material.dart';
import 'package:perdidos_ya/users.dart';

class EditUsername extends StatelessWidget {
  final User user;
  final Function() refreshSettings;
  final Function() refreshProfile;

  const EditUsername({required this.user, required this.refreshSettings, required this.refreshProfile});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: Text("Modificar nombre de usuario"),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: "Nombre de usuario",
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
            refreshSettings();
            refreshProfile();
            Navigator.pop(context);
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}