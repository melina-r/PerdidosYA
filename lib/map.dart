import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perdidos_ya/objects/barrios.dart';
import 'theme.dart';
import 'package:perdidos_ya/users.dart';

class MapPage extends StatefulWidget {
  final User user;

  const MapPage({required this.user});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final LatLng _center = const LatLng(-34.602469417156684, -58.390846554589395);

  String? _selectedZone;
  final List<String> _zones = Zona.values.map((zone) => zonaToString(zone)).toList();
  List<String> _currentZones = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _showReports();
  }

  void _showReports() async{
    CollectionReference zonasTotales = FirebaseFirestore.instance.collection('Zonas');
    List<String> listaZonas = widget.user.zones.map((zona) => zonaToString(zona)).toList();
    
    for (var z in listaZonas){
      QuerySnapshot snapshot = await zonasTotales.where('zona', isEqualTo: z).get();
  
      if (snapshot.docs.isNotEmpty) {
        DocumentReference zonaRef = snapshot.docs.first.reference;
        DocumentSnapshot zonaDoc = await zonaRef.get();
        List<dynamic> reportes = zonaDoc['reportes'];
        
        for (var reporte in reportes){
          String titulo = reporte['titulo'];
          String ubicacion = reporte['ubicacion'] + ', Buenos Aires, Argentina';
         
          _addMarkerFromAddress(titulo,ubicacion);
        }
      }    
    }
  }


  Future<void> _addMarkerFromAddress(String titulo,String ubicacion) async {
    try {
      List<Location> locations = await locationFromAddress(ubicacion);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final marker = Marker(
          markerId: MarkerId(titulo),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: titulo,
          ),
        );

        setState(() {
          _markers.add(marker);
        });

      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _addMarkersForSelectedZone() async{
    if (_selectedZone == null ) return;

    CollectionReference zonasTotales = FirebaseFirestore.instance.collection('Zonas');
    QuerySnapshot snapshot = await zonasTotales.where('zona', isEqualTo: _selectedZone).get();
  
    if (snapshot.docs.isNotEmpty) {
      DocumentReference zonaRef = snapshot.docs.first.reference;
      DocumentSnapshot zonaDoc = await zonaRef.get();
      List<dynamic> reportes = zonaDoc['reportes'];
        
      for (var reporte in reportes){
        String titulo = reporte['titulo'];
        String ubicacion = reporte['ubicacion'] + ', Buenos Aires, Argentina';
         
        _addMarkerFromAddress(titulo,ubicacion);
      }
    }    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        backgroundColor: colorPrincipalUno,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _markers,
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    hint: Text('Mostrar otra Zona'),
                    value: _selectedZone,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedZone = newValue;
                      });
                    },
                    items: _zones.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _addMarkersForSelectedZone();
                    },
                    child: Text('Confirmar'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}