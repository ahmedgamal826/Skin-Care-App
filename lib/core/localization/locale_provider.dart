import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the application's current locale and persists the user's
/// language preference using [SharedPreferences].
///
/// Listens to locale changes and notifies all widgets that depend on it.
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';

  Locale _locale = const Locale('en');

  /// The current locale of the application.
  Locale get locale => _locale;

  /// Whether the current language is Arabic.
  bool get isArabic => _locale.languageCode == 'ar';

  /// Loads the saved locale from [SharedPreferences].
  ///
  /// Should be called once during app initialization.
  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);

    if (savedLocale != null) {
      _locale = Locale(savedLocale);
      notifyListeners();
    }
  }

  /// Switches the locale to the given [locale] and persists the choice.
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  /// Toggles between Arabic and English.
  Future<void> toggleLocale() async {
    final newLocale = isArabic ? const Locale('en') : const Locale('ar');
    await setLocale(newLocale);
  }
}
