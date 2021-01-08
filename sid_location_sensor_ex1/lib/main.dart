import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:location/location.dart';

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

  int _counter = 0;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Location"),
            if (_locationData != null)
              Text("Longitude ${_locationData.longitude}"),
            if (_locationData != null)
              Text("Latitude ${_locationData.latitude}"),
            if (_locationData != null)
              Text("Altitude ${_locationData.altitude}"),
            if (_locationData != null)
              Text("Accuracy ${_locationData.accuracy}"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocationData,
        child: Icon(Icons.gps_fixed),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
