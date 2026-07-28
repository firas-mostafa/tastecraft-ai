import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

class ChipSelectionBox extends StatelessWidget {
  final String title;
  final String description;
  final List<String> availableOptions;
  final List<String> selectedOptions;
  final bool isDisease;
  final VoidCallback onAddPressed;
  final ValueChanged<List<String>> onChanged;

  const ChipSelectionBox({
    super.key,
    required this.title,
    required this.description,
    required this.availableOptions,
    required this.selectedOptions,
    required this.isDisease,
    required this.onAddPressed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.setMineSize(16)),
        side: BorderSide(color: context.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.setMineSize(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: context.colorScheme.primary)),
                      SizedBox(height: context.setHeight(4)),
                      Text(description, style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline_rounded, color: context.colorScheme.primary),
                  onPressed: onAddPressed,
                ),
              ],
            ),
            const Divider(height: 24),
            Wrap(
              spacing: context.setMineSize(8),
              runSpacing: context.setMineSize(8),
              children: [
                ...availableOptions.map((option) => _buildChoiceChip(
                      context,
                      label: option,
                      selected: selectedOptions.contains(option),
                      onSelected: (selected) {
                        final list = List<String>.from(selectedOptions);
                        if (selected) {
                          list.add(option);
                          list.remove(l10n.noneLabel);
                        } else {
                          list.remove(option);
                        }
                        onChanged(list);
                      },
                    )),
                _buildChoiceChip(
                  context,
                  label: l10n.noneLabel,
                  selected: selectedOptions.contains(l10n.noneLabel) || selectedOptions.isEmpty,
                  onSelected: (selected) {
                    final list = List<String>.from(selectedOptions);
                    if (selected) {
                      list.clear();
                      list.add(l10n.noneLabel);
                    } else {
                      list.remove(l10n.noneLabel);
                    }
                    onChanged(list);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip(BuildContext context, {required String label, required bool selected, required ValueChanged<bool> onSelected}) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: context.colorScheme.primary.withAlpha(50),
      labelStyle: TextStyle(
        color: selected ? context.colorScheme.primary : context.colorScheme.onSurface,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: onSelected,
    );
  }
}
