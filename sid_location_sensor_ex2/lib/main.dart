import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:location/location.dart';

import 'package:platform_maps_flutter/platform_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  var _makers = Set<Marker>();
  var _mapController;

  void _getLocationData() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.getLocation().then((locationData) async {
      setState(() {
        _locationData = locationData;
        _makers.clear();
        _makers.add(Marker(
          markerId: MarkerId('my_location'),
          position: LatLng(locationData.latitude, locationData.longitude),
        ));
        if (_mapController != null) {
          _mapController.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  _locationData.latitude,
                  _locationData.longitude,
                ),
                zoom: 16.0,
              ),
            ),
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: PlatformMap(
          initialCameraPosition: CameraPosition(
            target: const LatLng(35.68, 139.76),
            zoom: 16.0,
          ),
          markers: _makers,
          onMapCreated: (controller) {
            _mapController = controller;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocationData,
        child: Icon(Icons.gps_fixed),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// Set<Marker>.of(
// [
// Marker(
// markerId: MarkerId('marker_1'),
// position: LatLng(47.6, 8.8796),
// consumeTapEvents: true,
// infoWindow: InfoWindow(
// title: 'PlatformMarker',
// snippet: "Hi I'm a Platform Marker",
// ),
// onTap: () {
// print("Marker tapped");
// },
// ),
// ],
// ),

// Future.delayed(Duration(seconds: 2)).then(
// (_) {
// controller.animateCamera(
// CameraUpdate.newCameraPosition(
// const CameraPosition(
// bearing: 270.0,
// target: LatLng(51.5160895, -0.1294527),
// tilt: 30.0,
// zoom: 18,
// ),
// ),
// );
// },
// );
