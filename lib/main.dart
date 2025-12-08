import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin_screen.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (kIsWeb) {
    // Initialize for Web
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux) {
    // Initialize for Windows/Linux
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('es'), Locale('de')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const SRHHotelApp(),
    ),
  );
}

class SRHHotelApp extends StatelessWidget {
  static final ValueNotifier<double> textScaleNotifier = ValueNotifier<double>(
    1.0,
  );

  const SRHHotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: textScaleNotifier,
      builder: (context, scale, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: MaterialApp(
            title: 'SRH Hotel',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
              primarySwatch: Colors.orange,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
              useMaterial3: true,
            ),
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/': (context) => const HomeScreen(),
              '/booking': (context) => const BookingScreen(),
              '/confirmation': (context) => const ConfirmationScreen(),
              '/scanner': (context) => const ScannerScreen(),
              '/admin': (context) => const AdminScreen(),
            },
          ),
        );
      },
    );
  }
}
