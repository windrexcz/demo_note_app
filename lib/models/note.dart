// This hive object is used for notes serialization and storage.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
@HiveType(typeId: 0)
class Note with _$Note {
  const factory Note({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required String content,
    @HiveField(3) @Default([]) List<int> topicIds,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) String? icon,
    @HiveField(6) @Default(false) bool isImportant,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
