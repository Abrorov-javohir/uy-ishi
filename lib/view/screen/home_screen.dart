import 'package:dars12/view_model/notes_database.dart';
import 'package:flutter/material.dart';
import 'package:dars12/models/note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final notesViewModel = NotesDatabase();
  String data = "Malumot yuq";

  @override
  void initState() {
    super.initState();
    notesViewModel.createDatabase();
  }

  Future<void> _addNote() async {
    await notesViewModel.addNote();
    setState(() {}); // Trigger a rebuild to fetch the new list of notes
  }

  Future<void> _deleteNote(int id) async {
    await notesViewModel.deleteNote(id);
    setState(() {}); // Trigger a rebuild to fetch the updated list of notes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: _addNote,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: notesViewModel.getNotes(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching notes"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Malumot yuq"),
            );
          }
          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text(notes[index].title),
                subtitle: Text(notes[index].content),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(notes[index].createdTime.toString()),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await _deleteNote(notes[index].id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
