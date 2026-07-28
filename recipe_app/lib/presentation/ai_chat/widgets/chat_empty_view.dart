import 'package:flutter/material.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

class ChatEmptyView extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionSelected;

  const ChatEmptyView({
    super.key,
    required this.suggestions,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(context.setMineSize(24)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: context.setHeight(60)),
            Container(
              width: context.setMineSize(80),
              height: context.setMineSize(80),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.colorScheme.primary,
                    context.colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.colorScheme.primary.withAlpha(60),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.auto_awesome,
                size: context.setMineSize(40),
                color: context.colorScheme.onPrimary,
              ),
            ),
            SizedBox(height: context.setHeight(24)),
            Text(
              l10n.aiChatSubtitle,
              style: context.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.secondary,
              ),
            ),
            SizedBox(height: context.setHeight(8)),
            Text(
              l10n.aiChatDescription,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
            SizedBox(height: context.setHeight(40)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.aiChatTryAsking,
                style: context.textTheme.titleSmall!.copyWith(
                  color: context.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: context.setHeight(12)),
            Wrap(
              spacing: context.setMineSize(8),
              runSpacing: context.setMineSize(8),
              children: suggestions.map((suggestion) {
                return ActionChip(
                  label: Text(
                    suggestion,
                    style: TextStyle(
                      fontSize: context.setMineSize(12),
                      color: context.colorScheme.secondary,
                    ),
                  ),
                  backgroundColor: context.colorScheme.surfaceContainerLow,
                  side: BorderSide(
                    color: context.colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.setMineSize(12),
                    ),
                  ),
                  onPressed: () => onSuggestionSelected(suggestion),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
