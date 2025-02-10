import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/api/repositories/auth_repository.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_app_bar_spacer.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_elevated_button.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_text.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  String? _loginMessage;

  String? _responseMessage;

//   Future<void> login(String username, String password) async {
//     final String apiUrl = "https://systemproject.pythonanywhere.com/auth/token/login/";
//     try {
//       final response = await https.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           "username": username,
//           "password": password,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _responseMessage = "Login successful! Token: ${data['auth_token']}";
//         });
//       } else {
//         setState(() {
//           _responseMessage = "Login failed! Error: ${response.body}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _responseMessage = "An error occurred: $e";
//       });
//     }
//   }

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
                obscureText: true,
                controller: _passwordController,
                cursorColor: Color(AppConstants.white),
                style: TextStyle(color: Color(AppConstants.white)),
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: Icon(Icons.remove_red_eye_outlined),
                  suffixIconColor: Color(AppConstants.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(9.0),
                    ),
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
              CustomElevatedButton(
                  context, 'Login', AppConstants.white, AppConstants.purple,
                  () async {
                final username = _usernameController.text;
                final password = _passwordController.text;

                try {
                  final token = await _authRepository.login(username, password);
                  _loginMessage = 'Login successful! Token: $token';
                  context.push("/banner");
                } catch (e) {
                  _loginMessage = 'Login failed. Error: $e';
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
