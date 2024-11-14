import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/profile_app_bar.dart';
import 'package:perdidos_ya/components/profile_pic.dart';
import 'package:perdidos_ya/components/toggle_list.dart';
import 'package:perdidos_ya/components/username.dart';
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/profile_settings.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users;

class ProfilePage extends StatefulWidget {
  final users.User user;

  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      () async => await widget.user.loadFromDatabase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        user: widget.user,
        title: "Perfil",
        icon: Icon(Icons.settings, color: colorPrincipalUno, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileSettings(user: widget.user)),
          );
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ProfilePic(user: widget.user),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Username(username: widget.user.username),
                Column(
                  children: [
                    ToggleList(sections: [
                      ToggleData(
                        icon: Icons.map,
                        title: "Zonas preferidas", 
                        content: widget.user.zones.map((zone) => ListTile(
                          title: Text(zonaToString(zone), style: TextStyle(fontSize: 20)),
                        )).toList()
                      ),
                      ToggleData(
                        icon: Icons.pets, 
                        title: "Mis mascotas", 
                        content: widget.user.pets.map((pet) => ListTile(
                          title: Text(pet.name, style: TextStyle(fontSize: 20)),
                          leading: Icon(Icons.arrow_outward),
                          onTap: () {},
                        )).toList()
                      ),
                      ToggleData(
                        icon: Icons.assistant_photo,
                        title: "Mis reportes",
                        content: widget.user.reportes.map((report) => ListTile(
                          title: Text(report.titulo, style: TextStyle(fontSize: 20)),
                          leading: Icon(Icons.arrow_outward),
                          onTap: () {},
                        )).toList()
                      )
                    ])
                  ],
                )
          
              ],
            ),
          ],
        ),
      ),
    );
  }
}

