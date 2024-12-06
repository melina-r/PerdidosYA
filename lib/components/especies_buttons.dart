import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perdidos_ya/objects/pet.dart';
import 'package:perdidos_ya/theme.dart';
import 'package:perdidos_ya/utils.dart';

class EspeciesButtons extends StatefulWidget {
  final ValueChanged<String> onSelected;

  const EspeciesButtons({super.key, required this.onSelected});

  @override
  _EspeciesButtonsState createState() => _EspeciesButtonsState();
}

class _EspeciesButtonsState extends State<EspeciesButtons> {
  final especies = Especie.values;
  Especie? especieSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: especies.map((especie) {
        return IconButton(
          icon: Icon(especie == Especie.gato ? FontAwesomeIcons.cat : FontAwesomeIcons.dog),
          iconSize: 80,
          splashRadius: 50,
          onPressed: () {
            widget.onSelected(splitAndGetEnum(especie));
            setState(() {
              especieSeleccionada = especie;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: especieSeleccionada == especie ? colorPrincipalDos : colorSecundarioUno,
          ),
          splashColor: colorTerciario.withOpacity(0.5),
          highlightColor: colorTerciario.withOpacity(0.3),
        );
      }).toList(),
    );
  }
}



