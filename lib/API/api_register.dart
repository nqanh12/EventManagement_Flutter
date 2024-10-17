import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class RegisterService {
  final String baseUrl = 'http://10.0.2.2:8080';
  final Logger _logger = Logger();

  Future<bool> usernameExists(String username) async {
    final url = Uri.parse('$baseUrl/check-username'); // API URL for checking username
    final body = jsonEncode({'userName': username});

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse['exists'];
      } else {
        _logger.e('Failed to check username: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Exception during username check: $e');
    }
    return false;
  }

  Future<AuthResponse?> register(String username, String password) async {
    final url = Uri.parse('$baseUrl/register'); // API URL
    final body = jsonEncode({
      'userName': username,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['code'] == 1000) {
          return AuthResponse.fromJson(jsonResponse['result']);
        } else {
          _logger.e('Error: ${jsonResponse['message']}');
        }
      } else {
        _logger.e('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Exception during registration: $e');
    }
    return null;
  }
}

class AuthResponse {
  final String id;
  final String userName;
  final String? fullName;
  final String? classId;
  final String? trainingPoint;
  final String? email;
  final String? phone;
  final String? address;
  final List<String>? eventsRegistered;
  final List<String> roles;

  AuthResponse({
    required this.id,
    required this.userName,
    this.fullName,
    this.classId,
    this.trainingPoint,
    this.email,
    this.phone,
    this.address,
    this.eventsRegistered,
    required this.roles,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['id'],
      userName: json['userName'],
      fullName: json['full_Name'],
      classId: json['class_id'],
      trainingPoint: json['training_point'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      eventsRegistered: json['eventsRegistered'] != null
          ? List<String>.from(json['eventsRegistered'])
          : null,
      roles: List<String>.from(json['roles']),
    );
  }
}