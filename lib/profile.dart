import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/card_details.dart';
import 'package:perdidos_ya/components/profile_picture.dart';
import 'package:perdidos_ya/components/toggle_list.dart';
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/profile_settings.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users;

class ProfilePage extends StatefulWidget {
  final users.User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
  const ProfilePage({super.key, required this.user});
}


class _ProfilePageState extends State<ProfilePage> {
  late users.User user;

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
    _loadUserFromFirebase();
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
              ProfilePicture(user: user),
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
                    icon: Icons.location_on,
                    title: 'Zonas preferidas',
                    content: [
                      ...user.zones.map((zona) => ListTile(title: Text(zonaToString(zona)))),
                    ],
                  ),
                  ToggleData(
                    icon: Icons.pets,
                    title: 'Mascotas',
                    content: [
                    ...user.pets.map((pet) => PetDetails(petInfo: pet)),
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
