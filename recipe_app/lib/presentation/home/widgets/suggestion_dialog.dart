import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe_models/recipe_model.dart'
    show RecipeModel;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/helpers/image/recipe_image_helper.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

void showSuggestionDialog(BuildContext context, RecipeModel recipe) {
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: context.colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.suggestedRecipeDialogTitle)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                (recipe.image != null && recipe.image!.isNotEmpty)
                    ? recipe.image!
                    : RecipeImageHelper.getFallbackImage(
                        recipe.id,
                        recipe.title,
                      ),
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (c, o, s) => Container(
                  height: 150,
                  color: context.colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.restaurant, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              recipe.title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              recipe.description ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (recipe.calories != null && recipe.calories! > 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.whatshot,
                        size: 16,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text('${recipe.calories} kcal'),
                    ],
                  ),
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text('${recipe.timeMinutes} min'),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pushNamed(context, 'recipe_detail', arguments: recipe);
            },
            child: Text(l10n.viewDetails),
          ),
        ],
      );
    },
  );
}
