part of 'recipe_cubit.dart';

abstract class RecipeState {}

final class RecipeInitial extends RecipeState {}

final class CreateRecipeLoading extends RecipeState {}

final class CreateRecipeFailure extends RecipeState {
  final String errorMessage;
  CreateRecipeFailure(this.errorMessage);
}

final class CreateRecipeSuccess extends RecipeState {
  final RecipeModel recipeModel;

  CreateRecipeSuccess(this.recipeModel);
}

final class GetRecipesLoading extends RecipeState {}

final class GetRecipesFailure extends RecipeState {
  final String errorMessage;
  GetRecipesFailure(this.errorMessage);
}

final class GetRecipesSuccess extends RecipeState {
  final List<RecipeModel> recipes;

  GetRecipesSuccess(this.recipes);
}

final class UploadRecipePicLoading extends RecipeState {}

final class UploadRecipePicFailure extends RecipeState {
  final String errorMessage;
  UploadRecipePicFailure(this.errorMessage);
}

final class UploadRecipePicSuccess extends RecipeState {
  final RecipeImageModel recipeImageModel;

  UploadRecipePicSuccess(this.recipeImageModel);
}

final class TagsAndIngredients extends RecipeState {
  final List<String> tags;
  final List<String> ingredients;
  TagsAndIngredients(this.tags, this.ingredients);
}

final class DeleteRecipeSuccess extends RecipeState {}

final class DeleteRecipeLoading extends RecipeState {}

final class DeleteRecipeFailure extends RecipeState {
  final String errorMessage;
  DeleteRecipeFailure(this.errorMessage);
}

final class GetRecipeSuccess extends RecipeState {
  final RecipeModel recipeModel;
  GetRecipeSuccess(this.recipeModel);
}

final class GetRecipeLoading extends RecipeState {}

final class GetRecipeFailure extends RecipeState {
  final String errorMessage;
  GetRecipeFailure(this.errorMessage);
}

final class EditRecipeLoading extends RecipeState {}

final class EditRecipeFailure extends RecipeState {
  final String errorMessage;
  EditRecipeFailure(this.errorMessage);
}

final class CompleteRecipeAiLoading extends RecipeState {}

final class CompleteRecipeAiSuccess extends RecipeState {
  final RecipeModel recipeModel;
  CompleteRecipeAiSuccess(this.recipeModel);
}

final class CompleteRecipeAiFailure extends RecipeState {
  final String errorMessage;
  CompleteRecipeAiFailure(this.errorMessage);
}

final class EditRecipeSuccess extends RecipeState {
  final RecipeModel recipeModel;
  EditRecipeSuccess(this.recipeModel);
}

final class RecipeSuggestionLoading extends RecipeState {}

final class RecipeSuggestionSuccess extends RecipeState {
  final RecipeModel recipeModel;
  RecipeSuggestionSuccess(this.recipeModel);
}

final class RecipeSuggestionFailure extends RecipeState {
  final String errorMessage;
  RecipeSuggestionFailure(this.errorMessage);
}

final class RecipeRatingLoading extends RecipeState {}

final class RecipeRatingSuccess extends RecipeState {
  final RecipeModel recipeModel;
  RecipeRatingSuccess(this.recipeModel);
}

final class RecipeRatingFailure extends RecipeState {
  final String errorMessage;
  RecipeRatingFailure(this.errorMessage);
}
