import 'package:flutter/material.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users;

class ProfilePic extends StatefulWidget {
  final users.User user;

  const ProfilePic({super.key, required this.user});
  
  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          Padding(padding: EdgeInsets.all(20), child: 
            CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage(widget.user.icon),
              backgroundColor: colorPrincipalDos,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorSecundarioUno
              ),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.edit,
                  color: colorTerciario,
                ),
              )
            )
          )
        ],
      ),
    );
  }
}