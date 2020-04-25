import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttersqflite/sqflite_helper.dart';
import 'note_model.dart';

class SQFLiteExample extends StatefulWidget {
  @override
  _SQFLiteExampleState createState() => new _SQFLiteExampleState();
}

class _SQFLiteExampleState extends State<SQFLiteExample> {
  List<Note> items = new List();
  SQFLiteHelper db = new SQFLiteHelper();

  @override
  void initState() {
    super.initState();

    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQFLite'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    'Add',
                  ),
                  onPressed: () {
                    _addNote();
                  },
                ),
                RaisedButton(
                  child: Text(
                    'Delete Data',
                  ),
                  onPressed: () {
                    _deleteData();
                  },
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, position) {
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              '${items[position].name}',
                            ),
                            subtitle: Text(
                              '${items[position].age}',
                            ),
                            onTap: () => _updateNote(position),
                            onLongPress: () =>
                                _deleteNote(items[position], position),
                          ),
                        ],
                      );
                    }))
          ],
        ),
      ),
    );
  }

  void _addNote() async {
    var add = Note("Dan", 21);
    db.addNote(add).then((notes) {
      setState(() {
        items = List.from(items)..add(add);
      });
    });
  }

  void _updateNote(int position) async {
    db
        .updateNote(
            Note.fromMap({'id': position + 1, 'name': 'yosi', 'age': 24}))
        .then((notes) {
      setState(() {
        _getItems();
      });
    });
  }

  void _deleteNote(Note note, int position) async {
    db.deleteNote(note.id).then((notes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _deleteData() async {
    db.deleteData().then((notes) {
      setState(() {
        _getItems();
      });
    });
  }

  void _getItems() async {
    db.getAllNotes().then((notes) {
      setState(() {
        items.clear();
        notes.forEach((note) {
          items.add(Note.fromMap(note));
        });
      });
    });
  }
}
