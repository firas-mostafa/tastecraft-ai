import 'package:equatable/equatable.dart';
import 'package:recipe_app/data/models/meal_plan_models/meal_plan_model.dart';

abstract class MealPlanState extends Equatable {
  const MealPlanState();

  @override
  List<Object> get props => [];
}

class MealPlanInitial extends MealPlanState {}

class MealPlanLoading extends MealPlanState {}

class MealPlanLoaded extends MealPlanState {
  final MealPlanModel mealPlan;

  const MealPlanLoaded({required this.mealPlan});

  @override
  List<Object> get props => [mealPlan];
}

class MealPlanError extends MealPlanState {
  final String message;

  const MealPlanError({required this.message});

  @override
  List<Object> get props => [message];
}
