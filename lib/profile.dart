import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/profile_picture.dart';
import 'package:perdidos_ya/components/toggle_list.dart';
import 'package:perdidos_ya/objects/pet.dart';
import 'package:perdidos_ya/profile_settings.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettings(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              ProfilePicture(username: "John Doe"),
              SizedBox(height: 10),
              Text(
                '@JohnDoe',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ToggleList(
                sections: [
                  ToggleData(
                    icon: Icons.pets,
                    title: 'Mascotas',
                    content: [
                      PetDetails(petInfo: Pet(age: AgePet.adulto, size: SizePet.chico, name: "Firulais", color: "marrón", description: " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum consequat neque feugiat augue elementum, non tempus risus tempus. Curabitur eu aliquam leo, placerat congue velit. Sed nec dui eget odio facilisis maximus sed vel odio. Etiam ac venenatis felis, sit amet facilisis dolor. Suspendisse faucibus, mi ac elementum accumsan, lorem ex mattis neque, eget tempor justo ex non justo. Fusce quis mi urna. Aliquam erat volutpat. Sed sed nibh nec mauris tincidunt venenatis sed at turpis. Donec imperdiet lorem quis tortor blandit dignissim. Quisque feugiat feugiat venenatis. Aliquam metus mi, scelerisque et placerat ultrices, auctor sit amet est. Curabitur aliquam tincidunt imperdiet. Phasellus id dignissim libero. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; ")),
                      PetDetails(petInfo: Pet(age: AgePet.bebe, size: SizePet.chico, name: "Negrito", color: "negro", description: "Tiene el pelo corto, usa un collar violeta y tiene una mancha blanca en el pecho."))
                    ],
                  ),
                  ToggleData(
                    icon: Icons.location_on,
                    title: 'Zonas preferidas',
                    content: [
                      ListTile(title: Text("Belgrano")),
                      ListTile(title: Text("San Telmo"))
                    ],
                  ),
                  ToggleData(
                    icon: Icons.announcement,
                    title: 'Mis anuncios',
                    content: [],
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

