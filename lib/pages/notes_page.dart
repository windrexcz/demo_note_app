import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/note.dart';
import '../providers/providers.dart';
import '../utils/string_utils.dart';
import '../widgets/note_card.dart';
import '../widgets/icon_picker.dart';
import '../services/hive_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesPage extends ConsumerStatefulWidget {
  final int? topicId;

  const NotesPage({super.key, this.topicId});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  String _searchQuery = '';
  bool _isSearchVisible = false;
  bool _showOnlyImportant = false;
  final TextEditingController _searchController = TextEditingController();
  bool _hasCheckedSampleData = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowSampleDataDialog();
    });
  }

  Future<void> _checkAndShowSampleDataDialog() async {
    if (_hasCheckedSampleData) return;
    _hasCheckedSampleData = true;

    final notesState = ref.read(notesManagerProvider);
    final topicsState = ref.read(topicsManagerProvider);

    // Check if both boxes are empty
    if (notesState.notes.isEmpty && topicsState.topics.isEmpty) {
      // Check if user has already declined
      final hasDeclined = await HiveService.hasSampleDataBeenDeclined();
      if (!hasDeclined && mounted) {
        _showSampleDataDialog();
      }
    }
  }

  void _showSampleDataDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.loadSampleDataTitle),
        content: Text(l10n.loadSampleDataMessage),
        actions: [
          TextButton(
            onPressed: () async {
              await HiveService.setSampleDataDeclined(true);
              if (context.mounted) Navigator.pop(dialogContext);
            },
            child: Text(l10n.noThanks),
          ),
          FilledButton(
            onPressed: () async {
              final notesBox = await HiveService.openNotesBox();
              final topicsBox = await HiveService.openTopicsBox();
              await HiveService.loadSampleData(notesBox, topicsBox);

              // Refresh providers
              ref.invalidate(notesManagerProvider);
              ref.invalidate(topicsManagerProvider);

              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text(l10n.loadSampleData),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesManagerProvider);
    final topicsState = ref.watch(topicsManagerProvider);
    final l10n = AppLocalizations.of(context)!;

    // Filter notes by topic if topicId is provided
    var notes = widget.topicId != null
        ? notesState.notes
            .where((note) => note.topicIds.contains(widget.topicId))
            .toList()
        : notesState.notes;

    // Filter notes by search query
    if (_searchQuery.isNotEmpty) {
      final normalizedQuery = normalizeString(_searchQuery);
      notes = notes.where((note) {
        final normalizedTitle = normalizeString(note.title);
        final normalizedContent = normalizeString(note.content);
        return normalizedTitle.contains(normalizedQuery) ||
            normalizedContent.contains(normalizedQuery);
      }).toList();
    }

    // Filter by important if enabled
    if (_showOnlyImportant) {
      notes = notes.where((note) => note.isImportant).toList();
    }

    // Get topic name for subtitle if filtering by topic
    String? topicName;
    if (widget.topicId != null) {
      final topic = topicsState.topics.firstWhere(
        (t) => t.id == widget.topicId,
        orElse: () => throw StateError('Topic not found'),
      );
      topicName = topic.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.notes),
            if (topicName != null)
              Text(
                topicName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_showOnlyImportant ? Icons.star : Icons.star_border),
            onPressed: () {
              setState(() {
                _showOnlyImportant = !_showOnlyImportant;
              });
            },
            tooltip: l10n.showOnlyImportant,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddNoteDialog(context, widget.topicId),
            tooltip: l10n.addNote,
          ),
          IconButton(
              icon: Icon(_isSearchVisible ? Icons.search_off : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearchVisible = !_isSearchVisible;
                  if (!_isSearchVisible) {
                    _searchController.clear();
                    _searchQuery = '';
                  }
                });
              },
              tooltip: l10n.toggleSearch),
        ],
      ),
      body: Column(
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            child: Container(
              height: _isSearchVisible ? 68 : 0,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                boxShadow: _isSearchVisible
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: _isSearchVisible
                  ? TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchNotes,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Expanded(
            child: notesState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : notesState.error != null
                    ? Center(
                        child: Text('${l10n.errorPrefix}: ${notesState.error}'))
                    : notes.isEmpty
                        ? Center(
                            child: Text(
                              _searchQuery.isNotEmpty
                                  ? l10n.noNotesFound
                                  : l10n.emptyNotes,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                        : _buildGridView(notes),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Note> notes) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double cellWidth = 250;
        const double spacing = 8;
        final int crossAxisCount =
            (constraints.maxWidth / (cellWidth + spacing)).floor().clamp(1, 4);
        final double columnWidth =
            (constraints.maxWidth - (spacing * (crossAxisCount + 1))) /
                crossAxisCount;

        // Create columns for masonry layout
        List<List<Note>> columns = List.generate(crossAxisCount, (_) => []);
        for (int i = 0; i < notes.length; i++) {
          columns[i % crossAxisCount].add(notes[i]);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(crossAxisCount, (columnIndex) {
              return SizedBox(
                width: columnWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: columnIndex > 0 ? spacing / 2 : 0,
                    right: columnIndex < crossAxisCount - 1 ? spacing / 2 : 0,
                  ),
                  child: Column(
                    children: columns[columnIndex].map((note) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: spacing),
                        child: NoteCard(
                          note: note,
                          onTap: () => context.push('/notes/${note.id}'),
                          onDelete: () => _deleteNote(note),
                          onToggleImportant: () => _toggleImportant(note),
                          onEdit: () => _showEditNoteDialog(context, note),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  void _deleteNote(Note note) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteNote),
        content: Text(l10n.confirmDeleteNoteMessage(note.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              ref.read(notesManagerProvider.notifier).deleteNote(note.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _toggleImportant(Note note) {
    final updatedNote = note.copyWith(isImportant: !note.isImportant);
    ref.read(notesManagerProvider.notifier).updateNote(updatedNote);
  }

  void _showEditNoteDialog(BuildContext context, Note note) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    final topicsState = ref.read(topicsManagerProvider);
    Set<int> selectedTopicIds = note.topicIds.toSet();
    String? selectedIcon = note.icon;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.editNote),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
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
                    createdAt: DateTime.now(),
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

  void _showAddNoteDialog(BuildContext context, int? defaultTopicId) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final topicsState = ref.read(topicsManagerProvider);
    Set<int> selectedTopicIds = defaultTopicId != null ? {defaultTopicId} : {};
    String? selectedIcon;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.newNote),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final notesManager = ref.read(notesManagerProvider.notifier);
                  final newId = notesManager.getNextId();
                  final note = Note(
                    id: newId,
                    title: titleController.text,
                    content: contentController.text,
                    topicIds: selectedTopicIds.toList(),
                    icon: selectedIcon,
                    createdAt: DateTime.now(),
                  );
                  notesManager.addNote(note);
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
}
