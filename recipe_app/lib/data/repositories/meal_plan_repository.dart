import 'package:recipe_app/core/api/api_consumer.dart';
import 'package:recipe_app/core/api/end_ponits.dart';
import 'package:recipe_app/data/models/meal_plan_models/meal_plan_model.dart';
import 'package:recipe_app/core/errors/exceptions.dart';

class MealPlanRepository {
  final ApiConsumer apiConsumer;

  MealPlanRepository(this.apiConsumer);

  Future<MealPlanModel> getMealPlan() async {
    try {
      final response = await apiConsumer.get(EndPoint.mealPlan);
      return MealPlanModel.fromJson(response);
    } on ServerException catch (e) {
      if (e.errorModel.status == 404) {
        throw Exception("404");
      }
      throw Exception('Failed to get meal plan: ${e.errorModel.errorMessage}');
    } catch (e) {
      throw Exception('Failed to get meal plan: ${e.toString()}');
    }
  }

  Future<MealPlanModel> generateMealPlan({
    String? prompt,
    int? googleFitSteps,
    int? googleFitCalories,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (prompt != null && prompt.isNotEmpty) data['prompt'] = prompt;
      if (googleFitSteps != null) data['google_fit_steps'] = googleFitSteps;
      if (googleFitCalories != null) data['google_fit_calories'] = googleFitCalories;

      final response = await apiConsumer.post(
        EndPoint.generateMealPlan,
        data: data.isNotEmpty ? data : null,
      );
      return MealPlanModel.fromJson(response);
    } on ServerException catch (e) {
      throw Exception('Failed to generate meal plan: ${e.errorModel.errorMessage}');
    } catch (e) {
      throw Exception('Failed to generate meal plan: ${e.toString()}');
    }
  }

  Future<String> getMealPlanAiNotes(String languageCode) async {
    try {
      final response = await apiConsumer.get(
        EndPoint.mealPlanAiNotes,
        queryParameters: {'lang': languageCode},
      );
      return response['notes'] as String;
    } on ServerException catch (e) {
      throw Exception('Failed to get plan notes: ${e.errorModel.errorMessage}');
    } catch (e) {
      throw Exception('Failed to get plan notes: ${e.toString()}');
    }
  }
}
