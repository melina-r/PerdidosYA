import 'package:flutter/material.dart';
import 'package:perdidos_ya/objects/pet.dart';
import 'package:perdidos_ya/users.dart';

class EditPetsDialog extends StatelessWidget {
  final User user;

  const EditPetsDialog({required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modificar mascotas"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ...user.pets.map((pet) => SizedBox(
            width: 500,
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pet.name, style: TextStyle(fontSize: 24),),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditPetDialog(pet: pet, user: user),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            user.pets.remove(pet);
                            user.updateDatabase();
                          },
                        ),
                      ],
                    )
                    
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => EditPetDialog(user: user),
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
  }
}

class EditPetDialog extends StatefulWidget {
  final Pet? pet;
  final User user;

  const EditPetDialog({super.key, this.pet, required this.user});

  @override
  State<EditPetDialog> createState() => _EditPetDialog();
}

class _EditPetDialog extends State<EditPetDialog> {
  late Pet petInfo;
  late String title;
  late bool isDog = petInfo.especie == Especie.perro;
  late List<Enum> razaList = isDog ? RazaPerro.values : RazaGato.values;

  TextEditingController nameController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      petInfo = widget.pet!;
      title = "Modificar mascota";
    } else {
      petInfo = Pet(
        name: "Nombre",
        color: "Color",
        description: "Descripción",
        especie: Especie.perro,
        raza: RazaPerro.mestizo,
        age: AgePet.cachorro,
        size: SizePet.chico,
      );
      title = "Agregar nueva mascota";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(hintText: petInfo.name),
                controller: nameController,
              ),
              TextField(
                decoration: InputDecoration(hintText: petInfo.color),
                controller: colorController,
              ),
              TextField(
                decoration: InputDecoration(hintText: petInfo.description),
                controller: descriptionController,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(hintText: petInfo.especieString),
                items: Especie.values.map((especie) => DropdownMenuItem(
                  value: especie.index,
                  child: Text(especie.toString().split('.').last),
                )).toList(),
                onChanged: (value) {
                  petInfo.especie = Especie.values[value!];
                  isDog = value == Especie.perro.index;
                  razaList = isDog ? RazaPerro.values : RazaGato.values;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(hintText: petInfo.razaString),
                items: razaList.map((raza) => DropdownMenuItem(
                  value: raza.index,
                  child: Text(raza.toString().split('.').last),
                )).toList(),
                onChanged: (value) {
                  petInfo.raza = razaList[value!];
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(hintText: petInfo.ageString),
                items: AgePet.values.map((age) => DropdownMenuItem(
                  value: age.index,
                  child: Text(age.toString().split('.').last),
                )).toList(),
                onChanged: (value) {
                  petInfo.age = Pet.agePetFromInt(value!);
                },
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(hintText: petInfo.sizeString),
                items: SizePet.values.map((size) => DropdownMenuItem(
                  value: size.index,
                  child: Text(size.toString().split('.').last),
                )).toList(),
                onChanged: (value) {
                  petInfo.age = Pet.agePetFromInt(value!);
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
              if (nameController.text.isEmpty || colorController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Por favor, completa todos los campos")),
                );
                return;
              }

              petInfo.name = nameController.text;
              petInfo.color = colorController.text;
              petInfo.description = descriptionController.text;

              if (widget.pet == null) {
                widget.user.pets.add(petInfo);
              } else {
                widget.user.pets[widget.user.pets.indexOf(widget.pet!)] = petInfo;
              }
              widget.user.updateDatabase();
              Navigator.pop(context);
            },
            child: Text('Aceptar'),
          ),
        ],
      );
  }
}