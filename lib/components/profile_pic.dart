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
  late users.User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Stack(
        children: [
          Padding(padding: EdgeInsets.all(20), child: 
            CircleAvatar(
              radius: 75,
              backgroundImage: NetworkImage(user.icon),
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
                onTap: () {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      TextEditingController controller = TextEditingController();
                      return AlertDialog(
                        title: const Text('Cambiar foto de perfil'),
                        content: 
                        TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            labelText: 'URL de la imagen',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (controller.text.isEmpty) {
                                return;
                              }
                              
                              user.icon = controller.text;

                              user.updateDatabase();
                              () async => await user.loadFromDatabase();

                              setState(() {});
                              
                              Navigator.of(context).pop();
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    }
                  );
                },
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