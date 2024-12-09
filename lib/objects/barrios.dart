// ignore_for_file: constant_identifier_names

import 'package:perdidos_ya/utils.dart';

enum Zona {
  Agronomia,
  Almagro,
  Balvanera,
  Barracas,
  Belgrano,
  Boedo,
  Caballito,
  Chacarita,
  Coghlan,
  Colegiales,
  Constitucion,
  Flores,
  Floresta,
  LaBoca,
  LaPaternal,
  Liniers,
  Mataderos,
  MonteCastro,
  Monserrat,
  NuevaPompeya,
  Nunez,
  Palermo,
  ParqueAvellaneda,
  ParqueChacabuco,
  ParqueChas,
  ParquePatricios,
  PuertoMadero,
  Recoleta,
  Retiro,
  Saavedra,
  SanCristobal,
  SanNicolas,
  SanTelmo,
  VelezSarsfield,
  Versalles,
  VillaCrespo,
  VillaDelParque,
  VillaDevoto,
  VillaGeneralMitre,
  VillaLugano,
  VillaLuro,
  VillaOrtuzar,
  VillaPueyrredon,
  VillaReal,
  VillaRiachuelo,
  VillaSantaRita,
  VillaSoldati,
  VillaUrquiza,
  VillaRosas,
}

String zonaToString(Zona zona) {
  final zonaStr = splitAndGetEnum(zona);
  return formatZonaName(zonaStr);
}

Zona stringToZona(String zona) {
  return Zona.values.firstWhere((e) => splitAndGetEnum(e) == zona, orElse: () => Zona.Agronomia);
}

String formatZonaName(String zonaName) {
  return zonaName.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]} ${m[2]}');
}