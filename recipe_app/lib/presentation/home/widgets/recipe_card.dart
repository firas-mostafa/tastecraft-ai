import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/data/models/recipe_models/recipe_model.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart';
import 'package:recipe_app/presentation/widgets/translated_text.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

import 'package:recipe_app/helpers/image/recipe_image_helper.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipeModel;
  const RecipeCard({super.key, required this.recipeModel});

  @override
  Widget build(BuildContext context) {
    final hasImage = recipeModel.image != null && recipeModel.image!.isNotEmpty;

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, 'recipe_detail', arguments: recipeModel),
      child: Container(
        height: context.setMineSize(380),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.setMineSize(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                hasImage
                    ? recipeModel.image!
                    : RecipeImageHelper.getFallbackImage(
                        recipeModel.id,
                        recipeModel.title,
                      ),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallbackBackground(context),
              ),
            ),

            // Gradient Overlay for text readability
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color.fromARGB(217, 0, 0, 0),
                      Color.fromARGB(127, 0, 0, 0),
                      Colors.transparent,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),

            // Content Layer
            Positioned(
              left: context.setMineSize(16),
              right: context.setMineSize(16),
              bottom: context.setMineSize(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  TranslatedText(
                    recipeModel.title,
                    textAlign: TextAlign.start,
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: context.setMineSize(22),
                        ) ??
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: context.setMineSize(22),
                        ),
                  ),
                  SizedBox(height: context.setMineSize(8)),

                  // Description
                  if (recipeModel.description != null &&
                      recipeModel.description!.isNotEmpty) ...[
                    Text(
                      recipeModel.description!,
                      style: TextStyle(
                        color: Colors.white.withAlpha(204),
                        fontSize: context.setMineSize(14),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.setMineSize(12)),
                  ],

                  // Info Chips
                  Wrap(
                    spacing: context.setMineSize(8),
                    runSpacing: context.setMineSize(8),
                    children: [
                      _buildChip(
                        context,
                        icon: Icons.timer_outlined,
                        label:
                            "${recipeModel.timeMinutes} ${AppLocalizations.of(context)!.minuteShort}",
                      ),
                      if (recipeModel.tags.isNotEmpty)
                        _buildChip(
                          context,
                          icon: Icons.local_offer_outlined,
                          label: recipeModel.tags.first.name,
                        ),
                      _buildChip(
                        context,
                        icon: null,
                        label: "${recipeModel.price}\$",
                      ),
                    ],
                  ),
                  SizedBox(height: context.setMineSize(16)),

                  // "View Details" Button mimicking "Book now"
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: context.setMineSize(14),
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(
                        context.setMineSize(24),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.viewRecipe,
                      style: TextStyle(
                        color: context.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: context.setMineSize(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top Right Actions (Edit & Delete)
            Positioned(
              top: context.setMineSize(16),
              right: context.setMineSize(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionIcon(
                    context,
                    icon: Icons.edit_rounded,
                    onTap: () => Navigator.pushNamed(
                      context,
                      'edit_recipe',
                      arguments: recipeModel,
                    ),
                  ),
                  SizedBox(width: context.setMineSize(8)),
                  _buildActionIcon(
                    context,
                    icon: Icons.delete_outline_rounded,
                    onTap: () => context.read<RecipeCubit>().deleteRecipeByID(
                      recipeModel.id,
                    ),
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.primary.withAlpha(200),
            context.colorScheme.tertiary.withAlpha(200),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_menu_rounded,
          size: context.setMineSize(64),
          color: Colors.white.withAlpha(127),
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    IconData? icon,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.setMineSize(10),
        vertical: context.setMineSize(6),
      ),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(100),
        borderRadius: BorderRadius.circular(context.setMineSize(16)),
        border: Border.all(color: Colors.white.withAlpha(40), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: context.setMineSize(14)),
            SizedBox(width: context.setMineSize(4)),
          ],
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: context.setMineSize(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.setMineSize(8)),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(76),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.redAccent : Colors.white,
          size: context.setMineSize(18),
        ),
      ),
    );
  }
}
