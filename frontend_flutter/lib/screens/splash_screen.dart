import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend_flutter/screens/auth/login_screen.dart';
import 'package:frontend_flutter/screens/events/events_list_screen.dart';
import 'package:frontend_flutter/screens/home_screen.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Artboard? _riveArtboard;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadDashAnimation();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final token = await _storage.read(key: 'auth_token');
    Timer(const Duration(seconds: 15), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => token != null
              ? const HomeScreen()
              : const LoginScreen(),
        ),
      );
    });
  }

  Future<void> _loadDashAnimation() async {
    try {
      final data = await rootBundle.load('assets/animations/bird.riv');
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      // Find the state machine controller
      final controller = StateMachineController.fromArtboard(artboard, 'birb');

      if (controller != null) {
        artboard.addController(controller);

        // Find the dance input and activate it
        final danceInput = controller.findInput<bool>('dance');
        if (danceInput != null) {
          danceInput.value = true;
        }

        // Find look up trigger and fire it
        final lookUpInput = controller.findInput<bool>('look up');
        if (lookUpInput != null) {
          lookUpInput.value = true;
        }
      }

      setState(() => _riveArtboard = artboard);
    } catch (e) {
      debugPrint('Error loading animation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _riveArtboard != null
          ? Rive(
        artboard: _riveArtboard!,
        fit: BoxFit.contain,
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}