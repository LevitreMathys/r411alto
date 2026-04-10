class Message {
  final String key; // Type: MESSAGE, ICON, COLOR, etc.
  final String value; // Contenu en clair
  final bool isMe; // Si c'est moi qui l'ai envoyé (Optionnel si on ne peut pas le savoir via l'API element)
  final DateTime timestamp;

  Message({
    required this.key,
    required this.value,
    this.isMe = false,
    required this.timestamp,
  });
}
