import 'package:flutter/material.dart';

class OpenCapsuleScreen extends StatelessWidget {
  final String message;
  final String dateInfo;

  const OpenCapsuleScreen({
    super.key,
    required this.message,
    required this.dateInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Kapsul Terbuka (Visual)
              Image.asset('assets/asset6.png', width: 100), // Pastikan ini gambar unlocked
              const SizedBox(height: 20),

              const Text(
                "UNLOCKED CAPSULE",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontFamily: 'VT323',
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                dateInfo, // Contoh: Opened 2 days ago
                style: const TextStyle(color: Colors.grey, fontSize: 14, fontFamily: 'VT323'),
              ),
              const SizedBox(height: 30),

              // Area Surat / Pesan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1), // Warna kertas tua/krem
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(4, 4))
                  ],
                  border: Border.all(color: const Color(0xFFD7CCC8), width: 2),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.format_quote, color: Colors.brown, size: 30),
                    const SizedBox(height: 10),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.brown,
                        fontSize: 20,
                        fontFamily: 'VT323',
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.brown),
                    const Text(
                      "- From Your Past Self -",
                      style: TextStyle(color: Colors.brown, fontSize: 14, fontFamily: 'VT323', fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}