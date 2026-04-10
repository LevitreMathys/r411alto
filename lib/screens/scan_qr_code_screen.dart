import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:r411alto/services/qrcodeParing.service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ScanQRCodeScreen extends StatefulWidget {
  const ScanQRCodeScreen({super.key});

  @override
  State<ScanQRCodeScreen> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  final QrCodeParingService _pairingService = QrCodeParingService();
  bool _isProcessing = false;
  Timer? _pollingTimer;

  void _handleScan(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null && !_isProcessing) {
        setState(() {
          _isProcessing = true;
        });
        _processPairing(code);
        break;
      }
    }
  }

  Future<void> _processPairing(String relationCodeA) async {
    try {
      // Étape 2 : Bob matche avec Alice
      await _pairingService.match(relationCodeA);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Matching réussi, attente de la finalisation d'Alice...")),
        );
      }

      // Commencer le polling pour attendre que Alice finalise (Étape 4)
      _startPolling(relationCodeA);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors du matching: $e")),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _startPolling(String relationCodeA) {
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final status = await _pairingService.getStatus(relationCodeA);
        if (status == "finalized") {
          timer.cancel();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pairing 100% établi !")),
            );
            context.pop(); // Retour à l'écran précédent
          }
        }
      } catch (e) {
        // Ignorer les erreurs temporaires de réseau pendant le polling
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
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
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Scan QR Code",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _handleScan,
          ),
          // Overlay with scan frame
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isProcessing ? Colors.blue : Colors.white.withValues(alpha: 0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Positionnez le QR code dans le cadre",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          // Instructions at bottom
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Le scan se fait automatiquement",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

