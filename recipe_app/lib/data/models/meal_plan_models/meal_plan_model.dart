import 'package:equatable/equatable.dart';

class MealPlanModel extends Equatable {
  final List<MealPlanDay> days;

  const MealPlanModel({required this.days});

  factory MealPlanModel.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return const MealPlanModel(days: []);
    }
    if (json['days'] != null && json['days'] is List) {
      return MealPlanModel(
        days: (json['days'] as List)
            .where((e) => e != null && e is Map)
            .map((e) => MealPlanDay.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    }
    return const MealPlanModel(days: []);
  }

  @override
  List<Object?> get props => [days];
}

class MealPlanDay extends Equatable {
  final String day;
  final List<MealPlanRecipeOption> breakfast;
  final List<MealPlanRecipeOption> lunch;
  final List<MealPlanRecipeOption> dessert;
  final List<MealPlanRecipeOption> dinner;

  const MealPlanDay({
    required this.day,
    required this.breakfast,
    required this.lunch,
    required this.dessert,
    required this.dinner,
  });

  factory MealPlanDay.fromJson(Map<String, dynamic> json) {
    return MealPlanDay(
      day: json['day']?.toString() ?? '',
      breakfast: _parseOptions(json['breakfast']),
      lunch: _parseOptions(json['lunch']),
      dessert: _parseOptions(json['dessert']),
      dinner: _parseOptions(json['dinner']),
    );
  }

  static List<MealPlanRecipeOption> _parseOptions(dynamic jsonList) {
    if (jsonList == null || jsonList is! List) return [];
    return jsonList
        .where((e) => e != null && e is Map)
        .map((e) => MealPlanRecipeOption.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  List<Object?> get props => [day, breakfast, lunch, dessert, dinner];
}

class MealPlanRecipeOption extends Equatable {
  final int id;
  final String title;
  final String description;
  final int timeMinutes;
  final double price;

  const MealPlanRecipeOption({
    required this.id,
    required this.title,
    required this.description,
    required this.timeMinutes,
    required this.price,
  });

  factory MealPlanRecipeOption.fromJson(Map<String, dynamic> json) {
    return MealPlanRecipeOption(
      id: json['id'] is int ? json['id'] : (int.tryParse(json['id']?.toString() ?? '') ?? 0),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      timeMinutes: json['time_minutes'] is int 
          ? json['time_minutes'] 
          : (int.tryParse(json['time_minutes']?.toString() ?? '') ?? 0),
      price: (json['price'] is num) 
          ? (json['price'] as num).toDouble() 
          : (double.tryParse(json['price']?.toString() ?? '') ?? 0.0),
    );
  }

  @override
  List<Object?> get props => [id, title, description, timeMinutes, price];
}
