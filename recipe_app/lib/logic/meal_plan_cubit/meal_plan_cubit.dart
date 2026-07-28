import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/data/repositories/meal_plan_repository.dart';
import 'package:recipe_app/helpers/health/health_helper.dart';
import 'meal_plan_state.dart';

class MealPlanCubit extends Cubit<MealPlanState> {
  final MealPlanRepository mealPlanRepository;

  MealPlanCubit({required this.mealPlanRepository}) : super(MealPlanInitial());

  Future<void> fetchMealPlan() async {
    emit(MealPlanLoading());
    try {
      final mealPlan = await mealPlanRepository.getMealPlan();
      emit(MealPlanLoaded(mealPlan: mealPlan));
    } catch (e) {
      if (e.toString().contains("404")) {
        emit(MealPlanInitial());
      } else {
        emit(MealPlanError(message: e.toString()));
      }
    }
  }

  Future<void> generateMealPlan([String? prompt]) async {
    emit(MealPlanLoading());
    try {
      final fitnessData = await HealthHelper.getTodayActivity();
      final steps = fitnessData['steps'] != 0 ? fitnessData['steps'] : null;
      final calories = fitnessData['calories'] != 0
          ? fitnessData['calories']
          : null;

      final mealPlan = await mealPlanRepository.generateMealPlan(
        prompt: prompt,
        googleFitSteps: steps,
        googleFitCalories: calories,
      );
      emit(MealPlanLoaded(mealPlan: mealPlan));
    } catch (e) {
      emit(MealPlanError(message: e.toString()));
    }
  }

  Future<String> getMealPlanAiNotes(String languageCode) async {
    return await mealPlanRepository.getMealPlanAiNotes(languageCode);
  }
}
