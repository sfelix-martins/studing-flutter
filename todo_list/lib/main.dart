import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  runApp(MaterialApp(
    title: 'TODO List',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _taskController = TextEditingController();
  List _todoList = [];

  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPosition;

  @override
  void initState() {
    super.initState();

    _readData().then((String todoList) {
      setState(() {
        _todoList = json.decode(todoList);
      });
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File("${directory.path}/todoList.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  void _addTodo() {
    setState(() {
      Map<String, dynamic> todo = Map();
      todo['title'] = _taskController.text;
      todo['completed'] = false;

      _taskController.clear();
      _todoList.add(todo);
      _saveData();
    });
  }

  void _changeTodoStatus(int i, bool checked) {
    setState(() {
      _todoList[i]['completed'] = checked;
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'TODO List',
        ),
      ),
      body: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: _taskController,
                      decoration: InputDecoration(labelText: 'New Task'))),
              RaisedButton(
                  color: Colors.blue,
                  textTheme: ButtonTextTheme.primary,
                  child: Text('ADD'),
                  onPressed: _addTodo)
            ],
          ),
        ),
        Expanded(
          child: _buildTodoList(),
        )
      ]),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return Dismissible(
      key: UniqueKey(),
      child: CheckboxListTile(
          title: Text(_todoList[index]['title']),
          value: _todoList[index]['completed'],
          secondary: CircleAvatar(
            child:
                Icon(_todoList[index]['completed'] ? Icons.check : Icons.error),
          ),
          onChanged: (checked) {
            _changeTodoStatus(index, checked);
          }),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        setState(() {
          _lastRemoved = Map.from(_todoList[index]);
          _lastRemovedPosition = index;
          _todoList.removeAt(index);

          _saveData();
        });

        final snackBar = SnackBar(
          content: Text("Task \"${_lastRemoved['title']}\" removed"),
          action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  _todoList.insert(_lastRemovedPosition, _lastRemoved);
                  _saveData();
                });
              }),
          duration: Duration(seconds: 3),
        );

        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snackBar);
      },
    );
  }

  Widget _buildTodoList() {
    return RefreshIndicator(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 10.0),
            itemCount: _todoList.length,
            itemBuilder: _buildItem),
        onRefresh: _refreshTodoList);
  }

  Future<void> _refreshTodoList() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _todoList.sort((a, b) =>
          a['completed'].toString().compareTo(b['completed'].toString()));
      _saveData();
    });
  }
}
