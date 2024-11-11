import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/users.dart' as users; // Para manejar los archivos locales

class ProfilePicture extends StatefulWidget {
  final users.User user;

  const ProfilePicture({
    super.key,
    required this.user,
  });

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  late File _image;

  @override
  void initState() {
    super.initState();
    _image = File(widget.user.icon);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedImage != null) {
      widget.user.icon = pickedImage.path;
      _updateDatabase("Imagen de perfil actualizada.");
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 75,
                backgroundImage: FileImage(_image),
                backgroundColor: colorPrincipalDos,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorSecundarioUno
                  ),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Icon(
                      Icons.edit,
                      color: colorTerciario,
                      size: 30,
                    ),
                  )
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _updateDatabase(String successMessage) async {
    final userId = (await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: widget.user.email).get()).docs.first.id;
    FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)                  
                  .update(widget.user.toMap())
                  .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(successMessage)),
                    );
                  })
                  .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Hubo un error. Intenta nuevamente.")),
                    );
                  });
  }
}
