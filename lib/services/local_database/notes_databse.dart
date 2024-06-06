import 'package:dars12/models/note.dart';
import 'package:dars12/services/local_database/local_database.dart';

class NotesDatabse {
  final _localDatabase = LocalDatabase();
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
        "created_time": DateTime.now().millisecond,
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
}
