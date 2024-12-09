import 'package:flutter/material.dart';

class DetailTile extends StatelessWidget {
  final String title;
  final String info;

  const DetailTile({required this.title, required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$title:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      subtitle: Text(info),
    );
  }
}