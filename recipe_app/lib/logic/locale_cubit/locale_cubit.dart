import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/helpers/cache/cache_helper.dart';

class LocaleCubit extends Cubit<Locale> {
  final CacheHelper cacheHelper;
  static const String _localeKey = 'locale_language_code';

  LocaleCubit({required this.cacheHelper}) : super(const Locale('en')) {
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    final String? languageCode = cacheHelper.getDataString(_localeKey);
    if (languageCode != null) {
      emit(Locale(languageCode));
    }
  }

  void changeLocale(String languageCode) {
    cacheHelper.saveData(key: _localeKey, value: languageCode);
    emit(Locale(languageCode));
  }

  void toggleLocale() {
    if (state.languageCode == 'en') {
      changeLocale('ar');
    } else {
      changeLocale('en');
    }
  }
}
