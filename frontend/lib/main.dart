import 'package:flutter/material.dart';
import 'features/auth/screens/role_selection.dart';
import 'features/auth/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DHLink',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define routes in one place
      routes: {
        '/': (context) => const SplashScreen(),
        '/roleSelection': (context) => const RoleSelectionScreen(),
      },
      initialRoute: '/',
    );
  }
}