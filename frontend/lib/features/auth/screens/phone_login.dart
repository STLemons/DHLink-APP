import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../core/services/api_service.dart';
import 'package:intl_phone_field/countries.dart';
import 'dart:developer' as developer;

enum Role { student, parent, staff }

class PhoneLoginScreen extends StatefulWidget {
  final Role role;
  const PhoneLoginScreen({super.key, required this.role});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _apiService = ApiService();
  bool _isLoading = false;
  bool _isPhoneVerified = false;
  String _fullPhoneNumber = '';
  final _passwordController = TextEditingController();

  String get roleTitle {
    switch (widget.role) {
      case Role.student: return 'Student';
      case Role.parent: return 'Parent';
      case Role.staff: return 'Staff';
    }
  }

  Future<void> _handleVerifyPhone() async {
  if (_fullPhoneNumber.isEmpty) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Please enter a phone number'),
      backgroundColor: Colors.orange,
    ));
    return;
  }

  setState(() => _isLoading = true);
  final response = await _apiService.checkPhoneNumber(
    _fullPhoneNumber,
    roleTitle.toLowerCase(),
  );

  if (!mounted) return; // safeguard

  setState(() => _isLoading = false);

  if (response.statusCode == 200) {
    setState(() => _isPhoneVerified = true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('This phone number is not registered.'),
      backgroundColor: Colors.red,
    ));
  }
}

  Future<void> _handleLogin() async {
  await Future.delayed(const Duration(seconds: 1));
  if (!mounted) return;

  developer.log(
    'Logging in with phone: $_fullPhoneNumber',
    name: 'PhoneLoginScreen',
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$roleTitle Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IntlPhoneField(
  decoration: const InputDecoration(
    labelText: 'Phone Number',
    border: OutlineInputBorder(borderSide: BorderSide()),
  ),
  initialCountryCode: 'ID',
  countries: countries.where((c) => c.code == 'ID' || c.code == 'TW').toList(),
  onChanged: (phone) {
    _fullPhoneNumber = phone.completeNumber;
  },
  enabled: !_isPhoneVerified,
),
            const SizedBox(height: 16),
            if (_isPhoneVerified)
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 32),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _isPhoneVerified ? _handleLogin : _handleVerifyPhone,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: Text(_isPhoneVerified ? 'Sign In' : 'Continue'),
              ),
          ],
        ),
      ),
    );
  }
}