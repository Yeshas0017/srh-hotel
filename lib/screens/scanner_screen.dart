import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_controls.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isProcessing = false;

  Future<void> _launchURL(String? urlString) async {
    if (_isProcessing) return;
    if (urlString == null || urlString.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Basic check to ensure it looks like a URL
      String finalUrl = urlString;
      if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
        finalUrl = 'https://$finalUrl';
      }

      final Uri url = Uri.parse(finalUrl);

      debugPrint('Attempting to launch: $url');

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      } else {
        // Some URLs (like schemes) might fail 'canLaunchUrl' but still work, or vice versa.
        // Trying launch directly if simple check failed might be a backup, but usually canLaunch is best.
        // On web, sometimes popups are blocked.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch URL: $urlString')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      // Delay enabling processing to prevent multiple triggers from same QR frame stream
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

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
                _launchURL(barcode.rawValue);
              }
            },
          ),
          const Positioned(bottom: 10, right: 10, child: ResizeControls()),
        ],
      ),
    );
  }
}
