import 'package:equatable/equatable.dart' show Equatable;

import 'package:recipe_app/helpers/image/image_helper.dart';
import 'package:recipe_app/core/api/end_ponits.dart' show ApiKey;

class UserModel extends Equatable {
  final String? profilePic;
  final String email;
  final String name;
  final double? heightCm;
  final double? weightKg;
  final String? allergies;
  final int? age;
  final String? diseases;
  final bool isOnboarded;

  const UserModel({
    this.profilePic,
    required this.email,
    required this.name,
    this.heightCm,
    this.weightKg,
    this.allergies,
    this.age,
    this.diseases,
    this.isOnboarded = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      profilePic: jsonData[ApiKey.image] != null
          ? ImageHelper.fixImageUrl(jsonData[ApiKey.image])
          : jsonData[ApiKey.image],
      email: jsonData[ApiKey.email],
      name: jsonData[ApiKey.name],
      heightCm: jsonData[ApiKey.heightCm]?.toDouble(),
      weightKg: jsonData[ApiKey.weightKg]?.toDouble(),
      allergies: jsonData[ApiKey.allergies],
      age: jsonData[ApiKey.age],
      diseases: jsonData[ApiKey.diseases],
      isOnboarded: jsonData[ApiKey.isOnboarded] ?? false,
    );
  }

  @override
  List<Object?> get props => [profilePic, name, email, heightCm, weightKg, allergies, age, diseases, isOnboarded];
}
