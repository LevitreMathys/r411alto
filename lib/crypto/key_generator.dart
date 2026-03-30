import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/random/fortuna_random.dart';

/// Generates RSA 2048-bit key pair in PEM format.
class KeyGenerator {
  /// Generates a new RSA key pair (2048 bits) and returns PEM strings.
  static Future<Map<String, String>> generateRsaKeyPair() async {
    final publicExponent = BigInt.from(65537);
    final params = RSAKeyGeneratorParameters(publicExponent, 2048);
    final secureRandom = _generateSecureRandom();
    final keyGen = RSAKeyGenerator();
    keyGen.init(ParametersWithRandom(params, secureRandom));

    final pair = keyGen.generateKeyPair();
    final publicKeyPem = _encodePublicKeyToPem(pair.publicKey as RSAPublicKey);
    final privateKeyPem = _encodePrivateKeyToPem(
      pair.privateKey as RSAPrivateKey,
    );

    return {'publicKeyPem': publicKeyPem, 'privateKeyPem': privateKeyPem};
  }

  static SecureRandom _generateSecureRandom() {
    final random = FortunaRandom();
    final seed = Uint8List(32);
    final rng = Random.secure();
    for (int i = 0; i < 32; i++) {
      seed[i] = rng.nextInt(256);
    }
    random.seed(KeyParameter(seed));
    return random;
  }

  static String _encodePublicKeyToPem(RSAPublicKey publicKey) {
    final pem = StringBuffer();
    pem.writeln('-----BEGIN PUBLIC KEY-----');
    final modulusBytes = _bigIntToBytes(publicKey.modulus!);
    final modulus = base64.encode(modulusBytes);
    final exponentBytes = _bigIntToBytes(publicKey.exponent!);
    final exponent = base64.encode(exponentBytes);
    pem.writeln(modulus);
    pem.writeln(exponent);
    pem.writeln('-----END PUBLIC KEY-----');
    return pem.toString();
  }

  static List<int> _bigIntToBytes(BigInt bigInt) {
    if (bigInt == BigInt.zero) return [0];
    List<int> bytes = [];
    while (bigInt > BigInt.zero) {
      bytes.add((bigInt & BigInt.from(255)).toInt());
      bigInt = bigInt >> 8;
    }
    return bytes.reversed.toList();
  }

  static String _encodePrivateKeyToPem(RSAPrivateKey privateKey) {
    final pem = StringBuffer();
    pem.writeln('-----BEGIN PRIVATE KEY-----');
    final modulusBytes = _bigIntToBytes(privateKey.modulus!);
    final modulus = base64.encode(modulusBytes);
    final exponentBytes = _bigIntToBytes(privateKey.privateExponent!);
    final exponent = base64.encode(exponentBytes);
    pem.writeln(modulus);
    pem.writeln(exponent);
    pem.writeln('-----END PRIVATE KEY-----');
    return pem.toString();
  }
}
