import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/api/repositories/auth_repository.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_app_bar_spacer.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_elevated_button.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_text.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false; // Track login progress

  String? _loginMessage = '';

  bool _obscureText = true;
  // Controls password visibility
  String? _responseMessage;

  Future<void> checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
      Permission.storage,
      Permission.microphone,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
      Permission.sensors,
    ].request();

    statuses.forEach((permission, status) {
      if (status.isDenied) {
        print("Permission denied: $permission");
      } else if (status.isPermanentlyDenied) {
        print(
            "Permission permanently denied: $permission. Open settings to enable.");
        openAppSettings(); // Open settings if permanently denied
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _loginMessage = null; // Clear previous message
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _loginMessage = "Please enter both email and password.";
        _isLoading = false;
      });
      return;
    }

    try {
      final token = await _authRepository.login(username, password);

      setState(() {
        _loginMessage = "Login successful!";
        _isLoading = false;
      });

      if (mounted) {
        context.push("/banner");
      }
    } catch (e) {
      String errorMessage = "An unknown error occurred.";

      if (e is DioException) {
        if (e.response != null) {
          final int? statusCode = e.response?.statusCode;
          final responseData = e.response?.data;

          if (responseData is Map<String, dynamic> &&
              responseData.containsKey('detail')) {
            errorMessage = responseData['detail']; // Get detailed error message
          } else {
            switch (statusCode) {
              case 401:
                errorMessage = "Invalid credentials. Please try again.";
                break;
              case 403:
                errorMessage = "Access denied. Contact support.";
                break;
              case 404:
                errorMessage = "User not found. Please check your email.";
                break;
              case 405:
                errorMessage = "Method not allowed. Contact support.";
                break;
              case 500:
                errorMessage = "Server error. Please try again later.";
                break;
              default:
                errorMessage = "Something went wrong. Please try again.";
            }
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage = "Request timed out. Check your network and retry.";
        } else if (e.type == DioExceptionType.receiveTimeout) {
          errorMessage = "Server is taking too long to respond.";
        } else {
          errorMessage =
              "Network error. Please check your internet connection.";
        }
      } else {
        errorMessage = e.toString();
      }

      setState(() {
        _loginMessage = errorMessage;
        _isLoading = false;
      });

      // Show Snackbar for better visibility
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_loginMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

//   Future<void> login(String username, String password) async {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBarSpacer(),
              CustomTextWidget(
                  'Welcome Back 👋', AppConstants.white, 24, FontWeight.bold),
              SizedBox(height: 10),
              CustomTextWidget(
                'Enter your email to log in to your account',
                AppConstants.white,
                16,
                FontWeight.normal,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                cursorColor: Color(AppConstants.white),
                style: TextStyle(color: Color(AppConstants.white)),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(9.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText:
                    _obscureText, // Controls whether the text is hidden
                controller: _passwordController,
                cursorColor:
                    Colors.white, // Adjusted color without AppConstants
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                      color: Colors.white), // Ensure label is visible
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Toggle visibility
                      });
                    },
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(9.0)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.push("/forget_password");
                  },
                  child: CustomTextWidget('Forget Password?',
                      AppConstants.white, 14, FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : CustomElevatedButton(
                          context,
                          'Login',
                          AppConstants.white,
                          AppConstants.purple,
                          _handleLogin,
                        ),
                ],
              )
              // CustomElevatedButton(
              //     context, 'Login', AppConstants.white, AppConstants.purple,
              //     () async {
              //   final username = _usernameController.text;
              //   final password = _passwordController.text;

              //   try {
              //     final token = await _authRepository.login(username, password);
              //     _loginMessage = 'Login successful! Token: $token';
              //     context.push("/banner");
              //   } catch (e) {
              //     _loginMessage = 'Login failed. Error: $e';
              //   }
              // }),
            ],
          ),
        ),
      ),
    );
  }
}
