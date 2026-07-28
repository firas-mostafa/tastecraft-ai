import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/data/models/recipe_models/recipe_model.dart' show RecipeModel;
import 'package:recipe_app/helpers/theme/theme_helper_extension.dart' show ThemeHelperExtension;
import 'package:recipe_app/logic/recipe_cubit/recipe_cubit.dart';
import 'package:recipe_app/presentation/recipe/widgets/recipe_detail_content.dart' show RecipeDetailContent;
import 'package:recipe_app/l10n/app_localizations.dart';

class RecipeDetail extends StatefulWidget {
  final RecipeModel recipe;
  const RecipeDetail({required this.recipe, super.key});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  late RecipeModel currentRecipe;

  @override
  void initState() {
    super.initState();
    currentRecipe = widget.recipe;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<RecipeCubit, RecipeState>(
      listener: (context, state) {
        if (state is CompleteRecipeAiLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is CompleteRecipeAiFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
          );
        } else if (state is CompleteRecipeAiSuccess) {
          Navigator.pop(context);
          setState(() {
            currentRecipe = state.recipeModel;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: RecipeDetailContent(
            recipe: currentRecipe,
            onRecipeChanged: (updated) => setState(() => currentRecipe = updated),
          ),
          floatingActionButton: (currentRecipe.description == null ||
                  currentRecipe.description!.isEmpty ||
                  currentRecipe.ingredients.isEmpty)
              ? FloatingActionButton.extended(
                  onPressed: () {
                    context.read<RecipeCubit>().completeRecipeAi(currentRecipe.id);
                  },
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(l10n.completeRecipe),
                  backgroundColor: context.colorScheme.primary,
                  foregroundColor: context.colorScheme.onPrimary,
                )
              : null,
        );
      },
    );
  }
}
