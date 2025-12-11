import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';
import '../models/topic.dart';
import '../data/samples.dart';

class HiveService {
  static const String notesBoxName = 'notes';
  static const String topicsBoxName = 'topics';
  static const String preferencesBoxName = 'preferences';
  static const String sampleDataDeclinedKey = 'sampleDataDeclined';

  static Future<(Box<Note>, Box<Topic>)> initializeWithData() async {
    await Hive.initFlutter();

    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TopicAdapter());

    // Open boxes
    final notesBox = await openNotesBox();
    final topicsBox = await openTopicsBox();

    return (notesBox, topicsBox);
  }

  static Future<void> loadSampleData(
      Box<Note> notesBox, Box<Topic> topicsBox) async {
    // Add sample topics
    final sampleTopics = SampleData.getSampleTopics();
    for (final topic in sampleTopics) {
      await topicsBox.put(topic.id, topic);
    }

    // Add sample notes
    final sampleNotes = SampleData.getSampleNotes();
    for (final note in sampleNotes) {
      await notesBox.put(note.id, note);
    }
  }

  static Future<Box<Note>> openNotesBox() async {
    return await Hive.openBox<Note>(notesBoxName);
  }

  static Future<Box<Topic>> openTopicsBox() async {
    return await Hive.openBox<Topic>(topicsBoxName);
  }

  static Future<Box> openPreferencesBox() async {
    return await Hive.openBox(preferencesBoxName);
  }

  static Future<bool> hasSampleDataBeenDeclined() async {
    final prefsBox = await openPreferencesBox();
    return prefsBox.get(sampleDataDeclinedKey, defaultValue: false);
  }

  static Future<void> setSampleDataDeclined(bool declined) async {
    final prefsBox = await openPreferencesBox();
    await prefsBox.put(sampleDataDeclinedKey, declined);
  }
}
