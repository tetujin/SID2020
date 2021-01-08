import 'package:flutter/material.dart';
import 'package:battery/battery.dart';

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
  Battery _battery = Battery();

  String _batteryInfo = "";
  String _time = "";

  void _getBatteryInfo() {
    _battery.batteryLevel.then((value) {
      setState(() {
        var datetime = DateTime.now();
        var hour = datetime.hour;
        var min = datetime.minute;
        var sec = datetime.second;
        _time = "$hour時$min分$sec秒";
        _batteryInfo = "$value";
      });
    });
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
            Text(_time),
            Text(_batteryInfo),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getBatteryInfo,
        child: Icon(Icons.battery_unknown),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
