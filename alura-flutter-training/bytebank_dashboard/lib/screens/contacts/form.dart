import 'package:bytebank_dashboard/components/form/button.dart';
import 'package:bytebank_dashboard/components/form/input.dart';
import 'package:bytebank_dashboard/database/dao/contact_dao.dart';
import 'package:bytebank_dashboard/models/contact.dart';
import 'package:flutter/material.dart';

class ContactsForm extends StatefulWidget {
  final Contact contact;

  const ContactsForm({Key key, this.contact}) : super(key: key);

  @override
  _ContactsFormState createState() => _ContactsFormState();
}

class _ContactsFormState extends State<ContactsForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _fullNameFieldController =
      TextEditingController();
  final TextEditingController _accountNumberFieldController =
      TextEditingController();

  final ContactDao _dao = ContactDao();

  @override
  void initState() {
    super.initState();

    final Contact contact = widget.contact;

    if (contact != null) {
      _fullNameFieldController.text = contact.name;
      _accountNumberFieldController.text = contact.accountNumber.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contact != null ? widget.contact.name : 'New contact',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              InputText(
                controller: _fullNameFieldController,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.text,
                labelText: 'Full name',
                hintText: 'João',
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Full name is required';
                  }

                  return null;
                },
              ),
              InputText(
                controller: _accountNumberFieldController,
                keyboardType: TextInputType.number,
                labelText: 'Account number',
                hintText: '0000',
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Account number is required';
                  }

                  return null;
                },
              ),
              SubmitButton(
                text: 'Save',
                onPressed: () {
                  if (_key.currentState.validate()) {
                    _createOrUpdate();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createOrUpdate() async {
    final String name = _fullNameFieldController.text;
    final int accountNumber = int.tryParse(_accountNumberFieldController.text);

    if (accountNumber == null) {
      return;
    }

    if (widget.contact == null || widget.contact.id == null) {
      await _dao.save(Contact(null, name, accountNumber));
    } else {
      await _dao.update(Contact(widget.contact.id, name, accountNumber));
    }

    Navigator.pop(context);
  }
}
