import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/card_details.dart';
import 'package:perdidos_ya/components/profile_picture.dart';
import 'package:perdidos_ya/components/toggle_list.dart';
import 'package:perdidos_ya/profile_settings.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: colorTerciario,
        appBar: AppBar(
          backgroundColor: colorTerciario,
          actions: [
            IconButton(
              icon: Icon(Icons.settings, size: 40,),
              color: colorPrincipalUno,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettings(user: user,),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              ProfilePicture(username: user.icon),
              SizedBox(height: 20),
              Text(
                '@${user.username}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ToggleList(
                sections: [
                  ToggleData(
                    icon: Icons.pets,
                    title: 'Mascotas',
                    content: [
                    ...user.pets.map((pet) => PetDetails(petInfo: pet)),
                    ],
                  ),
                  ToggleData(
                    icon: Icons.location_on,
                    title: 'Zonas preferidas',
                    content: [
                      ...user.zones.map((zona) => ListTile(title: Text(zona))),
                    ],
                  ),
                  ToggleData(
                    icon: Icons.announcement,
                    title: 'Mis anuncios',
                    content: [
                      ...user.reportes.map((report) => ListTile(title: Text(report.titulo))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

