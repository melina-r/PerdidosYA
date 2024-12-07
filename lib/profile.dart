import 'package:flutter/material.dart';
import 'package:perdidos_ya/components/card_details.dart';
import 'package:perdidos_ya/components/custom_appbar.dart';
import 'package:perdidos_ya/components/profile_pic.dart';
import 'package:perdidos_ya/components/toggle_list.dart';
import 'package:perdidos_ya/components/username.dart';
import 'package:perdidos_ya/objects/barrios.dart';
import 'package:perdidos_ya/profile_settings.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final List<VoidCallback> refreshPages;

  const ProfilePage({super.key, required this.user, required this.refreshPages});

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
        title: "Perfil",
        icon: Icon(Icons.settings, color: colorPrincipalUno, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileSettings(user: widget.user, refreshPages: widget.refreshPages + [_refresh]),),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ProfilePic(user: widget.user),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Username(username: widget.user.username),
                  SizedBox(height: 20),
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
                          content: [...widget.user.pets.map((pet) => PetDetails(petInfo: pet))],
                        ),
                        ToggleData(
                          icon: Icons.assistant_photo,
                          title: "Mis reportes",
                          content: [...widget.user.reports.map((report) => ReportDetails(reportInfo: report, deleteFunction: () {
                            widget.user.deleteReport(report);
                            for (var element in widget.refreshPages) {
                              element();
                            }
                            _refresh();
                          },))],
                        )
                      ])
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}