import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/transaction/form.dart';
import 'package:flutter/material.dart';

const _appBarTitle = 'Transactions';

class TransactionsList extends StatefulWidget {
  final List<Transaction> _transactions = List();

  @override
  _TransactionsListState createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: ListView.builder(
        itemCount: widget._transactions.length,
        itemBuilder: (BuildContext context, int index) {
          return TransactionItem(widget._transactions[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final Transaction resultTransaction = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return TransactionForm();
              },
            ),
          );

          _updateTransaction(resultTransaction);
        },
      ),
    );
  }

  void _updateTransaction(Transaction resultTransaction) {
    if (resultTransaction != null) {
      setState(() {
        widget._transactions.add(resultTransaction);
      });
    }
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction _transaction;

  TransactionItem(this._transaction);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: ListTile(
          leading: Icon(Icons.monetization_on),
          title: Text(_transaction.value.toString()),
          subtitle: Text(_transaction.accountNumber.toString()),
        ),
      ),
    );
  }
}
