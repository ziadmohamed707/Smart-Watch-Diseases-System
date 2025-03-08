import 'package:flutter/material.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/token/token_storage.dart';

import '../Services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<String> login(String username, String password) async {
    try {
      debugPrint('Attempting to log in with username: $username');

      final response = await _apiService.post('/auth/token/login/', data: {
        'username': username,
        'password': password,
      });

      debugPrint('Login successful. Token: ${response.data['auth_token']}');
      await TokenStorage.setToken(response.data['auth_token']);
      return response.data['auth_token'];
    } catch (e) {
      debugPrint('Login failed. Error: $e');
      rethrow;
    }
  }

  Future<void> logout(String token) async {
    try {
      debugPrint('Attempting to log out.');

      await _apiService.post(
        '/auth/token/logout/',
        data: {},
        headers: {'Authorization': 'Token $token'},
      );
      await TokenStorage.clearToken();
      debugPrint('Logout successful.');
    } catch (e) {
      debugPrint('Logout failed. Error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchProfile(String token) async {
    try {
      debugPrint('Fetching profile data.');

      final response = await _apiService.get('/api/Profile/', token: token);

      debugPrint('Profile data fetched successfully: ${response.data}');
      return response.data;
    } catch (e) {
      debugPrint('Failed to fetch profile data. Error: $e');
      rethrow;
    }
  }

  Future<void> updateProfile(
      String token, Map<String, dynamic> updatedData) async {
    try {
      debugPrint('Updating profile data.');

      final response = await _apiService.put(
        '/api/Profile/',
        data: updatedData,
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('Profile updated successfully.');
      } else {
        debugPrint(
            'Failed to update profile. Status code: ${response.statusCode}');
        throw Exception('Failed to update profile.');
      }
    } catch (e) {
      debugPrint('Error updating profile data. Error: $e');
      rethrow;
    }
  }

  Future<void> sendWatchData(
      String token, Map<String, dynamic> watchData) async {
    try {
      debugPrint('upload Watch Data.....');

      final response = await _apiService.post(
        '/api/smartwatch/',
        data: watchData,
        headers: {'Authorization': 'Token $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('Watch Data uploaded successfully.');
      } else {
        debugPrint(
            'Failed to upload Watch Data. Status code: ${response.statusCode}');
        throw Exception('Failed to upload Watch Data.');
      }
    } catch (e) {
      debugPrint('Error upload Watch Data. Error: $e');
      rethrow;
    }
  }
}
