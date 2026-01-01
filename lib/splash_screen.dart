import 'dart:async';
import 'package:digital_time_capsule/home_screen.dart';
import 'package:digital_time_capsule/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _navigate();
  }

  Future<void> _navigate() async {
    // Wait for a few seconds to show the splash screen.
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    // Listen to the auth state changes.
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (!mounted) return;
      
      if (user == null) {
        // If there is no user, go to LoginScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // If there is a user, go to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: 50, left: 40, child: _buildStar(2)),
            Positioned(top: 100, right: 30, child: _buildStar(3)),
            Positioned(top: 150, left: 150, child: _buildStar(2)),
            Positioned(top: 80, left: 250, child: _buildStar(4)),
            Positioned(top: 200, right: 80, child: _buildStar(2)),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 80),

                Column(
                  children: const [
                    Text(
                      'DIGITAL',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontFamily: 'VT323',
                          letterSpacing: 5,
                          shadows: [
                            Shadow(color: Colors.blueAccent, offset: Offset(2, 2), blurRadius: 0),
                          ]
                      ),
                    ),
                    Text(
                      'TIME CAPSULE',
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.amber,
                          fontFamily: 'VT323',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(color: Colors.brown, offset: Offset(2, 2), blurRadius: 0),
                          ]
                      ),
                    ),
                  ],
                ),

                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.2),
                          blurRadius: 40,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                    child: Image.asset('assets/asset5.png', width: 140),
                  ),
                ),

                Column(
                  children: [
                    // Ganti tombol START dengan loading indicator
                    const SizedBox(
                      height: 60,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Image.asset(
                            'assets/asset8.png',
                            repeat: ImageRepeat.repeatX,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 60,
                          color: const Color(0xFF4E342E),
                          child: Center(
                            child: Text(
                              "v1.0.0 Buatan Irsyad Dan Hafiz",
                              style: TextStyle(color: Colors.white.withOpacity(0.3), fontFamily: 'VT323', fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
      ),
    );
  }
}