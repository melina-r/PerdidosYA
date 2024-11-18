import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:perdidos_ya/objects/report.dart';
import 'registro.dart'; 
import 'inicio.dart'; 
import 'users.dart' as users;

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Inicio de Sesion'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _loginUser(
                    usernameController.text,
                    passwordController.text,
                    context,
                  );
                },
                child: const Text('Iniciar Sesion'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginUser(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }catch (e) {
      if (e is FirebaseAuthException) {
       _showErrorDialog(context, 'Error al iniciar sesión: email o contraseña incorrectos.');
        return;
      }
    }  
    
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first;

      var perdidosSnapshot = await FirebaseFirestore.instance
          .collection('Mascotas perdidas')
          .where('user', isEqualTo: userDoc['username'])
          .get();
      var encontradosSnapshot = await FirebaseFirestore.instance
          .collection('Mascotas encontradas')
          .where('user', isEqualTo: userDoc['username'])
          .get();

      var perdidos = perdidosSnapshot.docs;
      var encontrados = encontradosSnapshot.docs;

      var reportesTotales = perdidos + encontrados;
      List<Reporte> reportes = reportesTotales.map((reporte) => Reporte.fromMap(reporte.data())).toList();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      userData['reportes'] = reportes;

      users.User user = users.User.fromMap(userData);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Inicio(user: user,)), 
      );
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}