

import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/toggle_list.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart';

class ProfileSettings extends StatefulWidget {
  final User user;

  const ProfileSettings({super.key, required this.user});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late final User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorTerciario,
      appBar: AppBar(
        backgroundColor: colorTerciario,
        title: Text('Configuraciones', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          ToggleList(
            sections: [
              ToggleData(
                icon: Icons.person,
                title: 'Modificar datos',
                content: [
                  ListTile(
                    title: Text('Username'),
                    subtitle: Text(user.username),
                    trailing: Icon(Icons.edit),
                    onTap: () => _updateUsername(context),
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
                ],
              ),
              ToggleData(
                icon: Icons.notifications,                  
                title: 'Notificaciones',
                content: [
                  ListTile(
                    title: Text('Apagar todas las notificaciones'),
                    trailing: Switch(
                      value: widget.user.notificaciones,
                      onChanged: (bool value) {
                          setState(() {
                            widget.user.notificaciones = value;
                          });
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
          ListTile(
            title: Text("Cerrar sesion"),

          ),
        ],
      ),
    );
  }

  void _updateUsername(BuildContext context) {
    _showAlertDialog(context, "Modificar nombre de usuario", "nuevo nombre de usuario");
  }

  void _editPassword(BuildContext context) {
    _showAlertDialog(context, "Modificar contraseña", "nueva contraseña");
  }

  void _editPets(BuildContext context) {
    _showPetsDialog(context);
  }

  void _editZones(BuildContext context) {
    _showZonesDialog(context);
  }

  void _showZonesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modificar zonas preferidas"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ...user.zones.map((zone) => ListTile(
                  title: Text(zone),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      // Eliminar zona
                      Navigator.pop(context);
                      _showZonesDialog(context);
                    },
                  ),
                )),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                      title: Text("Agregar nueva zona"),
                      content: TextField(
                        decoration: InputDecoration(hintText: "Nombre de la zona"),
                      ),
                      actions: [
                        TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar'),
                        ),
                        TextButton(
                        onPressed: () {
                          // Agregar nueva zona
                          Navigator.pop(context);
                        },
                        child: Text('Aceptar'),
                        ),
                      ],
                      );
                    },
                    );
                  },
                  child: Text("Agregar nueva zona"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _showPetsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modificar mascotas"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ...user.pets.map((pet) => ListTile(
                  title: Text(pet.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Edit pet information
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          // eliminar mascota
                          Navigator.pop(context);
                          _showPetsDialog(context);
                        },
                      ),
                    ],
                  ),
                )),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Agregar nueva mascota"),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(hintText: "Nombre"),
                                ),
                                TextField(
                                  decoration: InputDecoration(hintText: "Color"),
                                ),
                                TextField(
                                  decoration: InputDecoration(hintText: "Descripción"),
                                ),
                                DropdownButtonFormField<int>(
                                  decoration: InputDecoration(hintText: "Edad"),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 0,
                                      child: Text("bebé"),
                                    ),
                                    DropdownMenuItem(
                                      value: 1,
                                      child: Text("adulto"),
                                    ),
                                    DropdownMenuItem(
                                      value: 2,
                                      child: Text("anciano"),
                                    ),
                                  ],
                                  onChanged: (value) {},
                                ),
                                DropdownButtonFormField<int>(
                                  decoration: InputDecoration(hintText: "Tamaño"),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 0,
                                      child: Text("Pequeño"),
                                    ),
                                    DropdownMenuItem(
                                      value: 1,
                                      child: Text("Mediano"),
                                    ),
                                    DropdownMenuItem(
                                      value: 2,
                                      child: Text("Grande"),
                                    ),
                                    ],
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Agregar nueva mascota
                                Navigator.pop(context);
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Agregar nueva mascota"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
  
  void _showAlertDialog(BuildContext context, String title, String hint) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            decoration: InputDecoration(hintText: hint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Cambiar el username
                Navigator.pop(context);
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}

