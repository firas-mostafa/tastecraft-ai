import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:recipe_app/helpers/cache/cache_helper.dart' show CacheHelper;

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final CacheHelper cacheHelper;

  ThemeCubit({required this.cacheHelper})
    : super(ThemeState(ThemeMode.system)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeIndex = cacheHelper.getData(key: "theme");
    switch (themeIndex) {
      case 0:
        emit(ThemeState(ThemeMode.system));
      case 1:
        emit(ThemeState(ThemeMode.light));
      case 2:
        emit(ThemeState(ThemeMode.dark));
      default:
        emit(ThemeState(ThemeMode.system));
    }
  }

  Future<void> setSystem() async {
    await cacheHelper.saveData(key: "theme", value: 0);
    emit(ThemeState(ThemeMode.system));
  }

  Future<void> setLight() async {
    await cacheHelper.saveData(key: "theme", value: 1);
    emit(ThemeState(ThemeMode.light));
  }

  Future<void> setDark() async {
    await cacheHelper.saveData(key: "theme", value: 2);
    emit(ThemeState(ThemeMode.dark));
  }
}
