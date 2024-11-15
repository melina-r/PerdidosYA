import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/edit_username.dart';
import 'package:perdidos_ya/components/edit_zones.dart';
import 'package:perdidos_ya/components/edit_pets.dart';
import 'package:perdidos_ya/components/logout_alert.dart';
import 'package:perdidos_ya/components/custom_appbar.dart';
import 'package:perdidos_ya/components/toggle_list.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users;

class ProfileSettings extends StatefulWidget {
  final users.User user;
  final Function() refreshProfile;

  const ProfileSettings({super.key, required this.user, required this.refreshProfile});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  void initState() {
    super.initState();
  }

  void _refresh() {
    widget.user.loadFromDatabase();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorTerciario,
      appBar: CustomAppBar(
        user: widget.user, 
        title: "Configuraciones", 
        icon: Icon(Icons.logout, color: colorPrincipalUno, size: 30),
        onPressed: () {
          LogoutAlert.show(context);
        }
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
                      subtitle: Text(widget.user.username),
                      trailing: Icon(Icons.edit),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EditUsername(user: widget.user, refreshSettings: _refresh, refreshProfile: widget.refreshProfile);
                          }
                        );
                      }
                    ),
                    ListTile(
                      title: Text("Mascotas"),
                      subtitle: Text("Agregar o eliminar mascotas"),
                      trailing: Icon(Icons.edit),
                      onTap: () => _editPetsDialog(context),
                    ),
                    ListTile(
                      title: Text("Zonas preferidas"),
                      subtitle: Text("Agregar o eliminar zonas"),
                      trailing: Icon(Icons.edit),
                      onTap: () => _editZonesDialog(context),
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
                            widget.user.notificaciones = value;
                            widget.user.updateDatabase();
                            widget.refreshProfile();
                            setState(() {});
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
            ],
          ),
        ],
      ),
    );
  }

  void _editZonesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ListZoneDialog(user: widget.user, refreshSettings: _refresh, refreshProfile: widget.refreshProfile);
      },
    );
  }

  void _editPetsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ListPetsDialog(user: widget.user, refreshSettings: _refresh, refreshProfile: widget.refreshProfile);
      }
    );
  }    
}