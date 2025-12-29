import 'create_capsule_screen.dart';
import 'edit_capsule_screen.dart';
import 'login_screen.dart';
import 'open_capsule_screen.dart'; // <--- JANGAN LUPA IMPORT INI
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // DATA MASTER
  List<Map<String, dynamic>> allCapsules = [
    {
      "message": "Halo masa depan! Semoga kamu sudah lulus.",
      "image": "assets/asset5.png",
      "unlockDate": DateTime.now().add(const Duration(days: 2)).toIso8601String(),
    },
    {
      "message": "Ini kenangan saat belajar Flutter pertama kali.",
      "image": "assets/asset6.png",
      "unlockDate": DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    },
  ];

  List<Map<String, dynamic>> lockedList = [];
  List<Map<String, dynamic>> unlockedList = [];
  int _selectedLockedIndex = -1;
  int _selectedUnlockedIndex = -1;

  @override
  void initState() {
    super.initState();
    _organizeCapsules();
  }

  void _organizeCapsules() {
    final now = DateTime.now();
    setState(() {
      lockedList.clear();
      unlockedList.clear();

      for (var capsule in allCapsules) {
        DateTime unlockTime = DateTime.parse(capsule['unlockDate']);
        capsule['timeDisplay'] = _calculateTimeDisplay(unlockTime);

        if (unlockTime.isAfter(now)) {
          lockedList.add(capsule);
        } else {
          unlockedList.add(capsule);
        }
      }
      lockedList.sort((a, b) => DateTime.parse(a['unlockDate']).compareTo(DateTime.parse(b['unlockDate'])));
      unlockedList.sort((a, b) => DateTime.parse(b['unlockDate']).compareTo(DateTime.parse(a['unlockDate'])));
    });
  }

  // --- PERBAIKAN LOGIKA WAKTU (GANTI TOTAL FUNGSI INI) ---
  String _calculateTimeDisplay(DateTime targetTime) {
    final now = DateTime.now();

    // Kita "bersihkan" jam-nya, jadi murni hitung selisih tanggal kalender
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final targetMidnight = DateTime(targetTime.year, targetTime.month, targetTime.day);

    final difference = targetMidnight.difference(todayMidnight);

    if (difference.isNegative) {
      // MASA LALU
      final daysAgo = difference.abs().inDays;
      if (daysAgo == 0) return "Opened Today"; // Jika hari ini tapi sudah lewat jam
      return "Opened $daysAgo days ago";
    } else {
      // MASA DEPAN
      final daysLeft = difference.inDays;

      if (daysLeft == 0) {
        // Jika harinya sama (Hari ini), kita hitung sisa jam
        final hoursLeft = targetTime.difference(now).inHours;
        if (hoursLeft <= 0) return "Ready to Open!";
        return "$hoursLeft Hours Remaining";
      }

      return "$daysLeft Days Remaining";
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
                  style: TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'VT323', letterSpacing: 1.5),
                ),
                const SizedBox(height: 20),

                // TOMBOL ADD
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CreateCapsuleScreen()),
                    );

                    if (result != null) {
                      allCapsules.add({
                        "message": result['message'],
                        "image": "assets/asset5.png",
                        "unlockDate": result['date'].toIso8601String(),
                      });
                      _organizeCapsules();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.add_circle_outline, color: Colors.white, size: 28),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LIST LOCKED
                _buildCapsuleList(
                    dataList: lockedList,
                    selectedIndex: _selectedLockedIndex,
                    isLockedList: true
                ),

                const SizedBox(height: 20),

                // PREVIEW AREA (Updated)
                SizedBox(
                  height: 300,
                  child: _buildPreviewArea(),
                ),

                const SizedBox(height: 20),

                // LIST UNLOCKED
                _buildCapsuleList(
                    dataList: unlockedList,
                    selectedIndex: _selectedUnlockedIndex,
                    isLockedList: false
                ),

                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => _showLogoutDialog(context),
                  child: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontFamily: 'VT323')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCapsuleList({
    required List<Map<String, dynamic>> dataList,
    required int selectedIndex,
    required bool isLockedList,
  }) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54),
        borderRadius: BorderRadius.circular(8),
      ),
      child: dataList.isEmpty
          ? const Center(child: Text("Empty", style: TextStyle(color: Colors.white30, fontFamily: 'VT323')))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataList.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isLockedList) {
                  _selectedLockedIndex = index;
                  _selectedUnlockedIndex = -1;
                } else {
                  _selectedUnlockedIndex = index;
                  _selectedLockedIndex = -1;
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF444444) : Colors.transparent,
                border: isSelected ? Border.all(color: Colors.white) : Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(dataList[index]['image']!, width: 40),
                  const SizedBox(height: 5),
                  Text(
                    dataList[index]['timeDisplay'].toString().split(' ').take(2).join(' '),
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'VT323'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- LOGIKA UTAMA DI SINI ---
  // --- GANTI BAGIAN INI SAJA ---
  Widget _buildPreviewArea() {
    Map<String, dynamic>? activeData;
    bool isLocked = false;
    int activeIndex = -1;

    // Cek mana yang sedang dipilih
    if (_selectedLockedIndex != -1 && _selectedLockedIndex < lockedList.length) {
      activeData = lockedList[_selectedLockedIndex];
      isLocked = true;
      activeIndex = _selectedLockedIndex;
    } else if (_selectedUnlockedIndex != -1 && _selectedUnlockedIndex < unlockedList.length) {
      activeData = unlockedList[_selectedUnlockedIndex];
      isLocked = false;
      activeIndex = _selectedUnlockedIndex;
    }

    // Jika belum ada yang dipilih
    if (activeData == null) {
      return const Center(
        child: Text(
          "Pilih capsule untuk melihat detail",
          style: TextStyle(color: Colors.grey, fontFamily: 'VT323', fontSize: 18),
        ),
      );
    }

    // Tentukan Warna Shadow (Biru jika Locked, Emas jika Unlocked)
    Color glowColor = isLocked ? Colors.blueAccent : Colors.amber;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Tombol Edit (Hanya jika Locked)
            isLocked
                ? IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => _editCapsule(activeData!, activeIndex),
            )
                : const SizedBox(width: 48),

            // --- GAMBAR CAPSULE UTAMA (INTERAKTIF) ---
            GestureDetector(
              onTap: () {
                if (isLocked) {
                  // Feedback jika masih terkunci
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sabar ya! Belum waktunya dibuka.", style: TextStyle(fontFamily: 'VT323')),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else {
                  // Buka surat jika sudah Unlocked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OpenCapsuleScreen(
                        message: activeData!['message'],
                        dateInfo: activeData['timeDisplay'],
                      ),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // Efek Glowing berbeda tergantung status
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
                ),
                // Animasi kecil saat ditekan bisa ditambahkan nanti, sementara image biasa
                child: Image.asset(activeData['image']!, width: 120),
              ),
            ),

            // Tombol Delete
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _showDeleteDialog(context, activeData!, isLocked),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Text(
          isLocked ? "LOCKED" : "UNLOCKED",
          style: TextStyle(
            color: isLocked ? Colors.white : Colors.amber, // Teks jadi emas kalau unlocked
            fontSize: 32,
            fontFamily: 'VT323',
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white30),
            color: Colors.black26,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            activeData['timeDisplay']!,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'VT323'),
          ),
        ),

        const SizedBox(height: 15),

        // --- KETERANGAN / PETUNJUK ---
        if (!isLocked)
        // Keterangan untuk Unlocked
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.touch_app, color: Colors.greenAccent, size: 18),
              SizedBox(width: 5),
              Text(
                "Tap capsule to read message",
                style: TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'VT323',
                    fontSize: 16,
                    letterSpacing: 1.2
                ),
              ),
            ],
          )
        else
        // Keterangan untuk Locked
          const Text(
            "( Waiting for the future... )",
            style: TextStyle(color: Colors.grey, fontFamily: 'VT323', fontSize: 14, fontStyle: FontStyle.italic),
          ),
      ],
    );
  }

  // --- Fungsi Edit, Delete, Logout tetap sama seperti sebelumnya ---
  // (Saya singkat biar tidak kepanjangan di chat, tapi pastikan copy method yang lama ya)

  void _editCapsule(Map<String, dynamic> capsuleData, int index) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCapsuleScreen(
          initialMessage: capsuleData['message'],
          initialDateDisplay: capsuleData['timeDisplay'], // Ganti nama parameter biar jelas
          initialRawDate: capsuleData['unlockDate'],      // TAMBAHAN: Kirim tanggal asli ISO String
        ),
      ),
    );
    if (updatedData != null) {
      setState(() {
        allCapsules.remove(capsuleData);
        allCapsules.add({
          "message": updatedData['message'],
          "image": capsuleData['image'],
          "unlockDate": updatedData['time'] ?? capsuleData['unlockDate'],
        });
        _organizeCapsules();
        _selectedLockedIndex = -1;
      });
    }
  }

  void _showDeleteDialog(BuildContext context, Map<String, dynamic> itemToDelete, bool isLocked) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        title: const Text("Delete?", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                allCapsules.remove(itemToDelete);
                _organizeCapsules();
                _selectedLockedIndex = -1;
                _selectedUnlockedIndex = -1;
              });
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red, fontFamily: 'VT323')),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF333333),
        title: const Text("Logout", style: TextStyle(color: Colors.white, fontFamily: 'VT323')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey, fontFamily: 'VT323')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text("Keluar", style: TextStyle(color: Colors.red, fontFamily: 'VT323')),
          ),
        ],
      ),
    );
  }
}