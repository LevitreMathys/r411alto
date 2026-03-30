import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../models/element.dart';
import 'api_client.dart';

/// Service for element exchange (messages etc.).
class ElementService {
  final ApiClient _client = ApiClient.instance;

  /// Post encrypted element for relation.
  Future<String> postElement({
    required String relationCode,
    required String key,
    required String encryptedValue,
  }) async {
    try {
      final data = {
        'relationCode': relationCode,
        'key': key,
        'value': encryptedValue,
      };
      final response = await _client.post('/element', data);
      return response.data['id']?.toString() ?? '';
    } catch (e) {
      developer.log(
        'DEBUG: Element post failed: \${e.displayMessage}',
        name: 'ElementService',
      );
      rethrow;
    }
  }

  /// Get elements for relation.
  Future<List<Element>> getElements(String relationCode) async {
    try {
      final response = await _client.get(
        '/element',
        queryParameters: {'relationCode': relationCode},
      );
      final List<dynamic> list = response.data;
      return list.map((json) => Element.fromJson(json)).toList();
    } catch (e) {
      developer.log(
        'DEBUG: Element get failed: \${e.displayMessage}',
        name: 'ElementService',
      );
      rethrow;
    }
  }
}
