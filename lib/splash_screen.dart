import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan resizeToAvoidBottomInset agar tidak error saat ada keyboard (opsional)
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2C2C2C), Color(0xFF1A237E), Color(0xFF1A237E)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60), // Dikurangi sedikit agar lebih naik
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/asset1.png', width: 40),
                Image.asset('assets/asset1.png', width: 40),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Digital Time Capsule',
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontFamily: 'VT323'
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/asset1.png', width: 30),
                const SizedBox(width: 100),
                Image.asset('assets/asset1.png', width: 30),
              ],
            ),
            const Spacer(), // Memberikan ruang kosong di tengah

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
                  Image.asset('assets/asset2.png', width: 200),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      'MULAI',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: 'VT323'
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // Jarak tombol ke rumput

            // --- PERBAIKAN AREA RUMPUT & TANAH AGAR TIDAK OVERFLOW ---
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  // Menggunakan height agar rumput tidak terlalu besar
                  height: 40,
                  child: Image.asset(
                    'assets/asset8.png',
                    fit: BoxFit.fill, // fill agar rumput rapat ke samping
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 100, // DIKECILKAN: Dari 150 menjadi 100 agar muat di layar
                  color: const Color(0xFF4E342E),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
