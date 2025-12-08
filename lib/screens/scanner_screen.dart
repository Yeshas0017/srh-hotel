import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/app_controls.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('scan_qr'.tr()),
        actions: const [LogoutButton()],
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Found: ${barcode.rawValue}')),
                );
              }
            },
          ),
          const Positioned(top: 10, left: 10, child: ResizeControls()),
        ],
      ),
    );
  }
}
