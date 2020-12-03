import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/contacts_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  const ContactPage({Key key, this.contact}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ContactHelper _contactHelper = ContactHelper();
  Contact _contact;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _dirtyForm = false;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _contact = Contact();
    } else {
      _contact = widget.contact;
      _nameController.text = _contact.name;
      _emailController.text = _contact.email;
      _phoneController.text = _contact.phone;
    }
  }

  void _saveContact() {
    _contact.name = _nameController.text;
    _contact.email = _emailController.text;
    _contact.phone = _phoneController.text;

    if (widget.contact == null) {
      _contactHelper.saveContact(_contact);
    } else {
      _contactHelper.updateContact(_contact);
    }

    Navigator.of(context).pop(_contact);
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Do you really want back?'),
            content: Text('All your changes will be closed!'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (_dirtyForm) {
            _showDialog();

            return Future.value(false);
          }

          return Future.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(_contact.name ?? 'New Contact'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.save),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _saveContact();
                }
              }),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: _contact.image != null
                                ? FileImage(File(_contact.image))
                                : AssetImage('images/person.png'))),
                  ),
                  onTap: () async {
                    File file =
                        await ImagePicker.pickImage(source: ImageSource.camera);

                    if (file != null) {
                      setState(() {
                        _contact.image = file.path;
                        _dirtyForm = true;
                      });
                    }
                  },
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Name'),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          controller: _nameController,
                          onChanged: (String text) {
                            _dirtyForm = true;
                            setState(() {
                              _contact.name = text;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Name is required';
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(labelText: 'Email'),
                          controller: _emailController,
                          onChanged: (String text) {
                            _dirtyForm = true;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email is required';
                            }

                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);
                            if (!emailValid) {
                              return 'The email must a valid email';
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(labelText: 'Phone'),
                          controller: _phoneController,
                          onChanged: (String text) {
                            _dirtyForm = true;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Phone is required';
                            }

                            return null;
                          },
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
