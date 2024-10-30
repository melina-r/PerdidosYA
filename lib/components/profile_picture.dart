import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:perdidos_ya/theme.dart'; // Para manejar los archivos locales

class ProfilePicture extends StatefulWidget {
  final String username;

  const ProfilePicture({
    super.key,
    required this.username,
  });

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? _image; 

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedImage != null) {
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
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _image != null ? FileImage(_image!) : null,
            backgroundColor: colorPrincipalDos,
            child: _image == null
                ? Text(
                    widget.username[0], // Mostrar la inicial si no hay imagen
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: colorTerciario,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
