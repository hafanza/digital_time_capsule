import 'dart:async';
import 'package:digital_time_capsule/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import HomeScreen

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    print('[REGISTER] Tombol Daftar Ditekan.');
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showWarning("Email dan Password harus diisi!", Colors.redAccent);
      print('[REGISTER] Gagal: Email atau Password kosong.');
      return;
    }
    if (password.length < 6) {
      _showWarning("Password minimal harus 6 karakter.", Colors.orangeAccent);
      print('[REGISTER] Gagal: Password kurang dari 6 karakter.');
      return;
    }

    setState(() => _isLoading = true);
    print('[REGISTER] Memulai proses registrasi ke Firebase...');

    try {
      final user = await _firebaseService
          .registerWithEmailAndPassword(email, password)
          .timeout(const Duration(seconds: 15)); // Tambahkan timeout
      print('[REGISTER] Panggilan Firebase selesai.');

      if (user != null) {
        print('[REGISTER] Sukses! User ID: ${user.uid}. Navigasi ke HomeScreen.');
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        print('[REGISTER] Gagal: User null setelah registrasi.');
      }
    } on FirebaseAuthException catch (e) {
      print('[REGISTER] Error FirebaseAuth: ${e.code} - ${e.message}');
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email ini sudah terdaftar. Silakan login.';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid.';
          break;
        case 'weak-password':
          errorMessage = 'Password terlalu lemah. Gunakan minimal 6 karakter.';
          break;
        default:
          errorMessage = 'Terjadi kesalahan autentikasi. Silakan coba lagi.';
      }
      _showWarning(errorMessage, Colors.redAccent);
    } on TimeoutException {
      print('[REGISTER] Error: Timeout setelah 15 detik.');
      _showWarning('Server tidak merespon. Cek koneksi internet Anda.', Colors.orangeAccent);
    }
    catch (e) {
      print('[REGISTER] Error tidak terduga: $e');
      _showWarning("Terjadi kesalahan tidak terduga.", Colors.redAccent);
    } finally {
      print('[REGISTER] Proses selesai, mengembalikan _isLoading ke false.');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showWarning(String pesan, Color warna) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(pesan, style: const TextStyle(fontFamily: 'VT323', fontSize: 16)),
          backgroundColor: warna),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text("Privacy Policy",
            style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 22)),
        content: const SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              "Digital Time Capsule menghargai privasi Anda. Semua data (Akun & Pesan) disimpan secara aman di server Firebase (Google).\n\n"
                  "1. Kami menggunakan autentikasi aman dari Firebase.\n"
                  "2. Data kapsul Anda hanya bisa diakses oleh akun Anda.\n"
                  "3. Anda punya hak penuh untuk menghapus akun & seluruh data terkait melalui fitur di dalam aplikasi.\n"
                  "4. Kami tidak membagikan data Anda kepada pihak ketiga.",
              style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 16),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("MENGERTI",
                style: TextStyle(color: Colors.green, fontFamily: 'VT323', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/asset5.png', width: 80),
              const SizedBox(height: 15),
              const Text(
                'BUAT AKUN BARU',
                style: TextStyle(fontSize: 32, color: Colors.white, fontFamily: 'VT323'),
              ),
              const Text(
                'Mulai perjalanan waktu digitalmu',
                style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'VT323'),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  border: Border.all(color: Colors.white54),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Email", style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                      decoration: _simpleInputDecoration(hint: "email@anda.com"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    const Text("Password", style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                      decoration: _simpleInputDecoration(hint: "minimal 6 karakter", isPassword: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: const BorderSide(color: Colors.white, width: 1),
                  ),
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('DAFTAR SEKARANG', style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'VT323')),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => _isLoading ? null : Navigator.pop(context),
                child: const Text('Sudah punya akun? Login di sini', style: TextStyle(color: Colors.white70, fontSize: 16, fontFamily: 'VT323', decoration: TextDecoration.underline)),
              ),
              TextButton(
                onPressed: _showPrivacyPolicy,
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(color: Colors.white30, fontSize: 12, fontFamily: 'VT323'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      fillColor: const Color(0xFF222222),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white30), borderRadius: BorderRadius.circular(4)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(4)),
    );
  }
}
