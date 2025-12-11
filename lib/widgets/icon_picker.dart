import 'package:flutter/material.dart';
import '../constants/app_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IconPicker extends StatefulWidget {
  final String? selectedIcon;
  final ValueChanged<String?> onIconSelected;

  const IconPicker({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.iconLabel,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            if (widget.selectedIcon != null)
              TextButton.icon(
                onPressed: () => widget.onIconSelected(null),
                icon: const Icon(Icons.clear, size: 16),
                label: Text(l10n.removeIcon),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppIcons.availableIcons.map((iconEntry) {
            final isSelected = widget.selectedIcon == iconEntry.key;

            return InkWell(
              onTap: () => widget.onIconSelected(iconEntry.key),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Icon(
                  iconEntry.value,
                  size: 24,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
