import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay splash for 3 seconds before navigating
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (!mounted) return; // ✅ safeguard
      Navigator.pushReplacementNamed(context, '/roleSelection');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          // Make sure to add 'assets/intro.riv' to pubspec.yaml
          child: RiveAnimation.asset('assets/intro.riv'),
        ),
      ),
    );
  }
}
