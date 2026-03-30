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
    final data = {
      'relationCode': relationCode,
      'key': key,
      'value': encryptedValue,
    };
    final response = await _client.post('/element', data);
    return response.data['id']?.toString() ?? '';
  }

  /// Get elements for relation.
  Future<List<Element>> getElements(String relationCode) async {
    final response = await _client.get(
      '/element',
      queryParameters: {'relationCode': relationCode},
    );
    final List<dynamic> list = response.data;
    return list.map((json) => Element.fromJson(json)).toList();
  }
}
