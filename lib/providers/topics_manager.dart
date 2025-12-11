import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/topic.dart';

class TopicsState {
  final List<Topic> topics;
  final bool isLoading;
  final String? error;

  TopicsState({
    this.topics = const [],
    this.isLoading = false,
    this.error,
  });

  TopicsState copyWith({
    List<Topic>? topics,
    bool? isLoading,
    String? error,
  }) {
    return TopicsState(
      topics: topics ?? this.topics,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TopicsManager extends StateNotifier<TopicsState> {
  final Box<Topic> _topicsBox;

  TopicsManager(this._topicsBox) : super(TopicsState()) {
    _loadTopics();
  }

  int getNextId() {
    if (_topicsBox.isEmpty) {
      return 1;
    }
    final maxId = _topicsBox.values.map((topic) => topic.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  void _loadTopics() {
    state = state.copyWith(isLoading: true);
    try {
      final topics = _topicsBox.values.toList();
      state = state.copyWith(topics: topics, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addTopic(Topic topic) async {
    try {
      await _topicsBox.put(topic.id, topic);
      _loadTopics();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateTopic(Topic topic) async {
    try {
      await _topicsBox.put(topic.id, topic);
      _loadTopics();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteTopic(int id) async {
    try {
      await _topicsBox.delete(id);
      _loadTopics();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Topic? getTopicById(int id) {
    try {
      return state.topics.firstWhere((topic) => topic.id == id);
    } catch (e) {
      return null;
    }
  }
}
