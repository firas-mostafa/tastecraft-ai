import 'package:equatable/equatable.dart' show Equatable;

import 'package:recipe_app/core/api/end_ponits.dart' show ApiKey;

class IngredientModel extends Equatable {
  final String name;
  final num id;

  const IngredientModel({required this.name, required this.id});

  factory IngredientModel.fromJson(Map<String, dynamic> jsonData) {
    return IngredientModel(
      name: jsonData[ApiKey.name],
      id: jsonData[ApiKey.id],
    );
  }
  static Map<String, dynamic> toJson(IngredientModel ingredientModel) {
    return {ApiKey.name: ingredientModel.name, ApiKey.id: ingredientModel.id};
  }

  @override
  List<Object?> get props => [name, id];
}
