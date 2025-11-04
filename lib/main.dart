import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding/onboarding_screen.dart';

void main() {
  SystemUiMode.edgeToEdge;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'SFPro', brightness: Brightness.dark),
        home: OnboardingScreen(),
      ),
    );
  }
}
