import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../utils/database_helper.dart';
import '../widgets/app_controls.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _refreshBookings();
  }

  void _refreshBookings() {
    setState(() {
      _bookingsFuture = DatabaseHelper.instance.getBookings();
    });
  }

  Future<void> _deleteBooking(int id) async {
    await DatabaseHelper.instance.deleteBooking(id);
    _refreshBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: const [LogoutButton()],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Booking>>(
            future: _bookingsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No bookings yet.'));
              }

              final bookings = snapshot.data!;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(booking.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${booking.email}'),
                          Text('Room: ${booking.roomType} - €${booking.price}'),
                          Text(
                            'Check-in: ${DateFormat('yyyy-MM-dd').format(booking.checkIn)}',
                          ),
                          Text(
                            'Check-out: ${DateFormat('yyyy-MM-dd').format(booking.checkOut)}',
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          if (booking.id != null) {
                            _deleteBooking(booking.id!);
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const Positioned(top: 10, left: 10, child: ResizeControls()),
        ],
      ),
    );
  }
}
