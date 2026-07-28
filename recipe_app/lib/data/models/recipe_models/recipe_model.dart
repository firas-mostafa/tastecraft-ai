import 'package:equatable/equatable.dart' show Equatable;

import 'package:recipe_app/core/api/end_ponits.dart' show ApiKey;
import 'package:recipe_app/helpers/image/image_helper.dart';
import 'tag_model.dart' show TagModel;
import 'ingredients_model.dart' show IngredientModel;

class RecipeModel extends Equatable {
  final int id;
  final String title;
  final num timeMinutes;
  final String price;
  final String link;
  final List<TagModel> tags;
  final List<IngredientModel> ingredients;
  final String? image;
  final String? description;
  final int? calories;
  final bool? isLiked;
  final String? userNote;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.timeMinutes,
    required this.price,
    required this.link,
    required this.tags,
    required this.ingredients,
    required this.image,
    this.description,
    this.calories,
    this.isLiked,
    this.userNote,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> jsonData) {
    List tagsFromJson = jsonData[ApiKey.tags] ?? [];
    List<TagModel> tags = [];
    for (Map<String, dynamic> tag in tagsFromJson) {
      tags.add(TagModel.fromJson(tag));
    }

    List ingredientsFromJson = jsonData[ApiKey.ingredients] ?? [];
    List<IngredientModel> ingredients = [];
    for (Map<String, dynamic> ingredient in ingredientsFromJson) {
      ingredients.add(IngredientModel.fromJson(ingredient));
    }

    return RecipeModel(
      id: jsonData[ApiKey.id],
      title: jsonData[ApiKey.title],
      timeMinutes: jsonData[ApiKey.timeMinutes],
      price: jsonData[ApiKey.price],
      link: jsonData[ApiKey.link],
      tags: tags,
      ingredients: ingredients,
      image: jsonData[ApiKey.image] != null
          ? ImageHelper.fixImageUrl(jsonData[ApiKey.image])
          : null,
      description: jsonData[ApiKey.description],
      calories: jsonData[ApiKey.calories] != null ? int.tryParse(jsonData[ApiKey.calories].toString()) : null,
      isLiked: jsonData[ApiKey.isLiked],
      userNote: jsonData[ApiKey.userNote],
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    timeMinutes,
    price,
    link,
    tags,
    ingredients,
    image,
    description,
    calories,
    isLiked,
    userNote,
  ];
}
