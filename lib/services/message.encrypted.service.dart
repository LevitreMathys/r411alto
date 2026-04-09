import 'dart:convert';
import 'dart:typed_data';

import 'package:basic_utils/basic_utils.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:pointycastle/asymmetric/oaep.dart';

String rsaEncryptToBase64({
  /// rsaEncryptToBase64 : Chiffre un message en utilisant la clé publique RSA du destinataire.
  ///
  /// Paramètres :
  /// - recipientPublicKeyPem (String) : La clé publique du destinataire au format PEM.
  /// - plaintext (String) : Le message à chiffrer.
  ///
  /// Retourne :
  /// - String : Le message chiffré au format Base64.
  required String recipientPublicKeyPem,
  required String plaintext,
}) {
  final RSAPublicKey publicKey = CryptoUtils.rsaPublicKeyFromPem(
    recipientPublicKeyPem,
  );

  final engine = OAEPEncoding(pc.RSAEngine())
    ..init(true, pc.PublicKeyParameter<RSAPublicKey>(publicKey));

  final ciphertextBytes = engine.process(
    Uint8List.fromList(utf8.encode(plaintext)),
  );
  return base64Encode(ciphertextBytes);
}

String rsaDecryptFromBase64({
  /// rsaDecryptFromBase64 : Déchiffre un message en utilisant la clé privée RSA de l'utilisateur.
  ///
  /// Paramètres :
  /// - myPrivateKeyPem (String) : La clé privée de l'utilisateur au format PEM.
  /// - ciphertextB64 (String) : Le message chiffré au format Base64.
  ///
  /// Retourne :
  /// - String : Le message déchiffré.
  required String myPrivateKeyPem,
  required String ciphertextB64,
}) {
  final RSAPrivateKey privateKey = CryptoUtils.rsaPrivateKeyFromPem(
    myPrivateKeyPem,
  );

  final engine = OAEPEncoding(pc.RSAEngine())
    ..init(false, pc.PrivateKeyParameter<RSAPrivateKey>(privateKey));

  final clearBytes = engine.process(base64Decode(ciphertextB64));
  return utf8.decode(clearBytes);
}
