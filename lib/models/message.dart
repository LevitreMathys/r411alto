import 'package:uuid/uuid.dart';

class Message {
  final String id;
  final String encryptedContent;
  final DateTime timestamp;
  final bool isSent;
  String? decryptedContent;

  Message({
    required this.id,
    required this.encryptedContent,
    required this.timestamp,
    required this.isSent,
    this.decryptedContent,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'] as String,
    encryptedContent: json['encryptedContent'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    isSent: json['isSent'] as bool,
    decryptedContent: json['decryptedContent'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'encryptedContent': encryptedContent,
    'timestamp': timestamp.toIso8601String(),
    'isSent': isSent,
    'decryptedContent': decryptedContent,
  };
}

/// Helper to generate new message ID
String generateMessageId() => const Uuid().v4();
