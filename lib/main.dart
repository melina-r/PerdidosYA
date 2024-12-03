import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:perdidos_ya/login.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/cloudinary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  subirImagen();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'perdidosYa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colorPrincipalUno),
        useMaterial3: true,
      ),
      home:  LoginPage(), 
    );
  }
}

void subirImagen() {
  // String path = 'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';
  // uploadImage(path);
}