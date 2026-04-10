import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r411alto/widgets/common/HeaderAccount.dart';
import 'package:r411alto/widgets/common/messageWidget.dart';
import 'package:r411alto/notifiers/messages_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String relationId;

  const ChatScreen({super.key, required this.relationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isPolling = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(messagesProvider(widget.relationId).notifier);
      notifier.startPolling();
      _isPolling = true;
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    // Timer cancelled in notifier on dispose if implemented
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Easter egg
  static const String _rickRollUrl =
      'https://www.youtube.com/watch?v=dQw4w9WgXcQ';

  Future<void> _launchRickRoll() async {
    final Uri url = Uri.parse(_rickRollUrl);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the Rick Roll!')),
        );
      }
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    ref
        .read(messagesProvider(widget.relationId).notifier)
        .send(_controller.text.trim());
    _controller.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(messagesProvider(widget.relationId));

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                Headeraccount(
                  user_name: widget.relationId.substring(0, 8) + "...",
                ),
              ],
            ),
            Expanded(
              child: messagesAsync.when(
                data: (messages) => ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return MessageWidget(message: msg);
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Enter your message',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  suffixIcon: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
