import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../screens/generalInformation/model/profile.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://systemproject.pythonanywhere.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  // POST request
  Future<Response> post(String path,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    try {
      debugPrint('Sending POST request to $path');
      if (data != null) debugPrint('Request Data: $data');
      if (headers != null) debugPrint('Headers: $headers');

      final response = await _dio.post(
        path,
        data: data,
        options: Options(headers: headers),
      );

      debugPrint(
          'POST request to $path successful. Response: ${response.data}');
      return response;
    } catch (e) {
      debugPrint('POST request to $path failed. Error: $e');
      rethrow;
    }
  }

  // GET request
  Future<Response> get(String path, {String? token}) async {
    try {
      debugPrint('Sending GET request to $path');
      if (token != null) debugPrint('Using token: $token');

      final response = await _dio.get(
        path,
        options: Options(headers: {'Authorization': 'Token $token'}),
      );

      debugPrint('GET request to $path successful. Response: ${response.data}');
      return response;
    } catch (e) {
      debugPrint('GET request to $path failed. Error: $e');
      rethrow;
    }
  }

  // Push Profile Data to API
  Future<void> pushProfile(Profile profile) async {
    try {
      Response response = await post(
        '/api/Profile/',
        data: profile.toJson(),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('Profile created successfully: ${response.data}');
    } catch (e) {
      debugPrint('Failed to create profile: $e');
    }
  }

  // Update Profile
  Future<void> updateProfile(
      String token, Map<String, dynamic> updatedData) async {
    try {
      debugPrint('Sending PUT request to update profile.');

      final response = await _dio.put(
        '/api/Profile/',
        data: updatedData,
        options: Options(headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('Profile updated successfully.');
      } else {
        debugPrint(
            'Failed to update profile. Status code: ${response.statusCode}');
        throw Exception('Failed to update profile.');
      }
    } catch (e) {
      debugPrint('Error while updating profile: $e');
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(String path,
      {Map<String, dynamic>? data, Map<String, String>? headers}) async {
    try {
      debugPrint('Sending PUT request to $path');
      if (data != null) debugPrint('Request Data: $data');
      if (headers != null) debugPrint('Headers: $headers');

      final response = await _dio.patch(
        path,
        data: data,
        options: Options(headers: headers),
      );

      debugPrint('PUT request to $path successful. Response: ${response.data}');
      return response;
    } catch (e) {
      debugPrint('PUT request to $path failed. Error: $e');
      rethrow;
    }
  }
}
