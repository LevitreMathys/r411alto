import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageRsaService {
  /// StorageRsaService : gestion du stockage des clés RSA de l'application.

  /// Création de l'instance du stockage.
  final FlutterSecureStorage _storage;

  StorageRsaService(this._storage);

  /// Méthode de sauvegarde des clés RSA.
  ///
  /// Paramètres :
  /// - relationId (String) : L'identifiant de la relation.
  /// - publicKeyPem (String) : La clé publique au format PEM.
  /// - privateKeyPem (String) : La clé privée au format PEM.
  String _pubKey(String relationId) => 'rel:$relationId:pubPem';
  String _privKey(String relationId) => 'rel:$relationId:privPem';

  Future<void> saveKeyPair(
    String relationId, {
    required String publicKeyPem,
    required String privateKeyPem,
  }) async {
    await _storage.write(key: _pubKey(relationId), value: publicKeyPem);
    await _storage.write(key: _privKey(relationId), value: privateKeyPem);
  }

  String _distantPubKey(String relationId) => 'rel:$relationId:distantPubPem';

  Future<void> saveDistantPublicKey(String relationId, String publicKeyPem) async {
    await _storage.write(key: _distantPubKey(relationId), value: publicKeyPem);
  }

  Future<String?> readPublicKeyPem(String relationId) =>
      _storage.read(key: _pubKey(relationId));

  Future<String?> readPrivateKeyPem(String relationId) =>
      _storage.read(key: _privKey(relationId));

  /// Récupérer l'ID de la dernière relation enregistrée ou null si pas de relation.
  Future<String?> getLastRelationId() async {
    final allKeys = await _storage.readAll();
    String? lastId;

    for (var key in allKeys.keys) {
      if (key.startsWith('rel:')) {
        final idPart = key.split(':')[1];
        lastId = idPart;
      }
    }
    return lastId;
  }

  /// Récupérer tous les identifiants de relation uniques.
  Future<List<String>> getAllRelationIds() async {
    final allKeys = await _storage.readAll();
    final Set<String> ids = {};

    for (var key in allKeys.keys) {
      if (key.startsWith('rel:')) {
        final idPart = key.split(':')[1];
        ids.add(idPart);
      }
    }
    return ids.toList();
  }

  /// Gérer l'alias (nom) du contact
  String _aliasKey(String relationId) => 'rel:$relationId:alias';

  Future<void> saveAlias(String relationId, String alias) async {
    await _storage.write(key: _aliasKey(relationId), value: alias);
  }

  Future<String?> getAlias(String relationId) =>
      _storage.read(key: _aliasKey(relationId));
}
