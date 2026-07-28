import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/meal_plan_models/meal_plan_model.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'recipe_option_card.dart';

class MealSection extends StatelessWidget {
  final String title;
  final List<MealPlanRecipeOption> options;
  final IconData icon;

  const MealSection({
    super.key,
    required this.title,
    required this.options,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.setMineSize(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.setMineSize(16)),
            child: Row(
              children: [
                Icon(icon, color: context.colorScheme.secondary, size: 20),
                SizedBox(width: context.setMineSize(8)),
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: context.setHeight(8)),
          SizedBox(
            height: context.setHeight(160),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: context.setMineSize(12)),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return RecipeOptionCard(option: options[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
