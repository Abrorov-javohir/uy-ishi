import 'package:dars12/models/note.dart';
import 'package:dars12/services/local_database/local_database.dart';

class NotesDatabase {
  final _localDatabase = LocalDatabase();

  Future<List<Note>> get list async {
    return await getNotes();
  }

  void createDatabase() async {
    final db = await _localDatabase.database;
  }

  Future<void> addNote() async {
    final db = await _localDatabase.database;

    await db.insert(
      "notes",
      {
        "title": "Abrorov Javohir",
        "content": "+998 90 062 09 10",
        "created_time": DateTime.now().millisecondsSinceEpoch,
      },
    );
    await db.insert(
      "notes",
      {
        "title": "SADSADASD",
        "content": "+998 90 04524 456460",
        "created_time": DateTime.now().millisecondsSinceEpoch,
      },
    );
    await db.insert(
      "notes",
      {
        "title": "DASSDA ADWQED",
        "content": "+7 865646 454565456",
        "created_time": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<List<Note>> getNotes() async {
    final db = await _localDatabase.database;
    final rows = await db.query("notes");
    List<Note> notes = [];
    for (var row in rows) {
      notes.add(
        Note(
          id: row['id'] as int,
          title: row['title'] as String,
          content: row['content'] as String,
          createdTime:
              DateTime.fromMillisecondsSinceEpoch(row['created_time'] as int),
        ),
      );
    }
    return notes;
  }

  Future<void> updateNote(Note note) async {
    final db = await _localDatabase.database;
    await db.update(
      "notes",
      {
        "title": note.title,
        "content": note.content,
        "created_time": note.createdTime.millisecondsSinceEpoch,
      },
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await _localDatabase.database;
    await db.delete(
      "notes",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
