import 'dart:convert';

import 'users_enums.dart';

class UserModel {
  String id;
  String email;
  String name;
  String phoneNumber;

  SkinType? skinType;
  ClimateType? climate;
  bool? hasAllergies;
  String? allergyDescription;
  SkincareFrequency? skincareFrequency;
  SkincarePriority? skincarePriority;
  SunscreenUsage? sunscreenUsage;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    this.skinType,
    this.climate,
    this.hasAllergies,
    this.allergyDescription,
    this.skincareFrequency,
    this.skincarePriority,
    this.sunscreenUsage,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    SkinType? skinType,
    ClimateType? climate,
    bool? hasAllergies,
    String? allergyDescription,
    SkincareFrequency? skincareFrequency,
    SkincarePriority? skincarePriority,
    SunscreenUsage? sunscreenUsage,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      skinType: skinType ?? this.skinType,
      climate: climate ?? this.climate,
      hasAllergies: hasAllergies ?? this.hasAllergies,
      allergyDescription: allergyDescription ?? this.allergyDescription,
      skincareFrequency: skincareFrequency ?? this.skincareFrequency,
      skincarePriority: skincarePriority ?? this.skincarePriority,
      sunscreenUsage: sunscreenUsage ?? this.sunscreenUsage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'skin_type': skinType?.index,
      'climate': climate?.index,
      'has_allergies': hasAllergies ?? false,
      'allergy_description': allergyDescription,
      'skincare_frequency': skincareFrequency?.index,
      'skincare_priority': skincarePriority?.index,
      'sunscreen_usage': sunscreenUsage?.index,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    T? safeEnum<T>(int? index, List<T> values) {
      if (index == null || index < 0 || index >= values.length) return null;
      return values[index];
    }

    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      skinType: safeEnum(map['skin_type'] as int?, SkinType.values),
      climate: safeEnum(map['climate'] as int?, ClimateType.values),
      hasAllergies: map['has_allergies'] ?? false,
      allergyDescription: map['allergy_description'],
      skincareFrequency:
          safeEnum(map['skincare_frequency'] as int?, SkincareFrequency.values),
      skincarePriority:
          safeEnum(map['skincare_priority'] as int?, SkincarePriority.values),
      sunscreenUsage:
          safeEnum(map['sunscreen_usage'] as int?, SunscreenUsage.values),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
