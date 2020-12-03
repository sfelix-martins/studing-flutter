import 'dart:io';

import 'package:contacts/helpers/contacts_helper.dart';
import 'package:contacts/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/contacts_helper.dart';

enum OrderOptions { az, za }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper _contactHelper = ContactHelper();

  List<Contact> _contacts = [];

  void _loadContacts() {
    _contactHelper.getAllContacts().then((List<Contact> data) {
      setState(() {
        _contacts = data;
        _orderContacts(OrderOptions.az);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _loadContacts();
  }

  void _goToContactPage({Contact contact}) async {
    final resultContact = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ContactPage(
              contact: contact,
            )));

    if (resultContact != null) {
      _loadContacts();
    }
  }

  void _orderContacts(OrderOptions option) {
    switch (option) {
      case OrderOptions.az:
        _contacts.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case OrderOptions.za:
        _contacts.sort(
            (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
              onSelected: (OrderOptions option) {
                _orderContacts(option);
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<OrderOptions>>[
                    const PopupMenuItem<OrderOptions>(
                      child: Text('Order A-Z'),
                      value: OrderOptions.az,
                    ),
                    const PopupMenuItem<OrderOptions>(
                      child: Text('Order Z-A'),
                      value: OrderOptions.za,
                    ),
                  ])
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
          onPressed: () {
            _goToContactPage();
          }),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: _contacts.length,
          itemBuilder: _buildContactCard),
    );
  }

  Widget _buildContactCard(BuildContext context, int index) {
    Contact contact = _contacts[index];
    return GestureDetector(
        onTap: () {
          _showOptions(context, index);
        },
        child: Card(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: contact.image != null
                                ? FileImage(File(contact.image))
                                : AssetImage('images/person.png')),
                      )),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          contact.name ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          contact.email ?? '',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          contact.phone ?? '',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  )
                ],
              )),
        ));
  }

  void _showOptions(BuildContext context, int index) {
    Contact contact = _contacts[index];
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(
              onClosing: () {},
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _goToContactPage(contact: contact);
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(fontSize: 20),
                          )),
                      Divider(),
                      FlatButton(
                          onPressed: () {
                            launch("tel:${contact.phone}");
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Call',
                            style: TextStyle(fontSize: 20),
                          )),
                      Divider(),
                      FlatButton(
                          onPressed: () async {
                            await _contactHelper.deleteContact(contact.id);
                            setState(() {
                              _contacts.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(fontSize: 20),
                          ))
                    ],
                  ),
                );
              });
        });
  }
}
