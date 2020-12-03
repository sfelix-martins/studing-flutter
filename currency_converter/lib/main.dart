import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  runApp(
    MaterialApp(
      title: 'Currency Converter',
      home: Home(),
    ),
  );
}

const url =
    'https://api.hgbrasil.com/finance?array_limit=1&fields=only_results,currencies&key=3ef4316b';

Future<Map> getData() async {
  http.Response response = await http.get(url);

  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _brlController = TextEditingController();
  final TextEditingController _usdController = TextEditingController();
  final TextEditingController _eurController = TextEditingController();

  double usd;
  double eur;

  void _clearAll() {
    this._brlController.clear();
    this._usdController.clear();
    this._eurController.clear();
  }

  void _brlChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double brl = double.parse(text);

    this._usdController.text = (brl / this.usd).toStringAsFixed(2);
    this._eurController.text = (brl / this.eur).toStringAsFixed(2);
  }

  void _usdChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double usd = double.parse(text);

    this._brlController.text = (usd * this.usd).toStringAsFixed(2);
    this._eurController.text = (usd * this.usd / this.eur).toStringAsFixed(2);
  }

  void _eurChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    double eur = double.parse(text);

    this._brlController.text = (eur * this.eur).toStringAsFixed(2);
    this._usdController.text = (eur * this.eur / this.usd).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '\$ Currency Converter \$',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Loader();
            default:
              if (snapshot.hasError) {
                return ErrorMessage();
              }
              Map currencies = snapshot.data['currencies'];

              this.usd = currencies['USD']['buy'];
              this.eur = currencies['EUR']['buy'];

              return SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.monetization_on,
                      size: 120.0,
                      color: Colors.amber,
                    ),
                    Divider(),
                    StyledTextField(
                      controller: _brlController,
                      labelText: 'BRL',
                      prefixText: "R\$ ",
                      onChanged: _brlChanged,
                    ),
                    Divider(),
                    StyledTextField(
                      controller: _usdController,
                      labelText: 'USD',
                      prefixText: "\$ ",
                      onChanged: _usdChanged,
                    ),
                    Divider(),
                    StyledTextField(
                      controller: _eurController,
                      labelText: 'EUR',
                      prefixText: "€ ",
                      onChanged: _eurChanged,
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}

class StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String prefixText;
  final Function onChanged;

  StyledTextField(
      {Key key,
      @required this.controller,
      @required this.labelText,
      @required this.prefixText,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefixText,
        prefixStyle: TextStyle(color: Colors.amber),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(
        color: Colors.amber,
      ),
    );
  }
}

class ErrorMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.error,
          size: 120.0,
          color: Colors.amber,
        ),
        Center(
          child: Text(
            'Whoops, error loading data!',
            style: TextStyle(color: Colors.amber, fontSize: 25.0),
          ),
        )
      ],
    );
  }
}

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Loading...',
        style: TextStyle(color: Colors.amber, fontSize: 25.0),
      ),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  TextEditingController _brlController = TextEditingController();
  TextEditingController _usdController = TextEditingController();
  TextEditingController _eurController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            Icons.monetization_on,
            size: 120.0,
            color: Colors.amber,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: TextField(
              controller: _brlController,
              decoration: InputDecoration(
                labelText: 'BRL',
                labelStyle: TextStyle(color: Colors.amber),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.amber,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: TextField(
              controller: _usdController,
              decoration: InputDecoration(
                labelText: 'USD',
                labelStyle: TextStyle(color: Colors.amber),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.amber,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: TextField(
              controller: _eurController,
              decoration: InputDecoration(
                labelText: 'EUR',
                labelStyle: TextStyle(color: Colors.amber),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
