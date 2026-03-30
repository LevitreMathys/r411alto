import 'package:flutter/material.dart';
import '../models/pairing.dart';
import '../models/element.dart' as model_element;
import '../services/element_service.dart';
import '../widgets/relation/message_bubble.dart';

class RelationScreen extends StatefulWidget {
  const RelationScreen({super.key});

  @override
  State<RelationScreen> createState() => _RelationScreenState();
}

class _RelationScreenState extends State<RelationScreen> {
  List<Relation> relations = [];
  Relation? selectedRelation;

  @override
  void initState() {
    super.initState();
    _loadRelations();
  }

  Future<void> _loadRelations() async {
    final loaded = await Relation.listFromStorage();
    setState(() {
      relations = loaded;
    });
  }

  void _sendMessage(String text) async {
    if (text.isEmpty || selectedRelation == null) return;
    final encrypted = selectedRelation!.encryptMessage(text);
    await ElementService().postElement(
      relationCode: selectedRelation!.relationCode,
      key: 'message',
      encryptedValue: encrypted,
    );
    // Refresh
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (relations.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Relations')),
        body: const Center(child: Text('Aucune relation')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedRelation?.displayName ?? 'Relations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRelations,
          ),
        ],
      ),
      body: selectedRelation == null
          ? ListView.builder(
              itemCount: relations.length,
              itemBuilder: (context, index) {
                final rel = relations[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(rel.displayName)),
                  title: Text(rel.displayName),
                  subtitle: Text(rel.relationCode.substring(0, 8)),
                  onTap: () => setState(() => selectedRelation = rel),
                );
              },
            )
          : Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<model_element.Element>>(
                    future: ElementService().getElements(
                      selectedRelation!.relationCode,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Center(child: CircularProgressIndicator());
                      final elements = snapshot.data!;
                      return ListView.builder(
                        reverse: true,
                        itemCount: elements.length,
                        itemBuilder: (context, index) {
                          final element = elements[index];
                          final isOwn = true; // TODO: implement properly
                          return MessageBubble(
                            element: element,
                            relation: selectedRelation!,
                            isOwnMessage: isOwn,
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Message...',
                          ),
                          onSubmitted: _sendMessage,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {}, // Use controller for send
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
