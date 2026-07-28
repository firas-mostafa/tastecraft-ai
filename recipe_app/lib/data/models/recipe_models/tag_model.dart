import 'package:equatable/equatable.dart' show Equatable;

import 'package:recipe_app/core/api/end_ponits.dart' show ApiKey;

class TagModel extends Equatable {
  final String name;
  final num id;

  const TagModel({required this.name, required this.id});
  factory TagModel.fromJson(Map<String, dynamic> jsonData) {
    return TagModel(name: jsonData[ApiKey.name], id: jsonData[ApiKey.id]);
  }
  static Map<String, dynamic> toJson(TagModel tagModel) {
    return {ApiKey.name: tagModel.name, ApiKey.id: tagModel.id};
  }

  @override
  List<Object?> get props => [name, id];
}
