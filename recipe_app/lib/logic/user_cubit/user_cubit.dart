import 'package:flutter/material.dart' show TextEditingController, FocusNode;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:recipe_app/data/models/user_models/user_image_model.dart'
    show UserImageModel;
import 'package:recipe_app/data/repositories/user_repository.dart'
    show UserRepository;
import 'package:recipe_app/data/models/user_models/sign_in_model.dart'
    show SignInModel;
import 'package:recipe_app/data/models/user_models/user_model.dart'
    show UserModel;
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  FocusNode signInEmailFocuseNode = FocusNode();
  FocusNode signInPasswordFocuseNode = FocusNode();
  FocusNode signUpEmailFocuseNode = FocusNode();
  FocusNode signUpPasswordFocuseNode = FocusNode();
  FocusNode signUpNameFocuseNode = FocusNode();
  FocusNode patchMeEmailFocuseNode = FocusNode();
  FocusNode patchMePasswordFocuseNode = FocusNode();
  FocusNode patchMeNameFocuseNode = FocusNode();
  FocusNode patchMeAgeFocuseNode = FocusNode();
  FocusNode patchMeHeightFocuseNode = FocusNode();
  FocusNode patchMeWeightFocuseNode = FocusNode();
  FocusNode patchMeAiInstructionsFocuseNode = FocusNode();

  final UserRepository userRepository;

  //Sign in email
  TextEditingController signInEmail = TextEditingController();
  //Sign in password
  TextEditingController signInPassword = TextEditingController();
  //Sign up name
  TextEditingController signUpName = TextEditingController();
  //Sign up email
  TextEditingController signUpEmail = TextEditingController();
  //Sign up password
  TextEditingController signUpPassword = TextEditingController();
  
  //Profile edit controllers
  TextEditingController patchMeName = TextEditingController();
  TextEditingController patchMeEmail = TextEditingController();
  TextEditingController patchMePassword = TextEditingController();
  TextEditingController patchMeAge = TextEditingController();
  TextEditingController patchMeHeight = TextEditingController();
  TextEditingController patchMeWeight = TextEditingController();
  TextEditingController patchMeAiInstructions = TextEditingController();

  List<String> patchMeSelectedDiseases = [];
  List<String> patchMeSelectedAllergies = [];

  //Profile Pic
  XFile? profilePic;

  SignInModel? userToken;
  UserCubit(this.userRepository) : super(UserInitial());

  void prepopulateProfileEdit(UserModel user) {
    patchMeName.text = user.name;
    patchMeEmail.text = user.email;
    patchMePassword.text = ''; // Clear password unless changed
    patchMeAge.text = user.age?.toString() ?? '';
    patchMeHeight.text = user.heightCm?.toString() ?? '';
    patchMeWeight.text = user.weightKg?.toString() ?? '';

    // Parse allergies and AI instructions
    final allAllergies = user.allergies ?? '';
    String instructions = '';
    String baseAllergies = allAllergies;
    if (allAllergies.contains('| AI Instructions:')) {
      final parts = allAllergies.split('| AI Instructions:');
      baseAllergies = parts[0].trim();
      instructions = parts[1].trim();
    }
    patchMeAiInstructions.text = instructions;

    patchMeSelectedAllergies = baseAllergies
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final allDiseases = user.diseases ?? '';
    patchMeSelectedDiseases = allDiseases
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<dynamic> signIn() async {
    emit(SignInLoading());
    final response = await userRepository.signIn(
      signInEmail.text,
      signInPassword.text,
    );
    response.fold(
      (errorMessage) => emit(SignInFailure(errorMessage)),
      (signInModel) => emit(SignInSuccess()),
    );
  }

  Future<dynamic> signUp() async {
    emit(SignUpLoading());
    final response = await userRepository.signUp(
      signUpEmail.text,
      signUpName.text,
      signUpPassword.text,
    );
    response.fold(
      (errorMessage) => emit(SignUpFailure(errorMessage)),
      (signInModel) => emit(SignUpSuccess()),
    );
  }

  Future<dynamic> getMe() async {
    emit(GetMeLoading());
    final response = await userRepository.getMe();
    response.fold(
      (errorMessage) => emit(GetMeFailure(errorMessage)),
      (userModel) => emit(GetMeSuccess(userModel)),
    );
  }

  Future<dynamic> patchMe() async {
    emit(PatchMeLoading());
    String allergiesStr = patchMeSelectedAllergies.join(', ');
    if (patchMeAiInstructions.text.isNotEmpty) {
      allergiesStr += ' | AI Instructions: ${patchMeAiInstructions.text}';
    }

    final response = await userRepository.patchMe(
      email: patchMeEmail.text,
      password: patchMePassword.text,
      name: patchMeName.text,
      age: int.tryParse(patchMeAge.text),
      heightCm: double.tryParse(patchMeHeight.text),
      weightKg: double.tryParse(patchMeWeight.text),
      diseases: patchMeSelectedDiseases.join(', '),
      allergies: allergiesStr,
    );
    response.fold(
      (errorMessage) => emit(PatchMeFailure(errorMessage)),
      (userModel) => emit(PatchMeSuccess(userModel)),
    );
  }

  Future<dynamic> patchHealthProfile(
    int age,
    double heightCm,
    double weightKg,
    String diseases,
    String allergies,
  ) async {
    emit(PatchMeLoading());
    final response = await userRepository.patchHealthProfile(
      age,
      heightCm,
      weightKg,
      diseases,
      allergies,
    );
    response.fold(
      (errorMessage) => emit(PatchMeFailure(errorMessage)),
      (userModel) => emit(PatchMeSuccess(userModel)),
    );
  }

  Future<dynamic> uploadProfilePic(XFile profilePic) async {
    emit(UploadProfilePicLoading());
    final response = await userRepository.uploadProfilePic(profilePic);
    response.fold(
      (errorMessage) => emit(UploadProfilePicFailure(errorMessage)),
      (imageModel) => emit(UploadProfilePicSuccess(imageModel)),
    );
  }

  Future<void> sendEmail() async {
    await userRepository.sendEmail(
      recipientEmail: 'alawiteman@gmail.com',
      subject: 'App Feedback',
      body: 'Hello, I have some feedback about your app...',
    );
  }

  void logOut() {
    userRepository.logOut();
    emit(UserInitial());
  }
}
