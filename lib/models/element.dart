import 'package:dio/dio.dart';

/// Model for element (encrypted data for messages etc.).
class Element {
  final String id;
  final String key;
  final String value; // encrypted
  final DateTime timestamp;

  Element({
    required this.id,
    required this.key,
    required this.value,
    required this.timestamp,
  });

  factory Element.fromJson(Map<String, dynamic> json) {
    return Element(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      timestamp: DateTime.parse(
        json['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}
