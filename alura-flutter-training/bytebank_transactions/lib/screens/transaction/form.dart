import 'package:bytebank/components/editor.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:flutter/material.dart';

const _appBarTitle = 'New Transaction';

const _labelAccountNumberField = 'Account Number';
const _hintAccountNumberField = '0000';

const _labelValueField = 'Value';
const _hintValueField = '0.0';

const _submitButtonText = 'Confirm';

class TransactionForm extends StatefulWidget {
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _accountNumberFieldController =
      TextEditingController();
  final TextEditingController _valueFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: <Widget>[
              Editor(
                controller: _accountNumberFieldController,
                label: _labelAccountNumberField,
                hint: _hintAccountNumberField,
              ),
              Editor(
                controller: _valueFieldController,
                label: _labelValueField,
                hint: _hintValueField,
                icon: Icons.monetization_on,
              ),
              RaisedButton(
                onPressed: () => _createTransaction(),
                child: Text(_submitButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createTransaction() {
    final int accountNumber = int.tryParse(_accountNumberFieldController.text);
    final double value = double.tryParse(_valueFieldController.text);

    if (accountNumber != null && value != null) {
      Navigator.pop(context, Transaction(value, accountNumber));
    }
  }
}
