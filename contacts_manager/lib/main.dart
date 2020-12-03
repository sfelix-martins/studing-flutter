import 'package:contacts/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Contacts',
    home: HomePage(),
    theme: ThemeData(
      primaryColor: Colors.red,
    ),
  ));
}
