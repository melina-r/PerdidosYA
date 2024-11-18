import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/toggle_list.dart';
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/objects/pet.dart';
import 'package:perdidos_ya/profile.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users;

class ProfileSettings extends StatefulWidget {
  final users.User user;

  const ProfileSettings({super.key, required this.user});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  void initState() {
    super.initState();
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
                    subtitle: Text(widget.user.username),
                    trailing: Icon(Icons.edit),
                    onTap: () {
                      _updateUsername(context);
                    }
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
    _showAlertDialog(context, "Modificar nombre de usuario", "nuevo nombre de usuario", _changeUsername);
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
                ...widget.user.zones.map((zone) => ListTile(
                  title: Text(zonaToString(zone)),
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
                ...widget.user.pets.map((pet) => ListTile(
                  title: Text(pet.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => _showPetInfoDialog("Editar mascota", widget.user, pet),
                          );
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
                      builder: (context) => _showPetInfoDialog("Agregar nueva mascota", widget.user, null),
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
  
  Widget _showPetInfoDialog(String title, users.User user, Pet? pet) {
    TextEditingController nameController = TextEditingController();
    TextEditingController colorController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    Pet finalPet = pet ?? Pet(
      name: "Nombre",
      color: "Color",
      description: "Descripción",
      age: AgePet.cachorro,
      size: SizePet.chico,
      raza: "Raza",
      especie: Especie.gato,
    );

    if (pet != null) {
      nameController.text = pet.name;
      colorController.text = pet.color;
      descriptionController.text = pet.description ?? "";
    }

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: finalPet.name),
              controller: nameController,
            ),
            TextField(
              decoration: InputDecoration(hintText: finalPet.color),
              controller: colorController,
            ),
            TextField(
              decoration: InputDecoration(hintText: finalPet.description),
              controller: descriptionController,
            ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(hintText: finalPet.ageString),
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text("Cachorro"),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text("Adulto"),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text("Anciano"),
                ),
              ],
              onChanged: (value) {
                finalPet.age = Pet.agePetFromInt(value!);
              },
            ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(hintText: finalPet.sizeString),
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
              onChanged: (value) {
                pet?.age = Pet.agePetFromInt(value!);
              },
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
            finalPet.name = nameController.text;
            finalPet.color = colorController.text;
            finalPet.description = descriptionController.text;
            if (pet == null) {
              user.pets.add(finalPet);
            } else {
              user.pets[user.pets.indexOf(pet)] = finalPet;
            }
            _updateDatabase(user, "Mascota actualizada!", "Hubo un error. Intenta nuevamente.");
            Navigator.pop(context);
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }


  void _showAlertDialog(BuildContext context, String title, String hint, void Function(String) updateField) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                updateField(controller.text);
                _updateDatabase(widget.user, "Nombre de usuario actualizado!", "Hubo un error. Intenta nuevamente.");
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateDatabase(users.User user, String successMessage, String errorMessage) async {
    final userId = (await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user.email).get()).docs.first.id;
    FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)                  
                  .update(user.toMap())
                  .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(successMessage)),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(user: widget.user,),
                      ),
                    );
                  })
                  .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                    );
                  });
  }

  void _changeUsername(String newUsername) {
    widget.user.username = newUsername;
  }
}