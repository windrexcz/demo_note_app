import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';
import '../constants/app_icons.dart';
import '../widgets/icon_picker.dart';
import '../utils/date_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoteDetailPage extends ConsumerWidget {
  final int noteId;

  const NoteDetailPage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the entire notes state to rebuild when note is updated
    final notesState = ref.watch(notesManagerProvider);
    final note = notesState.notes.where((n) => n.id == noteId).firstOrNull;
    final l10n = AppLocalizations.of(context)!;

    if (note == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.noteNotFoundTitle),
        ),
        body: Center(
          child: Text(l10n.noteNotFoundMessage),
        ),
      );
    }

    final topicsManager = ref.watch(topicsManagerProvider.notifier);
    final topics = note.topicIds
        .map((id) => topicsManager.getTopicById(id))
        .where((t) => t != null)
        .toList();
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(note.isImportant ? Icons.star : Icons.star_border),
            onPressed: () {
              final updatedNote = note.copyWith(isImportant: !note.isImportant);
              ref.read(notesManagerProvider.notifier).updateNote(updatedNote);
            },
            tooltip: note.isImportant
                ? l10n.markAsNotImportant
                : l10n.markAsImportant,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditNoteDialog(context, ref, note),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteNote(context, ref, note.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Topics info
            if (topics.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: topics.map((topic) {
                  if (topic == null) return const SizedBox.shrink();
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (topic.icon != null &&
                            AppIcons.fromKey(topic.icon) != null) ...[
                          Icon(
                            AppIcons.fromKey(topic.icon)!,
                            size: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          topic.name,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),

            // Title with icon
            Row(
              children: [
                if (note.icon != null &&
                    AppIcons.fromKey(note.icon) != null) ...[
                  Icon(
                    AppIcons.fromKey(note.icon)!,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    note.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date
            Text(
              '${l10n.created}: ${localizeDate(locale.languageCode, note.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            // Content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                note.content.isEmpty ? 'No content' : note.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNoteDialog(BuildContext context, WidgetRef ref, note) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    final topicsState = ref.read(topicsManagerProvider);
    Set<int> selectedTopicIds = Set.from(note.topicIds);
    String? selectedIcon = note.icon;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.editNote),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: l10n.title,
                      hintText: l10n.titleHint,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.validationTitleRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contentController,
                    decoration: InputDecoration(
                      labelText: l10n.content,
                      hintText: l10n.contentHint,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.validationContentRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.topicsLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: topicsState.topics.map((topic) {
                      final isSelected = selectedTopicIds.contains(topic.id);
                      return FilterChip(
                        label: Text(topic.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedTopicIds.add(topic.id);
                            } else {
                              selectedTopicIds.remove(topic.id);
                            }
                          });
                        },
                      );
                    }).toList(),
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
                  final updatedNote = note.copyWith(
                    title: titleController.text,
                    content: contentController.text,
                    topicIds: selectedTopicIds.toList(),
                    icon: selectedIcon,
                  );
                  ref
                      .read(notesManagerProvider.notifier)
                      .updateNote(updatedNote);
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

  void _deleteNote(BuildContext context, WidgetRef ref, int id) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteNote),
        content: Text(l10n.confirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(notesManagerProvider.notifier).deleteNote(id);
              Navigator.pop(context);
              context.pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
