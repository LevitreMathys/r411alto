import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage for RSA keys, keyed by relationId.
class KeyStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Stores public and private PEM keys for a relation.
  static Future<void> storeKeys(
    String relationId,
    String publicKeyPem,
    String privateKeyPem,
  ) async {
    await _storage.write(
      key: _buildKey(relationId, 'pub'),
      value: publicKeyPem,
    );
    await _storage.write(
      key: _buildKey(relationId, 'priv'),
      value: privateKeyPem,
    );
  }

  /// Retrieves keys for a relation.
  static Future<Map<String, String>?> getKeys(String relationId) async {
    final pubKey = await _storage.read(key: _buildKey(relationId, 'pub'));
    final privKey = await _storage.read(key: _buildKey(relationId, 'priv'));
    if (pubKey == null || privKey == null) return null;
    return {'publicKeyPem': pubKey, 'privateKeyPem': privKey};
  }

  /// Deletes keys for a relation.
  static Future<void> deleteKeys(String relationId) async {
    await _storage.delete(key: _buildKey(relationId, 'pub'));
    await _storage.delete(key: _buildKey(relationId, 'priv'));
  }

  static String _buildKey(String relationId, String type) =>
      'alto_key_$relationId$type';
}
