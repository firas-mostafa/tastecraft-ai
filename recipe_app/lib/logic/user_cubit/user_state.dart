part of 'user_cubit.dart';

abstract class UserState {}

final class UserInitial extends UserState {}

//Upload user pic
final class UploadProfilePicLoading extends UserState {}

final class UploadProfilePicSuccess extends UserState {
  final UserImageModel imageModel;
  UploadProfilePicSuccess(this.imageModel);
}

final class UploadProfilePicFailure extends UserState {
  final String errorMessage;
  UploadProfilePicFailure(this.errorMessage);
}

// SignIn
final class SignInLoading extends UserState {}

final class SignInFailure extends UserState {
  final String errorMessage;
  SignInFailure(this.errorMessage);
}

final class SignInSuccess extends UserState {}

// SignUp
final class SignUpSuccess extends UserState {}

final class SignUpLoading extends UserState {}

final class SignUpFailure extends UserState {
  final String errorMessage;
  SignUpFailure(this.errorMessage);
}

// Get User info
final class GetMeSuccess extends UserState {
  final UserModel user;
  GetMeSuccess(this.user);
}

final class GetMeLoading extends UserState {}

final class GetMeFailure extends UserState {
  final String errorMessage;
  GetMeFailure(this.errorMessage);
}

// Update User info
final class PatchMeLoading extends UserState {}

final class PatchMeSuccess extends UserState {
  final UserModel user;
  PatchMeSuccess(this.user);
}

final class PatchMeFailure extends UserState {
  final String errorMessage;
  PatchMeFailure(this.errorMessage);
}
