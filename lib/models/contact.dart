class Contact {
  final String relationId;
  final String? alias;
  final String? publicKeyPem;
  final String? distantPublicKeyPem;

  Contact({
    required this.relationId,
    this.alias,
    this.publicKeyPem,
    this.distantPublicKeyPem,
  });

  String get displayName => alias ?? 'Contact ${relationId.substring(0, 8)}';
}
