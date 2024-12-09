import 'package:flutter/material.dart';
import 'package:perdidos_ya/theme.dart';

class Filters extends StatelessWidget {
  final Map<String, bool> mostrarBases;
  final VoidCallback refresh;

  const Filters({super.key, required this.mostrarBases, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          backgroundColor: colorTerciario,
          title: Center(child: Text('Filtrar'),),
          content: SizedBox(
            height: 400,
            width: 300,
            child: Center(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                      return  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: 
                        List<Widget>.from(mostrarBases.keys.map((key) {
                          return ReportsFilterButton(
                            text: key,
                            value: mostrarBases[key]!,
                            onChanged: (bool value) {
                              setDialogState(() {
                                mostrarBases[key] = value;
                                refresh();
                              });
                            },
                          );
                        }).toList()) + [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  ),
              ),
          ),
        );
  }
}

class ReportsFilterButton extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ReportsFilterButton({required this.text, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

}