import 'package:recipe_app/data/models/recipe_models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/meal_plan_models/meal_plan_model.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/presentation/widgets/translated_text.dart';

class RecipeOptionCard extends StatelessWidget {
  final MealPlanRecipeOption option;

  const RecipeOptionCard({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Recipe Detail Screen, passing a stub RecipeModel 
        // to be completed by AI later if the user chooses.
        Navigator.pushNamed(
          context,
          'recipe_detail', 
          arguments: RecipeModel(
            id: option.id,
            title: option.title,
            description: option.description,
            timeMinutes: option.timeMinutes,
            price: option.price.toString(),
            link: '',
            tags: const [],
            ingredients: const [],
            image: null,
          ),
        );
      },
      child: Container(
        width: context.setWidth(200),
        margin: EdgeInsets.symmetric(horizontal: context.setMineSize(4)),
        padding: EdgeInsets.all(context.setMineSize(12)),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TranslatedText(
              option.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: context.setHeight(4)),
            Expanded(
              child: TranslatedText(
                option.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
              ),
            ),
            SizedBox(height: context.setHeight(4)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14, color: context.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text('${option.timeMinutes}m', style: context.textTheme.labelSmall),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 14, color: context.colorScheme.primary),
                    Text('${option.price}', style: context.textTheme.labelSmall),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
