

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/toggle_list.dart';
import 'package:perdidos_ya/login.dart';
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
  late users.User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  Future<void> _loadUserFromFirebase() async {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    if (currentUserEmail != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUserEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first;
        setState(() {
          user = users.User.fromMap(userDoc.data());
        });
      }
    }
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                        value: user.notificaciones,
                        onChanged: (bool value) {
                            setState(() {
                              user.notificaciones = value;
                            });
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.logout),
            contentPadding: EdgeInsets.only(left: 25, bottom: 10),
            title: Text("Cerrar sesion", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            onTap: () {
              FirebaseAuth.instance.signOut();
              showDialog(
                context: context, builder: (context) => AlertDialog(
                title: Text("Cerrar sesión"),
                content: Text("¿Seguro que deseas cerrar sesión?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => LoginPage())
                      );
                    },
                    child: Text("Aceptar"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar"),
                  ),
                ],
                )
              );
            },
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
    Zona? newZone;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modificar zonas preferidas"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ...user.zones.map((zone) => ListTile(
                  title: Text(zonaToString(zone)),
                  trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      user.zones.remove(zone);
                      _updateDatabase("Zona preferida eliminada.");
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
                      content: DropdownButtonFormField<Zona>(
                        decoration: InputDecoration(hintText: "Zona"),
                        items: Zona.values.map((zona) => DropdownMenuItem(
                          value: zona,
                          child: Text(zonaToString(zona)),
                        )).toList(),
                        onChanged: (value) {
                          newZone = value;
                        },
                      ),
                      actions: [
                        TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar'),
                        ),
                        TextButton(
                        onPressed: () {
                          if (newZone == null) return;
                          user.zones.add(newZone!);
                          _updateDatabase("Zona agregada con éxito!");
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
                          showDialog(
                            context: context,
                            builder: (context) => _showPetInfoDialog("Editar mascota", user, pet),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          user.pets.remove(pet);
                          _updateDatabase("Mascota eliminada!");
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
                      builder: (context) => _showPetInfoDialog("Agregar nueva mascota", user, null),
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
      raza: RazaPerro.mestizo,
      especie: Especie.perro,
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
            DropdownButtonFormField(
              decoration: InputDecoration(hintText: finalPet.especieString),
              items: Especie.values.map((especie) => DropdownMenuItem(
                value: especie.index,
                child: Text(especie.toString().split('.').last),
              )).toList(),
              onChanged: (value) {
                finalPet.especie = Especie.values[value!];
              },
            ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(hintText: finalPet.razaString),
              items: (finalPet.especie == Especie.perro) ? RazaPerro.values.map((raza) => DropdownMenuItem(
                value: raza.index,
                child: Text(raza.toString().split('.').last),
              )).toList() : RazaGato.values.map((raza) => DropdownMenuItem(
                value: raza.index,
                child: Text(raza.toString().split('.').last),
              )).toList(),
              onChanged: (value) {
                finalPet.raza = (finalPet.especie == Especie.perro) ? RazaPerro.values[value!] : RazaGato.values[value!];
              },
            ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(hintText: finalPet.ageString),
              items: AgePet.values.map((age) => DropdownMenuItem(
                value: age.index,
                child: Text(age.toString().split('.').last),
              )).toList(),
              onChanged: (value) {
                finalPet.age = Pet.agePetFromInt(value!);
              },
            ),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(hintText: finalPet.sizeString),
              items: SizePet.values.map((size) => DropdownMenuItem(
                value: size.index,
                child: Text(size.toString().split('.').last),
              )).toList(),
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
            _updateDatabase("Mascota actualizada!");
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
                _updateDatabase("Nombre de usuario actualizado!");
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateDatabase(String successMessage) async {
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
                        builder: (context) => ProfilePage(user: user,),
                      ),
                    );
                    _loadUserFromFirebase();
                  })
                  .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Hubo un error. Intenta nuevamente.")),
                    );
                  });
    _loadUserFromFirebase();
  }

  void _changeUsername(String newUsername) {
    user.username = newUsername;
  }
}