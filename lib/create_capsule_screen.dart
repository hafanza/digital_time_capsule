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

  // --- LOGIC DATE PICKER ---
  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: todayStart,
      lastDate: DateTime(2100),
      builder: (context, child) {
        // Kita sesuaikan tema kalender agar cocok dengan nuansa retro/paper
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.brown, // Warna utama cokelat
              onPrimary: Colors.white,
              surface: Color(0xFFFFF8E1), // Warna kertas
              onSurface: Colors.brown,
            ),
            dialogBackgroundColor: const Color(0xFFFFF8E1),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --- LOGIC VALIDASI ---
  void _validateAndCreate() {
    String message = _messageController.text.trim();

    if (message.isEmpty) {
      _showWarningDialog("Kertas Masih Kosong!", "Tuliskan pesan untuk masa depanmu.");
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tentukan tanggal buka dulu!', style: TextStyle(fontFamily: 'VT323')),
          backgroundColor: Colors.brown,
        ),
      );
    } else {
      // Kirim Data
      Map<String, dynamic> newCapsule = {
        "message": message,
        "date": _selectedDate,
      };
      Navigator.pop(context, newCapsule);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Capsule berhasil disegel!', style: TextStyle(fontFamily: 'VT323')),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showWarningDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8E1), // Warna kertas
        shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.brown, width: 2), borderRadius: BorderRadius.circular(4)),
        title: Text(title, style: const TextStyle(color: Colors.redAccent, fontFamily: 'VT323', fontSize: 24, fontWeight: FontWeight.bold)),
        content: Text(content, style: const TextStyle(color: Colors.brown, fontFamily: 'VT323', fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.brown, fontFamily: 'VT323', fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222), // Background gelap
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("WRITE MESSAGE", style: TextStyle(fontFamily: 'VT323', color: Colors.white, fontSize: 24)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // --- AREA KERTAS SURAT ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1), // Warna kertas tua/krem
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(4, 4))
                ],
                border: Border.all(color: const Color(0xFFD7CCC8), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Kertas (Tanggal)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.mark_email_unread_outlined, color: Colors.brown, size: 28),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white54,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16, color: _selectedDate == null ? Colors.redAccent : Colors.brown),
                              const SizedBox(width: 8),
                              Text(
                                _selectedDate == null
                                    ? "SET UNLOCK DATE"
                                    : DateFormat('dd MMM yyyy').format(_selectedDate!).toUpperCase(),
                                style: TextStyle(
                                    color: _selectedDate == null ? Colors.redAccent : Colors.brown,
                                    fontFamily: 'VT323',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  const Divider(color: Colors.brown, thickness: 1.5),
                  const SizedBox(height: 10),

                  // Area Menulis (TextField menyatu dengan kertas)
                  TextField(
                    controller: _messageController,
                    maxLines: 12, // Tinggi kertas
                    style: const TextStyle(
                      color: Colors.brown, // Warna tinta
                      fontSize: 20,
                      fontFamily: 'VT323',
                      height: 1.5,
                    ),
                    cursorColor: Colors.brown,
                    decoration: const InputDecoration(
                      hintText: "Dear Future Me,\n\nHari ini aku merasa...",
                      hintStyle: TextStyle(color: Colors.black26, fontFamily: 'VT323', fontStyle: FontStyle.italic),
                      border: InputBorder.none, // Hilangkan garis border bawaan TextField
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "- From The Past",
                      style: TextStyle(color: Colors.brown, fontFamily: 'VT323', fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- TOMBOL AKSI DI LUAR KERTAS ---
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    label: const Text("DISCARD", style: TextStyle(color: Colors.redAccent, fontFamily: 'VT323', fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _validateAndCreate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8D6E63), // Warna Cokelat Kayu / Segel
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      elevation: 5,
                    ),
                    icon: const Icon(Icons.lock_outline, color: Colors.white),
                    label: const Text("SEAL CAPSULE", style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}