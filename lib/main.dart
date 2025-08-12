import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SwipeNewsApp());
}

class SwipeNewsApp extends StatelessWidget {
  const SwipeNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwipeNews',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}
