import 'package:digital_time_capsule/models/capsule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services/firebase_service.dart';

class EditCapsuleScreen extends StatefulWidget {
  final Capsule capsule;

  const EditCapsuleScreen({
    super.key,
    required this.capsule,
  });

  @override
  State<EditCapsuleScreen> createState() => _EditCapsuleScreenState();
}

class _EditCapsuleScreenState extends State<EditCapsuleScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late TextEditingController _messageController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.capsule.message);
    _selectedDate = widget.capsule.unlockDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.brown,
              onPrimary: Colors.white,
              surface: Color(0xFFFFF8E1),
              onSurface: Colors.brown,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Color(0xFFFFF8E1)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveChanges() async {
    String message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesan tidak boleh kosong!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    await _firebaseService.updateCapsule(widget.capsule.id, message, _selectedDate);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perubahan Disimpan!'), backgroundColor: Colors.green),
      );
    }
  }

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
        title: const Text("EDIT CAPSULE", style: TextStyle(fontFamily: 'VT323', color: Colors.white, fontSize: 24)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(4, 4),
                  )
                ],
                border: Border.all(color: const Color(0xFFD7CCC8), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("UNLOCK DATE:", style: TextStyle(color: Colors.brown, fontFamily: 'VT323', fontSize: 14)),
                          Text(
                            DateFormat('dd MMM yyyy').format(_selectedDate).toUpperCase(),
                            style: const TextStyle(color: Colors.redAccent, fontFamily: 'VT323', fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown),
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.edit_calendar, size: 16, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                "RESCHEDULE",
                                style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Colors.brown, thickness: 1.5),
                  const SizedBox(height: 15),
                  const Text("MESSAGE:", style: TextStyle(color: Colors.brown, fontFamily: 'VT323', fontSize: 16)),
                  TextField(
                    controller: _messageController,
                    maxLines: 8,
                    style: const TextStyle(color: Colors.brown, fontSize: 18, fontFamily: 'VT323'),
                    cursorColor: Colors.brown,
                    decoration: const InputDecoration(
                      hintText: "What do you want to tell to your future self?",
                      hintStyle: TextStyle(color: Colors.black26, fontFamily: 'VT323', fontStyle: FontStyle.italic),
                      filled: true,
                      fillColor: Colors.white54,
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.brown)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CANCEL", style: TextStyle(color: Colors.white54, fontFamily: 'VT323', fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      elevation: 5,
                    ),
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text("SAVE CHANGES", style: TextStyle(color: Colors.white, fontFamily: 'VT323', fontSize: 20, fontWeight: FontWeight.bold)),
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
