import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart'
    show ThemeHelperExtension;
import 'package:recipe_app/presentation/widgets/custom_text_field.dart'
    show CustomTextField;
import 'package:recipe_app/l10n/app_localizations.dart';
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<RecipeCubit>();
    return SizedBox(
      width: context.setWidth(400),
      height: context.setHeight(45) > 45 ? context.setHeight(45) : 45,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              onChanged: (value) => cubit.searchRecipes(value),
              onFieldSubmitted: (value) => cubit.searchRecipes(value),
              textInputAction: TextInputAction.search,
              focusNode: FocusNode(),
              controller: cubit.searchController,
              text: l10n.searchHint,
              suffix: SizedBox(
                height: context.setMineSize(5),
                width: context.setMineSize(5),
                child: Center(
                  child: Icon(
                    Icons.search_rounded,
                    color: context.colorScheme.outline,
                    size: context.setMineSize(24),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: context.setMineSize(10)),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: context.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(context.setMineSize(20))),
                ),
                isScrollControlled: true,
                builder: (sheetContext) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: context.setMineSize(20),
                      right: context.setMineSize(20),
                      top: context.setMineSize(20),
                      bottom: MediaQuery.of(sheetContext).viewInsets.bottom + context.setMineSize(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.advancedFilters,
                          style: context.textTheme.headlineMedium!.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: context.setMineSize(20)),
                        CustomTextField(
                          onChanged: (_) => cubit.applyAdvancedFilters(),
                          onFieldSubmitted: (_) => cubit.applyAdvancedFilters(),
                          textInputAction: TextInputAction.next,
                          focusNode: FocusNode(),
                          controller: cubit.filterTagsController,
                          text: l10n.recipeTags,
                        ),
                        SizedBox(height: context.setMineSize(15)),
                        CustomTextField(
                          onChanged: (_) => cubit.applyAdvancedFilters(),
                          onFieldSubmitted: (_) => cubit.applyAdvancedFilters(),
                          textInputAction: TextInputAction.next,
                          focusNode: FocusNode(),
                          controller: cubit.filterIngredientsController,
                          text: l10n.recipeIngredients,
                        ),
                        SizedBox(height: context.setMineSize(15)),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                onChanged: (_) => cubit.applyAdvancedFilters(),
                                onFieldSubmitted: (_) => cubit.applyAdvancedFilters(),
                                textInputAction: TextInputAction.next,
                                focusNode: FocusNode(),
                                controller: cubit.filterTimeController,
                                text: l10n.recipeTime.replaceAll('*', '').trim(),
                              ),
                            ),
                            SizedBox(width: context.setMineSize(10)),
                            Expanded(
                              child: CustomTextField(
                                onChanged: (_) => cubit.applyAdvancedFilters(),
                                onFieldSubmitted: (_) => cubit.applyAdvancedFilters(),
                                textInputAction: TextInputAction.done,
                                focusNode: FocusNode(),
                                controller: cubit.filterCostController,
                                text: l10n.recipeCost.replaceAll('*', '').trim(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: context.setMineSize(20)),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: context.colorScheme.errorContainer,
                                  foregroundColor: context.colorScheme.onErrorContainer,
                                  padding: EdgeInsets.all(context.setMineSize(12)),
                                ),
                                onPressed: () {
                                  cubit.clearAdvancedFilters();
                                  cubit.searchController.clear();
                                  cubit.searchQuery = '';
                                  cubit.changeHomeTag(0, null);
                                  Navigator.pop(sheetContext);
                                },
                                child: Text(l10n.clear, style: context.textTheme.titleMedium!.copyWith(color: context.colorScheme.onErrorContainer)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              width: context.setMineSize(50),
              height: double.infinity,
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(context.setMineSize(10)),
              ),
              child: Center(
                child: Icon(
                  Icons.tune_rounded,
                  color: context.colorScheme.primary,
                  size: context.setMineSize(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
