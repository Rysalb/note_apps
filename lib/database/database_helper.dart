import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class DatabaseHelper {
  static const TABLE_NOTES = 'notes';
  static const TABLE_NOTES_ID = 'id';
  static const TABLE_NOTES_TITLE = 'title';
  static const TABLE_NOTES_NOTE = 'note';
  static const TABLE_NOTES_ISPINNED = 'ispinned';
  static const TABLE_NOTES_UPDATEDAT = 'updated_at';
  static const TABLE_NOTES_CREATEDAT = 'created_at';

  static Future<Database> init() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, 'notes.db'), version: 1,
        onCreate: (newDb, version) {
      newDb.execute(
          ''' CREATE TABLE $TABLE_NOTES ($TABLE_NOTES_ID TEXT PRIMARY KEY, $TABLE_NOTES_TITLE TEXT, $TABLE_NOTES_NOTE TEXT, $TABLE_NOTES_ISPINNED INTEGER, $TABLE_NOTES_UPDATEDAT Text, $TABLE_NOTES_CREATEDAT TEXT) ''');
    });
  }

  Future<List<Note>> getAllNote() async {
    final db = await DatabaseHelper.init();
    final results = await db.query('notes');

    List<Note> listNote = [];
    results.forEach((data) {
      listNote.add(Note.fromDb(data));
    });

    return listNote;
  }

  Future<void> insertAllNote(List<Note> listNote) async {
    final db = await DatabaseHelper.init();
    Batch batch = db.batch();

    listNote.forEach((note) {
      batch.insert(
        'notes',
        note.toDb(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    await batch.commit();
  }

  Future<void> updateNote(Note note) async {
    final db = await DatabaseHelper.init();
    await db.update(TABLE_NOTES, note.toDb(),
        where: '$TABLE_NOTES_ID = ?', whereArgs: [note.id]);
  }

  Future<void> toggleIsPinned(
      String? id, bool isPinned, DateTime updatedAt) async {
    final db = await DatabaseHelper.init();
    await db.update(
      TABLE_NOTES,
      {
        TABLE_NOTES_ISPINNED: isPinned ? 1 : 0,
        TABLE_NOTES_UPDATEDAT: updatedAt.toIso8601String()
      },
      where: '$TABLE_NOTES_ID = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteNote(String? id) async {
    final db = await DatabaseHelper.init();
    await db.delete(TABLE_NOTES, where: '$TABLE_NOTES_ID = ?', whereArgs: [id]);
  }

  Future<void> insertNote(Note note) async {
    final db = await DatabaseHelper.init();
    await db.insert(TABLE_NOTES, note.toDb());
  }
}
