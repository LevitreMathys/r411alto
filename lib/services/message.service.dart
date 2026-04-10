import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/local_message_storage.dart';
import 'package:r411alto/models/message.dart';
import 'package:r411alto/models/contact.dart';
import 'package:r411alto/services/contact.service.dart';
import 'package:r411alto/services/storage.RSA.service.dart';
import 'package:r411alto/services/message.encrypted.service.dart';

const String apiBase = 'https://alto.samyn.ovh';

class MessageService {
  final ContactService _contactService;
  final StorageRsaService _storageRsaService;
  final LocalMessageStorage _localStorage;

  MessageService(
    this._contactService,
    this._storageRsaService,
    this._localStorage,
  );

  // String _msgsKey(String relationId) => 'rel:$relationId:msgs';

  /// Send plaintext message: encrypt -> POST -> local save (decrypted, isSent=true)
  Future<void> sendMessage(String relationId, String plaintext) async {
    final contact = await _contactService.getContact(relationId);
    if (contact == null) throw Exception('Contact not found');

    final pubKeyPem = contact.distantPublicKeyPem ?? contact.publicKeyPem ?? '';
    if (pubKeyPem.isEmpty) throw Exception('No public key for contact');

    final encrypted = rsaEncryptToBase64(
      recipientPublicKeyPem: pubKeyPem,
      plaintext: plaintext,
    );

    await http.post(
      Uri.parse('$apiBase/element'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'relationCode': relationId,
        'key': 'MESSAGE',
        'value': encrypted,
      }),
    );

    // Local save with decrypted
    final msg = Message(
      id: generateMessageId(),
      encryptedContent: encrypted,
      timestamp: DateTime.now(),
      isSent: true,
      decryptedContent: plaintext,
    );
    await _saveMessage(relationId, msg);
  }

  /// Poll server for new message: GET -> if new, local save (encrypted, isSent=false)
  Future<Message?> pollNew(String relationId) async {
    final response = await http.get(
      Uri.parse('$apiBase/element?relationCode=$relationId'),
    );
    if (response.statusCode == 200) {
      final value = jsonDecode(response.body)['value'] as String;
      final msg = Message(
        id: generateMessageId(),
        encryptedContent: value,
        timestamp: DateTime.now(),
        isSent: false,
      );
      await _saveMessage(relationId, msg);
      return msg;
    }
    return null;
  }

  /// Load all local messages for conversation
  Future<List<Message>> loadConversation(String relationId) async {
    return await LocalMessageStorage.loadMessages(relationId);
  }

  /// Save/append message to local storage (JSON list)
  Future<void> _saveMessage(String relationId, Message msg) async {
    await LocalMessageStorage.addMessage(relationId, msg);
  }

  /// Decrypt pending messages in conversation
  Future<List<Message>> decryptConversation(
    String relationId,
    List<Message> msgs,
  ) async {
    final privKey = await _storageRsaService.readPrivateKeyPem(relationId);
    if (privKey == null) return msgs;

    final decryptedMsgs = msgs.map((msg) {
      if (msg.decryptedContent == null && !msg.isSent) {
        try {
          final decrypted = rsaDecryptFromBase64(
            myPrivateKeyPem: privKey,
            ciphertextB64: msg.encryptedContent,
          );
          return Message(
            id: msg.id,
            encryptedContent: msg.encryptedContent,
            timestamp: msg.timestamp,
            isSent: msg.isSent,
            decryptedContent: decrypted,
          );
        } catch (e) {
          return msg; // Keep encrypted if fail
        }
      }
      return msg;
    }).toList();

    // Save updated decrypted messages
    for (final updatedMsg in decryptedMsgs) {
      await _saveMessage(relationId, updatedMsg);
    }
    return decryptedMsgs;
  }
}
