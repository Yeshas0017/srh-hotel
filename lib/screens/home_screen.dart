import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/app_controls.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showMagnifier = false;
  Offset _magnifierPosition = const Offset(100, 100);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'.tr()),
        actions: [
          IconButton(
            icon: Icon(_showMagnifier ? Icons.zoom_in : Icons.zoom_out),
            onPressed: () {
              setState(() {
                _showMagnifier = !_showMagnifier;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              if (context.locale.languageCode == 'en') {
                context.setLocale(const Locale('es'));
              } else if (context.locale.languageCode == 'es') {
                context.setLocale(const Locale('de'));
              } else {
                context.setLocale(const Locale('en'));
              }
            },
          ),
          const LogoutButton(),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildRoomCard(context, 'Standard Room', 100),
                    _buildRoomCard(context, 'Deluxe Room', 200),
                    _buildRoomCard(context, 'Suite Room', 300),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    FlutterMap(
                      options: MapOptions(
                        initialCenter: const LatLng(
                          49.40768,
                          8.69079,
                        ), // Heidelberg, Germany
                        initialZoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.srh_hotel',
                        ),
                        MarkerLayer(
                          markers: [
                            // SRH Hotel (Main)
                            Marker(
                              point: const LatLng(49.40768, 8.69079),
                              width: 80,
                              height: 80,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                            // Hotel 2
                            Marker(
                              point: const LatLng(49.41000, 8.70000),
                              width: 80,
                              height: 80,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                            // Hotel 3
                            Marker(
                              point: const LatLng(49.40500, 8.68000),
                              width: 80,
                              height: 80,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_showMagnifier)
                      Positioned(
                        left: _magnifierPosition.dx - 50,
                        top: _magnifierPosition.dy - 50,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              _magnifierPosition += details.delta;
                            });
                          },
                          child: RawMagnifier(
                            decoration: const MagnifierDecoration(
                              shape: CircleBorder(
                                side: BorderSide(color: Colors.pink, width: 3),
                              ),
                            ),
                            size: const Size(100, 100),
                            magnificationScale: 2,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const Positioned(top: 10, left: 10, child: ResizeControls()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/scanner');
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
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
