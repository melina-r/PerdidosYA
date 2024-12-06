import 'package:flutter/material.dart';
import 'package:perdidos_ya/theme.dart';

enum TypeAlert { perdido, encontrado }

class NewAlertButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const NewAlertButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150, // Ancho del primer botón
      height: 100,
      child: ElevatedButton(
        onPressed: onPressed, // Texto del botón
        style: ElevatedButton.styleFrom(
          backgroundColor: colorSecundarioUno, // Color de fondo
          foregroundColor: Colors.black, // Color del texto
          shape: CircleBorder(),
        ),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}

class NewAlert extends StatelessWidget {
  final Function(int) onPressed;

  const NewAlert({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0), // Espaciado interno
      decoration: BoxDecoration(
        color: Colors.transparent, // Color de fondo
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Espacio entre botones
        children: [
          NewAlertButton(text: 'Mascota Perdida', onPressed: () {
            onPressed(TypeAlert.perdido.index);
          }),
          NewAlertButton(text: 'Mascota Encontrada', onPressed: () {
            onPressed(TypeAlert.encontrado.index);
          }),
        ],
      ),
    );
  }
}