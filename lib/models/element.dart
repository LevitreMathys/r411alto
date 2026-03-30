import 'package:dio/dio.dart';

enum ElementType { message, color, icon }

/// Model for element (encrypted data for messages etc.).
class Element {
  final ElementType type;
  final String id;
  final String key;
  final String value; // encrypted
  final DateTime timestamp;

  Element({
    required this.type,
    required this.id,
    required this.key,
    required this.value,
    required this.timestamp,
  });

  factory Element.fromJson(Map<String, dynamic> json) => Element(
    id: json['id'] ?? '',
    key: json['key'] ?? '',
    type: ElementType.values.firstWhere(
      (t) => t.name == json['key'],
      orElse: () => ElementType.message,
    ),
    value: json['value'] ?? '',
    timestamp: DateTime.parse(
      json['timestamp'] ?? DateTime.now().toIso8601String(),
    ),
  );

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}
