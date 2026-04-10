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
      final alias = await _storageRsaService.getAlias(id);
      final pubKey = await _storageRsaService.readPublicKeyPem(id);

      contacts.add(Contact(relationId: id, alias: alias, publicKeyPem: pubKey));
    }

    return contacts;
  }

  /// Récupère un contact par son relationId.
  Future<Contact?> getContact(String relationId) async {
    final alias = await _storageRsaService.getAlias(relationId);
    final pubKey = await _storageRsaService.readPublicKeyPem(relationId);

    if (pubKey == null && alias == null) return null;

    return Contact(relationId: relationId, alias: alias, publicKeyPem: pubKey);
  }

  /// Met à jour ou définit l'alias d'un contact.
  Future<void> updateAlias(String relationId, String alias) async {
    await _storageRsaService.saveAlias(relationId, alias);
  }
}
