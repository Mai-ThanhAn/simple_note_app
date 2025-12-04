import 'package:simple_note_app/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteService {
  // NoteService instance using single pattern (just one instance)
  // Because NoteService using for manage database SQLite and SQLite should have one connection in the app
  // If you have lots intances ==> have lots connection ==> easy cause errors.
  static final NoteService instance = NoteService._init();
  static Database? _database;

  NoteService._init();
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            createdAt DATETIME,
            updatedAt DATETIME
          )
        ''');
      },
    );
  }

  // ReadAll
  Future<List<NoteModel>> readAll() async {
    final db = await database;
    final maps = await db.query("notes", orderBy: "updatedAt DESC");

    return maps.map((m) => NoteModel.fromMap(m)).toList();
  }

  // Create
  Future<int> create(NoteModel note) async {
    final db = await database;
    return await db.insert("notes", note.toMap());
  }

  // Update
  Future<int> update(NoteModel note) async {
    final db = await database;
    return await db.update(
      "notes",
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  // Delete
  Future<int> delete(int? id) async {
    final db = await database;
    return await db.delete("notes", where: "id = ?", whereArgs: [id]);
  }

  // Get
  Future<Map<String, dynamic>?> getNoteById(int id) async {
    final db = await database;

    final result = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }
}
