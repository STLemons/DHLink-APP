import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../core/services/api_service.dart';
import 'package:intl_phone_field/countries.dart';
import 'email_verification.dart'; // this gives you Country objects


class OwnerSignupScreen extends StatefulWidget {
  const OwnerSignupScreen({super.key});

  @override
  State<OwnerSignupScreen> createState() => _OwnerSignupScreenState();
}

class _OwnerSignupScreenState extends State<OwnerSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _orgNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _fullPhoneNumber = '';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _orgNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final response = await _apiService.ownerSignup(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phoneNumber: _fullPhoneNumber,
        organizationName: _orgNameController.text,
        password: _passwordController.text,
      );

      setState(() => _isLoading = false);
      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup successful! Please verify your email.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OwnerEmailVerificationScreen(
              email: _emailController.text,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup failed: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Owner Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty || !value.contains('@')
                        ? 'Please enter a valid email'
                        : null,
              ),
              const SizedBox(height: 16),
              IntlPhoneField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                initialCountryCode: 'ID',
                countries: const [
                  Country(
                      name: "Indonesia",
                      nameTranslations: {"en": "Indonesia"},
                      flag: "🇮🇩",
                      code: "ID",
                      dialCode: "62",
                      minLength: 9,
                      maxLength: 13),
                  Country(
                      name: "Taiwan",
                      nameTranslations: {"en": "Taiwan"},
                      flag: "🇹🇼",
                      code: "TW",
                      dialCode: "886",
                      minLength: 9,
                      maxLength: 9),
                ],
                onChanged: (phone) => _fullPhoneNumber = phone.completeNumber,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _orgNameController,
                decoration:
                    const InputDecoration(labelText: 'Organization Name'),
                validator: (value) => value!.isEmpty
                    ? 'Please enter your organization name'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () =>
                        setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                validator: (value) => value!.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isPasswordVisible,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                validator: (value) => value != _passwordController.text
                    ? 'Passwords do not match'
                    : null,
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handleSignup,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}