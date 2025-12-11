import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';

class NotesState {
  final List<Note> notes;
  final bool isLoading;
  final String? error;

  NotesState({
    this.notes = const [],
    this.isLoading = false,
    this.error,
  });

  NotesState copyWith({
    List<Note>? notes,
    bool? isLoading,
    String? error,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class NotesManager extends StateNotifier<NotesState> {
  final Box<Note> _notesBox;

  NotesManager(this._notesBox) : super(NotesState()) {
    _loadNotes();
  }

  int getNextId() {
    if (_notesBox.isEmpty) {
      return 1;
    }
    final maxId = _notesBox.values.map((note) => note.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  void _loadNotes() {
    state = state.copyWith(isLoading: true);
    try {
      final notes = _notesBox.values.toList();
      state = state.copyWith(notes: notes, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addNote(Note note) async {
    try {
      await _notesBox.put(note.id, note);
      _loadNotes();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _notesBox.put(note.id, note);
      _loadNotes();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _notesBox.delete(id);
      _loadNotes();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  List<Note> getNotesByTopic(int topicId) {
    return state.notes.where((note) => note.topicIds.contains(topicId)).toList();
  }

  Note? getNoteById(int id) {
    try {
      return state.notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }
}
