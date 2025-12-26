import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const DigitalTimeCapsule());
}

class DigitalTimeCapsule extends StatelessWidget {
  const DigitalTimeCapsule({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Time Capsule',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Mengeset font VT323 sebagai font default aplikasi
        fontFamily: 'VT323',
        scaffoldBackgroundColor: const Color(0xFF222222), // Warna background gelap seperti di Figma
      ),
      home: const SplashScreen(),
    );
  }
}
