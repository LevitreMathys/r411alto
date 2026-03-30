import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import '../crypto/key_generator.dart';
import '../crypto/key_storage.dart';
import '../services/pairing_service.dart';

class ScanQRCodeScreen extends StatefulWidget {
  const ScanQRCodeScreen({super.key});

  @override
  State<ScanQRCodeScreen> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  bool _isScanning = true;
  bool isMatching = false;
  String status = 'Scan QR code';
  String? codeA;
  Map<String, String>? keyPair;
  StreamSubscription<StatusResponse>? _pollSub;

  void _handleScan(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null && _isScanning) {
        setState(() {
          _isScanning = false;
          codeA = code;
          status = 'QR scanné, matching...';
        });
        _handleScanMatch(code);
        break;
      }
    }
  }

  Future<void> _handleScanMatch(String relationCodeA) async {
    setState(() {
      isMatching = true;
      status = 'Génération clés et match...';
    });
    try {
      final keyPairMap = await KeyGenerator.generateRsaKeyPair();
      final codeB = const Uuid().v4();
      final aliceInfo = await PairingService().matchPairing(
        relationCodeA: relationCodeA,
        publicKeyB: keyPairMap['publicKeyPem']!,
        relationCodeB: codeB,
      );
      await KeyStorage.storeKeys(
        relationCodeA,
        keyPairMap['publicKeyPem']!,
        keyPairMap['privateKeyPem']!,
      );
      const storage = FlutterSecureStorage();
      await storage.write(
        key: 'peer_pub_$relationCodeA',
        value: aliceInfo.publicKeyA,
      );
      setState(() {
        keyPair = keyPairMap;
        status = 'waiting';
        isMatching = false;
      });
      _startPolling(relationCodeA);
    } catch (e) {
      setState(() {
        isMatching = false;
        status = 'Erreur match: $e';
      });
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Match erreur: $e')));
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => _isScanning = true);
      });
    }
  }

  void _startPolling(String codeA) {
    _pollSub = PairingService()
        .pollUntilFinalized(codeA)
        .listen(
          (statusResp) {
            if (mounted) {
              setState(() => status = statusResp.status);
              if (statusResp.status == 'finalized') {
                _completePairing();
              }
            }
          },
          onError: (e) {
            if (mounted) {
              setState(() => status = 'Erreur polling');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Polling: $e')));
            }
          },
        );
  }

  void _completePairing() {
    _pollSub?.cancel();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pairing finalisé !')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Scan QR Pairing",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.flashlight_on, color: Colors.white),
            onPressed: () {
              // Toggle flashlight
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isScanning)
            MobileScanner(onDetect: _handleScan)
          else
            Center(child: CircularProgressIndicator()),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
