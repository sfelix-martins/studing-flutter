import 'package:bytebank_dashboard/components/form/button.dart';
import 'package:bytebank_dashboard/components/form/input.dart';
import 'package:bytebank_dashboard/http/services/transaction_service.dart';
import 'package:bytebank_dashboard/models/transaction.dart';
import 'package:flutter/material.dart';

import 'package:bytebank_dashboard/models/contact.dart';

class TransactionsForm extends StatefulWidget {
  final Contact _contact;

  TransactionsForm(this._contact);

  @override
  _TransactionsFormState createState() => _TransactionsFormState();
}

class _TransactionsFormState extends State<TransactionsForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionService _transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget._contact.name,
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              widget._contact.accountNumber.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
              ),
            ),
            InputText(
              controller: _valueController,
              labelText: 'Value',
            ),
            SubmitButton(
              onPressed: () => _makeTransfer(),
              text: 'Transfer',
            )
          ],
        ),
      ),
    );
  }

  Future<void> _makeTransfer() async {
    final double value = double.tryParse(_valueController.text);

    if (value != null) {
      await _transactionService.save(Transaction(value, widget._contact));

      Navigator.pop(context);
    }
  }
}
