import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:perdidos_ya/login.dart';
import 'package:perdidos_ya/notifications.dart';
import 'package:perdidos_ya/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Notifications.initNotifications();
  Notifications.saveToken();

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

