import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class App extends StatefulWidget {
  App({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _counter = 0;
  Position _position;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      //changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. chang    // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(children: <Widget>[
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: RaisedButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () async {
                      _position = await setPosition();
                      print(_position);
                    },
                    child: Wrap(children: <Widget>[
                      Icon(
                        Icons.gps_fixed,
                        color: Colors.white,
                      ),
                      Text(
                        "   Save position  ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ]),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () async {
                          String parsedPosition = await getPosition();
                          createPosition(parsedPosition);
                        },
                        child: Wrap(children: <Widget>[
                          Icon(
                            Icons.pageview,
                            color: Colors.white,
                          ),
                          Text(
                            "   Read position  ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ])),
                  ),
                )
              ]),
        ]));
  }

  void createPosition(String parsedPosition) {
    double longitude =
        double.parse(parsedPosition.split(',')[0].replaceAll('long:', ''));
    double latitude =
        double.parse(parsedPosition.split(',')[1].replaceAll('lat:', ''));
    DateTime timestamp = DateTime.parse(
        parsedPosition.split(',')[2].replaceAll('timestamp:', ''));
    bool mocked = bool.fromEnvironment(
        parsedPosition.split(',')[3].replaceAll('mocked:', ''));
    double accuracy =
        double.parse(parsedPosition.split(',')[4].replaceAll('accuracy:', ''));
    double altitude =
        double.parse(parsedPosition.split(',')[5].replaceAll('altitude:', ''));
    double heading =
        double.parse(parsedPosition.split(',')[6].replaceAll('heading:', ''));
    double speed =
        double.parse(parsedPosition.split(',')[7].replaceAll('speed:', ''));
    double speedAccuracy = double.parse(
        parsedPosition.split(',')[8].replaceAll('speedAccuracy:', ''));
    Position position = new Position(
        longitude: longitude,
        latitude: latitude,
        timestamp: timestamp,
        mocked: mocked,
        accuracy: accuracy,
        altitude: altitude,
        heading: heading,
        speed: speed,
        speedAccuracy: speedAccuracy);
    print(position.toString());
  }

  Future<Position> setPosition() async {
    _position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/position.txt');
    await file.writeAsString("long:" +
        _position.longitude.toString() +
        ",lat:" +
        _position.latitude.toString() +
        ",timestamp:" +
        _position.timestamp.toString() +
        ",mocked:" +
        _position.mocked.toString() +
        ",accuracy:" +
        _position.accuracy.toString() +
        ",altitude:" +
        _position.altitude.toString() +
        ",heading:" +
        _position.heading.toString() +
        ",speed:" +
        _position.speed.toString() +
        ",speedAccuracy:" +
        _position.speedAccuracy.toString());
    return _position;
  }

  Future<String> getPosition() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/position.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    print(text);
    return text;
  }
}
