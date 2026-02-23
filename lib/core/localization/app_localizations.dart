import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Provides localized strings for the application.
///
/// Loads translations from JSON files in `assets/lang/` and exposes them
/// via a simple key-based lookup using [translate].
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// Retrieves the [AppLocalizations] instance from the widget tree.
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  /// Loads the JSON file for the current locale and parses it into
  /// a map of key-value pairs.
  Future<bool> load() async {
    final jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  /// Returns the translated string for the given [key].
  ///
  /// Falls back to the key itself if no translation is found.
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// Whether the current locale is right-to-left (Arabic).
  bool get isRtl => locale.languageCode == 'ar';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
