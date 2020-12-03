import 'package:sqflite/sqlite_api.dart';
import 'package:bytebank_dashboard/models/contact.dart';
import 'package:bytebank_dashboard/database/app_database.dart';

class ContactDao {
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';

  Future<int> save(Contact contact) async {
    Map<String, dynamic> contactMap = _toMap(contact);

    Database db = await getDatabase();
    return db.insert(_tableName, contactMap);
  }

  Future<List<Contact>> findAll() async {
    Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contact> contacts = _toList(result);

    return contacts;
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = {
      _name: contact.name,
      _accountNumber: contact.accountNumber,
    };
    return contactMap;
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = List();
    for (Map<String, dynamic> row in result) {
      contacts.add(
        Contact(
          row[_id],
          row[_name],
          row[_accountNumber],
        ),
      );
    }
    return contacts;
  }

  Future<int> update(Contact contact) async {
    Database db = await getDatabase();

    return db.update(
      _tableName,
      _toMap(contact),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> delete(Contact contact) async {
    Database db = await getDatabase();

    return db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }
}
