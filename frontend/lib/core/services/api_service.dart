import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // Import the logger package

class ApiService {
  // Use 'http://10.0.2.2:8000' for the Android Emulator.
  // Use 'http://localhost:8000' for iOS Simulator or Windows Desktop.
  final String _baseUrl = 'http://10.0.2.2:8000';
  
  // Create a logger instance
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
      // ✅ FIX: Replaced print() with logger.e() for better error logging
      _logger.e('Network Error occurred: $e');
      return http.Response('Network error occurred', 503);
    }
  }

  Future<http.Response> checkPhoneNumber(String phoneNumber, String role) async {
    // This endpoint needs to be created in the Python backend
    // ✅ FIX: The 'uri' variable is commented out until it's used in a real API call.
    // final Uri uri = Uri.parse('$_baseUrl/auth/check-phone');
    
    // Simulating a success for now
    await Future.delayed(const Duration(seconds: 1));
    return http.Response(jsonEncode({'message': 'Phone number is registered'}), 200);
  }

  Future ownerLogin({required String email, required String password}) async {}
}