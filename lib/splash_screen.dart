import 'package:flutter/material.dart';
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
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

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
                          color: Colors.blueAccent.withValues(alpha:0.2),
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
                              style: TextStyle(color: Colors.white.withValues(alpha:0.3), fontFamily: 'VT323', fontSize: 12),
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