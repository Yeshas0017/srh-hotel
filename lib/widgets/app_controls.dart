import 'package:flutter/material.dart';
import '../main.dart';

class ResizeControls extends StatelessWidget {
  const ResizeControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            if (SRHHotelApp.textScaleNotifier.value > 0.5) {
              SRHHotelApp.textScaleNotifier.value -= 0.1;
            }
          },
          tooltip: 'Decrease Text Size',
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            if (SRHHotelApp.textScaleNotifier.value < 2.0) {
              SRHHotelApp.textScaleNotifier.value += 0.1;
            }
          },
          tooltip: 'Increase Text Size',
        ),
      ],
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
      tooltip: 'Logout',
    );
  }
}
