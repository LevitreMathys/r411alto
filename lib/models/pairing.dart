import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../crypto/key_storage.dart';
import '../../crypto/rsa_crypto.dart';
import '../../crypto/key_generator.dart';
import 'package:pointycastle/asymmetric/api.dart';

/// Model representing a paired relation.
class Relation {
  final String relationCode;
  final String localPublicKeyPem;
  final String localPrivateKeyPem;
  final String peerPublicKeyPem;

  RSAPublicKey get peerPublicKey => _pemToPublicKey(peerPublicKeyPem);
  RSAPrivateKey get localPrivateKey => _pemToPrivateKey(localPrivateKeyPem);

  static RSAPublicKey _pemToPublicKey(String pem) {
    final lines = pem.split('\n').where((l) => !l.startsWith('-----')).toList();
    final modulusBytes = base64.decode(lines[0]);
    final exponentBytes = base64.decode(lines[1]);
    final modulus = _bytesToBigInt(modulusBytes);
    final exponent = _bytesToBigInt(exponentBytes);
    return RSAPublicKey(modulus, exponent);
  }

  static RSAPrivateKey _pemToPrivateKey(String pem) {
    final lines = pem.split('\n').where((l) => !l.startsWith('-----')).toList();
    final modulusBytes = base64.decode(lines[0]);
    final exponentBytes = base64.decode(lines[1]);
    final modulus = _bytesToBigInt(modulusBytes);
    final privExp = _bytesToBigInt(exponentBytes);
    return RSAPrivateKey(modulus, privExp);
  }

  static BigInt _bytesToBigInt(List<int> bytes) {
    BigInt result = BigInt.zero;
    for (int i = 0; i < bytes.length; i++) {
      result = (result << 8) + BigInt.from(bytes[i]);
    }
    return result;
  }

  Relation({
    required this.relationCode,
    required this.localPublicKeyPem,
    required this.localPrivateKeyPem,
    required this.peerPublicKeyPem,
  });

  /// Short display name for UI (first 8 chars of code).
  String get displayName => relationCode.substring(0, 8);

  /// Encrypt message for peer using their public key.
  String encryptMessage(String plaintext) {
    return RsaCrypto.encrypt(plaintext, peerPublicKey);
  }

  /// Decrypt incoming message using local private key.
  String decryptMessage(String encrypted) {
    return RsaCrypto.decrypt(encrypted, localPrivateKey);
  }

  static Future<Relation?> fromStorage(String relationCode) async {
    final keys = await KeyStorage.getKeys(relationCode);
    if (keys == null) return null;
    final storage = const FlutterSecureStorage();
    final peerPub = await storage.read(key: 'peer_pub_$relationCode');
    if (peerPub == null) return null;
    return Relation(
      relationCode: relationCode,
      localPublicKeyPem: keys['publicKeyPem']!,
      localPrivateKeyPem: keys['privateKeyPem']!,
      peerPublicKeyPem: peerPub,
    );
  }

  /// List all relations by scanning storage (keys starting with 'alto_key_').
  static Future<List<Relation>> listFromStorage() async {
    final storage = const FlutterSecureStorage();
    final allKeys = await storage.readAll();
    final relationCodes = <String>{};
    for (final key in allKeys.keys) {
      if (key.startsWith('alto_key_') && key.endsWith('_pub')) {
        final code = key.substring(
          'alto_key_'.length,
          key.length - 4,
        ); // remove _pub
        if (await storage.read(key: 'peer_pub_$code') != null) {
          relationCodes.add(code);
        }
      }
    }
    final relations = <Relation>[];
    for (final code in relationCodes) {
      final rel = await Relation.fromStorage(code);
      if (rel != null) relations.add(rel);
    }
    return relations;
  }
}
