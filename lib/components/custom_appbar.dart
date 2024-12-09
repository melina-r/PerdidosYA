import 'package:flutter/material.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? icon;
  final Function()? onPressed;
  final User user;
  final bool leading;

  const CustomAppBar({super.key, required this.user, required this.title, this.icon, this.onPressed, this.leading = false});

  @override
  Widget build(BuildContext context) {
    IconButton? iconButton = icon != null ? IconButton(onPressed: onPressed, icon: icon!) : null;

    return AppBar(
      backgroundColor: colorPrincipalUno,
      automaticallyImplyLeading: leading,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
          Text(title, 
          style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: colorTerciario,
            ),
          ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: iconButton,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}