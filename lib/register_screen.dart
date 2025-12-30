import 'package:flutter/material.dart';
import 'package:hive/hive.dart'; // <--- PERUBAHAN 1: Import Hive

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

  // <--- PERUBAHAN 2: Fungsi diubah menjadi async untuk proses simpan --->
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

    var userBox = Hive.box('userBox');
    await userBox.put('name', name);
    await userBox.put('username', username);
    await userBox.put('password', password);
    await userBox.flush();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi Berhasil! Silakan Login.', style: TextStyle(fontFamily: 'VT323', fontSize: 16)),
          backgroundColor: Colors.green,
        )
    );
    Navigator.pop(context);
  }

  void _showWarning(String pesan, Color warna) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(pesan, style: const TextStyle(fontFamily: 'VT323', fontSize: 16)),
          backgroundColor: warna
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
              // 1. LOGO KECIL (Opsional, biar senada)
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
                      style: const TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                      decoration: _simpleInputDecoration(hint: " Tuliskan Nama Kamu"),
                    ),

                    const SizedBox(height: 15),

                    const Text("Username", style: TextStyle(color: Colors.white70, fontFamily: 'VT323', fontSize: 18)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20),
                      decoration: _simpleInputDecoration(hint: "@username"),
                    ),

                    const SizedBox(height: 15),

                    // INPUT PASSWORD
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

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(color: Colors.white, width: 1),
                  ),
                  onPressed: _handleRegister,
                  child: const Text(
                      'DAFTAR SEKARANG',
                      style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'VT323')
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 4. BACK TO LOGIN
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                    'Sudah punya akun? Login di sini',
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontFamily: 'VT323', decoration: TextDecoration.underline)
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
