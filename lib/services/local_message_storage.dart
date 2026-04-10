import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';

class LocalMessageStorage {
  static const String _keyPrefix = 'messages_';

  /// Save a list of messages for a relationId
  static Future<void> saveMessages(
    String relationId,
    List<Message> messages,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + relationId;
    final jsonList = messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  /// Load messages for a relationId
  static Future<List<Message>> loadMessages(String relationId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _keyPrefix + relationId;
    final jsonList = prefs.getStringList(key) ?? [];
    return jsonList.map((jsonStr) {
      final jsonMap = jsonDecode(jsonStr);
      return Message.fromJson(jsonMap);
    }).toList();
  }

  /// Add or update a single message
  static Future<void> addMessage(String relationId, Message message) async {
    final messages = await loadMessages(relationId);
    final index = messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      messages[index] = message;
    } else {
      messages.add(message);
    }
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    await saveMessages(relationId, messages);
  }
}
