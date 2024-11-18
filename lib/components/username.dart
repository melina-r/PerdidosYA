import 'package:flutter/material.dart';

class Username extends StatelessWidget {
  final String username;

  const Username({required this.username});

  @override
  Widget build(BuildContext context) {
    return Text(
      "@$username",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}