import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main.dart'; // Needed for SRHHotelApp and textScaleNotifier

class ResizeControls extends StatelessWidget {
  const ResizeControls({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
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
      ),
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

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: context.locale,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
          elevation: 16,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          onChanged: (Locale? newValue) {
            if (newValue != null) {
              context.setLocale(newValue);
            }
          },
          items: const [
            DropdownMenuItem(value: Locale('en'), child: Text('English')),
            DropdownMenuItem(value: Locale('de'), child: Text('Deutsch')),
            DropdownMenuItem(value: Locale('fr'), child: Text('Français')),
            DropdownMenuItem(value: Locale('es'), child: Text('Español')),
          ],
        ),
      ),
    );
  }
}

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: SRHHotelApp.themeNotifier,
      builder: (context, currentMode, _) {
        final isDark = currentMode == ThemeMode.dark;
        return IconButton(
          icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          color: Colors.orange,
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          onPressed: () {
            SRHHotelApp.themeNotifier.value = isDark
                ? ThemeMode.light
                : ThemeMode.dark;
          },
        );
      },
    );
  }
}
