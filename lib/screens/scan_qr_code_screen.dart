import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRCodeScreen extends StatefulWidget {
  const ScanQRCodeScreen({super.key});

  @override
  State<ScanQRCodeScreen> createState() => _ScanQRCodeScreenState();
}

class _ScanQRCodeScreenState extends State<ScanQRCodeScreen> {
  bool _hasScanned = false;

  void _handleScan(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null && !_hasScanned) {
        setState(() {
          _hasScanned = true;
        });
        _showScannedDialog(code);
        break;
      }
    }
  }

  void _showScannedDialog(String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("QR Code Scanned!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data found:"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Check if it's a valid r411alto URL
            if (code.startsWith('r411alto://')) ...[
              const Text(
                "This appears to be a valid r411alto link!",
                style: TextStyle(color: Colors.green),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              // Allow scanning again after a delay
              Future.delayed(const Duration(seconds: 5), () {
                if (mounted) {
                  setState(() {
                    _hasScanned = false;
                  });
                }
              });
            },
            child: const Text("Scan Again"),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              // Navigate based on the scanned data
              _navigateBasedOnCode(code);
            },
            child: const Text("Open"),
          ),
        ],
      ),
    );
  }

  void _navigateBasedOnCode(String code) {
    // Example navigation logic based on scanned QR code
    if (code.startsWith('r411alto://user/profile?id=')) {
      final userId = code.split('id=').last;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Navigating to user profile: $userId")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Opening: $code")),
      );
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
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Scan QR Code",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.flashlight_on, color: Colors.white),
            onPressed: () {
              // Toggle flashlight if supported
            },
          ),
        ],
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
                  color: Colors.white.withValues(alpha: 0.5),
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

