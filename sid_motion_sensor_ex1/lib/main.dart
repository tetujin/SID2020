import 'dart:async';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _accelerometerStreamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _x = event.x;
        _y = event.y;
        _z = event.z;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
