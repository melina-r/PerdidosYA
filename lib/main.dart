import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // Importa la página de login
import 'inicio.dart'; // Importa la página de inicio

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'perdidosYa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AuthWrapper(), // Usa AuthWrapper para manejar la autenticación
      routes: {
        '/login': (context) => LoginPage(), 
        '/inicio': (context) => Inicio(), // Define la ruta para Inicio
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se verifica el estado de autenticación
        } else if (snapshot.hasData) {
          return Inicio(); // Si el usuario está autenticado, redirige a la página de inicio
        } else {
          return LoginPage(); // Si el usuario no está autenticado, redirige a la página de login
        }
      },
    );
  }
}