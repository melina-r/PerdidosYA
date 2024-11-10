import 'package:flutter/material.dart';
import 'package:perdidos_ya/home.dart';
import 'package:perdidos_ya/theme.dart';
import 'users.dart'; 
import 'profile.dart';
import 'map.dart';

class Inicio extends StatefulWidget {
  final User user;

  const Inicio({required this.user});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _selectedIndex = 0;
  List<Widget> paginas = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    paginas = [
      HomePage(user: widget.user, context: context,),
      MapPage(user: widget.user),
      ProfilePage(user: widget.user), //esta luego se reemplaza por la pagina de mensajes
      ProfilePage(user: widget.user), 
    ];
    return Scaffold(
      backgroundColor: colorTerciario,    //Cambiar color  //Cambiar color
      body: paginas[_selectedIndex],
       bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorPrincipalDos,
        onTap: _onItemTapped,
      ),
    );
  }
}