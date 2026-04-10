import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:r411alto/notifiers/contacts_notifier.dart';
import 'package:r411alto/services/qrcodeParing.service.dart';

class ScanQRCodeScreen extends ConsumerStatefulWidget {
  const ScanQRCodeScreen({super.key});

  @override
  ConsumerState<ScanQRCodeScreen> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends ConsumerState<ScanQRCodeScreen> {
  final QrCodeParingService _pairingService = QrCodeParingService();
  bool _isProcessing = false;
  String? _localRelationCode;
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
      final result = await _pairingService.match(relationCodeA);
      
      if (mounted) {
        setState(() {
          _localRelationCode = result['localRelationCode'];
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Matching réussi, attente de la finalisation du contact...")),
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
            // Force le rafraîchissement initial
            await ref.read(contactsProvider.notifier).refresh();
            
            if (mounted && _localRelationCode != null) {
              _showRenameDialog(_localRelationCode!);
            }
          }
        }
      } catch (e) {
        // Ignorer les erreurs temporaires
      }
    });
  }

  Future<void> _showRenameDialog(String relationId) async {
    final TextEditingController controller = TextEditingController();
    
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Nouveau contact !"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Comment souhaitez-vous appeler ce contact ?"),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Nom du contact",
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Ferme le dialogue
              if (mounted) context.pop(); // Retour au Home
            },
            child: const Text("Plus tard"),
          ),
          ElevatedButton(
            onPressed: () async {
              final alias = controller.text.trim();
              if (alias.isNotEmpty) {
                await ref.read(contactsProvider.notifier).updateAlias(relationId, alias);
              }
              if (mounted) {
                Navigator.of(context).pop(); // Ferme le dialogue
                context.pop(); // Retour au Home
              }
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
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

