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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar
    );
  }
    }