
import 'package:cloud_firestore/cloud_firestore.dart';
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
          onPressed: () async {
            if (controller.text.isEmpty) return;
            if (await _exists(controller.text)) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Error"),
                  content: Text("El nombre de usuario ya existe"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Aceptar'),
                    ),
                  ],
                ),
              );
              return;
            }
            
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

  Future<bool> _exists(String username) async {
    final users = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return users.docs.isNotEmpty;
  }
}