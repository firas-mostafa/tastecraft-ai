import 'package:dartz/dartz.dart' show Left, Right, Either;
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:recipe_app/core/api/end_ponits.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunchUrl, launchUrl;
import 'package:recipe_app/core/api/api_consumer.dart' show ApiConsumer;

import 'package:recipe_app/core/errors/exceptions.dart' show ServerException;
import 'package:recipe_app/core/functions/upload_image_to_api.dart'
    show uploadImageToAPI;
import '../models/user_models/sign_in_model.dart' show SignInModel;
import '../models/user_models/user_image_model.dart' show UserImageModel;
import '../models/user_models/user_model.dart' show UserModel;
import 'package:recipe_app/helpers/cache/cache_helper.dart' show CacheHelper;

class UserRepository {
  final ApiConsumer apiConsumer;

  UserRepository(this.apiConsumer);
  Future<Either<String, SignInModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.token,
        isFromData: true,
        data: {ApiKey.email: email, ApiKey.password: password},
      );
      final SignInModel user = SignInModel.fromJson(response);
      CacheHelper().saveData(key: ApiKey.token, value: user.token);
      return Right(user);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, SignInModel>> signUp(
    String email,
    String name,
    String password,
  ) async {
    try {
      await apiConsumer.post(
        EndPoint.createUser,
        data: {
          ApiKey.name: name,
          ApiKey.email: email,
          ApiKey.password: password,
        },
      );
      final response = await apiConsumer.post(
        EndPoint.token,
        data: {ApiKey.email: email, ApiKey.password: password},
      );
      final SignInModel user = SignInModel.fromJson(response);
      CacheHelper().saveData(key: ApiKey.token, value: user.token);
      return Right(user);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, UserModel>> getMe() async {
    try {
      final response = await apiConsumer.get(EndPoint.me);
      final UserModel user = UserModel.fromJson(response);
      return Right(user);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, UserModel>> patchMe({
    String? email,
    String? password,
    String? name,
    int? age,
    double? heightCm,
    double? weightKg,
    String? diseases,
    String? allergies,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (email != null && email.isNotEmpty) data[ApiKey.email] = email;
      if (password != null && password.isNotEmpty) data[ApiKey.password] = password;
      if (name != null && name.isNotEmpty) data[ApiKey.name] = name;
      if (age != null) data[ApiKey.age] = age;
      if (heightCm != null) data[ApiKey.heightCm] = heightCm;
      if (weightKg != null) data[ApiKey.weightKg] = weightKg;
      if (diseases != null) data[ApiKey.diseases] = diseases;
      if (allergies != null) data[ApiKey.allergies] = allergies;

      final response = await apiConsumer.patch(
        EndPoint.me,
        data: data,
      );
      final UserModel user = UserModel.fromJson(response);
      return Right(user);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, UserModel>> patchHealthProfile(
    int age,
    double heightCm,
    double weightKg,
    String diseases,
    String allergies,
  ) async {
    try {
      final response = await apiConsumer.patch(
        EndPoint.me,
        data: {
          ApiKey.age: age,
          ApiKey.heightCm: heightCm,
          ApiKey.weightKg: weightKg,
          ApiKey.diseases: diseases,
          ApiKey.allergies: allergies,
          ApiKey.isOnboarded: true,
        },
      );
      final UserModel user = UserModel.fromJson(response);
      return Right(user);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<Either<String, UserImageModel>> uploadProfilePic(
    XFile profilePic,
  ) async {
    try {
      final response = await apiConsumer.post(
        EndPoint.uploadUserImage,
        isFromData: true,
        data: {ApiKey.image: await uploadImageToAPI(profilePic)},
      );
      final UserImageModel userImageModel = UserImageModel.fromJson(response);
      return Right(userImageModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.errorMessage);
    }
  }

  Future<void> sendEmail({
    required String recipientEmail,
    String? subject,
    String? body,
  }) async {
    final Map<String, String> queryParameters = {};
    if (subject != null) queryParameters['subject'] = subject;
    if (body != null) queryParameters['body'] = body;

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      queryParameters: queryParameters,
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email';
    }
  }

  void logOut() {
    CacheHelper().clearData(key: ApiKey.token);
  }
}
