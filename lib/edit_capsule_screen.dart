import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditCapsuleScreen extends StatefulWidget {  final String initialMessage;
final String initialDate;

const EditCapsuleScreen({
  super.key,
  required this.initialMessage,
  required this.initialDate
});

@override
State<EditCapsuleScreen> createState() => _EditCapsuleScreenState();
}

class _EditCapsuleScreenState extends State<EditCapsuleScreen> {
  late TextEditingController _messageController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Mengisi input dengan data lama
    _messageController = TextEditingController(text: widget.initialMessage);
    // Mencoba mengubah string tanggal lama kembali ke objek Date
    try {
      _selectedDate = DateFormat('dd/MM/yyyy').parse(widget.initialDate);
    } catch (e) {
      _selectedDate = DateTime.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
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
                const Text('Digital Time Capsule',
                    style: TextStyle(fontSize: 28, color: Colors.white, fontFamily: 'VT323')),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text("Ubah Isi Capsule",
                          style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'VT323')),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                              child: Text(
                                "Unlock Date : ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}",
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'VT323'),
                              ),
                            ),
                          ),
                          Image.asset('assets/asset7.png', width: 60),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Area Pesan
                      Container(
                        height: 150,
                        color: Colors.white,
                        child: TextField(
                          controller: _messageController,
                          maxLines: 10,
                          style: const TextStyle(color: Colors.black, fontFamily: 'VT323'),
                          decoration: const InputDecoration(
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
                            child: const Text("Batalkan", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: () {
                              // Mengirim data baru kembali ke Home
                              Navigator.pop(context, {
                                'message': _messageController.text,
                                'time': DateFormat('dd/MM/yyyy').format(_selectedDate!),
                              });
                            },
                            child: const Text("Ubah Capsule", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
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
