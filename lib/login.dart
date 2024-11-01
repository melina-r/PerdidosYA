import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'objects/pet.dart';
import 'registro.dart'; 
import 'inicio.dart'; 
import 'users.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                labelText: 'Usuario',
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
    );
  }

  void _loginUser(String username, String password, BuildContext context) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get();

    if (querySnapshot.docs.isNotEmpty) {

      var userDoc = querySnapshot.docs.first;
      User user = User(
        username: userDoc['username'],
        email: userDoc['email'],
        password: userDoc['password'],
        pets: List<Pet>.from([            
            for (var mascota in userDoc['mascotas']) {
              Pet(
                age: mascota['age'],
                size: mascota['size'],
                name: mascota['name'],
                color: mascota['color'],
                description: mascota['description'],
              )
            }
          ]
          ),
        zones: List<String>.from(userDoc['zonas']),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Inicio(user: user,)), 
      );
    } else {
      _showErrorDialog(context, 'El usuario o la contraseña no son correctos.');
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