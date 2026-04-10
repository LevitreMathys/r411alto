import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/models/contact.dart';
import 'package:r411alto/models/message.dart';
import 'package:r411alto/providers/service_providers.dart';
import 'package:r411alto/widgets/common/HeaderAccount.dart';
import 'package:r411alto/widgets/common/message.dart' as widget_msg;

class ChatScreen extends ConsumerStatefulWidget {
  final String relationId;
  const ChatScreen({super.key, required this.relationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Contact? _contact;
  Timer? _pollingTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  Future<void> _loadContact() async {
    final contact = await ref.read(contactServiceProvider).getContact(widget.relationId);
    if (mounted) {
      setState(() {
        _contact = contact;
        _isLoading = false;
      });
      if (contact != null) {
        _startPolling();
      }
    }
  }

  void _startPolling() {
    _fetchMessages();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchMessages();
    });
  }

  Future<void> _fetchMessages() async {
    if (_contact == null) return;
    try {
      final newMessages = await ref.read(messageServiceProvider).fetchMessages(_contact!);
      if (newMessages.isNotEmpty && mounted) {
        setState(() {
          _messages.addAll(newMessages);
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint("Erreur polling messages: $e");
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _contact == null) return;

    final content = _controller.text.trim();

    final myMsg = Message(
      key: 'MESSAGE',
      value: content,
      isMe: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(myMsg);
    });
    _controller.clear();
    _scrollToBottom();

    try {
      await ref.read(messageServiceProvider).sendMessage(_contact!, 'MESSAGE', content);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur d'envoi: $e")),
        );
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_contact == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Contact introuvable")),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Headeraccount(user_name: _contact!.displayName),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return widget_msg.Message(
                    isMe: msg.isMe,
                    text: msg.value,
                  );
                },
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Votre message...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
