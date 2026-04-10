import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r411alto/models/message.dart';
import 'package:r411alto/services/message.service.dart';
import '../providers/service_providers.dart';

final latestMessagePreviewProvider = FutureProvider.family<String?, String>((
  ref,
  relationId,
) async {
  final service = ref.watch(messageServiceProvider);
  final messages = await service.loadConversation(relationId);
  if (messages.isEmpty) return null;
  final sorted = List<Message>.from(messages)
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  final latest = sorted.first;
  if (latest.decryptedContent == null) {
    await service.decryptConversation(relationId, messages);
    final refreshed = await service.loadConversation(relationId);
    final refreshedSorted = List<Message>.from(refreshed)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final newest = refreshedSorted.isNotEmpty ? refreshedSorted.first : latest;
    final preview = newest.decryptedContent ?? 'Pending decrypt';
    return preview.length > 30 ? preview.substring(0, 30) + '...' : preview;
  }
  final preview = latest.decryptedContent!;
  return preview.length > 30 ? preview.substring(0, 30) + '...' : preview;
});
