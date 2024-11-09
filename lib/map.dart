import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme.dart';

class MapPage extends StatefulWidget {
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
    CollectionReference reports = FirebaseFirestore.instance.collection('Mascotas encontradas');
    QuerySnapshot querySnapshot = await reports.get();

    for (var r in querySnapshot.docs) {
      String ubicacion = r['ubicacion'] + ', Buenos Aires, Argentina';
      String titulo = r['titulo'];
      _addMarkerFromAddress(titulo,ubicacion);
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