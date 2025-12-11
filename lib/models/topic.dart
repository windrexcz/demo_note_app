// This hive object is used for topics serialization and storage.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

@freezed
@HiveType(typeId: 1)
class Topic with _$Topic {
  const factory Topic({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) required String description,
    @HiveField(3) String? icon,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
