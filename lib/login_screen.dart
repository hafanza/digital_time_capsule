import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _handleLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showWarning("Username dan Password harus diisi!", Colors.redAccent);
      return;
    }
    if (!username.startsWith('@')) {
      _showWarning("Username harus pakai '@'", Colors.orangeAccent);
      return;
    }

    // Login Sukses
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(username: username)),
    );
  }

  void _showWarning(String pesan, Color warna) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan, style: const TextStyle(fontFamily: 'VT323', fontSize: 16)),
        backgroundColor: warna,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222), // Warna background Home Screen
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. ICON SEDERHANA (Sesuai aset Pixel Art)
              Image.asset('assets/asset5.png', width: 100), // Gambar Capsule Locked

              const SizedBox(height: 20),

              const Text(
                'DIGITAL TIME CAPSULE',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontFamily: 'VT323',
                ),
              ),
              const Text(
                'Masuk untuk melihat masa lalu',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'VT323'),
              ),

              const SizedBox(height: 40),

              // 2. FORM INPUT (Gaya Home Screen: Border Putih)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D), // Warna kartu di Home Screen
                  border: Border.all(color: Colors.white54),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Username", style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                      decoration: _simpleInputDecoration(hint: "@username"),
                    ),

                    const SizedBox(height: 20),

                    const Text("Password", style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                      decoration: _simpleInputDecoration(
                          hint: "********",
                          isPassword: true
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 3. TOMBOL LOGIN (Hijau Pixel Art)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Hijau standar pixel art
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Sama dengan tombol Home
                    ),
                    side: const BorderSide(color: Colors.white, width: 1), // Border putih tipis
                  ),
                  onPressed: _handleLogin,
                  child: const Text(
                      'MASUK',
                      style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'VT323')
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 4. TEXT BUTTON REGISTER
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
                child: const Text(
                  "Belum punya akun? Buat Baru",
                  style: TextStyle(color: Colors.white70, fontSize: 16, fontFamily: 'VT323', decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Style Input yang Bersih & Senada dengan Home
  InputDecoration _simpleInputDecoration({required String hint, bool isPassword = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white30, fontFamily: 'VT323'),
      suffixIcon: isPassword
          ? IconButton(
        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
      )
          : null,
      filled: true,
      fillColor: const Color(0xFF222222), // Input lebih gelap dari card
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),

      // Border Putih Biasa
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white30),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}