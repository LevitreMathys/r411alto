import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:r411alto/services/storage.auth.service.dart';
import 'package:r411alto/services/storage.RSA.service.dart';
import 'package:r411alto/crypto/RelationshipKey.service.dart';
import 'package:r411alto/main.dart';

// Alice génére le qrcode
// Bob scan le qrcode

class QrCodeParingService {
  final StorageRsaService storageRsaService = StorageRsaService(
    const FlutterSecureStorage(),
  );
  final StorageAuthService storageAuthService = StorageAuthService();
  final RelationshipKeysService relationshipKeysService =
      RelationshipKeysService();

  /// Génère un QR code pour le pairing en créant d'abord une paire de clés RSA.
  Future<String> generateQrCode() async {
    // 1. Génération du relationCodeA (UUID) et des clés RSA
    final String relationCodeA = const Uuid().v4();
    final keys = relationshipKeysService.generateRelationshipRsaKeyPair();

    // 2. Sauvegarde locale des clés avec le relationCodeA comme identifiant
    await storageRsaService.saveKeyPair(
      relationCodeA,
      publicKeyPem: keys.publicKeyPem,
      privateKeyPem: keys.privateKeyPem,
    );

    // 3. Appel POST /pairing pour enregistrer le pairing sur le serveur
    final response = await http.post(
      Uri.parse('$urlBackend/pairing'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'relationCode': relationCodeA,
        'userPublicKey': keys.publicKeyPem,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Erreur lors de l'enregistrement du pairing: ${response.statusCode}",
      );
    }

    // 4. Retourne uniquement le relationCodeA pour le QR Code
    return relationCodeA;
  }

  /// Récupère le statut du pairing
  Future<String> getStatus(String relationCode) async {
    final response = await http.get(
      Uri.parse('$urlBackend/pairing/$relationCode/status'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['status']; // "waiting", "completed", "finalized"
    }
    return "error";
  }

  /// Finalise le pairing
  /// Retourne les infos de Bob (publicKeyB, relationCodeB).
  Future<Map<String, dynamic>> finalize(String relationCode) async {
    final response = await http.delete(
      Uri.parse('$urlBackend/pairing?relationCodeA=$relationCode'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("Erreur lors de la finalisation");
  }

  /// Étape 2: Bob scanne et matche.
  /// Retourne les infos d'Alice (publicKeyA, relationCodeA).
  Future<Map<String, dynamic>> match(String relationCodeA) async {
    final String relationCodeB = const Uuid().v4();
    final keys = relationshipKeysService.generateRelationshipRsaKeyPair();

    // Bob sauve ses propres clés avec relationCodeB
    await storageRsaService.saveKeyPair(
      relationCodeB,
      publicKeyPem: keys.publicKeyPem,
      privateKeyPem: keys.privateKeyPem,
    );

    final response = await http.put(
      Uri.parse('$urlBackend/pairing'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'relationCodeA': relationCodeA,
        'relationCodeB': relationCodeB,
        'publicKeyB': keys.publicKeyPem,
      }),
    );

    if (response.statusCode == 200) {
      final aliceData = jsonDecode(response.body);
      // Bob sauve la clé publique d'Alice
      await storageRsaService.saveDistantPublicKey(
        aliceData['relationCodeA'],
        aliceData['publicKeyA'],
      );
      return aliceData;
    }
    throw Exception("Erreur lors du matching: ${response.statusCode}");
  }
}
