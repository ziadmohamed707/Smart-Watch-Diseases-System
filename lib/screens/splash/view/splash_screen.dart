import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 150, width: 150, child: Image.asset("assets/logo.png")),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                context.push('/login');
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
