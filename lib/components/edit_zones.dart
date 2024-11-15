import 'package:flutter/material.dart';
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/users.dart';

class AddZoneButton extends StatelessWidget {
  final User user;
  final Function() refreshList;
  final Function() refreshSettings;
  final Function() refreshProfile;
  
  const AddZoneButton({required this.user, required this.refreshSettings, required this.refreshProfile, required this.refreshList});

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
                    refreshList();
                    refreshSettings();
                    refreshProfile();
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

class ListZoneDialog extends StatefulWidget {
  final User user;
  final Function() refreshSettings;
  final Function() refreshProfile;

  const ListZoneDialog({required this.user, required this.refreshSettings, required this.refreshProfile});

  @override
  State<ListZoneDialog> createState() => _ListZoneDialogState();
}

class _ListZoneDialogState extends State<ListZoneDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modificar zonas preferidas"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ...widget.user.zones.map(
              (zone) => ListTile(
                title: Text(zonaToString(zone)),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    widget.user.zones.remove(zone);
                    widget.user.updateDatabase();
                    widget.refreshSettings();
                    widget.refreshProfile();
                    setState(() {});
                  },
                ),
              )
            ),
            SizedBox(height: 20),
            AddZoneButton(
              user: widget.user,
              refreshList: () => setState(() {}),
              refreshSettings: widget.refreshSettings,
              refreshProfile: widget.refreshProfile,
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

