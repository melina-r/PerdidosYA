
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perdidos_ya/login.dart';

class LogoutAlert {
  static void show(BuildContext context) {
    FirebaseAuth.instance.signOut();
    showDialog(
      context: context, builder: (context) => AlertDialog(
        title: Text("Cerrar sesión"),
        content: Text("¿Seguro que deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => LoginPage())
              );
            },
            child: Text("Aceptar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar"),
          ),
        ],
      )
    );
  }
}