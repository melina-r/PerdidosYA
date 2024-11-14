import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
          Text(
            'Perfil', style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),
      actions: [
        Padding(padding: EdgeInsets.only(right: 10),
        child: 
          IconButton(
            icon: Icon(Icons.logout, size: 36,),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}