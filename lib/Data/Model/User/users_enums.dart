enum ClimateType { hotHumid, hotDry, moderate, cold }

enum SkinType { oily, dry, combination, sensitive, notSure }

enum SkincareFrequency {
  onceADay,
  twiceADay,
  occasionally,
  noRoutine,
}

enum SkincarePriority {
  hydration,
  brightening,
  antiAgeing,
  acneTreatment,
  sunProtection,
}

enum SunscreenUsage { always, sometimes, rarely, never }

extension ClimateTypeName on ClimateType {
  String get name {
    switch (this) {
      case ClimateType.hotHumid:
        return "Hot and humid";
      case ClimateType.hotDry:
        return "Hot and dry";
      case ClimateType.moderate:
        return "Moderate";
      case ClimateType.cold:
        return "Cold";
    }
  }
}

extension SkinTypeName on SkinType {
  String get name {
    switch (this) {
      case SkinType.oily:
        return "Oily";
      case SkinType.dry:
        return "Dry";
      case SkinType.combination:
        return "Combination";
      case SkinType.sensitive:
        return "Sensitive";
      case SkinType.notSure:
        return "Not sure";
    }
  }
}

extension SkincareFrequencyName on SkincareFrequency {
  String get name {
    switch (this) {
      case SkincareFrequency.onceADay:
        return "Once a day";
      case SkincareFrequency.twiceADay:
        return "Twice a day (morning and night)";
      case SkincareFrequency.occasionally:
        return "Occasionally";
      case SkincareFrequency.noRoutine:
        return "I don’t have a skincare routine";
    }
  }
}

extension SkincarePriorityName on SkincarePriority {
  String get name {
    switch (this) {
      case SkincarePriority.hydration:
        return "Hydration";
      case SkincarePriority.brightening:
        return "Brightening and even skin tone";
      case SkincarePriority.antiAgeing:
        return "Anti-ageing and wrinkle care";
      case SkincarePriority.acneTreatment:
        return "Acne treatment";
      case SkincarePriority.sunProtection:
        return "Sun protection";
    }
  }
}

extension SunscreenUsageName on SunscreenUsage {
  String get name {
    switch (this) {
      case SunscreenUsage.always:
        return "Yes, always";
      case SunscreenUsage.sometimes:
        return "Sometimes";
      case SunscreenUsage.rarely:
        return "Rarely";
      case SunscreenUsage.never:
        return "No, I don’t use it";
    }
  }
}
