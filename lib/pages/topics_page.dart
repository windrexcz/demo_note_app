import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/topic.dart';
import '../providers/providers.dart';
import '../widgets/topic_card.dart';
import '../widgets/icon_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopicsPage extends ConsumerStatefulWidget {
  const TopicsPage({super.key});

  @override
  ConsumerState<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends ConsumerState<TopicsPage> {
  @override
  Widget build(BuildContext context) {
    final topicsState = ref.watch(topicsManagerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.topics),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTopicDialog(context),
            tooltip: l10n.newTopic,
          ),
        ],
      ),
      body: topicsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : topicsState.error != null
              ? Center(child: Text('${l10n.errorPrefix}: ${topicsState.error}'))
              : topicsState.topics.isEmpty
                  ? Center(
                      child: Text(
                        l10n.emptyTopics,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : _buildListView(topicsState.topics),
    );
  }

  Widget _buildListView(List<Topic> topics) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TopicCard(
            topic: topic,
            onTap: () => context.push('/topics/${topic.id}'),
            onEdit: () => _showEditTopicDialog(context, topic),
            onDelete: () => _showDeleteTopicDialog(context, topic),
          ),
        );
      },
    );
  }

  void _showAddTopicDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedIcon;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.newTopic),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: l10n.topicName,
                      hintText: l10n.topicNameHint,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.validationTopicNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: l10n.description,
                      hintText: l10n.descriptionHint,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  IconPicker(
                    selectedIcon: selectedIcon,
                    onIconSelected: (icon) {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final topicsManager =
                      ref.read(topicsManagerProvider.notifier);
                  final newId = topicsManager.getNextId();
                  final topic = Topic(
                    id: newId,
                    name: nameController.text,
                    description: descriptionController.text,
                    icon: selectedIcon,
                  );
                  topicsManager.addTopic(topic);
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.add),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTopicDialog(BuildContext context, Topic topic) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: topic.name);
    final descriptionController =
        TextEditingController(text: topic.description);
    String? selectedIcon = topic.icon;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.editTopic),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: l10n.topicName,
                      hintText: l10n.topicNameHint,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.validationTopicNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: l10n.description,
                      hintText: l10n.descriptionHint,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  IconPicker(
                    selectedIcon: selectedIcon,
                    onIconSelected: (icon) {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final updatedTopic = topic.copyWith(
                    name: nameController.text,
                    description: descriptionController.text,
                    icon: selectedIcon,
                  );
                  ref
                      .read(topicsManagerProvider.notifier)
                      .updateTopic(updatedTopic);
                  Navigator.pop(context);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteTopicDialog(BuildContext context, Topic topic) {
    final l10n = AppLocalizations.of(context)!;
    final notesState = ref.read(notesManagerProvider);

    // Count notes in this topic
    final notesInTopic = notesState.notes
        .where((note) => note.topicIds.contains(topic.id))
        .toList();
    final noteCount = notesInTopic.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTopic),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.deleteTopicMessage),
            const SizedBox(height: 16),
            if (noteCount > 0) ...[
              Text(
                l10n.topicContainsNotes(noteCount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          if (noteCount > 0) ...[
            OutlinedButton(
              onPressed: () {
                // Delete topic only, remove from notes
                final notesManager = ref.read(notesManagerProvider.notifier);
                for (final note in notesInTopic) {
                  final updatedTopicIds =
                      note.topicIds.where((id) => id != topic.id).toList();
                  notesManager
                      .updateNote(note.copyWith(topicIds: updatedTopicIds));
                }
                ref.read(topicsManagerProvider.notifier).deleteTopic(topic.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.topicDeleted)),
                );
              },
              child: Text(
                l10n.deleteTopicOnly,
                textAlign: TextAlign.center,
              ),
            ),
            FilledButton(
              onPressed: () {
                // Delete topic and all notes
                final notesManager = ref.read(notesManagerProvider.notifier);
                for (final note in notesInTopic) {
                  notesManager.deleteNote(note.id);
                }
                ref.read(topicsManagerProvider.notifier).deleteTopic(topic.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(l10n.topicDeletedWithNotes(noteCount))),
                );
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                l10n.deleteTopicAndNotes,
                textAlign: TextAlign.center,
              ),
            ),
          ] else ...[
            FilledButton(
              onPressed: () {
                ref.read(topicsManagerProvider.notifier).deleteTopic(topic.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.topicDeleted)),
                );
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        ],
      ),
    );
  }
}
