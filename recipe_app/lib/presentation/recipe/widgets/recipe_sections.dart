import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe_models/recipe_model.dart'
    show RecipeModel;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;
import 'package:recipe_app/presentation/widgets/translated_text.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleLarge!.copyWith(
        color: context.colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class DescriptionSection extends StatelessWidget {
  final String description;
  const DescriptionSection({required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.setMineSize(16)),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(context.setMineSize(16)),
      ),
      child: TranslatedText(
        description,
        style: context.textTheme.bodyLarge!.copyWith(
          color: context.colorScheme.onSurface,
          height: 1.6,
        ),
      ),
    );
  }
}

class TagsSection extends StatelessWidget {
  final RecipeModel recipe;
  const TagsSection({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.setMineSize(8),
      runSpacing: context.setMineSize(8),
      children: recipe.tags
          .map(
            (tag) => Chip(
              label: TranslatedText(
                tag.name,
                style: context.textTheme.labelLarge!.copyWith(
                  color: context.colorScheme.onPrimaryContainer,
                ),
              ),
              backgroundColor: context.colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.setMineSize(12)),
              ),
              side: BorderSide.none,
            ),
          )
          .toList(),
    );
  }
}

class IngredientsSection extends StatelessWidget {
  final RecipeModel recipe;
  const IngredientsSection({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.setMineSize(16)),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(context.setMineSize(16)),
      ),
      child: Column(
        children: recipe.ingredients.asMap().entries.map((entry) {
          final isLast = entry.key == recipe.ingredients.length - 1;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.setMineSize(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: context.setMineSize(8),
                      height: context.setMineSize(8),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: context.setMineSize(14)),
                    Expanded(
                      child: TranslatedText(
                        entry.value.name,
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  color: context.colorScheme.surfaceContainerHigh,
                  height: 1,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
