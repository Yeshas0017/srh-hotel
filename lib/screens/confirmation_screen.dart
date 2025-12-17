import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/booking.dart';
import '../widgets/app_controls.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Booking) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No booking details found.')),
      );
    }
    final booking = args;
    final qrData =
        'Booking: ${booking.name}, ${booking.email}, ${DateFormat('yyyy-MM-dd').format(booking.checkIn)} - ${DateFormat('yyyy-MM-dd').format(booking.checkOut)}, Room: ${booking.roomType}, Price: €${booking.price}';

    return Scaffold(
      appBar: AppBar(
        title: Text('confirmation'.tr()),
        actions: const [LogoutButton()],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'booking_confirmed'.tr(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Semantics(
                  label: 'Booking Details for ${booking.name}',
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text('${'name'.tr()}: ${booking.name}'),
                          Text('${'email'.tr()}: ${booking.email}'),
                          Text('${'room'.tr()}: ${booking.roomType}'),
                          Text('${'price'.tr()}: €${booking.price}'),
                          Text(
                            '${'check_in'.tr()}: ${DateFormat('yyyy-MM-dd').format(booking.checkIn)}',
                          ),
                          Text(
                            '${'check_out'.tr()}: ${DateFormat('yyyy-MM-dd').format(booking.checkOut)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                    semanticsLabel: 'QR Code for Booking',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    await flutterTts.speak(
                      'Booking confirmed for ${booking.name}. Check in on ${DateFormat('yyyy-MM-dd').format(booking.checkIn)}.',
                    );
                  },
                  icon: const Icon(Icons.volume_up),
                  label: Text('read_details'.tr()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: Text('back_to_home'.tr()),
                ),
              ],
            ),
          ),
          const Positioned(bottom: 10, right: 10, child: ResizeControls()),
        ],
      ),
    );
  }
}
