import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'ai_calorie_state.dart';

class AiCalorieCubit extends Cubit<AiCalorieState> {
  final RecipeRepository recipeRepository;

  AiCalorieCubit(this.recipeRepository) : super(AiCalorieInitial());

  Future<void> analyzeCalories(XFile imageFile, String languageCode) async {
    emit(AiCalorieLoading());
    final response = await recipeRepository.analyzeCalories(imageFile, languageCode);
    response.fold(
      (error) => emit(AiCalorieFailure(errorMessage: error)),
      (result) => emit(AiCalorieSuccess(result: result)),
    );
  }
}
