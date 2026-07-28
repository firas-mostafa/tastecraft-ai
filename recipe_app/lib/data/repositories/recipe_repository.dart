import 'dart:convert' show base64Encode;
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:recipe_app/core/api/end_ponits.dart';
import 'package:recipe_app/data/models/recipe_models/ingredients_model.dart';
import 'package:recipe_app/data/models/recipe_models/recipe_image_model.dart';
import 'package:recipe_app/data/models/recipe_models/tag_model.dart';
import 'package:recipe_app/data/models/recipe_models/recipe_model.dart'
    show RecipeModel;
import 'package:recipe_app/core/api/api_consumer.dart' show ApiConsumer;

import 'package:recipe_app/core/errors/exceptions.dart' show ServerException;
import 'package:recipe_app/core/functions/upload_image_to_api.dart'
    show uploadImageToAPI;

class RecipeRepository {
  final ApiConsumer apiConsumer;
  RecipeRepository(this.apiConsumer);

  Future<Either<String, RecipeModel>> recipeCreate({
    required String title,
    required int? timeMinutes,
    required String price,
    required String link,
    required List<String> tags,
    required List<String> ingredients,
    required String description,
    int? calories,
  }) async {
    final List<Map<String, String>> jTags = [];
    final List<Map<String, String>> jIngredients = [];
    for (String tag in tags) {
      jTags.add({ApiKey.name: tag});
    }
    for (String ingredient in ingredients) {
      jIngredients.add({ApiKey.name: ingredient});
    }
    try {
      final response = await apiConsumer.post(
        EndPoint.recipes,
        data: {
          ApiKey.title: title,
          ApiKey.timeMinutes: timeMinutes,
          ApiKey.price: price,
          ApiKey.link: link,
          ApiKey.tags: jTags,
          ApiKey.ingredients: jIngredients,
          ApiKey.description: description,
          ApiKey.calories: calories,
        },
      );

      final RecipeModel recipeModel = RecipeModel.fromJson(response);
      return Right(recipeModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, List<RecipeModel>>> getRecipesList() async {
    try {
      final List<dynamic> response = await apiConsumer.get(
        EndPoint.recipes,
      );

      final List<RecipeModel> recipeModels = [];
      for (Map<String, dynamic> recipe in response) {
        recipeModels.add(RecipeModel.fromJson(recipe));
      }
      return Right(recipeModels);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, RecipeModel>> getRecipeByID(int id) async {
    try {
      final Map<String, dynamic> response = await apiConsumer.get(
        EndPoint.recipeByID(id),
      );
      final RecipeModel recipeModels = RecipeModel.fromJson(response);
      return Right(recipeModels);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, Null>> deleteRecipeByID(int id) async {
    try {
      await apiConsumer.delete(EndPoint.recipeByID(id));
      return Right(null);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, RecipeModel>> patchRecipeByID(
    int id, {
    required String title,
    required int? timeMinutes,
    required String price,
    required String link,
    required List<String> tags,
    required List<String> ingredients,
    required String description,
    int? calories,
  }) async {
    final List<Map<String, String>> jTags = [];
    final List<Map<String, String>> jIngredients = [];
    for (String tag in tags) {
      jTags.add({ApiKey.name: tag});
    }
    for (String ingredient in ingredients) {
      jIngredients.add({ApiKey.name: ingredient});
    }
    try {
      final response = await apiConsumer.patch(
        EndPoint.recipeByID(id),
        data: {
          ApiKey.title: title,
          ApiKey.timeMinutes: timeMinutes,
          ApiKey.price: price,
          ApiKey.link: link,
          ApiKey.tags: jTags,
          ApiKey.ingredients: jIngredients,
          ApiKey.description: description,
          ApiKey.calories: calories,
        },
      );
      return Right(RecipeModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, RecipeModel>> patchRecipeRating(
    int id, {
    bool? isLiked,
    String? userNote,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (isLiked != null) data[ApiKey.isLiked] = isLiked;
      if (userNote != null) data[ApiKey.userNote] = userNote;
      
      final response = await apiConsumer.patch(
        EndPoint.recipeByID(id),
        data: data,
      );
      return Right(RecipeModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, RecipeModel>> getRecipeSuggestion() async {
    try {
      final response = await apiConsumer.get(EndPoint.suggestRecipe);
      return Right(RecipeModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, RecipeModel>> completeRecipeAi(int id) async {
    try {
      final response = await apiConsumer.post(EndPoint.completeRecipeAi(id));
      return Right(RecipeModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, RecipeImageModel>> uploadRecipeePic(
    int id,
    XFile image,
  ) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.uploadRecipeImage(id),
        isFromData: true,
        data: {ApiKey.image: await uploadImageToAPI(image)},
      );
      final RecipeImageModel recipeImageModel = RecipeImageModel.fromJson(
        response,
      );
      return Right(recipeImageModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, List<TagModel>>> getTagsList() async {
    try {
      final List<Map<String, dynamic>> response = await apiConsumer.get(
        EndPoint.tags,
      );

      final List<TagModel> tagModels = [];
      for (Map<String, dynamic> tag in response) {
        tagModels.add(TagModel.fromJson(tag));
      }
      return Right(tagModels);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, List<IngredientModel>>> getIngredientList() async {
    try {
      final List<Map<String, dynamic>> response = await apiConsumer.get(
        EndPoint.ingredients,
      );

      final List<IngredientModel> ingredientModels = [];
      for (Map<String, dynamic> ingredient in response) {
        ingredientModels.add(IngredientModel.fromJson(ingredient));
      }
      return Right(ingredientModels);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<dynamic> deleteTagByID(int id) async {
    try {
      await apiConsumer.delete(EndPoint.tagsByID(id));
    } on ServerException catch (e) {
      return e.errorModel.errorMessage;
    }
  }

  Future<dynamic> deleteIngredientsByID(int id) async {
    try {
      await apiConsumer.delete(EndPoint.ingredientsByID(id));
    } on ServerException catch (e) {
      return e.errorModel.errorMessage;
    }
  }

  Future<Either<String, IngredientModel>> patchIngredientByID(
    int id,
    String name,
  ) async {
    try {
      final response = await apiConsumer.patch(
        EndPoint.ingredientsByID(id),
        data: {ApiKey.name: name},
      );
      return Right(IngredientModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, TagModel>> patchTagByID(int id, String name) async {
    try {
      final response = await apiConsumer.patch(
        EndPoint.tagsByID(id),
        data: {ApiKey.name: name},
      );
      return Right(TagModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, String>> analyzeCalories(XFile imageFile, String languageCode) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      final response = await apiConsumer.post(
        EndPoint.analyzeCalories,
        data: {
          ApiKey.image: base64Image,
          'language': languageCode,
        },
      );
      return Right(response['result'] as String);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    } catch (e) {
      return Left('Failed to process image: $e');
    }
  }
}
