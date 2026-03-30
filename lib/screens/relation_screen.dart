import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../models/pairing.dart';
import '../models/element.dart';
import '../models/element.dart' as model_element;
import '../services/element_service.dart';
import '../services/api_client.dart';
import '../widgets/relation/message_bubble.dart';
import '../widgets/common/error_display.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/relation/type_selector.dart';
import '../widgets/relation/color_picker.dart';
import '../widgets/relation/emoji_picker.dart';

class RelationScreen extends StatefulWidget {
  const RelationScreen({super.key, this.initialRelationCode});

  final String? initialRelationCode;

  @override
  State<RelationScreen> createState() => _RelationScreenState();
}

class _RelationScreenState extends State<RelationScreen> {
  List<Relation> relations = [];
  Relation? selectedRelation;
  String? errorMsg;
  bool isLoadingRelations = false;
  bool isLoadingElements = false;
  bool isSending = false;

  late ValueNotifier<ElementType> currentTypeNotifier;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentTypeNotifier = ValueNotifier(ElementType.message);
    _loadRelations();
  }

  @override
  void dispose() {
    _messageController.dispose();
    currentTypeNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadRelations() async {
    setState(() {
      isLoadingRelations = true;
      errorMsg = null;
    });

    try {
      final loaded = await Relation.listFromStorage();
      if (mounted) {
        setState(() {
          relations = loaded;
          // Auto-select if initial code provided
          if (widget.initialRelationCode != null) {
            selectedRelation = relations.firstWhere(
              (rel) => rel.relationCode == widget.initialRelationCode!,
              orElse: () => relations.isNotEmpty
                  ? relations.first!
                  : throw Exception('No relation found'),
            );
          } else if (relations.isNotEmpty && selectedRelation == null) {
            selectedRelation = relations.first;
          }
        });
      }
    } catch (e) {
      developer.log(
        'DEBUG: RelationScreen loadRelations failed: \${e}',
        name: 'RelationScreen',
      );
      if (mounted) {
        setState(() {
          errorMsg = (e as ApiException).displayMessage;
        });
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => ErrorDisplay(message: errorMsg ?? e.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingRelations = false;
        });
      }
    }
  }

  Future<void> _sendElement(ElementType type, String value) async {
    if (value.isEmpty || selectedRelation == null) return;

    setState(() {
      isSending = true;
      errorMsg = null;
    });

    try {
      final encrypted = selectedRelation!.encryptMessage(value);
      await ElementService().postElement(
        relationCode: selectedRelation!.relationCode,
        key: type.name,
        encryptedValue: encrypted,
      );
      _messageController.clear();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      developer.log(
        'DEBUG: RelationScreen sendElement failed: \${e}',
        name: 'RelationScreen',
      );
      if (mounted) {
        setState(() {
          errorMsg = (e as ApiException).displayMessage;
        });
      }
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => ErrorDisplay(message: errorMsg ?? e.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (relations.isEmpty && !isLoadingRelations) {
      return Scaffold(
        appBar: AppBar(title: const Text('Relations')),
        body: Center(
          child: errorMsg != null
              ? ErrorDisplay(
                  message: errorMsg!,
                  onDismiss: () => setState(() => errorMsg = null),
                )
              : const Text('Aucune relation'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedRelation?.displayName ?? 'Relations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoadingRelations ? null : _loadRelations,
          ),
        ],
      ),
      body: Stack(
        children: [
          selectedRelation == null
              ? ListView.builder(
                  itemCount: relations.length,
                  itemBuilder: (context, index) {
                    final rel = relations[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(rel.displayName[0])),
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
                        key: ValueKey(
                          selectedRelation!.relationCode,
                        ), // refresh on change
                        future: ElementService().getElements(
                          selectedRelation!.relationCode,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: ErrorDisplay(
                                message: (snapshot.error! as ApiException)
                                    .displayMessage,
                                onDismiss: () => setState(() {}),
                              ),
                            );
                          }
                          final elements = snapshot.data ?? [];
                          if (elements.isEmpty) {
                            return const Center(child: Text('Aucun élément'));
                          }
                          return ListView.builder(
                            reverse: true,
                            itemCount: elements.length,
                            itemBuilder: (context, index) {
                              final element = elements[index];
                              final isOwn = true; // TODO: determine properly
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
                          SizedBox(
                            width: 60,
                            child: ValueListenableBuilder<ElementType>(
                              valueListenable: currentTypeNotifier,
                              builder: (context, currentType, child) =>
                                  TypeSelector(
                                    onTypeChanged: (type) =>
                                        currentTypeNotifier.value = type,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: ValueListenableBuilder<ElementType>(
                              valueListenable: currentTypeNotifier,
                              builder: (context, currentType, child) {
                                if (currentType == ElementType.message) {
                                  return TextField(
                                    controller: _messageController,
                                    decoration: const InputDecoration(
                                      hintText: 'Message...',
                                      border: OutlineInputBorder(),
                                    ),
                                    onSubmitted: (text) =>
                                        _sendElement(currentType, text),
                                    enabled: !isSending,
                                  );
                                } else {
                                  return Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            currentType == ElementType.color
                                                ? Icons.color_lens
                                                : Icons.emoji_emotions,
                                          ),
                                          onPressed: isSending
                                              ? null
                                              : () => _showPicker(currentType),
                                        ),
                                        const Text('Appuyez pour choisir'),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: isSending
                                ? null
                                : () {
                                    final value = _messageController.text;
                                    _sendElement(
                                      currentTypeNotifier.value,
                                      value,
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          LoadingOverlay(isLoading: isLoadingRelations || isSending),
          if (errorMsg != null)
            ErrorDisplay(
              message: errorMsg!,
              onDismiss: () => setState(() => errorMsg = null),
            ),
        ],
      ),
    );
  }

  void _showPicker(ElementType type) {
    switch (type) {
      case ElementType.color:
        showDialog(
          context: context,
          builder: (context) => ColorPickerWidget(
            onColorSelected: (hex) => _sendElement(ElementType.color, hex),
          ),
        );
      case ElementType.icon:
        showDialog(
          context: context,
          builder: (context) => EmojiPickerWidget(
            onEmojiSelected: (emoji) => _sendElement(ElementType.icon, emoji),
          ),
        );
      default:
        break;
    }
  }
}
