import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r411alto/models/message.dart';
import 'package:r411alto/providers/service_providers.dart';
import 'dart:async';

class MessagesNotifier extends AsyncNotifier<List<Message>> {
  Timer? _pollTimer;
  final String _relationId;

  MessagesNotifier(this._relationId);

  @override
  Future<List<Message>> build() async {
    final service = ref.watch(messageServiceProvider);
    var msgs = await service.loadConversation(_relationId);
    return await service.decryptConversation(_relationId, msgs);
  }

  Future<void> send(String plaintext) async {
    state = const AsyncLoading();
    final service = ref.read(messageServiceProvider);
    await service.sendMessage(_relationId, plaintext);
    final msgs = await service.loadConversation(_relationId);
    state = AsyncData(await service.decryptConversation(_relationId, msgs));
  }

  void startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final service = ref.read(messageServiceProvider);
      await service.pollNew(_relationId);
      final msgs = await service.loadConversation(_relationId);
      state = AsyncData(await service.decryptConversation(_relationId, msgs));
    });
  }
}

final messagesProvider =
    AsyncNotifierProvider.family<MessagesNotifier, List<Message>, String>(
      (relationId) => MessagesNotifier(relationId),
    );
