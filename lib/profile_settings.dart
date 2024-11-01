

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart';

class ProfileSettings extends StatelessWidget{
  final User user;

  const ProfileSettings({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorTerciario,
      appBar: AppBar(
        backgroundColor: colorSecundarioUno,
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Username'),
            subtitle: Text(user.username),
            trailing: Icon(Icons.edit),
            onTap: () => _getNewUsername(context),
          ),
          ListTile(
            title: Text('Password'),
            subtitle: Text('********'),
            trailing: Icon(Icons.edit),
            onTap: () => _editPassword(context),
          ),
          ListTile(
            title: Text("Mascotas"),
            subtitle: Text("Agregar o eliminar mascotas"),
            trailing: Icon(Icons.edit),
            onTap: () => _editPets(context),
          ),
          ListTile(
            title: Text("Zonas preferidas"),
            subtitle: Text("Agregar o eliminar zonas"),
            trailing: Icon(Icons.edit),
            onTap: () => _editZones(context),
          ),
          ListTile(
            title: Text("Cerrar sesion"),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _editZones(BuildContext context) async {
    List<String> zones = List.from(user.zones);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar zonas preferidas'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Agregar zona'),
                    onSubmitted: (value) {
                      setState(() {
                        zones.add(value);
                      });
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: zones.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(zones[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                zones.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
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
                _updateZones(context, user, zones);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateZones(BuildContext context, User user, List<String> zones) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .update({'zones': zones});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Se actualizaron las zonas preferidas.')),
    );
  }
  Future<void> _editPets(BuildContext context) async {
    List<String> pets = List.from(user.pets);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar mascotas'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Agregar mascota'),
                    onSubmitted: (value) {
                      setState(() {
                        pets.add(value);
                      });
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(pets[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                pets.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
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
                _updatePets(context, user, pets);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updatePets(BuildContext context, User user, List<String> pets) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .update({'pets': pets});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Se actualizaron las mascotas.')),
    );
  }


  Future<void> _getNewUsername(BuildContext context) async {
    String username = '';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cambiar nombre de usuario'),
          content: TextField(
            onChanged: (value) {
              username = value;
            },
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
                _editUsername(context, user, username);
                Navigator.pop(context);
              },
              child: Text('Cambiar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editUsername(BuildContext context, User user, String username) async {
    await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .update({'username': username});
    
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Se cambió el nombre de usuario.')),
    );  
  }
Future<void> _editPassword(BuildContext context) async {
  String newPassword = '';
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Cambiar contraseña'),
        content: TextField(
          obscureText: true,
          onChanged: (value) {
            newPassword = value;
          },
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
              _updatePassword(context, user, newPassword);
              Navigator.pop(context);
            },
            child: Text('Cambiar'),
          ),
        ],
      );
    },
  );
}

Future<void> _updatePassword(BuildContext context, User user, String newPassword) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user.email)
      .update({'password': newPassword});

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Se cambió la contraseña.')),
  );
}
}