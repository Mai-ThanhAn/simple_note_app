import 'package:flutter/material.dart';
import 'package:simple_note_app/database/note_service.dart';
import 'package:simple_note_app/models/note_model.dart';

class NoteViewmodel extends ChangeNotifier {
  final NoteService _noteService = NoteService.instance;

  List<NoteModel> _notes = [];
  List<NoteModel> _filteredNotes = [];
  List<NoteModel> get notes => _searchText.isEmpty ? _notes : _filteredNotes;
  String _searchText = "";

  bool isLoading = false;
  String? errorMessage;
  // Load notes function
  Future<void> loadNotes() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      _notes = await _noteService.readAll();
      if (_searchText.isNotEmpty) {
        searchNotes(_searchText);
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // New note function
  Future<bool> createNotes(
    String title,
    String content,
    DateTime createdAt,
    DateTime updatedAt,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      NoteModel newNote = NoteModel(
        title: title,
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      await _noteService.create(newNote);
      await loadNotes();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Delete note function
  Future<bool> deleteNote(int? id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _noteService.delete(id);
      await loadNotes();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Update note function
  Future<bool> updateNote(NoteModel note) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _noteService.update(note);
      if (result > 0) {
        await loadNotes();
        return true;
      }
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Extension: search function
  void searchNotes(String query) {
    _searchText = query;
    if (query.isEmpty) {
      _filteredNotes = [];
    } else {
      _filteredNotes = _notes.where((note) {
        return note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
