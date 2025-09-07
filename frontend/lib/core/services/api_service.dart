import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // Import the logger package
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String? _baseUrl = dotenv.env['API'];
  final Logger _logger = Logger();

  Future<http.Response> ownerSignup({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String organizationName,
    required String password,
  }) async {
    final Uri uri = Uri.parse('$_baseUrl/auth/owner/signup');
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    }; 
    final Map<String, String> body = {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'organization_name': organizationName,
      'password': password,
    }; 
    try {
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      ); 
      return response;
    } catch (e) {
      _logger.e('Network Error occurred: $e');
      return http.Response('Network error occurred', 503); 
    }
  }

  Future<http.Response> checkPhoneNumber(String phoneNumber, String role) async {
    // final Uri uri = Uri.parse('$_baseUrl/auth/check-phone'); [cite: 10]
    await Future.delayed(const Duration(seconds: 1));
    return http.Response(jsonEncode({'message': 'Phone number is registered'}), 200);
  }

  //  ADDED THIS METHOD
  Future<http.Response> verifyOwnerEmail(String email, String code) async {
    final Uri uri = Uri.parse('$_baseUrl/auth/owner/verify-email');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'code': code}),
      );
      return response;
    } catch (e) {
      _logger.e('Email verification network error: $e');
      return http.Response('Network error occurred', 503);
    }
  }

  // ADDED THIS METHOD
  Future<http.Response> resendOwnerVerificationCode(String email) async {
    final Uri uri = Uri.parse('$_baseUrl/auth/owner/resend-code');
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email}),
      );
      return response;
    } catch (e) {
      _logger.e('Resend code network error: $e');
      return http.Response('Network error occurred', 503);
    }
  }

  Future<http.Response> ownerLogin({
    required String email,
    required String password,
  }) async {
    final Uri uri = Uri.parse('$_baseUrl/auth/login/owner');
    try {
      // Note: For FastAPI's OAuth2PasswordRequestForm, we send form data
      // instead of JSON. The username field corresponds to the email.
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': email, 'password': password},
      );
      return response;
    } catch (e) {
      _logger.e('Login network error: $e');
      return http.Response('Network error occurred', 503);
    }
  }
}