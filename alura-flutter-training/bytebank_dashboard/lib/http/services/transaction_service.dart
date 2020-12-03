import 'dart:convert';

import 'package:bytebank_dashboard/http/client.dart';
import 'package:bytebank_dashboard/models/transaction.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = 'http://192.168.0.58:8080/transactions';
const String _apiPassword = '1000';

class TransactionService {
  Future<Transaction> save(Transaction transaction) async {
    final http.Response response = await client.post(
      _baseUrl,
      headers: {
        'Content-type': 'application/json',
        'password': _apiPassword,
      },
      body: jsonEncode(transaction.toJson()),
    );

    return Transaction.fromJson(jsonDecode(response.body));
  }

  Future<List<Transaction>> findAll() async {
    final http.Response response =
        await client.get(_baseUrl).timeout(Duration(seconds: 5));

    final List<dynamic> decodedJson = jsonDecode(response.body);

    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }
}
