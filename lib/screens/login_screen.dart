import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/app_controls.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      if (username == 'admin' && password == 'admin@17') {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        // Regular user login (accepts any other input)
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white, // Removed to allow theme background
      body: Stack(
        children: [
          // Language Dropdown (Top Right)
          // Theme Toggle and Language Dropdown (Top Right)
          Positioned(
            top: 40,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ThemeToggle(),
                const SizedBox(width: 8),
                const LanguageDropdown(),
              ],
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/srh_logo.png',
                      height: 100,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.hotel,
                          size: 100,
                          color: Colors.orange,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'title'.tr(),
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person, color: Colors.orange),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.orange),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('About SRH Hotel'),
                            content: const Text(
                              'SRH Hotel App\nVersion 1.0.0\n\nDeveloped for SRH University Project.\n\nFeatures:\n- Multiple Languages (En, Es, De)\n- Offline Booking\n- Map Navigation\n- Accessibility Tools',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text('About App'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 10, right: 10),
        child: ResizeControls(),
      ),
    );
  }
}
