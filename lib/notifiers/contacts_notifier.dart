import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:r411alto/models/contact.dart';
import 'package:r411alto/providers/service_providers.dart';

class ContactsNotifier extends AsyncNotifier<List<Contact>> {
  @override
  Future<List<Contact>> build() async {
    final contactService = ref.watch(contactServiceProvider);
    return contactService.getAllContacts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(contactServiceProvider).getAllContacts());
  }

  Future<void> updateAlias(String relationId, String alias) async {
    await ref.read(contactServiceProvider).updateAlias(relationId, alias);
    await refresh();
  }
}

final contactsProvider = AsyncNotifierProvider<ContactsNotifier, List<Contact>>(
  ContactsNotifier.new,
);
