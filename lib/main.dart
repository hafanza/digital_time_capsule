import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        fontFamily: 'VT323',
        scaffoldBackgroundColor: const Color(0xFF222222),
      ),
      home: const SplashScreen(),
    );
  }
}
