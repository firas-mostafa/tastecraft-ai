import 'package:flutter/material.dart' show FocusNode, TextEditingController;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:recipe_app/data/models/recipe_models/recipe_image_model.dart';
import 'package:recipe_app/data/models/recipe_models/recipe_model.dart';
import 'package:recipe_app/data/repositories/recipe_repository.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  RecipeCubit(this.recipeRepository) : super(RecipeInitial());
  TextEditingController recipeCreateTitle = TextEditingController();
  TextEditingController recipeCreateTimeMinutes = TextEditingController();
  TextEditingController recipeCreateprice = TextEditingController();
  TextEditingController recipeCreatelink = TextEditingController();
  TextEditingController recipeCreatedescription = TextEditingController();
  TextEditingController recipeCreateTag = TextEditingController();
  TextEditingController recipeCreateIngredient = TextEditingController();

  XFile? recipeImage;

  FocusNode recipeCreateTitleNode = FocusNode();
  FocusNode recipeCreateTimeMinutesNode = FocusNode();
  FocusNode recipeCreatepriceNode = FocusNode();
  FocusNode recipeCreatelinkNode = FocusNode();
  FocusNode recipeCreatedescriptionNode = FocusNode();
  FocusNode recipeCreateTagNode = FocusNode();
  FocusNode recipeCreateIngredientNode = FocusNode();

  final RecipeRepository recipeRepository;
  final List<String> tags = [];
  final List<String> ingredients = [];

  int selectedHomeTagIndex = 0;
  String? selectedHomeTag;
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  
  String searchTags = '';
  String searchIngredients = '';
  String searchTime = '';
  String searchCost = '';
  TextEditingController filterTagsController = TextEditingController();
  TextEditingController filterIngredientsController = TextEditingController();
  TextEditingController filterTimeController = TextEditingController();
  TextEditingController filterCostController = TextEditingController();

  void applyAdvancedFilters() {
    searchTags = filterTagsController.text;
    searchIngredients = filterIngredientsController.text;
    searchTime = filterTimeController.text;
    searchCost = filterCostController.text;
    getRecipesList();
  }

  void clearAdvancedFilters() {
    filterTagsController.clear();
    filterIngredientsController.clear();
    filterTimeController.clear();
    filterCostController.clear();
    searchTags = '';
    searchIngredients = '';
    searchTime = '';
    searchCost = '';
    getRecipesList();
  }

  void searchRecipes(String query) {
    searchQuery = query;
    getRecipesList();
  }

  void changeHomeTag(int index, String? tag) {
    selectedHomeTagIndex = index;
    selectedHomeTag = tag;
    getRecipesList();
  }

  void addTag() {
    if (!tags.contains(recipeCreateTag.text) &&
        recipeCreateTag.text.isNotEmpty) {
      tags.add(recipeCreateTag.text);
    }
    recipeCreateTag.clear();
    emit(TagsAndIngredients(tags, ingredients));
  }

  void addIngredient() {
    if (!ingredients.contains(recipeCreateIngredient.text) &&
        recipeCreateIngredient.text.isNotEmpty) {
      ingredients.add(recipeCreateIngredient.text);
    }
    recipeCreateIngredient.clear();
    emit(TagsAndIngredients(tags, ingredients));
  }

  void removeTagsIngredients(int index, List<String> items) {
    items.remove(items[index]);
    emit(TagsAndIngredients(tags, ingredients));
  }

  void clearRecipeData() {
    recipeCreateTitle.clear();
    recipeCreateTimeMinutes.clear();
    recipeCreateprice.clear();
    recipeCreatelink.clear();
    recipeCreatedescription.clear();
    recipeCreateTag.clear();
    recipeCreateIngredient.clear();
    tags.clear();
    ingredients.clear();
    recipeImage = null;
    emit(RecipeInitial());
  }

  Future<dynamic> recipeCreate({XFile? image}) async {
    emit(CreateRecipeLoading());
    final response = await recipeRepository.recipeCreate(
      title: recipeCreateTitle.text,
      timeMinutes: int.tryParse(recipeCreateTimeMinutes.text),
      price: recipeCreateprice.text,
      link: recipeCreatelink.text,
      tags: tags,
      ingredients: ingredients,
      description: recipeCreatedescription.text,
    );
    response.fold((errorMessage) => emit(CreateRecipeFailure(errorMessage)), (
      recipe,
    ) async {
      if (image != null) {
        await uploadRecipeePic(image, recipe.id);
        clearRecipeData();
        emit(CreateRecipeSuccess(recipe));
      } else {
        clearRecipeData();
        emit(CreateRecipeSuccess(recipe));
      }
    });
  }

  Future<dynamic> uploadRecipeePic(XFile recipeImage, int recipeID) async {
    emit(UploadRecipePicLoading());
    final response = await recipeRepository.uploadRecipeePic(
      recipeID,
      recipeImage,
    );
    response.fold(
      (errorMessage) => emit(UploadRecipePicFailure(errorMessage)),
      (imageModel) => emit(UploadRecipePicSuccess(imageModel)),
    );
  }

  Future<dynamic> getRecipesList() async {
    emit(GetRecipesLoading());
    final response = await recipeRepository.getRecipesList();
    response.fold(
      (errorMessage) => emit(GetRecipesFailure(errorMessage)),
      (recipes) {
        List<RecipeModel> filtered = recipes;
        if (selectedHomeTagIndex != 0 && selectedHomeTag != null) {
          filtered = filtered.where((r) {
            return r.tags.any((t) => t.name.toLowerCase() == selectedHomeTag!.toLowerCase());
          }).toList();
        }
        if (searchQuery.isNotEmpty) {
          filtered = filtered.where((r) {
            return r.title.toLowerCase().contains(searchQuery.toLowerCase());
          }).toList();
        }
        if (searchTags.isNotEmpty) {
          filtered = filtered.where((r) {
            return r.tags.any((t) => t.name.toLowerCase().contains(searchTags.toLowerCase()));
          }).toList();
        }
        if (searchIngredients.isNotEmpty) {
          filtered = filtered.where((r) {
            return r.ingredients.any((i) => i.name.toLowerCase().contains(searchIngredients.toLowerCase()));
          }).toList();
        }
        if (searchTime.isNotEmpty) {
          final maxTime = num.tryParse(searchTime);
          if (maxTime != null) {
            filtered = filtered.where((r) {
              return r.timeMinutes <= maxTime;
            }).toList();
          }
        }
        if (searchCost.isNotEmpty) {
          filtered = filtered.where((r) {
            return r.price.toLowerCase().contains(searchCost.toLowerCase());
          }).toList();
        }
        emit(GetRecipesSuccess(filtered));
      },
    );
  }

  Future<dynamic> getRecipeByID(int id) async {
    emit(GetRecipeLoading());
    final response = await recipeRepository.getRecipeByID(id);
    response.fold(
      (errorMessage) => emit(GetRecipeFailure(errorMessage)),
      (recipe) => emit(GetRecipeSuccess(recipe)),
    );
  }

  Future<dynamic> deleteRecipeByID(int id) async {
    emit(DeleteRecipeLoading());
    final response = await recipeRepository.deleteRecipeByID(id);
    response.fold(
      (errorMessage) => emit(DeleteRecipeFailure(errorMessage)),
      (_) => emit(DeleteRecipeSuccess()),
    );
  }

  void prepopulateEditData(RecipeModel recipe) {
    clearRecipeData();
    recipeCreateTitle.text = recipe.title;
    recipeCreateTimeMinutes.text = recipe.timeMinutes.toString();
    recipeCreateprice.text = recipe.price;
    recipeCreatelink.text = recipe.link;
    recipeCreatedescription.text = recipe.description ?? '';
    tags.addAll(recipe.tags.map((t) => t.name));
    ingredients.addAll(recipe.ingredients.map((i) => i.name));
    emit(TagsAndIngredients(tags, ingredients));
  }

  Future<dynamic> patchRecipeByID(int id, {XFile? newImage}) async {
    emit(EditRecipeLoading());
    final response = await recipeRepository.patchRecipeByID(
      id,
      title: recipeCreateTitle.text,
      timeMinutes: int.tryParse(recipeCreateTimeMinutes.text),
      price: recipeCreateprice.text,
      link: recipeCreatelink.text,
      tags: tags,
      ingredients: ingredients,
      description: recipeCreatedescription.text,
    );
    
    response.fold((errorMessage) => emit(EditRecipeFailure(errorMessage)), (
      recipe,
    ) async {
      if (newImage != null) {
        await uploadRecipeePic(newImage, recipe.id);
        clearRecipeData();
        emit(EditRecipeSuccess(recipe));
      } else {
        clearRecipeData();
        emit(EditRecipeSuccess(recipe));
      }
    });
  }
  Future<void> completeRecipeAi(int recipeId) async {
    emit(CompleteRecipeAiLoading());
    final response = await recipeRepository.completeRecipeAi(recipeId);
    response.fold(
      (errorMessage) => emit(CompleteRecipeAiFailure(errorMessage)),
      (recipeModel) => emit(CompleteRecipeAiSuccess(recipeModel)),
    );
  }

  Future<void> updateRecipeRating(int id, {bool? isLiked, String? userNote}) async {
    emit(RecipeRatingLoading());
    final response = await recipeRepository.patchRecipeRating(id, isLiked: isLiked, userNote: userNote);
    response.fold(
      (errorMessage) => emit(RecipeRatingFailure(errorMessage)),
      (recipeModel) => emit(RecipeRatingSuccess(recipeModel)),
    );
  }

  Future<void> getRecipeSuggestion() async {
    emit(RecipeSuggestionLoading());
    final response = await recipeRepository.getRecipeSuggestion();
    response.fold(
      (errorMessage) => emit(RecipeSuggestionFailure(errorMessage)),
      (recipeModel) => emit(RecipeSuggestionSuccess(recipeModel)),
    );
  }
}
