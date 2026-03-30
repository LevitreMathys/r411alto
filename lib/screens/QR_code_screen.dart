import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import '../crypto/key_generator.dart';
import '../crypto/key_storage.dart';
import '../services/pairing_service.dart';
import 'relation_screen.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  bool isGenerating = false;
  String? qrData;
  String status = 'initial';
  Map<String, String>? keyPair;
  StreamSubscription<StatusResponse>? _pollSub;

  @override
  void initState() {
    super.initState();
    _generateAndInit();
  }

  @override
  void dispose() {
    _pollSub?.cancel();
    super.dispose();
  }

  Future<void> _generateAndInit() async {
    setState(() {
      isGenerating = true;
      status = 'Génération des clés RSA...';
    });
    try {
      final keyPairMap = await KeyGenerator.generateRsaKeyPair();
      final codeA = const Uuid().v4();
      await PairingService().initPairing(
        relationCodeA: codeA,
        publicKeyA: keyPairMap['publicKeyPem']!,
      );
      await KeyStorage.storeKeys(
        codeA,
        keyPairMap['publicKeyPem']!,
        keyPairMap['privateKeyPem']!,
      );
      setState(() {
        keyPair = keyPairMap;
        qrData = codeA;
        isGenerating = false;
        status = 'waiting';
      });
      _startPolling(codeA);
    } catch (e) {
      setState(() {
        isGenerating = false;
        status = 'Erreur';
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur init: $e')));
      }
    }
  }

  void _startPolling(String codeA) {
    _pollSub = PairingService()
        .pollUntilFinalized(codeA)
        .listen(
          (statusResp) {
            if (mounted) {
              setState(() {
                status = statusResp.status;
              });
              if (statusResp.status == 'completed') {
                _finalize(codeA);
              }
            }
          },
          onError: (e) {
            if (mounted) {
              setState(() {
                status = 'Erreur polling';
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Polling: $e')));
            }
          },
          onDone: () {
            setState(() {
              status = 'finalized';
            });
          },
        );
  }

  String? myRelationCode; // Add at class level with codeA

  Future<void> _finalize(String codeA) async {
    try {
      myRelationCode = codeA; // Set before finalize
      final bobInfo = await PairingService().finalizePairing(codeA);
      const storage = FlutterSecureStorage();
      await storage.write(key: 'peer_pub_$codeA', value: bobInfo.publicKeyA);
      _pollSub?.cancel();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Pairing réussi !')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RelationScreen(initialRelationCode: myRelationCode!),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Finalize: $e')));
      }
    }
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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Initier Pairing',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isGenerating || qrData == null)
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      'Génération des clés et init...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: PrettyQrView.data(
                        data: qrData!,
                        decoration: PrettyQrDecoration(
                          shape: const PrettyQrSmoothSymbol(
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Status: $status',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Montrez ce QR à votre partenaire\nAttendez la confirmation...",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
