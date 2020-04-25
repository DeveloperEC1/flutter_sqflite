import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note_model.dart';

class SQFLiteHelper {
  static final SQFLiteHelper _instance = new SQFLiteHelper.internal();

  factory SQFLiteHelper() => _instance;

  SQFLiteHelper.internal();

  final String tableNote = 'noteTable';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnAge = 'age';

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  void onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableNote($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnAge INTEGER)');
  }

  Future<int> addNote(Note note) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableNote, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    var dbClient = await db;
    return await dbClient.update(tableNote, note.toMap(),
        where: "$columnId = ?", whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteData() async {
    var dbClient = await db;
    return await dbClient.delete(tableNote);
  }

  Future<List> getAllNotes() async {
    var dbClient = await db;
    var result = await dbClient
        .query(tableNote, columns: [columnId, columnName, columnAge]);
    return result.toList();
  }
}
