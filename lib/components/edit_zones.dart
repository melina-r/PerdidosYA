import 'package:flutter/material.dart';
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/objects/pet.dart';
import 'package:perdidos_ya/users.dart';

class AddZoneButton extends StatelessWidget {
  final String title;
  final Widget content;
  final Function() update;

  const AddZoneButton({required this.content, required this.title, required this.update});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context, 
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: content,
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  }, 
                  child: Text('Cancelar')
                ),
                TextButton(
                  onPressed: () {
                    update();
                    Navigator.of(context).pop();
                  }, 
                  child: Text('Aceptar')
                ),
              ],

            );
          }
        );
      },
      child: Text(title),
    );
  }
}

class EditZoneDialog extends StatelessWidget {
  final User user;

  const EditZoneDialog({required this.user});

  @override
  Widget build(BuildContext context) {
    Zona? newZone;
    return AlertDialog(
      title: Text("Modificar zonas preferidas"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ...user.zones.map(
              (zone) => ListTile(
                title: Text(zonaToString(zone)),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    user.zones.remove(zone);
                    user.updateDatabase();
                  },
                ),
              )
            ),
            SizedBox(height: 20),
            AddZoneButton(
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
              title: "Agregar Zona", 
              update: () {
                if (newZone == null) return;
                user.zones.add(newZone!);
                user.updateDatabase();
              }
            )
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

