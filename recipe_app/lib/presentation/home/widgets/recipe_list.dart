import 'package:flutter/material.dart';
import 'package:recipe_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'
    show MasonryGridView;
import 'package:recipe_app/helpers/responsive/size_helper_extension.dart'
    show SizeHelperExtension;

import 'package:recipe_app/helpers/responsive/device_utils.dart'
    show DeviceUtils;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart';
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart';
import 'package:recipe_app/presentation/home/widgets/recipe_card.dart';
import 'package:recipe_app/presentation/widgets/custom_dialog.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  void initState() {
    super.initState();
    context.read<RecipeCubit>().getRecipesList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeCubit, RecipeState>(
      listener: (context, state) {
        if (state is GetRecipesFailure) {
          showDialog(
            context: context,
            builder: (context) => CustomDialog(
              icon: Icons.mood_rounded,
              backgroundColor: context.colorScheme.errorContainer,
              text: state.errorMessage,
              textColor: context.colorScheme.onErrorContainer,
            ),
          );
        } else if (!(state is GetRecipesLoading ||
            state is GetRecipesSuccess)) {
          context.read<RecipeCubit>().getRecipesList();
        }
      },
      builder: (context, state) {
        return state is GetRecipesLoading
            ? SizedBox(
                height: context.setHeight(150),
                child: Center(
                  child: CircularProgressIndicator(
                    color: context.colorScheme.primary,
                  ),
                ),
              )
            : state is GetRecipesSuccess
                ? state.recipes.isEmpty
                    ? SizedBox(
                        height: context.setHeight(300),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.no_food_rounded,
                                size: context.setMineSize(64),
                                color: context.colorScheme.outlineVariant,
                              ),
                              SizedBox(height: context.setHeight(16)),
                              Text(
                                "No recipes found here",
                                style: context.textTheme.titleMedium!.copyWith(
                                  color: context.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: DeviceUtils.valueDecider<double>(
                            context,
                            onMobile: context.screenWidth * 0.03,
                            onTablet: context.screenWidth * 0.05,
                            onDesktop: context.screenWidth * 0.1,
                          ),
                          vertical: context.setMineSize(25),
                        ),
                        crossAxisCount: DeviceUtils.valueDecider<int>(
                          context,
                          onMobile: 2,
                          onTablet: 3,
                          onDesktop: 5,
                        ),
                        mainAxisSpacing: context.setMineSize(15),
                        crossAxisSpacing: context.setMineSize(15),
                        itemCount: state.recipes.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, 'new_recipe');
                              },
                              child: Container(
                                height: context.setHeight(200),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.primaryContainer.withAlpha(150),
                                  borderRadius: BorderRadius.circular(context.setMineSize(15)),
                                  border: Border.all(
                                    color: context.colorScheme.primary.withAlpha(100),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        size: context.setMineSize(40),
                                        color: context.colorScheme.primary,
                                      ),
                                      SizedBox(height: context.setHeight(8)),
                                      Text(
                                        AppLocalizations.of(context)!.addRecipe,
                                        style: context.textTheme.titleMedium?.copyWith(
                                          color: context.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return RecipeCard(recipeModel: state.recipes[index - 1]);
                        },
                      )
                : const SizedBox();
      },
    );
  }
}
