import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import 'owner_login.dart';

class OwnerEmailVerificationScreen extends StatefulWidget {
  final String email;
  const OwnerEmailVerificationScreen({super.key, required this.email});

  @override
  State<OwnerEmailVerificationScreen> createState() =>
      _OwnerEmailVerificationScreenState();
}

class _OwnerEmailVerificationScreenState
    extends State<OwnerEmailVerificationScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService(); 
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    final response =
        await _apiService.verifyOwnerEmail(widget.email, _codeController.text); 

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Email verified successfully!'),
            backgroundColor: Colors.green),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const OwnerLoginScreen())); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Verification failed: ${response.body}'),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isLoading = true);
    final response =
        await _apiService.resendOwnerVerificationCode(widget.email);

    setState(() => _isLoading = false);
    if (!mounted) return;
    if (response.statusCode == 200) { 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Verification code resent!'),
            backgroundColor: Colors.blue),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to resend code: ${response.body}'),
            backgroundColor: Colors.red),
      );
    }
  }

  // ADDED UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'A verification code has been sent to:\n${widget.email}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Verify'),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : _resendCode,
                child: const Text('Resend Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}