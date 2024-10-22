import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart'; 

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: emailController,
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
                _registerUser(
                  nameController.text,
                  emailController.text,
                  passwordController.text,
                  context, 
                );
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser(String name, String email, String password, BuildContext context) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _showErrorDialog(context, 'El correo electrónico ya está en uso.');
      return;
    }

    querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('nombre', isEqualTo: name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      _showErrorDialog(context, 'El nombre de usuario ya está en uso.');
      return;
    }

    await FirebaseFirestore.instance.collection('users').add({
      'nombre': name,
      'email': email,
      'contrasena': password,
      'zonas': [],
      'mascotas': [],
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), 
    );
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