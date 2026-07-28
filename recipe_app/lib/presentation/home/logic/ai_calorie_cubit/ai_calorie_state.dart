abstract class AiCalorieState {}

class AiCalorieInitial extends AiCalorieState {}

class AiCalorieLoading extends AiCalorieState {}

class AiCalorieSuccess extends AiCalorieState {
  final String result;
  AiCalorieSuccess({required this.result});
}

class AiCalorieFailure extends AiCalorieState {
  final String errorMessage;
  AiCalorieFailure({required this.errorMessage});
}
