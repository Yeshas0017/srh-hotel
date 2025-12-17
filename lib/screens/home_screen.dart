import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/app_controls.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  // Views for each tab
  late final List<Widget> _pages = [
    _buildRoomList(),
    _buildMap(),
    const ScannerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'.tr()),
        actions: const [LogoutButton()],
      ),
      body: Stack(
        children: [
          // Main Content determined by current index
          IndexedStack(index: _currentIndex, children: _pages),

          // Controls (Bottom Right) - Resize Only
          const Positioned(bottom: 10, right: 10, child: ResizeControls()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scanner',
          ),
        ],
      ),
    );
  }

  Widget _buildRoomList() {
    return ListView(
      padding: const EdgeInsets.only(
        top: 80,
        left: 16,
        right: 16,
        bottom: 16,
      ), // Padding top for controls
      children: [
        // Display Uploaded Image Here
        Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 100, // Adjust height as needed
            child: Image.asset(
              'assets/images/srh_logo.png',
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          ),
        ),
        _buildRoomCard(context, 'Standard Room', 100),
        _buildRoomCard(context, 'Deluxe Room', 200),
        _buildRoomCard(context, 'Suite Room', 300),
      ],
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(49.409358, 8.653427), // SRH Campus
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.srh_hotel',
        ),
        MarkerLayer(
          markers: [
            // SRH Hotel (Main - Big Red)
            Marker(
              point: const LatLng(49.409358, 8.653427),
              width: 100,
              height: 100,
              child: const Icon(Icons.location_on, color: Colors.red, size: 60),
            ),
            // 1. Hotel Europäischer Hof
            Marker(
              point: const LatLng(49.4095, 8.6947),
              width: 60,
              height: 60,
              child: const Icon(Icons.hotel, color: Colors.blue, size: 30),
            ),
            // 2. Crowne Plaza
            Marker(
              point: const LatLng(49.4087, 8.6912),
              width: 60,
              height: 60,
              child: const Icon(Icons.hotel, color: Colors.blue, size: 30),
            ),
            // 3. Leonardo Hotel
            Marker(
              point: const LatLng(49.4036, 8.6732),
              width: 60,
              height: 60,
              child: const Icon(Icons.hotel, color: Colors.blue, size: 30),
            ),
            // 4. NH Heidelberg
            Marker(
              point: const LatLng(49.4068, 8.6793),
              width: 60,
              height: 60,
              child: const Icon(Icons.hotel, color: Colors.blue, size: 30),
            ),
            // 5. Qube Hotel
            Marker(
              point: const LatLng(49.4055, 8.6830),
              width: 60,
              height: 60,
              child: const Icon(Icons.hotel, color: Colors.blue, size: 30),
            ),
            // 6. Hotel Bayrischer Hof
            Marker(
              point: const LatLng(49.4102, 8.6935),
              width: 60,
              height: 60,
              child: const Icon(Icons.hotel, color: Colors.blue, size: 30),
            ),
            // 7. Heidelberg Suites
            Marker(
              point: const LatLng(49.4140, 8.7125),
              width: 60,
              height: 60,
              child: const Icon(Icons.hotel, color: Colors.blue, size: 30),
            ),
            // 8. Holländer Hof
            Marker(
              point: const LatLng(49.4125, 8.7100),
              width: 60,
              height: 60,
              child: const Icon(Icons.hotel, color: Colors.blue, size: 30),
            ),
            // 9. Arthotel Heidelberg
            Marker(
              point: const LatLng(49.4110, 8.7088),
              width: 60,
              height: 60,
              child: const Icon(Icons.hotel, color: Colors.blue, size: 30),
            ),
            // 10. Hotel Vier Jahreszeiten
            Marker(
              point: const LatLng(49.4120, 8.7110),
              width: 60,
              height: 60,
              child: const Icon(Icons.hotel, color: Colors.blue, size: 30),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoomCard(BuildContext context, String title, double price) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.hotel, color: Colors.orange, size: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('€$price / night'),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/booking',
              arguments: {'roomType': title, 'price': price},
            );
          },
          child: Text('book_now'.tr()),
        ),
      ),
    );
  }
}
