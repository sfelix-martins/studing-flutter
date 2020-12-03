import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _weightFocusNode;

  String _infoData = 'Info';
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _weightFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _weightFocusNode.dispose();

    super.dispose();
  }

  void _resetFields() {
    setState(() {
      _infoData = 'Put your data';
    });

    _formKey.currentState.reset();
    _weightController.clear();
    _heightController.clear();

    FocusScope.of(context).requestFocus(_weightFocusNode);
  }

  void _calculate() {
    double weight = double.parse(_weightController.text);
    double height = double.parse(_heightController.text) / 100;
    double bmi = weight / (height * height);

    String categorization = this.getCategorization(bmi);

    setState(() {
      _infoData = "$categorization (${bmi.toStringAsFixed(2)})";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BMI Calculator'),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields)
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    size: 120.0,
                    color: Colors.green,
                  ),
                  TextFormField(
                    controller: _weightController,
                    focusNode: _weightFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Weigth (Kg)",
                        labelStyle: TextStyle(
                          color: Colors.green,
                        )),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 30.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Weight is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Height (cm)",
                        labelStyle: TextStyle(
                          color: Colors.green,
                        )),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 30.0),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Height is required';
                      }
                      return null;
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        height: 50.0,
                        child: RaisedButton(
                            color: Colors.green,
                            child: Text(
                              'Calculate',
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.white),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _calculate();
                              }
                            }),
                      )),
                  Text(
                    _infoData,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green, fontSize: 25.0),
                  )
                ],
              )),
        ));
  }

  String getCategorization(double bmi) {
    if (bmi < 15) {
      return 'Very severely underweight';
    }

    if (bmi < 16) {
      return 'Severely underweight';
    }

    if (bmi < 18.5) {
      return 'Underweight';
    }

    if (bmi < 25) {
      return 'Normal (healthy weight)';
    }

    if (bmi < 30) {
      return 'Overweight';
    }

    if (bmi < 35) {
      return 'Moderately obese';
    }

    if (bmi < 40) {
      return 'Severely obese';
    }

    return 'Very severely obese';
  }
}
