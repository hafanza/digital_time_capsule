import 'package:flutter/material.dart';
import 'dart:math' as math; // Untuk animasi floating
import 'login_screen.dart';

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
    // Konfigurasi Animasi Floating (Naik Turun)
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true); // Ulangi bolak-balik

    _animation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
            // Warna langit malam gradasi
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
          ),
        ),
        child: Stack(
          children: [
            // 1. DEKORASI BINTANG (Background)
            Positioned(top: 50, left: 40, child: _buildStar(2)),
            Positioned(top: 100, right: 30, child: _buildStar(3)),
            Positioned(top: 150, left: 150, child: _buildStar(2)),
            Positioned(top: 80, left: 250, child: _buildStar(4)),
            Positioned(top: 200, right: 80, child: _buildStar(2)),

            // 2. KONTEN UTAMA
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 80),

                // --- JUDUL ---
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
                          color: Colors.amber, // Warna emas biar kontras
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

                // --- ANIMASI CAPSULE FLOATING ---
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value), // Gerak vertikal
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
                    // Menggunakan asset5 (Locked Capsule) sebagai Hero Image
                    child: Image.asset('assets/asset5.png', width: 140),
                  ),
                ),

                // --- TOMBOL MULAI & TANAH ---
                Column(
                  children: [
                    // Tombol Start
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen())
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Efek bayangan tombol biar pop-up
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 190,
                            height: 50,
                            color: Colors.black38,
                          ),
                          Image.asset('assets/asset2.png', width: 200),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              'START',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontFamily: 'VT323',
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Area Rumput & Tanah
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Image.asset(
                            'assets/asset8.png', // Rumput
                            repeat: ImageRepeat.repeatX, // Mengulang secara horizontal // Repeat biar nyambung kalau layar lebar
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 60, // Tanah
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

  // Widget kecil untuk membuat bintang kotak (pixel art style)
  Widget _buildStar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle, // Kotak biar pixel art
      ),
    );
  }
}