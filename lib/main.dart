import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Hive.openBox('capsuleBox');

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
