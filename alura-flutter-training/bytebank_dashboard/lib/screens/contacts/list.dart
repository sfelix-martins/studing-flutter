import 'package:bytebank_dashboard/components/future/progress.dart';
import 'package:bytebank_dashboard/database/dao/contact_dao.dart';
import 'package:bytebank_dashboard/models/contact.dart';
import 'package:bytebank_dashboard/screens/contacts/form.dart';
import 'package:bytebank_dashboard/screens/transactions/form.dart';
import 'package:flutter/material.dart';

import 'form.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactsForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Contact>>(
        future: _dao.findAll(),
        initialData: List(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Progress();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error!');
              }

              final List<Contact> contacts = snapshot.data;

              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = contacts[index];
                  return ContactItem(
                    contact,
                    onTap: () => _makeTransfer(contact),
                  );
                },
              );
          }

          return Text('Unkonwn error');
        },
      ),
    );
  }

  _makeTransfer(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TransactionsForm(contact),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  final Contact _contact;
  final Function onTap;

  ContactItem(this._contact, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(
          _contact.name,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          _contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
