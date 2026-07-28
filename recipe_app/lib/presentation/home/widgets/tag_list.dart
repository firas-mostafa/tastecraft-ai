import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/helpers/responsive/device_utils.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart';
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart';
import 'package:recipe_app/l10n/app_localizations.dart';

class TagList extends StatelessWidget {
  TagList({super.key});
  
  final List<IconData> tagsIcon = [
    Icons.apps_rounded,
    Icons.breakfast_dining_rounded,
    Icons.lunch_dining_rounded,
    Icons.dinner_dining_rounded,
    Icons.fastfood_rounded,
    Icons.icecream_rounded,
    Icons.eco_rounded,
    Icons.whatshot_rounded,
    Icons.local_drink_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> tagNames = [
      l10n.tagAll,
      l10n.tagBreakfast,
      l10n.tagLunch,
      l10n.tagDinner,
      l10n.tagSandwich,
      l10n.tagDessert,
      l10n.tagSalad,
      l10n.tagSpicy,
      l10n.tagDrink,
    ];
    final List<String> tagNamesForDb = [
      "All",
      "Breakfast",
      "Lunch",
      "Dinner",
      "Sandwich",
      "Dessert",
      "Salads",
      "Spicy Meals",
      "Drinks",
    ];
    return SizedBox(
      height: context.setMineSize(50),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: DeviceUtils.valueDecider<double>(
            context,
            onMobile: context.screenWidth * 0.03,
            onTablet: context.screenWidth * 0.05,
            onDesktop: context.screenWidth * 0.1,
          ),
        ),
        scrollDirection: Axis.horizontal,
        itemCount: tagsIcon.length,
        itemBuilder: (context, index) {
          return BlocBuilder<RecipeCubit, RecipeState>(
            builder: (context, state) {
              final cubit = context.read<RecipeCubit>();
              final isSelected = cubit.selectedHomeTagIndex == index;
              
              return GestureDetector(
                onTap: () {
                  final tag = index == 0 ? null : tagNamesForDb[index];
                  cubit.changeHomeTag(index, tag);
                },
                child: Container(
                  height: context.setMineSize(50),
                  padding: EdgeInsets.symmetric(horizontal: context.setMineSize(20)),
                  margin: EdgeInsets.symmetric(horizontal: context.setMineSize(8)),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.colorScheme.primary
                        : context.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(context.setMineSize(100)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        tagsIcon[index],
                        size: context.setMineSize(20),
                        color: isSelected
                            ? context.colorScheme.onPrimary
                            : context.colorScheme.secondary,
                      ),
                      SizedBox(width: context.setMineSize(8)),
                      Text(
                        tagNames[index],
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: isSelected
                              ? context.colorScheme.onPrimary
                              : context.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
