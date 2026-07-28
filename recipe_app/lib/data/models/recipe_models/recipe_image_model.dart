import 'package:equatable/equatable.dart' show Equatable;

import 'package:recipe_app/core/api/end_ponits.dart' show ApiKey;
import 'package:recipe_app/helpers/image/image_helper.dart';

class RecipeImageModel extends Equatable {
  final int id;
  final String image;

  const RecipeImageModel({required this.id, required this.image});
  factory RecipeImageModel.fromJson(Map<String, dynamic> jsonData) {
    return RecipeImageModel(
      image: ImageHelper.fixImageUrl(jsonData[ApiKey.image]),
      id: jsonData[ApiKey.id],
    );
  }

  @override
  List<Object?> get props => [id, image];
}
