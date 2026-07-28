import 'package:flutter/material.dart';
import 'package:recipe_app/data/models/meal_plan_models/meal_plan_model.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/l10n/app_localizations.dart';
import 'package:recipe_app/presentation/widgets/translated_text.dart';
import 'meal_section.dart';

class DayCard extends StatelessWidget {
  final MealPlanDay day;

  const DayCard({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: context.setMineSize(16),
        vertical: context.setMineSize(8),
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        title: TranslatedText(
          day.day,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.primary,
          ),
        ),
        children: [
          MealSection(
            title: l10n.tagBreakfast,
            options: day.breakfast,
            icon: Icons.wb_sunny_outlined,
          ),
          MealSection(
            title: l10n.tagLunch,
            options: day.lunch,
            icon: Icons.restaurant,
          ),
          MealSection(
            title: l10n.tagDessert,
            options: day.dessert,
            icon: Icons.icecream_outlined,
          ),
          MealSection(
            title: l10n.tagDinner,
            options: day.dinner,
            icon: Icons.nights_stay_outlined,
          ),
          SizedBox(height: context.setHeight(16)),
        ],
      ),
    );
  }
}
