import 'package:flutter/material.dart';
import 'owner_login.dart'; // Import owner login
import 'phone_login.dart'; // Import phone login

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Role")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneLoginScreen(role: Role.student)));
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('I am a Student'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneLoginScreen(role: Role.parent)));
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('I am a Parent / Caregiver'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // This could lead to another screen asking "Owner or Staff?"
                  // For now, let's assume "Teacher" means Owner.
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OwnerLoginScreen()));
                },
                 style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('I am a Teacher / Owner'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}