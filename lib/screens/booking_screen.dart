import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/booking.dart';
import '../widgets/app_controls.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _checkIn;
  DateTime? _checkOut;
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen(TextEditingController controller) async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => debugPrint('onStatus: $val'),
        onError: (val) => debugPrint('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            controller.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
        } else {
          _checkOut = picked;
        }
      });
    }
  }

  void _submitBooking(String roomType, double price) async {
    if (_formKey.currentState!.validate() &&
        _checkIn != null &&
        _checkOut != null) {
      try {
        final booking = Booking(
          name: _nameController.text,
          email: _emailController.text,
          checkIn: _checkIn!,
          checkOut: _checkOut!,
          roomType: roomType,
          price: price,
        );

        await DatabaseHelper.instance.insertBooking(booking);

        if (mounted) {
          Navigator.pushNamed(context, '/confirmation', arguments: booking);
        }
      } catch (e) {
        debugPrint('Error submitting booking: $e');
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to submit booking: $e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final roomType = args?['roomType'] ?? 'Unknown Room';
    final price = args?['price'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('booking'.tr()),
        actions: const [LogoutButton()],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Card(
                    color: Colors.orange.shade50,
                    child: ListTile(
                      title: Text('Booking: $roomType'),
                      subtitle: Text('Price: €$price / night'),
                      leading: const Icon(Icons.hotel, color: Colors.orange),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'name'.tr(),
                      suffixIcon: IconButton(
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        onPressed: () => _listen(_nameController),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'email'.tr(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.mic_none),
                        onPressed: () => _listen(_emailController),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: Text(
                      _checkIn == null
                          ? 'Select Check-in Date'
                          : 'Check-in: ${DateFormat('yyyy-MM-dd').format(_checkIn!)}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context, true),
                  ),
                  ListTile(
                    title: Text(
                      _checkOut == null
                          ? 'Select Check-out Date'
                          : 'Check-out: ${DateFormat('yyyy-MM-dd').format(_checkOut!)}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context, false),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _submitBooking(roomType, price),
                    child: Text('submit'.tr()),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(top: 10, left: 10, child: ResizeControls()),
        ],
      ),
    );
  }
}
