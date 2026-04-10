import 'package:r411alto/models/contact.dart';
import 'package:r411alto/services/storage.RSA.service.dart';

class ContactService {
  final StorageRsaService _storageRsaService;

  ContactService(this._storageRsaService);

  /// Récupère tous les contacts enregistrés.
  Future<List<Contact>> getAllContacts() async {
    final relationIds = await _storageRsaService.getAllRelationIds();
    final List<Contact> contacts = [];

    for (var id in relationIds) {
      final contact = await getContact(id);
      if (contact != null) {
        contacts.add(contact);
      }
    }

    return contacts;
  }

  /// Récupère un contact par son relationId (local).
  Future<Contact?> getContact(String relationId) async {
    final alias = await _storageRsaService.getAlias(relationId);
    final pubKey = await _storageRsaService.readPublicKeyPem(relationId);
    final distantId = await _storageRsaService.readDistantRelationId(relationId);
    final distantPubKey = await _storageRsaService.readDistantPublicKeyPem(relationId);

    // Un contact est valide s'il a au moins une clé publique locale ou un alias
    if (pubKey == null && alias == null) return null;

    return Contact(
      relationId: relationId,
      distantRelationId: distantId,
      alias: alias,
      publicKeyPem: pubKey,
      distantPublicKeyPem: distantPubKey,
    );
  }

  /// Met à jour ou définit l'alias d'un contact.
  Future<void> updateAlias(String relationId, String alias) async {
    await _storageRsaService.saveAlias(relationId, alias);
  }
}
