import 'dart:async';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import 'api_client.dart';

/// Minimal model for pairing response data.
class PairingInfo {
  final String relationCodeA;
  final String publicKeyA;

  PairingInfo({required this.relationCodeA, required this.publicKeyA});

  factory PairingInfo.fromJson(Map<String, dynamic> json) {
    return PairingInfo(
      relationCodeA: json['relationCodeA'] ?? json['relationCode'] ?? '',
      publicKeyA: json['publicKeyA'] ?? json['userPublicKey'] ?? '',
    );
  }
}

class StatusResponse {
  final String status;

  StatusResponse({required this.status});

  factory StatusResponse.fromJson(Map<String, dynamic> json) {
    return StatusResponse(status: json['status'] ?? '');
  }
}

/// Service for pairing API operations.
class PairingService {
  final ApiClient _client = ApiClient.instance;

  /// Step 1: Alice initializes pairing.
  /// Generates relationCodeA if not provided.
  Future<void> initPairing({
    String? relationCodeA,
    required String publicKeyA,
  }) async {
    relationCodeA ??= const Uuid().v4();
    final data = {'relationCode': relationCodeA, 'userPublicKey': publicKeyA};
    await _client.post('/pairing', data);
  }

  /// Step 2: Bob matches with Alice's code.
  /// Returns Alice's info.
  Future<PairingInfo> matchPairing({
    required String relationCodeA,
    required String publicKeyB,
    String? relationCodeB,
  }) async {
    relationCodeB ??= const Uuid().v4();
    final data = {
      'relationCodeA': relationCodeA,
      'relationCodeB': relationCodeB,
      'publicKeyB': publicKeyB,
    };
    final response = await _client.put('/pairing', data);
    return PairingInfo.fromJson(response.data);
  }

  /// Step 3: Alice finalizes after polling detects match.
  /// Returns Bob's info.
  Future<PairingInfo> finalizePairing(String relationCodeA) async {
    final response = await _client.delete(
      '/pairing',
      queryParameters: {'relationCodeA': relationCodeA},
    );
    return PairingInfo.fromJson(response.data);
  }

  /// Poll status for a code.
  Future<StatusResponse> getStatus(String code) async {
    final response = await _client.get('/pairing/$code/status');
    return StatusResponse.fromJson(response.data);
  }

  /// Stream for polling until finalized (timeout 2min).
  Stream<StatusResponse> pollUntilFinalized(String code) async* {
    final timeout = DateTime.now().add(const Duration(minutes: 2));
    while (DateTime.now().isBefore(timeout)) {
      final status = await getStatus(code);
      yield status;
      if (status.status == 'finalized') return;
      await Future.delayed(const Duration(seconds: 2));
    }
    throw ApiException('Polling timeout for code: $code');
  }
}
