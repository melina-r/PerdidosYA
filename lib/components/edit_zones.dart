import 'package:flutter/material.dart';
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/users.dart';

class AddZoneButton extends StatelessWidget {
  final User user;

  const AddZoneButton({required this.user});

  @override
  Widget build(BuildContext context) {
    Zona? newZone;
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context, 
          builder: (BuildContext context) {
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
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  }, 
                  child: Text('Cancelar')
                ),
                TextButton(
                  onPressed: () {
                    if (newZone == null) return;
                    user.zones.add(newZone!);
                    user.updateDatabase();
                    
                    Navigator.of(context).pop();
                  }, 
                  child: Text('Aceptar')
                ),
              ],
            );
          }
        );
      },
      child: Text("Agregar nueva zona"),
    );
  }
}

class EditZoneDialog extends StatelessWidget {
  final User user;

  const EditZoneDialog({required this.user});

  @override
  Widget build(BuildContext context) {
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
              user: user,
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

