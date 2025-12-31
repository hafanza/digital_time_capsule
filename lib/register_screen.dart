import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    String name = _nameController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      _showWarning("Semua data harus diisi!", Colors.redAccent);
      return;
    }
    if (!username.startsWith('@')) {
      _showWarning("Username harus diawali '@'", Colors.orangeAccent);
      return;
    }

    setState(() => _isLoading = true);

    try {
      var userBox = Hive.box('userBox');

      if (userBox.containsKey(username)) {
        _showWarning("Username $username sudah terdaftar!", Colors.redAccent);
        setState(() => _isLoading = false);
        return;
      }

      await userBox.put(username, {
        'name': name,
        'username': username,
        'password': password,
      });

      await userBox.flush();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi Berhasil! Silakan Login.', style: TextStyle(fontFamily: 'VT323', fontSize: 16)),
            backgroundColor: Colors.green,
          )
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.pop(context);

    } catch (e) {
      _showWarning("Terjadi kesalahan teknis!", Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showWarning(String pesan, Color warna) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(pesan, style: const TextStyle(fontFamily: 'VT323', fontSize: 16)),
          backgroundColor: warna
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text("Privacy Policy", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
        content: const Text(
          "Aplikasi Digital Time Capsule menyimpan data Nama, Username, dan Password Anda secara lokal di perangkat ini menggunakan database Hive. Kami tidak mengumpulkan atau mengirimkan data Anda ke server mana pun.",
          style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.green, fontFamily: 'VT323')),
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
                    const Text("Nama Lengkap", style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _nameController,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                      decoration: _simpleInputDecoration(hint: "Tuliskan Nama Kamu"),
                    ),
                    const SizedBox(height: 15),
                    const Text("Username", style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _usernameController,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                      decoration: _simpleInputDecoration(hint: "@username"),
                    ),
                    const SizedBox(height: 15),
                    const Text("Password", style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      enabled: !_isLoading,
                      style: const TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                      decoration: _simpleInputDecoration(hint: "********", isPassword: true),
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
