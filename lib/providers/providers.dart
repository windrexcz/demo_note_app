import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import '../models/topic.dart';
import 'notes_manager.dart';
import 'topics_manager.dart';

// Hive boxes providers
final notesBoxProvider = Provider<Box<Note>>((ref) {
  throw UnimplementedError('notesBoxProvider must be overridden');
});

final topicsBoxProvider = Provider<Box<Topic>>((ref) {
  throw UnimplementedError('topicsBoxProvider must be overridden');
});

// Notes manager provider
final notesManagerProvider = StateNotifierProvider<NotesManager, NotesState>((ref) {
  final box = ref.watch(notesBoxProvider);
  return NotesManager(box);
});

// Topics manager provider
final topicsManagerProvider = StateNotifierProvider<TopicsManager, TopicsState>((ref) {
  final box = ref.watch(topicsBoxProvider);
  return TopicsManager(box);
});

// Helper provider to get notes by topic
final notesByTopicProvider = Provider.family<List<Note>, int>((ref, topicId) {
  final notesManager = ref.watch(notesManagerProvider.notifier);
  return notesManager.getNotesByTopic(topicId);
});
