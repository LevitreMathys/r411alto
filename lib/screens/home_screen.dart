import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:r411alto/notifiers/contacts_notifier.dart';
import 'package:r411alto/providers/latest_message_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsProvider);

    return Scaffold(
      body: Stack(
        children: [
          contactsAsync.when(
            data: (contacts) {
              if (contacts.isEmpty) {
                return const Center(child: Text("Aucune connexion établie"));
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                  top: 120,
                  bottom: 100,
                  left: 16,
                  right: 16,
                ),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        child: Text(
                          contact.displayName[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: ref
                          .watch(
                            latestMessagePreviewProvider(contact.relationId),
                          )
                          .when(
                            data: (preview) => Text(
                              preview ?? 'No messages yet',
                              style: const TextStyle(color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            loading: () => const Text(
                              'Loading...',
                              style: TextStyle(color: Colors.grey),
                            ),
                            error: (_, __) => const Text(
                              'No messages',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                      trailing: const Icon(Icons.chat_bubble_outline),
                      onTap: () => context.go('/chat/${contact.relationId}'),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                Center(child: Text("Erreur lors du chargement : $err")),
          ),
        ],
      ),
    );
  }
}
