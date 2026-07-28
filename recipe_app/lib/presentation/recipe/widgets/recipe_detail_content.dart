import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/recipe_models/recipe_model.dart' show RecipeModel;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart' show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart' show ThemeHelperExtension;
import 'package:recipe_app/presentation/recipe/widgets/recipe_hero_app_bar.dart' show RecipeHeroAppBar;
import 'package:recipe_app/presentation/recipe/widgets/quick_info_row.dart' show QuickInfoRow;
import 'package:recipe_app/presentation/recipe/widgets/recipe_sections.dart' show SectionTitle, DescriptionSection, TagsSection, IngredientsSection;
import 'package:recipe_app/presentation/recipe/widgets/rating_notes_section.dart' show RatingNotesSection;
import 'package:recipe_app/l10n/app_localizations.dart';

class RecipeDetailContent extends StatelessWidget {
  final RecipeModel recipe;
  final ValueChanged<RecipeModel> onRecipeChanged;

  const RecipeDetailContent({
    required this.recipe,
    required this.onRecipeChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CustomScrollView(
      slivers: [
        RecipeHeroAppBar(id: recipe.id, title: recipe.title, image: recipe.image),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.setMineSize(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.setMineSize(20)),
                QuickInfoRow(
                  price: recipe.price,
                  timeMinutes: recipe.timeMinutes,
                  tagCount: recipe.tags.length,
                  calories: recipe.calories,
                ),
                SizedBox(height: context.setMineSize(24)),
                SectionTitle(title: l10n.descriptionSection),
                SizedBox(height: context.setMineSize(10)),
                DescriptionSection(
                  description: (recipe.description == null || recipe.description!.isEmpty)
                      ? l10n.noDescription
                      : recipe.description!,
                ),
                SizedBox(height: context.setMineSize(24)),
                if (recipe.tags.isNotEmpty) ...[
                  SectionTitle(title: l10n.recipeTags),
                  SizedBox(height: context.setMineSize(10)),
                  TagsSection(recipe: recipe),
                  SizedBox(height: context.setMineSize(24)),
                ],
                if (recipe.ingredients.isNotEmpty) ...[
                  SectionTitle(title: l10n.ingredientsSection),
                  SizedBox(height: context.setMineSize(10)),
                  IngredientsSection(recipe: recipe),
                  SizedBox(height: context.setMineSize(24)),
                ],
                if (recipe.link.isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    height: context.setMineSize(50),
                    child: FilledButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(recipe.link),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.open_in_new_rounded,
                        size: context.setMineSize(18),
                      ),
                      label: Text(
                        l10n.addReference,
                        style: context.textTheme.titleSmall!.copyWith(
                          color: context.colorScheme.onPrimary,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            context.setMineSize(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.setMineSize(24)),
                ],
                RatingNotesSection(
                  recipe: recipe,
                  onRecipeChanged: onRecipeChanged,
                ),
                SizedBox(height: context.setMineSize(40)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
