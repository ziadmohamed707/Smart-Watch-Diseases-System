import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/api/repositories/auth_repository.dart';
import 'package:iot_monitoring_chronic_diseases_system/app/token/token_storage.dart';
import 'package:iot_monitoring_chronic_diseases_system/utils/constants.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_app_bar_spacer.dart';
import 'package:iot_monitoring_chronic_diseases_system/widgets/custom_elevated_button.dart';

class LoginBanner extends StatelessWidget {
  const LoginBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    Map<String, dynamic>? profileData;
    String? error;

    String? token = TokenStorage.getToken();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBarSpacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset("assets/banner.png"),
            ),
            SizedBox(height: 150.0),
            CustomElevatedButton(
              context,
              'Get Started',
              AppConstants.white,
              AppConstants.purple,
              () => {context.push('/discover_watch')},
            ),
            SizedBox(height: 18.0),
          ],
        ),
      ),
    );
  }
}
