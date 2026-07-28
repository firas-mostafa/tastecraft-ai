import 'package:translator/translator.dart';
import 'package:flutter/material.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final GoogleTranslator _translator = GoogleTranslator();
  final Map<String, String> _cache = {};

  Future<String> translate(String text, BuildContext context) async {
    if (text.isEmpty) return text;
    
    final locale = Localizations.localeOf(context);
    final hasArabicCharacters = RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    if (locale.languageCode == 'ar' && !hasArabicCharacters) {
      // User wants Arabic, but text is English -> Translate to Arabic
      if (_cache.containsKey(text)) {
        return _cache[text]!;
      }
      try {
        final translation = await _translator.translate(text, from: 'en', to: 'ar');
        _cache[text] = translation.text;
        return translation.text;
      } catch (e) {
        return text; // Fallback to original text
      }
    } else if (locale.languageCode == 'en' && hasArabicCharacters) {
      // User wants English, but text is Arabic -> Translate to English
      if (_cache.containsKey(text)) {
        return _cache[text]!;
      }
      try {
        final translation = await _translator.translate(text, from: 'ar', to: 'en');
        _cache[text] = translation.text;
        return translation.text;
      } catch (e) {
        return text; // Fallback to original text
      }
    }

    return text;
  }
}
