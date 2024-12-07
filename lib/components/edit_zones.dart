import 'package:flutter/material.dart';
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/users.dart';

class AddZoneButton extends StatelessWidget {
  final User user;
  final List<VoidCallback> refreshPages;
  
  const AddZoneButton({required this.user, required this.refreshPages});

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
                    if (user.zones.contains(newZone!)) return;
                    user.zones.add(newZone!);
                    user.updateDatabase();
                    for (var element in refreshPages) {
                      element();
                    }
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
  final List<VoidCallback> refreshPages;

  const ListZoneDialog({required this.user, required this.refreshPages});

  @override
  State<ListZoneDialog> createState() => _ListZoneDialogState();
}

class _ListZoneDialogState extends State<ListZoneDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modificar zonas preferidas"),
      content: SingleChildScrollView(
        child: SingleChildScrollView(
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
                      for (var element in widget.refreshPages) {
                        element();
                      }
                      setState(() {});
                    },
                  ),
                )
              ),
              SizedBox(height: 20),
              AddZoneButton(
                user: widget.user,
                refreshPages: widget.refreshPages + [() => setState(() {})],
              ),
            ],
          ),
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

