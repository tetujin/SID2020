import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

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
  StreamSubscription<dynamic> _accelerometerStreamSubscription;

  double _x;
  double _y;
  double _z;

  String _actionLabel = "UNKNOWN";

  @override
  void initState() {
    super.initState();
    _accelerometerStreamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;

        // https://developer.android.com/guide/topics/sensors/sensors_motion?hl=ja
        // https://developer.apple.com/documentation/coremotion/getting_raw_accelerometer_events
        if (Platform.isAndroid) {
          _x = _x / 9.8;
          _y = _y / 9.8;
          _z = _z / 9.8;
        }

        if (_z >= 0.9) {
          _actionLabel = 'スクリーンが上向き';
        } else if (_z < 0.9) {
          _actionLabel = 'スクリーンが下向き';
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_accelerometerStreamSubscription != null) {
      _accelerometerStreamSubscription.cancel();
    }
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
            Text(_actionLabel),
            Text("加速度"),
            Text("x:$_x"),
            Text("y:$_y"),
            Text("z:$_z"),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
