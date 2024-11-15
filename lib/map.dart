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
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: _markers,
          ),
        ],
      ),
    );
  }
}