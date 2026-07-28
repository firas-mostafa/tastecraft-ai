import 'package:equatable/equatable.dart' show Equatable;

import 'package:recipe_app/core/api/end_ponits.dart' show ApiKey;

class UserImageModel extends Equatable {
  final String email;
  final String image;

  const UserImageModel({required this.email, required this.image});
  factory UserImageModel.fromJson(Map<String, dynamic> jsonData) {
    return UserImageModel(
      image: jsonData[ApiKey.image],
      email: jsonData[ApiKey.email],
    );
  }

  @override
  List<Object?> get props => [email, image];
}
