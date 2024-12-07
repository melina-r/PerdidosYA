// ignore_for_file: avoid_function_literals_in_foreach_calls

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
import 'package:perdidos_ya/utils.dart';

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

  Text _createLabel(Function getContent) {
    return Text(
      getContent(),
      style: TextStyle(fontSize: 24),
    );
  }

  String _getPetsCount() {
    return '${widget.user.pets.length} mascotas';
  }

  String _getReportsCount() {
    return '${widget.user.reports.length} reportes';
  }

  String _getStringZone(Zona zona) {
    return splitAndGetEnum(zona);
  }

  String _getUpperZone(String zona) {
    return zona.toUpperCase();
  }

  String _getConcatZones() {
    return widget.user.zones
      .map((zona) => _getStringZone(zona))
      .map((zona) => _getUpperZone(zona))
      .reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorTerciario,
      appBar: CustomAppBar(
        user: widget.user,
        title: "Perfil",
        icon: Icon(Icons.settings, color: colorTerciario, size: 30),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    _createLabel(_getPetsCount),
                    _createLabel(_getReportsCount)
                  ],),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      ToggleList(sections: [
                        ToggleData(
                          icon: Icons.map, 
                          title: "Zonas Preferidas", 
                          content: [
                            ...widget.user.zones
                            .map((zone) => ListTile(
                              title: Text(
                                splitAndGetEnum(zone),
                                style: TextStyle(fontSize: 24),
                              )
                            ))
                          ]
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
                            [...widget.refreshPages, _refresh].forEach(callFunction);
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