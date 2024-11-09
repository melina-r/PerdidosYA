// ignore_for_file: constant_identifier_names

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
  switch (zona) {
    case Zona.Agronomia:
      return 'Agronomia';
    case Zona.Almagro:
      return 'Almagro';
    case Zona.Balvanera:
      return 'Balvanera';
    case Zona.Barracas:
      return 'Barracas';
    case Zona.Belgrano:
      return 'Belgrano';
    case Zona.Boedo:
      return 'Boedo';
    case Zona.Caballito:
      return 'Caballito';
    case Zona.Chacarita:
      return 'Chacarita';
    case Zona.Coghlan:
      return 'Coghlan';
    case Zona.Colegiales:
      return 'Colegiales';
    case Zona.Constitucion:
      return 'Constitucion';
    case Zona.Flores:
      return 'Flores';
    case Zona.Floresta:
      return 'Floresta';
    case Zona.LaBoca:
      return 'La Boca';
    case Zona.LaPaternal:
      return 'La Paternal';
    case Zona.Liniers:
      return 'Liniers';
    case Zona.Mataderos:
      return 'Mataderos';
    case Zona.MonteCastro:
      return 'Monte Castro';
    case Zona.Monserrat:
      return 'Monserrat';
    case Zona.NuevaPompeya:
      return 'Nueva Pompeya';
    case Zona.Nunez:
      return 'Nunez';
    case Zona.Palermo:
      return 'Palermo';
    case Zona.ParqueAvellaneda:
      return 'Parque Avellaneda';
    case Zona.ParqueChacabuco:
      return 'Parque Chacabuco';
    case Zona.ParqueChas:
      return 'Parque Chas';
    case Zona.ParquePatricios:
      return 'Parque Patricios';
    case Zona.PuertoMadero:
      return 'Puerto Madero';
    case Zona.Recoleta:
      return 'Recoleta';
    case Zona.Retiro:
      return 'Retiro';
    case Zona.Saavedra:
      return 'Saavedra';
    case Zona.SanCristobal:
      return 'San Cristobal';
    case Zona.SanNicolas:
      return 'San Nicolas';
    case Zona.SanTelmo:
      return 'San Telmo';
    case Zona.VelezSarsfield:
      return 'Velez Sarsfield';
    case Zona.Versalles:
      return 'Versalles';
    case Zona.VillaCrespo:
      return 'Villa Crespo';
    case Zona.VillaDelParque:
      return 'Villa del Parque';
    case Zona.VillaDevoto:
      return 'Villa Devoto';
    case Zona.VillaGeneralMitre:
      return 'Villa General Mitre';
    case Zona.VillaLugano:
      return 'Villa Lugano';
    case Zona.VillaLuro:
      return 'Villa Luro';
    case Zona.VillaOrtuzar:
      return 'Villa Ortuzar';
    case Zona.VillaPueyrredon:
      return 'Villa Pueyrredon';
    case Zona.VillaReal:
      return 'Villa Real';
    case Zona.VillaRiachuelo:
      return 'Villa Riachuelo';
    case Zona.VillaSantaRita:
      return 'Villa Santa Rita';
    case Zona.VillaSoldati:
      return 'Villa Soldati';
    case Zona.VillaUrquiza:
      return 'Villa Urquiza';
    case Zona.VillaRosas:
      return 'Villa Rosas';
    default:
      return 'Unknown';
      }
    }

Zona stringToZona(String zona) {
  switch (zona) {
    case 'Agronomia':
      return Zona.Agronomia;
    case 'Almagro':
      return Zona.Almagro;
    case 'Balvanera':
      return Zona.Balvanera;
    case 'Barracas':
      return Zona.Barracas;
    case 'Belgrano':
      return Zona.Belgrano;
    case 'Boedo':
      return Zona.Boedo;
    case 'Caballito':
      return Zona.Caballito;
    case 'Chacarita':
      return Zona.Chacarita;
    case 'Coghlan':
      return Zona.Coghlan;
    case 'Colegiales':
      return Zona.Colegiales;
    case 'Constitucion':
      return Zona.Constitucion;
    case 'Flores':
      return Zona.Flores;
    case 'Floresta':
      return Zona.Floresta;
    case 'La Boca':
      return Zona.LaBoca;
    case 'La Paternal':
      return Zona.LaPaternal;
    case 'Liniers':
      return Zona.Liniers;
    case 'Mataderos':
      return Zona.Mataderos;
    case 'Monte Castro':
      return Zona.MonteCastro;
    case 'Monserrat':
      return Zona.Monserrat;
    case 'Nueva Pompeya':
      return Zona.NuevaPompeya;
    case 'Nunez':
      return Zona.Nunez;
    case 'Palermo':
      return Zona.Palermo;
    case 'Parque Avellaneda':
      return Zona.ParqueAvellaneda;
    case 'Parque Chacabuco':
      return Zona.ParqueChacabuco;
    case 'Parque Chas':
      return Zona.ParqueChas;
    case 'Parque Patricios':
      return Zona.ParquePatricios;
    case 'Puerto Madero':
      return Zona.PuertoMadero;
    case 'Recoleta':
      return Zona.Recoleta;
    case 'Retiro':
      return Zona.Retiro;
    case 'Saavedra':
      return Zona.Saavedra;
    case 'San Cristobal':
      return Zona.SanCristobal;
    case 'San Nicolas':
      return Zona.SanNicolas;
    case 'San Telmo':
      return Zona.SanTelmo;
    case 'Velez Sarsfield':
      return Zona.VelezSarsfield;
    case 'Versalles':
      return Zona.Versalles;
    case 'Villa Crespo':
      return Zona.VillaCrespo;
    case 'Villa Del Parque':
      return Zona.VillaDelParque;
    case 'VillaDevoto':
      return Zona.VillaDevoto;
    case 'Villa General Mitre':
      return Zona.VillaGeneralMitre;
    case 'Villa Lugano':
      return Zona.VillaLugano;
    case 'Villa Luro':
      return Zona.VillaLuro;
    case 'Villa Ortuzar':
      return Zona.VillaOrtuzar;
    case 'Villa Pueyrredon':
      return Zona.VillaPueyrredon;
    case 'Villa Real':
      return Zona.VillaReal;
    case 'Villa Riachuelo':
      return Zona.VillaRiachuelo;
    case 'Villa Santa Rita':
      return Zona.VillaSantaRita;
    case 'Villa Soldati':
      return Zona.VillaSoldati;
    case 'Villa Urquiza':
      return Zona.VillaUrquiza;
    case 'Villa Rosas':
      return Zona.VillaRosas;
    default:
      throw ArgumentError('Unknown zona: $zona');
  }
}