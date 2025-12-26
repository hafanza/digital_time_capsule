import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateCapsuleScreen extends StatefulWidget {
  const CreateCapsuleScreen({super.key});

  @override
  State<CreateCapsuleScreen> createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends State<CreateCapsuleScreen> {
  final TextEditingController _messageController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _validateAndCreate() {
    String message = _messageController.text.trim();

    if (message.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF333333),
          title: const Text("Peringatan", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
          content: const Text("Pesan tidak boleh kosong! Silakan tulis sesuatu.",
              style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK", style: TextStyle(color: Colors.green, fontFamily: 'VT323')),
            )
          ],
        ),
      );
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih tanggal Unlock terlebih dahulu!')),
      );
    } else {
      // PERBAIKAN: Menambahkan field "message" agar tersimpan
      Map<String, String> newCapsule = {
        "status": "Locked",
        "time": DateFormat('dd/MM/yyyy').format(_selectedDate!),
        "message": message,
        "image": "assets/asset5.png",
      };

      Navigator.pop(context, newCapsule);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Capsule berhasil dibuat!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Digital Time Capsule',
                  style: TextStyle(fontSize: 28, color: Colors.white, fontFamily: 'VT323'),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text("Buat Isi Capsule",
                          style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'VT323')),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: Text(
                                _selectedDate == null
                                    ? "Pilih Tanggal Unlock"
                                    : "Unlock Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                                style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'VT323'),
                              ),
                            ),
                          ),
                          Image.asset('assets/asset7.png', width: 60),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 150,
                        color: Colors.white,
                        child: TextField(
                          controller: _messageController,
                          maxLines: 10,
                          style: const TextStyle(color: Colors.black, fontFamily: 'VT323'),
                          decoration: const InputDecoration(
                            hintText: "Tulis pesanmu di sini...",
                            contentPadding: EdgeInsets.all(10),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batalkan", style: TextStyle(fontFamily: 'VT323', color: Colors.white)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: _validateAndCreate,
                            child: const Text("Buat Capsule", style: TextStyle(fontFamily: 'VT323', color: Colors.white)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
