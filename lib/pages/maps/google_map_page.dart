import 'dart:async';

import 'package:carros/pages/carros/carro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  State<GoogleMapPage> createState() => GoogleMapPageState();

  Carro carro;
  GoogleMapPage(this.carro);
}

class GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();

  Carro get carro => widget.carro;
  CameraPosition _kGooglePlex;
  CameraPosition _kLake;

  @override
  void initState() {
    super.initState();
    _kGooglePlex = CameraPosition(
      target:
          LatLng(double.parse(carro.latitude), double.parse(carro.longitude)),
      zoom: 14.4746,
    );

    _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target:
            LatLng(double.parse(carro.latitude), double.parse(carro.longitude)),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(carro.nome),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.of(getMarkers()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  List<Marker> getMarkers() {
    return [
      Marker(
          markerId: MarkerId(carro.id.toString()),
          position: carro.latlng(),
          infoWindow: InfoWindow(
              title: carro.nome,
              snippet: "Fabrica ${carro.nome}",
              onTap: () {
                print("Clicou na janela");
              }),
          onTap: () {
            print("Clicou no marcador");
          }),
    ];
  }
}
