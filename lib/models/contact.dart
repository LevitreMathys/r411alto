class Contact {
  final String relationId; // ID local
  final String? distantRelationId; // ID distant (du destinataire)
  final String? alias;
  final String? publicKeyPem; // Ma clé publique pour cette relation
  final String? distantPublicKeyPem; // Clé publique du destinataire

  Contact({
    required this.relationId,
    this.distantRelationId,
    this.alias,
    this.publicKeyPem,
    this.distantPublicKeyPem,
  });

  String get displayName => alias ?? 'Contact ${relationId.substring(0, 8)}';
}
