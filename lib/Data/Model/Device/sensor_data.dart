import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart'; // Removed Firebase
import 'package:flutter/material.dart';

class SensorData {
  final String id;
  final double? temperature;
  final double? smokeLevel;
  final double? humidity;

  final double? temperatureThreshold;
  final double? smokeLevelThreshold;
  final Color temperatureColor;
  final Color smokeLevelColor;
  String? token;
  bool? isTriggered;

  SensorData({
    required this.id,
    this.temperature,
    this.humidity,
    this.smokeLevel,
    this.temperatureThreshold,
    this.smokeLevelThreshold,
    required this.token,
    this.isTriggered = false,
  })  : temperatureColor = _getColor(temperature ?? 0),
        smokeLevelColor = _getColor(smokeLevel ?? 0);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "smoke_level": smokeLevel,
      "humidity": humidity,
      "smoke_level_threshold": smokeLevelThreshold,
      "temperature": temperature,
      "temperature_threshold": temperatureThreshold,
      "token": token,
      "isTriggered": isTriggered,
    };
  }

  factory SensorData.fromMap(Map<String, dynamic> map) {
    return SensorData(
      id: map["id"],
      token: map["token"],
      humidity: (map["humidity"] as num).toDouble(),
      smokeLevel: (map["smoke_level"] as num).toDouble(),
      smokeLevelThreshold: (map["smoke_level_threshold"] as num).toDouble(),
      temperature: (map["temperature"] as num).toDouble(),
      temperatureThreshold: (map["temperature_threshold"] as num).toDouble(),
      isTriggered: map["isTriggered"] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorData.fromJson(String source) =>
      SensorData.fromMap(json.decode(source) as Map<String, dynamic>);

  static Color _getColor(double level) {
    if (level < 200) return Colors.green;
    if (level < 500) return Colors.orange;
    return Colors.red;
  }
}
