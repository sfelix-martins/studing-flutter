import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "People Counter", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  static const String _defaultMessage = 'You may come in!';
  static const String _fillMessage = 'Fill';
  String _info = _defaultMessage;
  static const int _maxPeople = 10;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'images/restaurant.jpg',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "People: $_people",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                        onPressed: _incrementPeople,
                        child: Text(
                          "+1",
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ))),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                        onPressed: _decrementPeople,
                        child: Text(
                          "-1",
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ))),
              ],
            ),
            Text(
              _info,
              style: TextStyle(
                  color: Colors.white, fontStyle: FontStyle.italic, fontSize: 30),
            ),
          ],
        )
      ],
    );
  }

  void _incrementPeople() {
    setState(() {
      _people++;

      if (_people == _maxPeople) {
        _info = _fillMessage;
      }
    });
  }

  void _decrementPeople() {
    setState(() {
      _people--;

      if (_people == _maxPeople) {
        _info = _defaultMessage;
      }
    });
  }
}
