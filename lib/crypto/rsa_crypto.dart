import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/src/registry/registry.dart';

/// RSA encryption/decryption utilities with Base64 handling.
class RsaCrypto {
  /// Encrypts plaintext using RSA public key (PKCS1).
  static String encrypt(String plaintext, RSAPublicKey publicKey) {
    final cipher = AsymmetricBlockCipher('RSA/PKCS1')
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    final plaintextBytes = utf8.encode(plaintext);
    final paddedBytes = _padPlaintext(
      plaintextBytes,
      publicKey.modulus!.bitLength ~/ 8,
    );
    final input = Uint8List.fromList(paddedBytes);
    final output = cipher.process(input);

    return base64.encode(output);
  }

  /// Decrypts Base64 ciphertext using RSA private key.
  static String decrypt(String base64Ciphertext, RSAPrivateKey privateKey) {
    final cipher = AsymmetricBlockCipher('RSA/PKCS1')
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));

    final ciphertextBytes = base64.decode(base64Ciphertext);
    final output = cipher.process(Uint8List.fromList(ciphertextBytes));
    final unpadded = _unpadPlaintext(output);

    return utf8.decode(unpadded);
  }

  static List<int> _padPlaintext(List<int> plaintext, int blockSize) {
    // PKCS1 v1.5 padding
    final paddingLength = blockSize - 3 - plaintext.length;
    final padding = List<int>.filled(paddingLength, 0xFF);
    return [0x00, 0x02, ...padding, 0x00, ...plaintext];
  }

  static List<int> _unpadPlaintext(List<int> ciphertext) {
    // Remove PKCS1 v1.5 padding
    int i = 2;
    while (ciphertext[i] != 0x00) i++;
    return ciphertext.sublist(i + 1);
  }
}
