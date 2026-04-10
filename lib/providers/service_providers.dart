import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:r411alto/services/storage.RSA.service.dart';
import 'package:r411alto/services/contact.service.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final storageRsaServiceProvider = Provider<StorageRsaService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return StorageRsaService(storage);
});

final contactServiceProvider = Provider<ContactService>((ref) {
  final storageRsa = ref.watch(storageRsaServiceProvider);
  return ContactService(storageRsa);
});
