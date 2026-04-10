import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:r411alto/main.dart';
import 'package:r411alto/models/contact.dart';
import 'package:r411alto/models/message.dart';
import 'package:r411alto/services/message.encrypted.service.dart';
import 'package:r411alto/services/storage.RSA.service.dart';

class MessageService {
  final StorageRsaService _storageRsaService;

  MessageService(this._storageRsaService);

  /// Envoie un message chiffré au contact.
  Future<void> sendMessage(Contact contact, String type, String content) async {
    if (contact.distantRelationId == null || contact.distantPublicKeyPem == null) {
      throw Exception("Informations de contact incomplètes pour l'envoi");
    }

    // 1. Chiffrement avec la clé publique du destinataire
    final encryptedValue = rsaEncryptToBase64(
      recipientPublicKeyPem: contact.distantPublicKeyPem!,
      plaintext: content,
    );

    // 2. Envoi au serveur (mailbox du destinataire = son relationCode)
    final response = await http.post(
      Uri.parse('$urlBackend/element'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'relationCode': contact.distantRelationId,
        'key': type,
        'value': encryptedValue,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de l'envoi du message: ${response.statusCode}");
    }
  }

  /// Récupère les messages (Elements) pour nous ( mailbox = notre local relationId ).
  Future<List<Message>> fetchMessages(Contact contact) async {
    // mailbox = notre local relationId
    final response = await http.get(
      Uri.parse('$urlBackend/element?relationCode=${contact.relationId}'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['elements'] ?? [];
      final List<Message> messages = [];

      // Pour déchiffrer, on a besoin de notre clé privée
      final privateKey = await _storageRsaService.readPrivateKeyPem(contact.relationId);
      if (privateKey == null) {
        throw Exception("Clé privée introuvable pour cette relation");
      }

      for (var item in data) {
        try {
          final decryptedValue = rsaDecryptFromBase64(
            myPrivateKeyPem: privateKey,
            ciphertextB64: item['value'],
          );

          messages.add(Message(
            key: item['key'],
            value: decryptedValue,
            isMe: false,
            timestamp: DateTime.now(), // Le serveur ne semble pas renvoyer de timestamp
          ));
        } catch (e) {
          // Si le déchiffrement échoue, on ignore ou on affiche un message d'erreur
          print("Erreur de déchiffrement: $e");
        }
      }

      return messages;
    } else if (response.statusCode == 404) {
      // Pas de messages
      return [];
    } else {
      throw Exception("Erreur lors de la récupération des messages: ${response.statusCode}");
    }
  }
}
