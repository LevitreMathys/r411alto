import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:r411alto/services/qrcodeParing.service.dart';
import 'package:r411alto/services/storage.RSA.service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final QrCodeParingService _pairingService = QrCodeParingService();
  final StorageRsaService _storageRsaService = StorageRsaService(const FlutterSecureStorage());
  String? _relationCode;
  Timer? _pollingTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _startPairing();
  }

  Future<void> _startPairing() async {
    try {
      final code = await _pairingService.generateQrCode();
      if (mounted) {
        setState(() {
          _relationCode = code;
          _isLoading = false;
        });
        _startPolling(code);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: $e")),
        );
      }
    }
  }

  void _startPolling(String code) {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final status = await _pairingService.getStatus(code);
      if (status == "completed") {
        timer.cancel();
        _finalizePairing(code);
      }
    });
  }

  Future<void> _finalizePairing(String code) async {
    try {
      final bobData = await _pairingService.finalize(code);
      
      final String relationCodeB = bobData['relationCodeB'];
      final String publicKeyB = bobData['publicKeyB'];

      // Stocker la clé publique de Bob
      await _storageRsaService.saveDistantPublicKey(relationCodeB, publicKeyB);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pairing réussi avec succès !")),
        );
        context.pop(); // Retour à l'écran précédent
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la finalisation: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Mon QR Code",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: PrettyQrView.data(
                      data: _relationCode!,
                      decoration: const PrettyQrDecoration(
                        shape: PrettyQrSmoothSymbol(color: Color(0xFF1E3A8A)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Scannez ce code pour me retrouver",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ID: $_relationCode",
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ],
              ),
      ),
    );
  }
}
