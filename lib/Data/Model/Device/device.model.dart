import 'dart:convert';

class Devices {
  String id;
  String name;
  String userId;
  String barcode;

  Devices({
    required this.id,
    required this.name,
    required this.userId,
    required this.barcode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      "userId": userId,
      'barcode': barcode,
    };
  }

  factory Devices.fromMap(Map<String, dynamic> map) {
    return Devices(
      id: map['id'] as String,
      name: map['name'],
      userId: map['userId'],
      barcode: map['barcode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Devices.fromJson(String source) =>
      Devices.fromMap(json.decode(source) as Map<String, dynamic>);
}
